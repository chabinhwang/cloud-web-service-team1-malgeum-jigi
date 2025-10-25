import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../models/tab_info.dart';
import '../theme/app_theme.dart';
import '../utils/theme_provider.dart';

/// 데스크톱 레이아웃의 좌측 사이드바 위젯
class DesktopSidebar extends StatelessWidget {
  /// 현재 선택된 탭 인덱스
  final int selectedIndex;

  /// 탭 선택 시 호출되는 콜백
  final ValueChanged<int> onTabSelected;

  /// 탭 정보 리스트
  final List<TabInfo> tabs;

  const DesktopSidebar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final brightness = Theme.of(context).brightness;

    return Container(
      width: AppConstants.sidebarWidth,
      decoration: BoxDecoration(
        color: AppTheme.getSidebarBackgroundColor(brightness),
        boxShadow: [
          BoxShadow(
            color: AppTheme.getSidebarShadowColor(brightness),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo/Header
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingXlarge),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.getSidebarBorderColor(brightness),
                  width: 1,
                ),
              ),
            ),
            child: Center(
              child: Text(
                '맑음지기',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXlarge,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            ),
          ),
          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppConstants.spacingLarge),
              children: tabs.map((tab) {
                final isActive = selectedIndex == tab.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppConstants.spacingSmall),
                  child: Material(
                    color: isActive
                        ? AppTheme.getActiveTabBackgroundColor(brightness)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                    child: InkWell(
                      onTap: () => onTabSelected(tab.id),
                      borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingLarge,
                          vertical: AppConstants.spacingMedium,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              tab.icon,
                              color: isActive
                                  ? AppTheme.getActiveItemColor(brightness)
                                  : AppTheme.getInactiveItemColor(brightness),
                              size: AppConstants.iconSizeSmall,
                            ),
                            const SizedBox(width: AppConstants.spacingMedium),
                            Text(
                              tab.label,
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeMedium,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: isActive
                                    ? AppTheme.getActiveItemColor(brightness)
                                    : AppTheme.getInactiveItemColor(brightness),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Footer with Dark Mode Toggle
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLarge,
              vertical: AppConstants.spacingMedium,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dark Mode Toggle Button
                Tooltip(
                  message: themeProvider.getThemeModeLabel(),
                  child: IconButton(
                    onPressed: () async {
                      await themeProvider.toggleTheme();
                    },
                    icon: Icon(themeProvider.getThemeModeIcon()),
                    tooltip: '테마 전환 (${themeProvider.getThemeModeLabel()})',
                    color: Theme.of(context).iconTheme.color,
                    iconSize: AppConstants.iconSizeMedium,
                    splashRadius: AppConstants.iconSizeMedium,
                  ),
                ),
                // Copyright Text
                Text(
                  '© 2025 환기 가이드',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXsmall + 1,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
