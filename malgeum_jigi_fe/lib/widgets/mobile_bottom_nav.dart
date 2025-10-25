import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../constants/app_constants.dart';
import '../models/tab_info.dart';
import '../theme/app_theme.dart';

/// 모바일 레이아웃의 하단 네비게이션 바 위젯
class MobileBottomNav extends StatelessWidget {
  /// 현재 선택된 탭 인덱스
  final int selectedIndex;

  /// 탭 선택 시 호출되는 콜백
  final ValueChanged<int> onTabSelected;

  /// 탭 정보 리스트
  final List<TabInfo> tabs;

  const MobileBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppConstants.mobileNavHorizontalPadding,
            right: AppConstants.mobileNavHorizontalPadding,
            bottom: AppConstants.mobileNavBottomPadding,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.mobileNavBorderRadius),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.getSidebarShadowColor(brightness),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: GNav(
                selectedIndex: selectedIndex,
                onTabChange: onTabSelected,
                backgroundColor: AppTheme.getSidebarBackgroundColor(brightness),
                color: AppTheme.getInactiveItemColor(brightness),
                activeColor: AppTheme.getActiveItemColor(brightness),
                tabBackgroundColor: AppTheme.getActiveTabBackgroundColor(brightness),
                gap: AppConstants.spacingMedium,
                padding: const EdgeInsets.all(AppConstants.spacingXlarge - 4),
                duration: AppConstants.durationNormal,
                tabs: tabs
                    .map(
                      (tab) => GButton(
                        icon: tab.icon,
                        text: tab.label,
                        iconSize: AppConstants.iconSizeMedium,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppConstants.fontSizeSmall,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
