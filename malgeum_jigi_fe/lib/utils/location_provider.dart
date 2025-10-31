import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationProvider extends ChangeNotifier {
  double? _latitude;
  double? _longitude;
  String? _locationName;
  bool _isLoading = false;
  String? _error;

  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String? get locationName => _locationName;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 사용자의 현재 위치 가져오기
  Future<bool> getCurrentLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 위치 권한 확인
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _error = '위치 서비스가 비활성화되어 있습니다.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _error = '위치 권한이 거부되었습니다.';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _error = '위치 권한이 영구적으로 거부되었습니다. 설정에서 변경하세요.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // 위치 정보 가져오기
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('위치 조회 시간 초과'),
      );

      _latitude = position.latitude;
      _longitude = position.longitude;

      // 역지오코딩: 좌표 → 주소명 변환 (Nominatim API 사용)
      try {
        _locationName = await _reverseGeocode(position.latitude, position.longitude);
      } catch (e) {
        // 역지오코딩 실패 시 기본값 사용
        _locationName = '현재 위치';
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = '위치 정보를 가져올 수 없습니다: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// 위치 정보 수동으로 설정 (테스트용)
  void setLocation(double latitude, double longitude, {String? locationName}) {
    _latitude = latitude;
    _longitude = longitude;
    _locationName = locationName ?? '사용자 지정 위치';
    _error = null;
    notifyListeners();
  }

  /// 기본 위치로 설정 (서울 강남구)
  void setDefaultLocation() {
    _latitude = 37.4979;
    _longitude = 127.0276;
    _locationName = '서울특별시 강남구';
    _error = null;
    notifyListeners();
  }

  /// Nominatim API를 사용하여 좌표를 주소로 변환
  /// [latitude] 위도
  /// [longitude] 경도
  /// 반환값: 한국 형식의 주소 (예: "서울특별시 중구") 또는 실패 시 "현재 위치"
  Future<String> _reverseGeocode(double latitude, double longitude) async {
    try {
      final String url =
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&accept-language=ko';

      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw TimeoutException('Geocoding request timeout'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final address = json['address'] as Map<String, dynamic>?;

        if (address != null) {
          final String? city = address['city'] as String?;
          final String? borough = address['borough'] as String?;

          // city와 borough 모두 있으면 "시 구" 형식으로 반환
          if (city != null && city.isNotEmpty && borough != null && borough.isNotEmpty) {
            return '$city $borough';
          } else if (city != null && city.isNotEmpty) {
            return city;
          }
        }
      }

      return '현재 위치';
    } catch (e) {
      return '현재 위치';
    }
  }
}
