import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../theme/app_theme.dart';
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
  final List<ScrollController> _scrollControllers = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
  ];

  final List<Map<String, dynamic>> _tabs = [
    {
      'id': 0,
      'label': '환기',
      'icon': Icons.air,
    },
    {
      'id': 1,
      'label': '온도·습도',
      'icon': Icons.thermostat,
    },
    {
      'id': 2,
      'label': '생활 가이드',
      'icon': Icons.calendar_today,
    },
  ];

  // 탭별 색상
  final List<Color> _tabColors = [
    const Color(0xFF22C55E),  // 환기: 초록색
    const Color(0xFFFF6B6B),  // 온도·습도: 빨간색
    const Color(0xFF6366F1),  // 생활가이드: 보라색
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (isMobile) {
      // Mobile Layout: BottomNavigationBar
      return Scaffold(
        appBar: AppBar(
          title: const Text('맑음지기'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            // Tab Content
            IndexedStack(
              index: _selectedIndex,
              children: [
                _buildTabContent(0),
                _buildTabContent(1),
                _buildTabContent(2),
              ],
            ),
            // Floating Navigation Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 100, right: 100, bottom: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: GNav(
                      selectedIndex: _selectedIndex,
                      onTabChange: _onTabSelected,
                      backgroundColor: AppTheme.surfaceColor,
                      color: AppTheme.textSecondary,
                      activeColor: AppTheme.primaryBlue,
                      tabBackgroundColor: AppTheme.lightBlue,
                      gap: 12,
                      padding: const EdgeInsets.all(20),
                      duration: const Duration(milliseconds: 300),
                      tabs: _tabs
                          .map(
                            (tab) => GButton(
                              icon: tab['icon'] as IconData,
                              text: tab['label'] as String,
                              iconSize: 24,
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          )
                          .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Desktop Layout: Drawer + Content
      return Scaffold(
        body: Row(
          children: [
            // Sidebar
            Container(
              width: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Logo/Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '맑음지기',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Navigation Items
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: _tabs.map((tab) {
                        final isActive = _selectedIndex == tab['id'];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Material(
                            color: isActive
                                ? AppTheme.lightBlue
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              onTap: () => _onTabSelected(tab['id'] as int),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      tab['icon'] as IconData,
                                      color: isActive
                                          ? AppTheme.primaryBlue
                                          : AppTheme.textSecondary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      tab['label'] as String,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: isActive
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        color: isActive
                                            ? AppTheme.primaryBlue
                                            : AppTheme.textSecondary,
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
                  // Footer
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      '© 2025 환기 가이드',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main Content
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  _buildTabContent(0),
                  _buildTabContent(1),
                  _buildTabContent(2),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
