import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'location_provider.dart';

/// API 데이터 로딩의 공통 로직을 처리하는 유틸리티 클래스
///
/// 각 탭에서 반복되는 다음 로직을 중앙화합니다:
/// - 위치 정보 수집
/// - 위치 수집 실패 시 기본값 설정
/// - API 호출
/// - 에러 처리
///
/// 사용 예:
/// ```dart
/// final loader = ApiDataLoader(context);
/// await loader.loadWithLocation(
///   apiCall: (lat, lon) => ApiService.getVentilationScore(
///     latitude: lat,
///     longitude: lon,
///   ),
/// );
/// ```
class ApiDataLoader {
  final BuildContext context;

  ApiDataLoader(this.context);

  /// 위치 정보를 수집한 후 API 호출을 실행합니다.
  ///
  /// [apiCall]: 위도와 경도를 받아 API 응답을 반환하는 함수
  /// 반환값: API 응답 데이터 (null 가능)
  ///
  /// 실패 시:
  /// - 위치 수집 실패 → 기본값(서울) 사용
  /// - API 호출 실패 → ApiException 발생
  Future<Map<String, dynamic>?> loadWithLocation({
    required Future<Map<String, dynamic>?> Function(double latitude, double longitude)
        apiCall,
  }) async {
    final locationProvider = context.read<LocationProvider>();

    // 1. 실제 사용자 위치 수집 시도
    bool hasLocation = await locationProvider.getCurrentLocation();

    // 2. 위치 수집 실패 시 기본값 설정
    if (!hasLocation) {
      locationProvider.setDefaultLocation();
    }

    // 3. API 호출 (위도, 경도 전달)
    return await apiCall(
      locationProvider.latitude!,
      locationProvider.longitude!,
    );
  }

  /// 위치 정보를 수집한 후 API 호출을 실행하고 데이터를 파싱합니다.
  ///
  /// [apiCall]: API를 호출하는 함수
  /// [parser]: API 응답을 파싱하는 함수
  /// 반환값: 파싱된 데이터
  ///
  /// 사용 예:
  /// ```dart
  /// final ventilationData = await loader.loadAndParse(
  ///   apiCall: (lat, lon) => ApiService.getVentilationScore(
  ///     latitude: lat,
  ///     longitude: lon,
  ///   ),
  ///   parser: (response) => ApiParser.parseVentilationScore(response),
  /// );
  /// ```
  Future<T> loadAndParse<T>({
    required Future<Map<String, dynamic>?> Function(double latitude, double longitude)
        apiCall,
    required T Function(Map<String, dynamic>?) parser,
  }) async {
    final response = await loadWithLocation(apiCall: apiCall);
    return parser(response);
  }
}
