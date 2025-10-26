import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ActivityType {
  laundry,
  exercise,
  ventilation,
  indoor,
  warning,
  dishwasher,
  air_purifier,
  refrigerator,
  dryer,
  air_conditioner,
  vacuum,
  outdoor,
  hygiene,
}

enum ActivityStatus { recommended, caution, prohibited, optimal }

class Activity {
  final ActivityType type;
  final String emoji;
  final String title;
  final ActivityStatus status;
  final String? time;
  final String reason;

  const Activity({
    required this.type,
    required this.emoji,
    required this.title,
    required this.status,
    this.time,
    required this.reason,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      type: ActivityType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ActivityType.indoor,
      ),
      emoji: json['emoji'] as String,
      title: json['title'] as String,
      status: ActivityStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ActivityStatus.recommended,
      ),
      time: json['time'] as String?,
      reason: json['reason'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'emoji': emoji,
      'title': title,
      'status': status.name,
      'time': time,
      'reason': reason,
    };
  }

  String get statusLabel {
    switch (status) {
      case ActivityStatus.recommended:
        return '✅ 추천';
      case ActivityStatus.optimal:
        return '✨ 최적!';
      case ActivityStatus.caution:
        return '⚠️ 주의';
      case ActivityStatus.prohibited:
        return '❌ 금지';
    }
  }
}

class DayPlan {
  final String date; // "10/17"
  final String dayOfWeek; // "금요일"
  final bool isToday;
  final List<Activity> activities;

  const DayPlan({
    required this.date,
    required this.dayOfWeek,
    this.isToday = false,
    required this.activities,
  });

  factory DayPlan.fromJson(Map<String, dynamic> json) {
    return DayPlan(
      date: json['date'] as String,
      dayOfWeek: json['dayOfWeek'] as String,
      isToday: json['isToday'] as bool? ?? false,
      activities: (json['activities'] as List<dynamic>)
          .map((e) => Activity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'dayOfWeek': dayOfWeek,
      'isToday': isToday,
      'activities': activities.map((e) => e.toJson()).toList(),
    };
  }
}

/// 활동 상태에 따른 색상을 제공하는 Extension
extension ActivityStatusColors on ActivityStatus {
  /// 활동 상태에 해당하는 테두리 색상
  Color getBorderColor() {
    switch (this) {
      case ActivityStatus.recommended:
        return const Color(0xFFBBF7D0); // green-200
      case ActivityStatus.optimal:
        return const Color(0xFF93C5FD); // blue-300
      case ActivityStatus.caution:
        return const Color(0xFFFDE68A); // yellow-200
      case ActivityStatus.prohibited:
        return const Color(0xFFFECACA); // red-200
    }
  }

  /// 활동 상태에 해당하는 배지 배경색
  Color getBadgeColor() {
    switch (this) {
      case ActivityStatus.recommended:
        return AppTheme.lightGreen;
      case ActivityStatus.optimal:
        return AppTheme.lightBlue;
      case ActivityStatus.caution:
        return AppTheme.lightYellow;
      case ActivityStatus.prohibited:
        return AppTheme.lightRed;
    }
  }

  /// 활동 상태에 해당하는 배지 텍스트 색상
  Color getBadgeTextColor() {
    switch (this) {
      case ActivityStatus.recommended:
        return AppTheme.goodGreen;
      case ActivityStatus.optimal:
        return AppTheme.accentBlue;
      case ActivityStatus.caution:
        return const Color(0xFFA16207); // yellow-700
      case ActivityStatus.prohibited:
        return AppTheme.badRed;
    }
  }
}
