import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// 반응형 디자인을 위한 유틸리티 클래스
class ResponsiveUtil {
  /// 화면 너비에 따른 텍스트 스케일 팩터 계산
  ///
  /// Returns:
  /// - 1.0 for mobile (< 600px)
  /// - 1.1 for tablet (600px - 1199px)
  /// - 1.2 for desktop (>= 1200px)
  static double getTextScaleFactor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppConstants.mobileBreakpoint) return 1.0;
    if (width >= AppConstants.desktopBreakpoint) return 1.2;
    return 1.1;
  }

  /// 탭 헤더의 큰 제목 폰트 크기 계산
  static double getTitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppConstants.mobileBreakpoint) return 28;
    if (width >= AppConstants.desktopBreakpoint) return 36 * 1.2;
    return 36 * 1.1;
  }

  /// 탭 헤더의 작은 제목 폰트 크기 계산 (고정 앱바)
  static double getCollapsedTitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppConstants.mobileBreakpoint) return 18;
    if (width >= AppConstants.desktopBreakpoint) return 18 * 1.2;
    return 18 * 1.1;
  }

  /// 탭 헤더의 부제목 폰트 크기 계산
  static double getSubtitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppConstants.mobileBreakpoint) return 14;
    if (width >= AppConstants.desktopBreakpoint) return 16 * 1.2;
    return 16 * 1.1;
  }

  /// 화면 너비가 모바일 레이아웃인지 확인
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppConstants.mobileBreakpoint;
  }

  /// 화면 너비가 태블릿 레이아웃인지 확인
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppConstants.mobileBreakpoint &&
        width < AppConstants.desktopBreakpoint;
  }

  /// 화면 너비가 데스크톱 레이아웃인지 확인
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppConstants.desktopBreakpoint;
  }
}
