import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_util.dart';
import '../utils/location_provider.dart';
import '../utils/api_parser.dart';
import '../widgets/tab_header.dart';
import '../widgets/ventilation/ventilation_score_card.dart';
import '../widgets/ventilation/air_quality_details_card.dart';
import '../widgets/ventilation/outdoor_guide_card.dart';
import '../models/air_quality_data.dart';
import '../services/api_service.dart';
import '../constants/app_constants.dart';

class VentilationTab extends StatefulWidget {
  final ScrollController scrollController;

  const VentilationTab({super.key, required this.scrollController});

  @override
  State<VentilationTab> createState() => _VentilationTabState();
}

class _VentilationTabState extends State<VentilationTab> {
  bool _showDetails = false;
  bool _showOutdoorGuide = false;
  bool _isLoading = false;
  String? _error;

  int? _ventilationScore;
  String? _ventilationDescription;
  AirQualityData? _airQualityData;
  Map<String, dynamic>? _outdoorGuideData;

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
      final locationProvider =
          context.read<LocationProvider>();

      // 실제 사용자 위치 수집 시도
      bool hasLocation = await locationProvider.getCurrentLocation();

      // 위치 수집 실패시 기본값 설정
      if (!hasLocation) {
        locationProvider.setDefaultLocation();
      }

      // API 호출
      final scoreData = await ApiService.getVentilationScore(
        latitude: locationProvider.latitude!,
        longitude: locationProvider.longitude!,
        locationName: locationProvider.locationName,
      );

      final airQualityResponse = await ApiService.getAirQuality(
        latitude: locationProvider.latitude!,
        longitude: locationProvider.longitude!,
        includeForecast: false,
      );

      final outdoorGuideResponse = await ApiService.getOutdoorGuide(
        latitude: locationProvider.latitude!,
        longitude: locationProvider.longitude!,
      );

      if (mounted) {
        setState(() {
          // 환기 점수 데이터 파싱
          if (scoreData != null) {
            _ventilationScore = ApiParser.parseInt(
              scoreData['score'],
              AppConstants.defaultVentilationScore,
            );
            _ventilationDescription = ApiParser.parseString(
              scoreData['description'],
              AppConstants.defaultVentilationDescription,
            );
          } else {
            _ventilationScore = AppConstants.defaultVentilationScore;
            _ventilationDescription =
                AppConstants.defaultVentilationDescription;
          }

          // 공기질 데이터 파싱
          _airQualityData = ApiParser.parseAirQuality(airQualityResponse);

          _outdoorGuideData = outdoorGuideResponse;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'API 데이터를 불러올 수 없습니다: ${e.toString()}';
          _isLoading = false;
          // 기본값 설정 (오류 시)
          _ventilationScore = AppConstants.defaultVentilationScore;
          _ventilationDescription =
              AppConstants.defaultVentilationDescription;
          _airQualityData = ApiParser.parseAirQuality(null);
        });
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }


  @override
  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            '데이터를 불러오는 중...',
            style: TextStyle(
              fontSize: 16 * ResponsiveUtil.getTextScaleFactor(context),
              color: AppTheme.getSecondaryTextColor(Theme.of(context).brightness),
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy년 MM월 dd일 EEEE a h:mm', 'ko_KR');

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
        TabHeader(
          title: '실시간 환기 가이드',
          backgroundImage:
              'https://images.unsplash.com/photo-1527854269107-68e2d1343e1d',
          subtitle: '신선한 공기로 건강한 실내 환경을 만드세요',
          scrollController: widget.scrollController,
        ),
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _isLoading
                    ? _buildLoadingState()
                    : Column(
                  children: [
                    // Current Location & Time
                    Text(
                      context.read<LocationProvider>().locationName ?? '현재 위치',
                      style: TextStyle(
                        fontSize:
                            14 * ResponsiveUtil.getTextScaleFactor(context),
                        color: AppTheme.getLocationTimeTextColor(Theme.of(context).brightness),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(now),
                      style: TextStyle(
                        fontSize:
                            14 * ResponsiveUtil.getTextScaleFactor(context),
                        color: AppTheme.getLocationTimeTextColor(Theme.of(context).brightness),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Ventilation Score Card
                    VentilationScoreCard(
                      score: _ventilationScore ??
                          AppConstants.defaultVentilationScore,
                      description: _ventilationDescription ??
                          AppConstants.defaultVentilationDescription,
                    ),
                    const SizedBox(height: 16),

                    // Detail Toggle Button
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _showDetails = !_showDetails;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('상세 정보 보기'),
                          const SizedBox(width: 8),
                          Icon(
                            _showDetails
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 20,
                          ),
                        ],
                      ),
                    ),

                    // Detailed Information
                    AirQualityDetailsCard(
                      airQualityData: _airQualityData ??
                          ApiParser.parseAirQuality(null),
                      isExpanded: _showDetails,
                    ),
                    const SizedBox(height: 16),

                    // Outdoor Guide Toggle Button
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showOutdoorGuide = !_showOutdoorGuide;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: _showOutdoorGuide
                            ? (Theme.of(context).brightness == Brightness.dark
                                ? AppTheme.darkPrimaryBlue
                                : AppTheme.primaryBlue)
                            : (Theme.of(context).brightness == Brightness.dark
                                ? AppTheme.darkSurfaceColor
                                : Colors.white),
                        foregroundColor: _showOutdoorGuide
                            ? Colors.white
                            : (Theme.of(context).brightness == Brightness.dark
                                ? AppTheme.darkPrimaryBlue
                                : AppTheme.primaryBlue),
                        side: _showOutdoorGuide
                            ? null
                            : BorderSide(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? AppTheme.darkPrimaryBlue
                                    : AppTheme.primaryBlue,
                              ),
                      ),
                      child: Text(
                        _showOutdoorGuide ? '외출 가이드 닫기' : '외출 가이드 보기',
                      ),
                    ),

                    // Outdoor Guide
                    OutdoorGuideCard(
                      outdoorGuideData: _outdoorGuideData,
                      pmValue: _airQualityData?.pm10 ?? 45,
                      isExpanded: _showOutdoorGuide,
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
