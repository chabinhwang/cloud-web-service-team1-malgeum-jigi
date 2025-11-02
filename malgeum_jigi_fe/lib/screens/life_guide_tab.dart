import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import '../theme/text_styles.dart';
import '../utils/location_provider.dart';
import '../utils/api_parser.dart';
import '../widgets/common/tab_header.dart';
import '../widgets/common/app_card.dart';
import '../widgets/life_guide/day_plan_card.dart';
import '../models/weekly_plan.dart';
import '../services/api_service.dart';

class LifeGuideTab extends StatefulWidget {
  final ScrollController scrollController;

  const LifeGuideTab({super.key, required this.scrollController});

  @override
  State<LifeGuideTab> createState() => _LifeGuideTabState();
}

class _LifeGuideTabState extends State<LifeGuideTab> {
  late List<DayPlan> _weeklyPlan;

  @override
  void initState() {
    super.initState();
    // 기본값으로 초기화
    _weeklyPlan = ApiParser.parseWeeklyPlan(null);
    // 빌드가 완료된 후에 데이터 로드 (Provider 상태 변경 에러 방지)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    try {
      final locationProvider = context.read<LocationProvider>();

      // 실제 사용자 위치 수집 시도
      bool hasLocation = await locationProvider.getCurrentLocation();

      // 위치 수집 실패시 기본값 설정
      if (!hasLocation) {
        locationProvider.setDefaultLocation();
      }

      // API 호출
      final weeklyPlanResponse = await ApiService.getWeeklyPlan(
        latitude: locationProvider.latitude!,
        longitude: locationProvider.longitude!,
        days: 7,
      );

      if (mounted) {
        setState(() {
          // 주간 계획 데이터 파싱
          _weeklyPlan = ApiParser.parseWeeklyPlan(weeklyPlanResponse);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // 에러 시 기본값 유지 (이미 initState에서 설정됨)
          _weeklyPlan = ApiParser.parseWeeklyPlan(null);
        });
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final weeklyPlan = _weeklyPlan;

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          TabHeader(
            title: '생활 맞춤 가이드',
            backgroundImage:
                'https://images.unsplash.com/photo-1549582100-d67ab35b3507',
            subtitle: '일주일 생활 계획을 한눈에',
            scrollController: widget.scrollController,
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppConstants.contentMaxWidth),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Header
                      Text(
                        '주간 생활 플랜',
                        style: AppTextStyles.title2(context),
                      ),
                      const SizedBox(height: AppConstants.spacingSmall),
                      _buildDateRange(weeklyPlan, context),
                      const SizedBox(height: AppConstants.spacingXlarge),

                      // Weekly Plan
                      ...weeklyPlan.map((day) => DayPlanCard(day: day)),

                      // Tips Section
                      _buildTipsSection(context),
                      const SizedBox(
                        height: AppConstants.spacingXxlarge,
                      ), // Bottom padding for navigation bar
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 날짜 범위 표시
  Widget _buildDateRange(List<DayPlan> weeklyPlan, BuildContext context) {
    String dateRange = '로딩 중...';
    if (weeklyPlan.isNotEmpty) {
      final firstDate = weeklyPlan.first.date;
      final lastDate = weeklyPlan.last.date;
      dateRange = '$firstDate ~ $lastDate';
    }
    return Text(
      dateRange,
      style: AppTextStyles.locationTime(context),
    );
  }

  /// 생활 팁 섹션
  Widget _buildTipsSection(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final tipsBackground = brightness == Brightness.dark
        ? AppTheme.darkTipsBackgroundColor
        : AppTheme.tipsBackgroundColor;

    return AppCard(
      backgroundColor: tipsBackground.withValues(alpha: 0.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🌟', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '생활 팁',
                  style: AppTextStyles.headingSmall(context),
                ),
                const SizedBox(height: 4),
                Text(
                  '일주일 계획을 미리 확인하고, 빨래나 환기 청소는 공기질이 좋은 날을 활용하세요. '
                  '건강한 생활을 위해 미세먼지가 나쁜 날은 실내 활동을 추천드려요!',
                  style: AppTextStyles.recommendation(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
