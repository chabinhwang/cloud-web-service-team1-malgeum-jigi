import '../models/air_quality_data.dart';
import '../models/weekly_plan.dart';
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
      date: parseString(json['date'], ''),
      minTemp: parseDouble(
        json['min_temperature'],
        AppConstants.defaultMinTemp,
      ),
      maxTemp: parseDouble(
        json['max_temperature'],
        AppConstants.defaultMaxTemp,
      ),
      avgHumidity: parseInt(
        json['humidity'] ?? json['avg_humidity'],
        AppConstants.defaultAvgHumidity,
      ),
    );
  }

  /// ApplianceGuide 리스트를 API 응답에서 파싱합니다.
  static List<ApplianceGuide> parseAppliances(Map<String, dynamic>? json) {
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
    // 오늘 날짜 생성 (YYYY-MM-DD 형식)
    final today = DateTime.now();
    final todayString =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    return TodayEnvironmentData(
      date: todayString,
      minTemp: AppConstants.defaultMinTemp.toDouble(),
      maxTemp: AppConstants.defaultMaxTemp.toDouble(),
      avgHumidity: AppConstants.defaultAvgHumidity,
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

  /// WeeklyPlan 리스트를 API 응답에서 파싱합니다.
  static List<DayPlan> parseWeeklyPlan(Map<String, dynamic>? json) {
    if (json == null) {
      return _getDefaultWeeklyPlan();
    }

    // week_plans 또는 weekPlans 필드 찾기 (필드명 유연화)
    final weekPlansList = (json['week_plans'] ?? json['weekPlans']) as List<dynamic>? ?? [];

    if (weekPlansList.isEmpty) {
      return _getDefaultWeeklyPlan();
    }

    // 오늘 날짜 계산 (YYYY-MM-DD 형식)
    final today = DateTime.now();
    final todayString =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    try {
      final result = weekPlansList
          .map((e) {
            try {
              if (e is! Map<String, dynamic>) {
                return null;
              }

              // API 날짜 형식: "2024-10-23" -> UI 날짜 형식: "10/23"
              final apiDate = parseString(e['date'], '');
              final formattedDate = _formatDateToUI(apiDate);

              // is_today 자동 계산
              final isToday = apiDate == todayString;

              final activitiesList = (e['activities'] as List<dynamic>? ?? []);

              return DayPlan(
                date: formattedDate,
                dayOfWeek: parseString(e['day_of_week'], ''),
                isToday: isToday,
                activities: activitiesList
                    .map((activity) {
                      if (activity is! Map<String, dynamic>) {
                        return null;
                      }

                      final activityType = ActivityType.values.firstWhere(
                        (et) => et.name == activity['type'],
                        orElse: () => ActivityType.indoor,
                      );

                      // API에 emoji 없으면 타입별 기본 emoji 사용
                      final emoji =
                          activity['emoji'] as String? ??
                          _getDefaultEmojiForType(activityType);

                      return Activity(
                        type: activityType,
                        emoji: emoji,
                        title: parseString(activity['title'], ''),
                        status: ActivityStatus.values.firstWhere(
                          (es) => es.name == activity['status'],
                          orElse: () => ActivityStatus.recommended,
                        ),
                        time: activity['time'] as String?,
                        reason: parseString(activity['reason'], ''),
                      );
                    })
                    .whereType<Activity>()
                    .toList(),
              );
            } catch (e) {
              return null;
            }
          })
          .whereType<DayPlan>()
          .toList();

      return result;
    } catch (e) {
      return _getDefaultWeeklyPlan();
    }
  }

  /// 날짜 형식 변환: "2024-10-23" -> "10/23"
  static String _formatDateToUI(String apiDate) {
    if (apiDate.isEmpty) return '';

    try {
      final parts = apiDate.split('-');
      if (parts.length == 3) {
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        return '$month/$day';
      }
    } catch (e) {
      // 파싱 실패시 원본 반환
    }

    return apiDate;
  }

  /// ActivityType별 기본 emoji 반환
  static String _getDefaultEmojiForType(ActivityType type) {
    switch (type) {
      case ActivityType.laundry:
        return '🧺';
      case ActivityType.exercise:
        return '🏃';
      case ActivityType.ventilation:
        return '🧹';
      case ActivityType.indoor:
        return '📺';
      case ActivityType.warning:
        return '⚠️';
      case ActivityType.dishwasher:
        return '🍽️';
      case ActivityType.air_purifier:
        return '💨';
      case ActivityType.refrigerator:
        return '🧊';
      case ActivityType.dryer:
        return '👕';
      case ActivityType.air_conditioner:
        return '❄️';
      case ActivityType.vacuum:
        return '🧹';
      case ActivityType.outdoor:
        return '🌤️';
      case ActivityType.hygiene:
        return '🧼';
    }
  }

  /// 기본 WeeklyPlan 리스트를 반환합니다.
  static List<DayPlan> _getDefaultWeeklyPlan() {
    // 오늘부터 4일간의 더미 데이터 생성
    final today = DateTime.now();
    final daysOfWeek = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];

    final dummyPlans = <DayPlan>[];
    for (int i = 0; i < 4; i++) {
      final date = today.add(Duration(days: i));
      final month = date.month;
      final day = date.day;
      final dayOfWeek = daysOfWeek[date.weekday % 7];
      final isToday = i == 0;

      dummyPlans.add(
        DayPlan(
          date: '$month/$day',
          dayOfWeek: dayOfWeek,
          isToday: isToday,
          activities: const [
            Activity(
              type: ActivityType.indoor,
              emoji: '📺',
              title: '일정 로딩 중',
              status: ActivityStatus.recommended,
              reason: 'API에서 데이터를 받아오는 중입니다.',
            ),
          ],
        ),
      );
    }

    return dummyPlans;
  }
}
