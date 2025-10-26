class AirQualityData {
  final double pm10;
  final double pm25;
  final double temperature;
  final double humidity;
  final bool precipitation;

  const AirQualityData({
    required this.pm10,
    required this.pm25,
    required this.temperature,
    required this.humidity,
    this.precipitation = false,
  });

  factory AirQualityData.fromJson(Map<String, dynamic> json) {
    return AirQualityData(
      pm10: (json['pm10'] as num).toDouble(),
      pm25: (json['pm25'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      precipitation: json['precipitation'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pm10': pm10,
      'pm25': pm25,
      'temperature': temperature,
      'humidity': humidity,
      'precipitation': precipitation,
    };
  }

  String getPM10Status() {
    if (pm10 <= 30) return '좋음';
    if (pm10 <= 80) return '보통';
    if (pm10 <= 150) return '나쁨';
    return '매우나쁨';
  }

  String getPM25Status() {
    if (pm25 <= 15) return '좋음';
    if (pm25 <= 35) return '보통';
    if (pm25 <= 75) return '나쁨';
    return '매우나쁨';
  }

  String getHumidityStatus() {
    if (humidity >= 40 && humidity <= 60) return '적정';
    if (humidity > 60 && humidity <= 80) return '높음';
    if (humidity > 80) return '매우높음';
    return '낮음';
  }

  String getTemperatureStatus() {
    if (temperature >= 18 && temperature <= 26) return '쾌적';
    if (temperature < 18) return '추움';
    return '더움';
  }
}

class TodayEnvironmentData {
  final String date;
  final double minTemp;
  final double maxTemp;
  final int avgHumidity;

  const TodayEnvironmentData({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.avgHumidity,
  });

  factory TodayEnvironmentData.fromJson(Map<String, dynamic> json) {
    return TodayEnvironmentData(
      date: json['date'] as String,
      minTemp: (json['min_temperature'] as num).toDouble(),
      maxTemp: (json['max_temperature'] as num).toDouble(),
      avgHumidity: (json['avg_humidity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'min_temperature': minTemp,
      'max_temperature': maxTemp,
      'avg_humidity': avgHumidity,
    };
  }
}

class ApplianceGuide {
  final String name;
  final String status; // "필요", "불필요"
  final String? time;
  final String reason;
  final String? setting;

  const ApplianceGuide({
    required this.name,
    required this.status,
    this.time,
    required this.reason,
    this.setting,
  });

  factory ApplianceGuide.fromJson(Map<String, dynamic> json) {
    return ApplianceGuide(
      name: json['name'] as String,
      status: json['status'] as String,
      time: json['time'] as String?,
      reason: json['reason'] as String,
      setting: json['setting'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'status': status,
      'time': time,
      'reason': reason,
      'setting': setting,
    };
  }

  bool get isRequired => status == '필요';
}
