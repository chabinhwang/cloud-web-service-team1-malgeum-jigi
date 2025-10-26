import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  // 런타임에 .env에서 API_BASE_URL을 읽음
  static String get baseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api';
  }

  static const int _maxRetries = 3;
  static const Duration _initialDelay = Duration(seconds: 1);

  /// 환기 점수 조회
  static Future<Map<String, dynamic>?> getVentilationScore({
    required double latitude,
    required double longitude,
    String? locationName,
  }) async {
    return _retryableRequest(
      () async {
        final queryParams = {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        };
        if (locationName != null) {
          queryParams['location'] = locationName;
        }

        final uri = Uri.parse('$baseUrl/guides/ventilation')
            .replace(queryParameters: queryParams);
        final response = await http.get(uri).timeout(
          const Duration(seconds: 30),
          onTimeout: () => throw TimeoutException('Request timeout'),
        );

        return _handleResponse(response);
      },
    );
  }

  /// 실시간 공기질 데이터 조회
  static Future<Map<String, dynamic>?> getAirQuality({
    required double latitude,
    required double longitude,
    bool includeForecast = false,
  }) async {
    return _retryableRequest(
      () async {
        final queryParams = {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          'include_forecast': includeForecast.toString(),
        };

        final uri = Uri.parse('$baseUrl/weather/current')
            .replace(queryParameters: queryParams);
        final response = await http.get(uri).timeout(
          const Duration(seconds: 30),
          onTimeout: () => throw TimeoutException('Request timeout'),
        );

        return _handleResponse(response);
      },
    );
  }

  /// 외출 가이드 조회
  static Future<Map<String, dynamic>?> getOutdoorGuide({
    required double latitude,
    required double longitude,
  }) async {
    return _retryableRequest(
      () async {
        final queryParams = {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        };

        final uri = Uri.parse('$baseUrl/guides/outdoor')
            .replace(queryParameters: queryParams);
        final response = await http.get(uri).timeout(
          const Duration(seconds: 30),
          onTimeout: () => throw TimeoutException('Request timeout'),
        );

        return _handleResponse(response);
      },
    );
  }

  /// 오늘의 환경 데이터 조회
  static Future<Map<String, dynamic>?> getEnvironmentToday({
    required double latitude,
    required double longitude,
  }) async {
    return _retryableRequest(
      () async {
        final queryParams = {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        };

        final uri = Uri.parse('$baseUrl/weather/today')
            .replace(queryParameters: queryParams);
        final response = await http.get(uri).timeout(
          const Duration(seconds: 30),
          onTimeout: () => throw TimeoutException('Request timeout'),
        );

        return _handleResponse(response);
      },
    );
  }

  /// 가전제품 사용 가이드 조회
  static Future<Map<String, dynamic>?> getApplianceGuide({
    required double latitude,
    required double longitude,
  }) async {
    return _retryableRequest(
      () async {
        final queryParams = {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        };

        final uri = Uri.parse('$baseUrl/guides/appliances')
            .replace(queryParameters: queryParams);
        final response = await http.get(uri).timeout(
          const Duration(seconds: 30),
          onTimeout: () => throw TimeoutException('Request timeout'),
        );

        return _handleResponse(response);
      },
    );
  }

  /// 주간 생활 가이드 조회
  static Future<Map<String, dynamic>?> getWeeklyPlan({
    required double latitude,
    required double longitude,
    int days = 7,
  }) async {
    return _retryableRequest(
      () async {
        final queryParams = {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          'days': days.toString(),
        };

        final uri = Uri.parse('$baseUrl/guides/weekly')
            .replace(queryParameters: queryParams);

        final response = await http.get(uri).timeout(
          const Duration(seconds: 30),  // API 응답이 오래 걸리므로 30초로 증가
          onTimeout: () => throw TimeoutException('Request timeout after 30 seconds'),
        );

        return _handleResponse(response);
      },
    );
  }

  /// 표준 응답 처리
  static Map<String, dynamic>? _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return json['data'] as Map<String, dynamic>?;
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: _parseErrorMessage(response),
      );
    }
  }

  /// 에러 메시지 파싱
  static String _parseErrorMessage(http.Response response) {
    try {
      final json = jsonDecode(response.body);
      return json['message'] ?? 'Unknown error occurred';
    } catch (e) {
      return 'HTTP ${response.statusCode}: ${response.reasonPhrase}';
    }
  }

  /// 재시도 로직 (지수 백오프)
  static Future<T?> _retryableRequest<T>(Future<T?> Function() request) async {
    int retryCount = 0;
    Duration delay = _initialDelay;

    while (retryCount < _maxRetries) {
      try {
        return await request();
      } catch (e) {
        retryCount++;
        if (retryCount >= _maxRetries) {
          rethrow;
        }
        await Future.delayed(delay);
        delay *= 2; // 지수 백오프: 1s -> 2s -> 4s
      }
    }
    return null;
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException: [$statusCode] $message';
}
