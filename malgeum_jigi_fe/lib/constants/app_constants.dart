/// 앱 전체에서 사용하는 상수들을 정의합니다.
class AppConstants {
  // ============================================
  // Responsive Breakpoints (반응형 브레이크포인트)
  // ============================================
  /// 모바일 레이아웃 브레이크포인트 (600px 미만)
  static const int mobileBreakpoint = 600;

  /// 태블릿 레이아웃 브레이크포인트 (600px ~ 1199px)
  static const int tabletBreakpoint = 900;

  /// 데스크톱 레이아웃 브레이크포인트 (1200px 이상)
  static const int desktopBreakpoint = 1200;

  /// 매우 큰 화면 브레이크포인트 (1400px 이상)
  static const int largeDesktopBreakpoint = 1400;

  // ============================================
  // Spacing & Padding (여백 및 패딩)
  // ============================================
  /// 매우 작은 여백 (4px)
  static const double spacingXs = 4.0;

  /// 작은 여백 (8px)
  static const double spacingSmall = 8.0;

  /// 중간-작은 여백 (12px)
  static const double spacingMedium = 12.0;

  /// 중간 여백 (16px)
  static const double spacingLarge = 16.0;

  /// 중간-큰 여백 (24px)
  static const double spacingXlarge = 24.0;

  /// 큰 여백 (32px)
  static const double spacingXxlarge = 32.0;

  // ============================================
  // Border Radius (모서리 반경)
  // ============================================
  /// 작은 모서리 반경 (8px)
  static const double radiusSmall = 8.0;

  /// 중간 모서리 반경 (12px)
  static const double radiusMedium = 12.0;

  /// 큰 모서리 반경 (16px)
  static const double radiusLarge = 16.0;

  // ============================================
  // Animation Durations (애니메이션 시간)
  // ============================================
  /// 빠른 애니메이션 (200ms)
  static const Duration durationFast = Duration(milliseconds: 200);

  /// 일반 애니메이션 (300ms)
  static const Duration durationNormal = Duration(milliseconds: 300);

  /// 느린 애니메이션 (500ms)
  static const Duration durationSlow = Duration(milliseconds: 500);

  // ============================================
  // Elevation & Shadow (높이 및 그림자)
  // ============================================
  /// 카드 기본 높이
  static const double cardElevation = 4.0;

  /// 모달 높이
  static const double modalElevation = 8.0;

  // ============================================
  // Layout Dimensions (레이아웃 크기)
  // ============================================
  /// PC 사이드바 너비 (고정)
  static const double sidebarWidth = 280.0;

  /// 큰 화면 사이드바 너비
  static const double largeScreenSidebarWidth = 320.0;

  /// 콘텐츠 최대 너비
  static const double contentMaxWidth = 800.0;

  /// 헤더 확장 높이 (모바일)
  static const double mobileHeaderHeight = 192.0;

  /// 헤더 확장 높이 (데스크톱)
  static const double desktopHeaderHeight = 256.0;

  // ============================================
  // Icon Sizes (아이콘 크기)
  // ============================================
  /// 작은 아이콘 크기 (20px)
  static const double iconSizeSmall = 20.0;

  /// 중간 아이콘 크기 (24px)
  static const double iconSizeMedium = 24.0;

  /// 큰 아이콘 크기 (32px)
  static const double iconSizeLarge = 32.0;

  /// 매우 큰 아이콘 크기 (48px)
  static const double iconSizeXlarge = 48.0;

  // ============================================
  // Font Sizes Base (기본 폰트 크기)
  // ============================================
  /// 매우 작은 텍스트
  static const double fontSizeXsmall = 10.0;

  /// 작은 텍스트
  static const double fontSizeSmall = 12.0;

  /// 일반 텍스트
  static const double fontSizeNormal = 14.0;

  /// 중간 텍스트
  static const double fontSizeMedium = 16.0;

  /// 큰 텍스트
  static const double fontSizeLarge = 18.0;

  /// 매우 큰 텍스트
  static const double fontSizeXlarge = 24.0;

  /// 제목 텍스트
  static const double fontSizeTitle = 28.0;

  // ============================================
  // Opacity Values (불투명도)
  // ============================================
  /// 매우 투명한 상태
  static const double opacityVeryLight = 0.3;

  /// 투명한 상태
  static const double opacityLight = 0.5;

  /// 중간 투명도
  static const double opacityMedium = 0.7;

  /// 거의 불투명한 상태
  static const double opacityDark = 0.9;

  // ============================================
  // Default Values (기본값)
  // ============================================
  /// 기본 텍스트 스케일 팩터
  static const double defaultTextScaleFactor = 1.0;

  /// 기본 패딩
  static const double defaultPadding = 16.0;

  /// 기본 갭 (위젯 간 거리)
  static const double defaultGap = 8.0;

  // ============================================
  // Navigation Bar (네비게이션 바)
  // ============================================
  /// 모바일 하단 네비게이션 바 좌우 패딩
  static const double mobileNavHorizontalPadding = 100.0;

  /// 모바일 하단 네비게이션 바 하단 패딩
  static const double mobileNavBottomPadding = 16.0;

  /// 모바일 하단 네비게이션 바 둥근 모서리
  static const double mobileNavBorderRadius = 30.0;
}
