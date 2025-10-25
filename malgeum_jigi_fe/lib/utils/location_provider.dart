import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

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

      // 기본 위치명 설정 (역지오코딩은 나중에 구현 가능)
      _locationName = '현재 위치';

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
}
