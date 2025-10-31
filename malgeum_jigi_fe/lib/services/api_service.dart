import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API 서비스 상수 정의
class _ApiConstants {
  static const int maxRetries = 3;
  static const Duration initialDelay = Duration(seconds: 1);
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration longTimeout = Duration(seconds: 60);
}

class ApiService {
  // 런타임에 .env에서 API_BASE_URL을 읽음
  static String get baseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api';
  }

  /// 공통 GET 요청 처리 메서드 - 중복 코드 제거
  ///
  /// [endpoint] API 엔드포인트 경로
  /// [params] 쿼리 파라미터 맵
  /// [timeout] 요청 타임아웃 (기본값: 30초)
  static Future<Map<String, dynamic>?> _getRequest({
    required String endpoint,
    Map<String, String>? params,
    Duration timeout = _ApiConstants.defaultTimeout,
  }) {
    return _retryableRequest(
      () async {
        final uri = Uri.parse('$baseUrl$endpoint')
            .replace(queryParameters: params);

        final response = await http.get(uri).timeout(
          timeout,
          onTimeout: () => throw TimeoutException('Request timeout after ${timeout.inSeconds}s'),
        );

        return _handleResponse(response);
      },
    );
  }

  /// 환기 점수 조회
  static Future<Map<String, dynamic>?> getVentilationScore({
    required double latitude,
    required double longitude,
    String? locationName,
  }) {
    final params = {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      if (locationName != null) 'location': locationName,
    };

    return _getRequest(endpoint: '/guides/ventilation', params: params);
  }

  /// 실시간 공기질 데이터 조회
  static Future<Map<String, dynamic>?> getAirQuality({
    required double latitude,
    required double longitude,
    bool includeForecast = false,
  }) {
    final params = {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'include_forecast': includeForecast.toString(),
    };

    return _getRequest(endpoint: '/weather/current', params: params);
  }

  /// 외출 가이드 조회
  static Future<Map<String, dynamic>?> getOutdoorGuide({
    required double latitude,
    required double longitude,
  }) {
    final params = {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    };

    return _getRequest(endpoint: '/guides/outdoor', params: params);
  }

  /// 오늘의 환경 데이터 조회
  static Future<Map<String, dynamic>?> getEnvironmentToday({
    required double latitude,
    required double longitude,
  }) {
    final params = {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    };

    return _getRequest(endpoint: '/weather/today', params: params);
  }

  /// 가전제품 사용 가이드 조회
  static Future<Map<String, dynamic>?> getApplianceGuide({
    required double latitude,
    required double longitude,
  }) {
    final params = {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    };

    return _getRequest(endpoint: '/guides/appliances', params: params);
  }

  /// 주간 생활 가이드 조회 (긴 타임아웃 적용: 60초)
  static Future<Map<String, dynamic>?> getWeeklyPlan({
    required double latitude,
    required double longitude,
    int days = 7,
  }) {
    final params = {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'days': days.toString(),
    };

    return _getRequest(
      endpoint: '/guides/weekly',
      params: params,
      timeout: _ApiConstants.longTimeout,
    );
  }

  /// 표준 응답 처리
  /// 성공 응답에서 data 필드를 추출하고, 실패 시 ApiException 발생
  static Map<String, dynamic>? _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final json = jsonDecode(response.body);
        return json['data'] as Map<String, dynamic>?;
      } catch (e) {
        throw ApiException(
          statusCode: response.statusCode,
          message: 'Failed to parse response: $e',
          isParsingError: true,
        );
      }
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: _parseErrorMessage(response),
      );
    }
  }

  /// 에러 메시지 파싱
  /// 서버 응답에서 error 메시지를 추출하거나, 없으면 HTTP 상태 텍스트 반환
  static String _parseErrorMessage(http.Response response) {
    try {
      final json = jsonDecode(response.body);
      return json['message'] ??
          json['error'] ??
          'Unknown error occurred';
    } catch (e) {
      return 'HTTP ${response.statusCode}: ${response.reasonPhrase ?? 'Unknown error'}';
    }
  }

  /// 재시도 로직 (지수 백오프)
  /// 최대 [_ApiConstants.maxRetries]번 재시도하며, 각 재시도 간 대기 시간을 2배 증가
  /// [TimeoutException]과 네트워크 예외는 재시도, [ApiException]은 재시도하지 않음
  static Future<T?> _retryableRequest<T>(Future<T?> Function() request) async {
    int retryCount = 0;
    Duration delay = _ApiConstants.initialDelay;

    while (retryCount < _ApiConstants.maxRetries) {
      try {
        return await request();
      } on TimeoutException catch (e) {
        retryCount++;
        if (retryCount >= _ApiConstants.maxRetries) {
          throw ApiException(
            statusCode: 408,
            message: 'Request timeout after ${_ApiConstants.maxRetries} retries: ${e.message}',
          );
        }
        await Future.delayed(delay);
        delay *= 2; // 지수 백오프: 1s -> 2s -> 4s
      } on ApiException {
        // API 예외는 재시도하지 않음 (4xx, 5xx 에러)
        rethrow;
      } catch (e) {
        retryCount++;
        if (retryCount >= _ApiConstants.maxRetries) {
          throw ApiException(
            statusCode: -1,
            message: 'Network error after ${_ApiConstants.maxRetries} retries: $e',
          );
        }
        await Future.delayed(delay);
        delay *= 2;
      }
    }
    return null;
  }
}

/// API 예외 클래스
/// HTTP 요청 실패 또는 응답 파싱 실패 시 발생
class ApiException implements Exception {
  final int statusCode; // HTTP 상태 코드 (또는 -1 for network error)
  final String message; // 에러 메시지
  final bool isParsingError; // 파싱 에러 여부

  ApiException({
    required this.statusCode,
    required this.message,
    this.isParsingError = false,
  });

  @override
  String toString() => 'ApiException: [$statusCode] $message';
}
