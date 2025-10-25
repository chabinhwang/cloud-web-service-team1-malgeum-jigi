import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 가전제품의 UI 설정을 정의하는 클래스
class ApplianceConfig {
  final IconData icon;
  final Color activeBackgroundColor;
  final Color activeTextColor;

  const ApplianceConfig({
    required this.icon,
    required this.activeBackgroundColor,
    required this.activeTextColor,
  });

  /// 모든 가전제품의 설정을 정의합니다.
  static const Map<String, ApplianceConfig> configs = {
    '제습기': ApplianceConfig(
      icon: Icons.air,
      activeBackgroundColor: AppTheme.lightBlue,
      activeTextColor: AppTheme.accentBlue,
    ),
    '난방': ApplianceConfig(
      icon: Icons.thermostat,
      activeBackgroundColor: AppTheme.lightRed,
      activeTextColor: AppTheme.badRed,
    ),
    '에어컨': ApplianceConfig(
      icon: Icons.ac_unit,
      activeBackgroundColor: AppTheme.lightBlue,
      activeTextColor: AppTheme.accentBlue,
    ),
  };

  /// 가전제품 이름으로 설정을 가져옵니다.
  /// 정의되지 않은 가전제품은 기본 설정을 반환합니다.
  static ApplianceConfig get(String applianceName) {
    return configs[applianceName] ?? _defaultConfig;
  }

  /// 기본 설정 (정의되지 않은 가전제품용)
  static const ApplianceConfig _defaultConfig = ApplianceConfig(
    icon: Icons.device_unknown,
    activeBackgroundColor: AppTheme.lightBlue,
    activeTextColor: AppTheme.accentBlue,
  );
}
