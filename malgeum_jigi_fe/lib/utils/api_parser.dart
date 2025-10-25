import '../models/air_quality_data.dart';
import '../constants/app_constants.dart';

/// API 응답을 안전하게 파싱하는 유틸 클래스
class ApiParser {
  /// 안전하게 int를 파싱합니다.
  /// [value]가 null이거나 유효하지 않으면 [defaultValue]를 반환합니다.
  static int parseInt(dynamic value, int defaultValue) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return defaultValue;
  }

  /// 안전하게 double을 파싱합니다.
  /// [value]가 null이거나 유효하지 않으면 [defaultValue]를 반환합니다.
  static double parseDouble(dynamic value, double defaultValue) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return defaultValue;
  }

  /// 안전하게 bool을 파싱합니다.
  static bool parseBool(dynamic value, bool defaultValue) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    return defaultValue;
  }

  /// 안전하게 String을 파싱합니다.
  static String parseString(dynamic value, String defaultValue) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    return defaultValue;
  }

  /// AirQualityData를 API 응답에서 파싱합니다.
  /// 응답이 null이거나 필드가 없으면 기본값을 사용합니다.
  static AirQualityData parseAirQuality(Map<String, dynamic>? json) {
    if (json == null) {
      return _getDefaultAirQualityData();
    }

    return AirQualityData(
      pm10: parseDouble(json['pm10'], AppConstants.defaultPM10),
      pm25: parseDouble(json['pm25'], AppConstants.defaultPM25),
      temperature: parseDouble(
        json['temperature'],
        AppConstants.defaultTemperature,
      ),
      humidity: parseDouble(json['humidity'], AppConstants.defaultHumidity),
      precipitation: parseBool(json['precipitation'], false),
    );
  }

  /// TodayEnvironmentData를 API 응답에서 파싱합니다.
  static TodayEnvironmentData parseTodayEnvironment(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return _getDefaultTodayEnvironmentData();
    }

    return TodayEnvironmentData(
      minTemp: parseInt(json['min_temperature'], AppConstants.defaultMinTemp),
      maxTemp: parseInt(json['max_temperature'], AppConstants.defaultMaxTemp),
      avgHumidity: parseInt(
        json['avg_humidity'],
        AppConstants.defaultAvgHumidity,
      ),
      eveningHumidity: parseInt(
        json['evening_humidity'],
        AppConstants.defaultEveningHumidity,
      ),
      currentHumidity: parseInt(
        json['current_humidity'],
        AppConstants.defaultCurrentHumidity,
      ),
    );
  }

  /// ApplianceGuide 리스트를 API 응답에서 파싱합니다.
  static List<ApplianceGuide> parseAppliances(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return _getDefaultAppliances();
    }

    final appliancesList = json['appliances'] as List<dynamic>? ?? [];
    if (appliancesList.isEmpty) {
      return _getDefaultAppliances();
    }

    return appliancesList
        .map((e) {
          if (e is! Map<String, dynamic>) return null;
          return ApplianceGuide(
            name: parseString(e['name'], ''),
            status: parseString(e['status'], '필요'),
            time: e['time'] as String?,
            reason: parseString(e['reason'], ''),
            setting: e['setting'] as String?,
          );
        })
        .whereType<ApplianceGuide>()
        .toList();
  }

  /// 기본 AirQualityData를 반환합니다.
  static AirQualityData _getDefaultAirQualityData() {
    return const AirQualityData(
      pm10: AppConstants.defaultPM10,
      pm25: AppConstants.defaultPM25,
      temperature: AppConstants.defaultTemperature,
      humidity: AppConstants.defaultHumidity,
      precipitation: false,
    );
  }

  /// 기본 TodayEnvironmentData를 반환합니다.
  static TodayEnvironmentData _getDefaultTodayEnvironmentData() {
    return const TodayEnvironmentData(
      minTemp: AppConstants.defaultMinTemp,
      maxTemp: AppConstants.defaultMaxTemp,
      avgHumidity: AppConstants.defaultAvgHumidity,
      eveningHumidity: AppConstants.defaultEveningHumidity,
      currentHumidity: AppConstants.defaultCurrentHumidity,
    );
  }

  /// 기본 ApplianceGuide 리스트를 반환합니다.
  static List<ApplianceGuide> _getDefaultAppliances() {
    return const [
      ApplianceGuide(
        name: '제습기',
        status: '필요',
        time: '오후 6시 ~ 밤 11시',
        reason: '저녁부터 습도가 80% 이상으로 올라가요. 곰팡이 예방과 쾌적한 실내 환경을 위해 제습기를 켜두세요.',
        setting: '습도 55~60% 유지',
      ),
      ApplianceGuide(
        name: '난방',
        status: '필요',
        time: '새벽 5시 ~ 오전 8시',
        reason: '새벽 기온이 8°C까지 떨어져요. 기상 30분 전에 타이머를 설정하면 따뜻하게 일어날 수 있어요.',
        setting: '20~22°C',
      ),
      ApplianceGuide(
        name: '에어컨',
        status: '불필요',
        time: null,
        reason: '오늘은 에어컨 없이도 쾌적해요!',
        setting: null,
      ),
    ];
  }
}
