import 'package:flutter/material.dart';
import '../utils/responsive_util.dart';
import 'app_theme.dart';

/// 앱 전체에서 사용하는 일관된 텍스트 스타일을 정의합니다.
/// ResponsiveUtil을 통한 화면 크기별 자동 조정을 포함합니다.
class AppTextStyles {
  /// 현재 테마의 brightness를 반환합니다.
  static Brightness _getBrightness(BuildContext context) {
    return Theme.of(context).brightness;
  }

  // ============ Heading Styles ============

  /// 제목 1 - 매우 큰 제목 (28px)
  static TextStyle title1(BuildContext context) => TextStyle(
    fontSize: 28 * ResponsiveUtil.getTextScaleFactor(context),
    fontWeight: FontWeight.bold,
    color: AppTheme.textPrimary,
  );

  /// 제목 2 - 큰 제목 (24px)
  static TextStyle title2(BuildContext context) => TextStyle(
    fontSize: 24 * ResponsiveUtil.getTextScaleFactor(context),
    fontWeight: FontWeight.bold,
    color: AppTheme.textPrimary,
  );

  /// 제목 3 - 중간 제목 (20px)
  static TextStyle title3(BuildContext context) => TextStyle(
    fontSize: 20 * ResponsiveUtil.getTextScaleFactor(context),
    fontWeight: FontWeight.bold,
    color: AppTheme.textPrimary,
  );

  /// 헤딩 - 작은 제목 (18px)
  static TextStyle heading(BuildContext context) => TextStyle(
    fontSize: 18 * ResponsiveUtil.getTextScaleFactor(context),
    fontWeight: FontWeight.bold,
    color: AppTheme.textPrimary,
  );

  /// 헤딩 - 더 작은 제목 (16px, bold)
  static TextStyle headingSmall(BuildContext context) => TextStyle(
    fontSize: 16 * ResponsiveUtil.getTextScaleFactor(context),
    fontWeight: FontWeight.bold,
    color: AppTheme.textPrimary,
  );

  // ============ Body Styles ============

  /// 본문 - 큰 텍스트 (18px)
  static TextStyle bodyLarge(BuildContext context) => TextStyle(
    fontSize: 18 * ResponsiveUtil.getTextScaleFactor(context),
    color: AppTheme.textPrimary,
  );

  /// 본문 - 일반 텍스트 (16px)
  static TextStyle body(BuildContext context) => TextStyle(
    fontSize: 16 * ResponsiveUtil.getTextScaleFactor(context),
    color: AppTheme.textPrimary,
  );

  /// 본문 - 일반 텍스트 (14px)
  static TextStyle bodyMedium(BuildContext context) => TextStyle(
    fontSize: 14 * ResponsiveUtil.getTextScaleFactor(context),
    color: AppTheme.textPrimary,
  );

  /// 본문 - 작은 텍스트 (12px)
  static TextStyle bodySmall(BuildContext context) => TextStyle(
    fontSize: 12 * ResponsiveUtil.getTextScaleFactor(context),
    color: AppTheme.textPrimary,
  );

  // ============ Secondary Styles (보조 텍스트) ============

  /// 보조 텍스트 - 큰 (16px)
  static TextStyle secondaryLarge(BuildContext context) => TextStyle(
    fontSize: 16 * ResponsiveUtil.getTextScaleFactor(context),
    color: AppTheme.textSecondary,
  );

  /// 보조 텍스트 - 일반 (14px)
  static TextStyle secondary(BuildContext context) => TextStyle(
    fontSize: 14 * ResponsiveUtil.getTextScaleFactor(context),
    color: AppTheme.textSecondary,
  );

  /// 보조 텍스트 - 작은 (12px)
  static TextStyle secondarySmall(BuildContext context) => TextStyle(
    fontSize: 12 * ResponsiveUtil.getTextScaleFactor(context),
    color: AppTheme.textSecondary,
  );

  // ============ Special Styles ============

  /// 캡션 텍스트 (12px, 보조색)
  static TextStyle caption(BuildContext context) => TextStyle(
    fontSize: 12 * ResponsiveUtil.getTextScaleFactor(context),
    color: AppTheme.textSecondary,
  );

  /// 라벨 텍스트 (12px, bold, 주요색)
  static TextStyle label(BuildContext context) => TextStyle(
    fontSize: 12 * ResponsiveUtil.getTextScaleFactor(context),
    fontWeight: FontWeight.w600,
    color: AppTheme.textPrimary,
  );

  /// 배지 텍스트 (12px, bold)
  static TextStyle badge(BuildContext context) => TextStyle(
    fontSize: 12 * ResponsiveUtil.getTextScaleFactor(context),
    fontWeight: FontWeight.bold,
    color: AppTheme.textPrimary,
  );

  /// 점수 텍스트 (매우 큰, 80px)
  static TextStyle score(BuildContext context) => TextStyle(
    fontSize: 80 * ResponsiveUtil.getTextScaleFactor(context),
    fontWeight: FontWeight.bold,
    color: AppTheme.textPrimary,
  );

  /// 상태 설명 텍스트 (24px)
  static TextStyle statusDescription(BuildContext context) => TextStyle(
    fontSize: 24 * ResponsiveUtil.getTextScaleFactor(context),
    fontWeight: FontWeight.w600,
    color: AppTheme.textPrimary,
  );

  // ============ Location/Time Styles ============

  /// 위치/시간 텍스트 (14px)
  static TextStyle locationTime(BuildContext context) => TextStyle(
    fontSize: 14 * ResponsiveUtil.getTextScaleFactor(context),
    color: AppTheme.getLocationTimeTextColor(_getBrightness(context)),
  );

  /// 위치/시간 라벨 (12px)
  static TextStyle locationTimeLabel(BuildContext context) => TextStyle(
    fontSize: 12 * ResponsiveUtil.getTextScaleFactor(context),
    color: AppTheme.getLocationTimeTextColor(_getBrightness(context)),
  );

  // ============ Recommendation Styles ============

  /// 권장사항 텍스트 (14px)
  static TextStyle recommendation(BuildContext context) => TextStyle(
    fontSize: 14 * ResponsiveUtil.getTextScaleFactor(context),
    color: AppTheme.getRecommendationTextColor(_getBrightness(context)),
  );

  /// 권장사항 라벨 (12px)
  static TextStyle recommendationLabel(BuildContext context) => TextStyle(
    fontSize: 12 * ResponsiveUtil.getTextScaleFactor(context),
    color: AppTheme.getRecommendationTextColor(_getBrightness(context)),
  );

  /// 권장사항 라벨 (bold)
  static TextStyle recommendationLabelBold(BuildContext context) =>
      TextStyle(
    fontSize: 12 * ResponsiveUtil.getTextScaleFactor(context),
    fontWeight: FontWeight.w600,
    color: AppTheme.getRecommendationTextColor(_getBrightness(context)),
  );
}
