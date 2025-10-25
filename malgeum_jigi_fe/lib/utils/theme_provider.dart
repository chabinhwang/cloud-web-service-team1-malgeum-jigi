import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  light,    // 라이트 모드
  dark,     // 다크 모드
  system,   // 시스템 설정과 동기화 (자동)
}

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';

  late SharedPreferences _prefs;
  AppThemeMode _themeMode = AppThemeMode.system;

  AppThemeMode get themeMode => _themeMode;

  /// 초기화 - 저장된 테마 설정을 불러옴
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadThemeMode();
  }

  /// 저장된 테마 모드를 불러옴
  void _loadThemeMode() {
    final savedTheme = _prefs.getString(_themeKey);
    if (savedTheme == null) {
      _themeMode = AppThemeMode.system;
    } else {
      _themeMode = AppThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedTheme,
        orElse: () => AppThemeMode.system,
      );
    }
    notifyListeners();
  }

  /// 테마 모드 변경 및 저장
  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setString(_themeKey, mode.toString());
    notifyListeners();
  }

  /// 다음 테마로 순환 (light -> dark -> system -> light...)
  Future<void> toggleTheme() async {
    final nextMode = AppThemeMode.values[(AppThemeMode.values.indexOf(_themeMode) + 1) % AppThemeMode.values.length];
    await setThemeMode(nextMode);
  }

  /// 시스템 밝기에 따라 실제 사용할 밝기 결정
  Brightness getEffectiveBrightness(BuildContext context) {
    if (_themeMode == AppThemeMode.system) {
      return MediaQuery.of(context).platformBrightness;
    }
    return _themeMode == AppThemeMode.dark ? Brightness.dark : Brightness.light;
  }

  /// 현재 테마 모드의 표시 텍스트
  String getThemeModeLabel() {
    switch (_themeMode) {
      case AppThemeMode.light:
        return '라이트 모드';
      case AppThemeMode.dark:
        return '다크 모드';
      case AppThemeMode.system:
        return '자동 (기기 설정)';
    }
  }

  /// 현재 테마 모드의 아이콘
  IconData getThemeModeIcon() {
    switch (_themeMode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
