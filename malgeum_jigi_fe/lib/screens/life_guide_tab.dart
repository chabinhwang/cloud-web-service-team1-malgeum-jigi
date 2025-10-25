import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_util.dart';
import '../utils/location_provider.dart';
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
          if (weeklyPlanResponse != null) {
            final weekPlansList =
                weeklyPlanResponse['week_plans'] as List<dynamic>? ?? [];
            _weeklyPlan = weekPlansList
                .map((e) => DayPlan(
                      date: e['date'] as String,
                      dayOfWeek: e['day_of_week'] as String,
                      isToday: e['is_today'] as bool? ?? false,
                      activities: (e['activities'] as List<dynamic>? ?? [])
                          .map((activity) => Activity(
                                type: ActivityType.values.firstWhere(
                                  (et) => et.name == activity['type'],
                                  orElse: () => ActivityType.indoor,
                                ),
                                emoji: activity['emoji'] as String,
                                title: activity['title'] as String,
                                status: ActivityStatus.values.firstWhere(
                                  (es) => es.name == activity['status'],
                                  orElse: () => ActivityStatus.recommended,
                                ),
                                time: activity['time'] as String?,
                                reason: activity['reason'] as String,
                              ))
                          .toList(),
                    ))
                .toList();
          } else {
            // 기본값 설정 - 목업 데이터 유지
            _weeklyPlan = _getMockWeeklyPlan();
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'API 데이터를 불러올 수 없습니다: ${e.toString()}';
          _isLoading = false;
          // 기본값 설정
          _weeklyPlan = _getMockWeeklyPlan();
        });
      }
    }
  }

  List<DayPlan> _getMockWeeklyPlan() {
    return [
      const DayPlan(
        date: '10/17',
        dayOfWeek: '금요일',
        activities: [
          Activity(
            type: ActivityType.exercise,
            emoji: '🏃',
            title: '야외운동',
            status: ActivityStatus.recommended,
            time: '오전 7~9시',
            reason: '미세먼지 "좋음", 기온 15°C로 쾌적해요!',
          ),
          Activity(
            type: ActivityType.ventilation,
            emoji: '🧹',
            title: '환기 청소',
            status: ActivityStatus.recommended,
            time: '오전 9~11시',
            reason: '공기질이 좋고 바람도 적당해 먼지가 잘 배출돼요.',
          ),
        ],
      ),
      const DayPlan(
        date: '10/18',
        dayOfWeek: '토요일',
        activities: [
          Activity(
            type: ActivityType.laundry,
            emoji: '🧺',
            title: '세탁',
            status: ActivityStatus.recommended,
            time: '오전 10시~오후 3시',
            reason: '맑고 건조해서 빨래가 빨리 마릅니다. 일조량 충분!',
          ),
          Activity(
            type: ActivityType.exercise,
            emoji: '🏃',
            title: '야외운동',
            status: ActivityStatus.caution,
            reason: '새벽 영하 기온이라 이른 아침은 피하세요.',
          ),
        ],
      ),
      const DayPlan(
        date: '10/19',
        dayOfWeek: '일요일',
        activities: [
          Activity(
            type: ActivityType.laundry,
            emoji: '🌧️',
            title: '빨래 금지',
            status: ActivityStatus.prohibited,
            reason: '오후부터 비 예보(강수확률 80%). 빨래는 내일로!',
          ),
          Activity(
            type: ActivityType.indoor,
            emoji: '📺',
            title: '실내 활동 추천',
            status: ActivityStatus.recommended,
            reason: '하루 종일 비가 올 예정이에요.',
          ),
        ],
      ),
      const DayPlan(
        date: '10/20',
        dayOfWeek: '월요일',
        activities: [
          Activity(
            type: ActivityType.laundry,
            emoji: '🧺',
            title: '세탁',
            status: ActivityStatus.optimal,
            time: '오전 10시 이후',
            reason: '어제 내린 비로 공기가 깨끗해졌어요. 빨래하기 최고의 날!',
          ),
          Activity(
            type: ActivityType.exercise,
            emoji: '🏃',
            title: '야외운동',
            status: ActivityStatus.recommended,
            time: '오후 4~6시',
            reason: '비 개고 미세먼지 "매우좋음", 산책하기 완벽해요.',
          ),
        ],
      ),
      const DayPlan(
        date: '10/21',
        dayOfWeek: '화요일',
        activities: [
          Activity(
            type: ActivityType.exercise,
            emoji: '🏃',
            title: '야외운동',
            status: ActivityStatus.recommended,
            time: '오전 6~8시, 저녁 7~9시',
            reason: '미세먼지 낮고 기온 적당. 조깅 최적!',
          ),
        ],
      ),
      const DayPlan(
        date: '10/22',
        dayOfWeek: '수요일',
        isToday: true,
        activities: [
          Activity(
            type: ActivityType.warning,
            emoji: '⚠️',
            title: '미세먼지 나쁨',
            status: ActivityStatus.caution,
            reason: '야외활동 자제, 마스크 필수. 실내 환기도 최소화하세요',
          ),
        ],
      ),
      const DayPlan(
        date: '10/23',
        dayOfWeek: '목요일',
        activities: [
          Activity(
            type: ActivityType.ventilation,
            emoji: '🧹',
            title: '환기 청소',
            status: ActivityStatus.recommended,
            time: '오전 10~12시',
            reason: '미세먼지 다시 좋아져요. 이불 털고 환기하세요!',
          ),
        ],
      ),
    ];
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final weeklyPlan = _weeklyPlan.isEmpty ? _getMockWeeklyPlan() : _weeklyPlan;

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
                    Text(
                      '10월 17일 ~ 10월 23일',
                      style: TextStyle(
                        fontSize:
                            14 * ResponsiveUtil.getTextScaleFactor(context),
                        color: AppTheme.getLocationTimeTextColor(Theme.of(context).brightness),
                      ),
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
                            const SizedBox(height: AppConstants.spacingMedium),
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
                      color: const Color(0xFFFAF5FF).withValues(alpha: 0.5), // purple-50
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
                                      color: AppTheme.getRecommendationTextColor(Theme.of(context).brightness),
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
        side: const BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
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
                            color: AppTheme.getRecommendationTextColor(Theme.of(context).brightness),
                          ),
                        ),
                        Text(
                          activity.time!,
                          style: TextStyle(
                            fontSize:
                                12 * ResponsiveUtil.getTextScaleFactor(context),
                            fontWeight: FontWeight.w600,
                            color: AppTheme.getRecommendationTextColor(Theme.of(context).brightness),
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
                          color: AppTheme.getRecommendationTextColor(Theme.of(context).brightness),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '"${activity.reason}"',
                          style: TextStyle(
                            fontSize:
                                12 * ResponsiveUtil.getTextScaleFactor(context),
                            color: AppTheme.getRecommendationTextColor(Theme.of(context).brightness),
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
