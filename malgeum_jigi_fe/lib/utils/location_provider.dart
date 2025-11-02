import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationProvider extends ChangeNotifier {
  double? _latitude;
  double? _longitude;
  String? _locationName;
  String? _region;
  String? _city;
  String? _locationType; // 'gps' 또는 'ip'
  bool _isLoading = false;
  String? _error;

  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String? get locationName => _locationName;
  String? get region => _region;
  String? get city => _city;
  String? get locationType => _locationType;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 사용자의 현재 위치 가져오기 (자동 선택: GPS 또는 IP)
  ///
  /// GPS 가능하면 GPS 사용, 불가능하면 IP 기반 위치 조회
  /// Web 환경에서 권한 요청 불가능한 경우 IP 방식 사용
  Future<bool> getCurrentLocation() async {
    // Web 환경에서 위치 권한을 사용할 수 있는지 확인
    if (kIsWeb && !await _canRequestLocation()) {
      // Web이고 권한 요청 불가 → IP 방식 사용
      return await getLocationByIP();
    } else {
      // 모바일 또는 HTTPS Web → GPS 방식 시도
      bool gpsSuccess = await _getLocationByGPS();
      if (!gpsSuccess) {
        // GPS 실패 → IP 방식 폴백
        return await getLocationByIP();
      }
      return true;
    }
  }

  /// Web 환경에서 위치 권한 요청 가능 여부 확인
  /// HTTPS 환경이면 true, HTTP 환경이면 false 반환
  Future<bool> _canRequestLocation() async {
    try {
      // 간단한 권한 체크: 권한이 없거나 거부된 상태면 false 반환
      final permission = await Geolocator.checkPermission();
      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      // 권한 요청 불가능 (HTTP 환경)
      return false;
    }
  }

  /// GPS를 사용하여 위치 정보 가져오기 (모바일 및 HTTPS Web)
  Future<bool> _getLocationByGPS() async {
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
      _locationType = 'gps';
      _region = null;
      _city = null;

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

  /// IP 주소를 기반으로 위치 정보 조회 (HTTP 환경용)
  ///
  /// 1. ipify.org에서 공개 IP 조회
  /// 2. ip-api.com에서 IP 기반 위치 정보 조회 (regionName, city, lat, lon 파싱)
  /// 반환: 성공 시 true, 실패 시 false
  Future<bool> getLocationByIP() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1️⃣ 공개 IP 주소 조회
      final ip = await _getPublicIP();

      // 2️⃣ IP로 위치 정보 조회
      final locationData = await _getLocationByIPAPI(ip);

      // 3️⃣ 데이터 파싱 및 저장
      _latitude = locationData['lat'] as double?;
      _longitude = locationData['lon'] as double?;
      _region = locationData['regionName'] as String?;
      _city = locationData['city'] as String?;
      _locationType = 'ip';

      // locationName 설정: "지역, 도시" 형태
      if (_region != null && _city != null) {
        _locationName = '$_region, $_city';
      } else if (_region != null) {
        _locationName = _region;
      } else {
        _locationName = '현재 위치';
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'IP 기반 위치 조회 실패: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// ipify.org에서 공개 IP 주소 조회
  /// 반환: IP 주소 문자열 (예: "172.226.94.46")
  Future<String> _getPublicIP() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.ipify.org?format=json'),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final ip = json['ip'] as String?;
        if (ip != null && ip.isNotEmpty) {
          return ip;
        } else {
          throw Exception('IP 주소를 찾을 수 없습니다');
        }
      } else {
        throw Exception('IP 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('IP 조회 오류: $e');
    }
  }

  /// ip-api.com에서 IP 기반 위치 정보 조회
  /// [ip] IP 주소
  /// 반환: 위치 정보 JSON 맵
  /// 예: {"status":"success","regionName":"Incheon","city":"Incheon","lat":37.4563,"lon":126.705,...}
  Future<Map<String, dynamic>> _getLocationByIPAPI(String ip) async {
    try {
      final response = await http.get(
        Uri.parse('http://ip-api.com/json/$ip'),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'success') {
          return json as Map<String, dynamic>;
        } else {
          throw Exception('위치 조회 실패: ${json['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('API 오류: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('IP 기반 위치 조회 오류: $e');
    }
  }

  /// 위치 정보 수동으로 설정 (테스트용)
  void setLocation(
    double latitude,
    double longitude, {
    String? locationName,
    String? region,
    String? city,
  }) {
    _latitude = latitude;
    _longitude = longitude;
    _locationName = locationName ?? '사용자 지정 위치';
    _region = region;
    _city = city;
    _locationType = 'manual';
    _error = null;
    notifyListeners();
  }

  /// 기본 위치로 설정 (서울 강남구)
  void setDefaultLocation() {
    _latitude = 37.4979;
    _longitude = 127.0276;
    _locationName = '서울특별시 강남구';
    _region = 'Seoul';
    _city = 'Seoul';
    _locationType = 'default';
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
