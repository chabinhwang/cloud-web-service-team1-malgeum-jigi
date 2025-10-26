import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_util.dart';
import '../utils/location_provider.dart';
import '../utils/api_parser.dart';
import '../widgets/tab_header.dart';
import '../widgets/temperature/environment_summary_card.dart';
import '../widgets/temperature/appliance_card.dart';
import '../models/air_quality_data.dart';
import '../services/api_service.dart';

class TemperatureHumidityTab extends StatefulWidget {
  final ScrollController scrollController;

  const TemperatureHumidityTab({super.key, required this.scrollController});

  @override
  State<TemperatureHumidityTab> createState() =>
      _TemperatureHumidityTabState();
}

class _TemperatureHumidityTabState extends State<TemperatureHumidityTab> {
  bool _isLoading = false;
  String? _error;

  TodayEnvironmentData? _todayData;
  List<ApplianceGuide> _appliances = [];

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
      final environmentResponse = await ApiService.getEnvironmentToday(
        latitude: locationProvider.latitude!,
        longitude: locationProvider.longitude!,
      );

      final applianceResponse = await ApiService.getApplianceGuide(
        latitude: locationProvider.latitude!,
        longitude: locationProvider.longitude!,
      );

      if (mounted) {
        setState(() {
          // 환경 데이터 파싱
          _todayData = ApiParser.parseTodayEnvironment(environmentResponse);

          // 가전 가이드 데이터 파싱
          _appliances = ApiParser.parseAppliances(applianceResponse);

          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'API 데이터를 불러올 수 없습니다: ${e.toString()}';
          _isLoading = false;
          // 기본값 설정
          _todayData = ApiParser.parseTodayEnvironment(null);
          _appliances = ApiParser.parseAppliances(null);
        });
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final todayData = _todayData ??
        ApiParser.parseTodayEnvironment(null);
    final appliances = _appliances.isNotEmpty
        ? _appliances
        : ApiParser.parseAppliances(null);

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
        TabHeader(
          title: '온도·습도 조절 가이드',
          backgroundImage:
              'https://images.unsplash.com/photo-1685660477711-2099ce15a089',
          subtitle: '쾌적한 실내 환경을 위한 맞춤 가이드',
          scrollController: widget.scrollController,
        ),
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Today's Environment Summary
                    EnvironmentSummaryCard(todayData: todayData),
                    const SizedBox(height: 24),

                    // Appliance Guide
                    Text(
                      '📅 오늘 (10월 22일 수요일)',
                      style: TextStyle(
                        fontSize:
                            18 * ResponsiveUtil.getTextScaleFactor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Appliance Cards
                    ...appliances.map((appliance) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ApplianceCard(appliance: appliance),
                      );
                    }),

                    // Additional Tips (Material 3)
                    Card(
                      elevation: 2,
                      shadowColor: const Color(0x140D0A2C),
                      color: AppTheme.lightYellow.withValues(alpha: 0.5),
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
                            Text('💡', style: TextStyle(fontSize: 24)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '꿀팁',
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
                                    '제습기와 난방을 동시에 사용할 경우 전기 요금이 증가할 수 있어요. '
                                    '타이머 기능을 활용해서 필요한 시간대에만 작동하도록 설정해보세요!',
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

}
