import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 앱 테마 모드 열거형
enum AppThemeMode {
  light,    // 라이트 모드
  dark,     // 다크 모드
  system,   // 시스템 설정과 동기화 (자동)
}

/// 테마 제공자 - SharedPreferences를 사용하여 사용자의 테마 선택을 저장/복원
///
/// 책임:
/// - 테마 모드 상태 관리 (light/dark/system)
/// - SharedPreferences를 통한 설정 저장
/// - 테마 모드 변경 시 UI 업데이트 (ChangeNotifier)
/// - 테마 모드별 표시 텍스트 및 아이콘 제공
class ThemeProvider extends ChangeNotifier {
  // 상수 정의
  static const String _themeKey = 'app_theme_mode';
  static const AppThemeMode _defaultThemeMode = AppThemeMode.system;

  // 필드
  late SharedPreferences _prefs;
  AppThemeMode _themeMode = _defaultThemeMode;

  // Getter
  AppThemeMode get themeMode => _themeMode;

  /// 초기화 - SharedPreferences 설정 및 저장된 테마 모드 로드
  ///
  /// main() 함수에서 runApp 호출 전에 반드시 호출해야 함
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _loadThemeMode();
    } catch (e) {
      debugPrint('ThemeProvider init error: $e');
      _themeMode = _defaultThemeMode;
      notifyListeners();
    }
  }

  /// 저장된 테마 모드를 로드하고 리스너 알림
  void _loadThemeMode() {
    final savedTheme = _prefs.getString(_themeKey);
    if (savedTheme == null) {
      _themeMode = _defaultThemeMode;
    } else {
      _themeMode = AppThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedTheme,
        orElse: () => _defaultThemeMode,
      );
    }
    notifyListeners();
  }

  /// 테마 모드를 변경하고 SharedPreferences에 저장
  ///
  /// [mode] 변경할 테마 모드
  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode == mode) return; // 동일한 모드면 중복 저장 방지

    try {
      _themeMode = mode;
      await _prefs.setString(_themeKey, mode.toString());
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting theme mode: $e');
      // 에러 발생 시 상태 복원
      _loadThemeMode();
    }
  }

  /// 테마 모드를 순환 (light -> dark -> system -> light...)
  ///
  /// 토글 버튼 클릭 시 사용
  Future<void> toggleTheme() async {
    final nextIndex = (AppThemeMode.values.indexOf(_themeMode) + 1) %
        AppThemeMode.values.length;
    final nextMode = AppThemeMode.values[nextIndex];
    await setThemeMode(nextMode);
  }

  /// 시스템 밝기에 따라 실제 사용할 밝기 결정
  ///
  /// [context] BuildContext - 시스템 밝기 확인에 필요
  /// 반환: 현재 테마 모드에 따른 밝기
  Brightness getEffectiveBrightness(BuildContext context) {
    if (_themeMode == AppThemeMode.system) {
      return MediaQuery.of(context).platformBrightness;
    }
    return _themeMode == AppThemeMode.dark
        ? Brightness.dark
        : Brightness.light;
  }

  /// 현재 테마 모드의 표시 텍스트
  ///
  /// UI에 표시할 한글 라벨 반환
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
  ///
  /// UI에 표시할 Material 아이콘 반환
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
