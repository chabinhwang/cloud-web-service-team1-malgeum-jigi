import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tab_info.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_util.dart';
import '../utils/theme_provider.dart';
import '../widgets/desktop_sidebar.dart';
import '../widgets/mobile_bottom_nav.dart';
import 'ventilation_tab.dart';
import 'temperature_humidity_tab.dart';
import 'life_guide_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // ScrollController를 각 탭에 제공
  final List<ScrollController> _scrollControllers = List.generate(
    3,
    (_) => ScrollController(),
  );

  // 탭 정보 (타입 안전한 모델 사용)
  static const List<TabInfo> _tabs = [
    TabInfo(
      id: 0,
      label: '환기',
      icon: Icons.air,
    ),
    TabInfo(
      id: 1,
      label: '온도·습도',
      icon: Icons.thermostat,
    ),
    TabInfo(
      id: 2,
      label: '생활 가이드',
      icon: Icons.calendar_today,
    ),
  ];

  @override
  void dispose() {
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return VentilationTab(scrollController: _scrollControllers[0]);
      case 1:
        return TemperatureHumidityTab(scrollController: _scrollControllers[1]);
      case 2:
        return LifeGuideTab(scrollController: _scrollControllers[2]);
      default:
        return VentilationTab(scrollController: _scrollControllers[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isMobile = ResponsiveUtil.isMobile(context);

    if (isMobile) {
      return _buildMobileLayout(themeProvider);
    } else {
      return _buildDesktopLayout();
    }
  }

  /// 모바일 레이아웃 (AppBar + BottomNavigationBar)
  Widget _buildMobileLayout(ThemeProvider themeProvider) {
    return Scaffold(
      backgroundColor: AppTheme.getTabContentBackgroundColor(
        Theme.of(context).brightness,
      ),
      appBar: AppBar(
        title: const Text('맑음지기'),
        centerTitle: true,
        actions: [
          Tooltip(
            message: themeProvider.getThemeModeLabel(),
            child: IconButton(
              onPressed: () async {
                await themeProvider.toggleTheme();
              },
              icon: Icon(themeProvider.getThemeModeIcon()),
              tooltip: '테마 전환 (${themeProvider.getThemeModeLabel()})',
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Tab Content
          IndexedStack(
            index: _selectedIndex,
            children: List.generate(
              _tabs.length,
              (index) => _buildTabContent(index),
            ),
          ),
          // Floating Navigation Bar
          MobileBottomNav(
            selectedIndex: _selectedIndex,
            onTabSelected: _onTabSelected,
            tabs: _tabs,
          ),
        ],
      ),
    );
  }

  /// 데스크톱 레이아웃 (Sidebar + Content)
  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: AppTheme.getTabContentBackgroundColor(
        Theme.of(context).brightness,
      ),
      body: Row(
        children: [
          // Sidebar
          DesktopSidebar(
            selectedIndex: _selectedIndex,
            onTabSelected: _onTabSelected,
            tabs: _tabs,
          ),
          // Main Content
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: List.generate(
                _tabs.length,
                (index) => _buildTabContent(index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
