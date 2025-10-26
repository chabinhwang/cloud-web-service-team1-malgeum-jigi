import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_util.dart';
import '../utils/location_provider.dart';
import '../utils/api_parser.dart';
import '../widgets/tab_header.dart';
import '../widgets/status_badge.dart';
import '../models/weekly_plan.dart';
import '../services/api_service.dart';

class LifeGuideTab extends StatefulWidget {
  final ScrollController scrollController;

  const LifeGuideTab({super.key, required this.scrollController});

  @override
  State<LifeGuideTab> createState() => _LifeGuideTabState();
}

class _LifeGuideTabState extends State<LifeGuideTab> {
  bool _isLoading = false;
  String? _error;
  List<DayPlan> _weeklyPlan = [];

  @override
  void initState() {
    super.initState();
    // 빌드가 완료된 후에 데이터 로드 (Provider 상태 변경 에러 방지)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

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
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'API 데이터를 불러올 수 없습니다: ${e.toString()}';
          _isLoading = false;
          // 기본값 설정 (목업 데이터)
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
    final weeklyPlan = _weeklyPlan.isEmpty
        ? ApiParser.parseWeeklyPlan(null)
        : _weeklyPlan;

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
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Header
                      Text(
                        '주간 생활 플랜',
                        style: TextStyle(
                          fontSize:
                              24 * ResponsiveUtil.getTextScaleFactor(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingSmall),
                      Builder(
                        builder: (context) {
                          // 날짜 범위 동적으로 표시
                          String dateRange = '로딩 중...';
                          if (weeklyPlan.isNotEmpty) {
                            final firstDate = weeklyPlan.first.date;
                            final lastDate = weeklyPlan.last.date;
                            dateRange = '$firstDate ~ $lastDate';
                          }
                          return Text(
                            dateRange,
                            style: TextStyle(
                              fontSize:
                                  14 *
                                  ResponsiveUtil.getTextScaleFactor(context),
                              color: AppTheme.getLocationTimeTextColor(
                                Theme.of(context).brightness,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppConstants.spacingXlarge),

                      // Weekly Plan
                      ...weeklyPlan.map((day) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${day.dayOfWeek} ${day.date}',
                                    style: TextStyle(
                                      fontSize:
                                          18 *
                                          ResponsiveUtil.getTextScaleFactor(
                                            context,
                                          ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (day.isToday) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryBlue,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '오늘',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(
                                height: AppConstants.spacingMedium,
                              ),
                              ...day.activities.map((activity) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _buildActivityCard(activity, context),
                                );
                              }),
                            ],
                          ),
                        );
                      }),

                      // Tips Section (Material 3)
                      Card(
                        elevation: 2,
                        shadowColor: const Color(0x140D0A2C),
                        color: const Color(
                          0xFFFAF5FF,
                        ).withValues(alpha: 0.5), // purple-50
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('🌟', style: TextStyle(fontSize: 24)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '생활 팁',
                                      style: TextStyle(
                                        fontSize:
                                            16 *
                                            ResponsiveUtil.getTextScaleFactor(
                                              context,
                                            ),
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '일주일 계획을 미리 확인하고, 빨래나 환기 청소는 공기질이 좋은 날을 활용하세요. '
                                      '건강한 생활을 위해 미세먼지가 나쁜 날은 실내 활동을 추천드려요!',
                                      style: TextStyle(
                                        fontSize:
                                            14 *
                                            ResponsiveUtil.getTextScaleFactor(
                                              context,
                                            ),
                                        color:
                                            AppTheme.getRecommendationTextColor(
                                              Theme.of(context).brightness,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 80,
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

  Widget _buildActivityCard(Activity activity, BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: const Color(0x140D0A2C),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.transparent, width: 0),
      ),
      color: activity.status.getBadgeColor().withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingLarge),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activity.emoji,
              style: const TextStyle(fontSize: AppConstants.iconSizeXlarge),
            ),
            const SizedBox(width: AppConstants.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        activity.title,
                        style: TextStyle(
                          fontSize:
                              16 * ResponsiveUtil.getTextScaleFactor(context),
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingSmall),
                      StatusBadge(
                        status: activity.status,
                        label: activity.statusLabel,
                        fontSize:
                            12 * ResponsiveUtil.getTextScaleFactor(context),
                      ),
                    ],
                  ),
                  if (activity.time != null) ...[
                    const SizedBox(height: AppConstants.spacingSmall),
                    Row(
                      children: [
                        Text(
                          '시간: ',
                          style: TextStyle(
                            fontSize:
                                12 * ResponsiveUtil.getTextScaleFactor(context),
                            color: AppTheme.getRecommendationTextColor(
                              Theme.of(context).brightness,
                            ),
                          ),
                        ),
                        Text(
                          activity.time!,
                          style: TextStyle(
                            fontSize:
                                12 * ResponsiveUtil.getTextScaleFactor(context),
                            fontWeight: FontWeight.w600,
                            color: AppTheme.getRecommendationTextColor(
                              Theme.of(context).brightness,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: AppConstants.spacingSmall),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '이유: ',
                        style: TextStyle(
                          fontSize:
                              12 * ResponsiveUtil.getTextScaleFactor(context),
                          color: AppTheme.getRecommendationTextColor(
                            Theme.of(context).brightness,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '"${activity.reason}"',
                          style: TextStyle(
                            fontSize:
                                12 * ResponsiveUtil.getTextScaleFactor(context),
                            color: AppTheme.getRecommendationTextColor(
                              Theme.of(context).brightness,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
