import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_util.dart';
import '../utils/location_provider.dart';
import '../utils/api_parser.dart';
import '../widgets/tab_header.dart';
import '../widgets/radial_gauge.dart';
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

  Color _getScoreColor(int score) {
    return AppTheme.getScoreColor(score);
  }

  String _getScoreStatus(int score) {
    if (score >= 70) return '좋음 😊';
    if (score >= 40) return '보통 😐';
    return '나쁨 😟';
  }

  Color _getOutdoorGuideColor() {
    final advisability = _outdoorGuideData?['advisability'] as String? ?? '';

    switch (advisability) {
      case '추천':
      case '좋음':
        return AppTheme.lightGreen;
      case '보통':
        return AppTheme.lightYellow;
      case '나쁨':
      case '주의':
        return AppTheme.lightRed;
      default:
        return AppTheme.lightGreen;
    }
  }

  String _getOutdoorGuideTitle() {
    final advisability = _outdoorGuideData?['advisability'] as String? ?? '';

    switch (advisability) {
      case '추천':
      case '좋음':
        return '🚶 지금 외출 추천합니다';
      case '보통':
        return '⚠️ 외출 시 주의가 필요합니다';
      case '나쁨':
      case '주의':
        return '❌ 외출을 삼가시기 바랍니다';
      default:
        return '🚶 지금 외출 괜찮아요';
    }
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

                    // Ventilation Score Card (Material 3)
                    Card(
                      elevation: 2,
                      shadowColor: const Color(0x140D0A2C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: Colors.transparent,
                          width: 0,
                        ),
                      ),
                      color: AppTheme.getScoreBackgroundColor(
                              _ventilationScore ?? 78)
                          .withValues(alpha: 0.5),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              '현재 환기 점수',
                              style: TextStyle(
                                fontSize:
                                    16 *
                                    ResponsiveUtil.getTextScaleFactor(context),
                                color: AppTheme.getRecommendationTextColor(Theme.of(context).brightness),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${_ventilationScore ?? AppConstants.defaultVentilationScore}',
                              style: TextStyle(
                                fontSize:
                                    80 *
                                    ResponsiveUtil.getTextScaleFactor(context),
                                fontWeight: FontWeight.bold,
                                color: _getScoreColor(
                                  _ventilationScore ??
                                      AppConstants.defaultVentilationScore,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getScoreStatus(
                                _ventilationScore ??
                                    AppConstants.defaultVentilationScore,
                              ),
                              style: TextStyle(
                                fontSize:
                                    24 *
                                    ResponsiveUtil.getTextScaleFactor(context),
                                fontWeight: FontWeight.w600,
                                color: _getScoreColor(
                                  _ventilationScore ??
                                      AppConstants.defaultVentilationScore,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _ventilationDescription ??
                                  AppConstants.defaultVentilationDescription,
                              style: TextStyle(
                                fontSize:
                                    18 *
                                    ResponsiveUtil.getTextScaleFactor(context),
                                color: AppTheme.getRecommendationTextColor(
                                  Theme.of(context).brightness,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
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

                    // Detailed Information (Material 3)
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Card(
                        margin: const EdgeInsets.only(top: 16),
                        elevation: 2,
                        shadowColor: const Color(0x140D0A2C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '상세 정보',
                                style: TextStyle(
                                  fontSize:
                                      18 *
                                      ResponsiveUtil.getTextScaleFactor(
                                        context,
                                      ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildDetailItem(
                                '미세먼지 (PM10)',
                                '${_airQualityData?.pm10.toStringAsFixed(0) ?? '45'} ㎍/㎥',
                                _airQualityData?.getPM10Status() ?? '보통',
                                AppTheme.lightYellow,
                              ),
                              const SizedBox(height: 12),
                              _buildDetailItem(
                                '초미세먼지 (PM2.5)',
                                '${_airQualityData?.pm25.toStringAsFixed(0) ?? '22'} ㎍/㎥',
                                _airQualityData?.getPM25Status() ?? '보통',
                                AppTheme.lightYellow,
                              ),
                              const SizedBox(height: 12),
                              _buildDetailItem(
                                '기온',
                                '${_airQualityData?.temperature.toStringAsFixed(0) ?? '18'}°C',
                                _airQualityData?.getTemperatureStatus() ?? '쾌적',
                                AppTheme.lightGreen,
                              ),
                              const SizedBox(height: 12),
                              _buildDetailItem(
                                '습도',
                                '${_airQualityData?.humidity.toStringAsFixed(0) ?? '62'}%',
                                _airQualityData?.getHumidityStatus() ?? '적정',
                                AppTheme.lightGreen,
                              ),
                            ],
                          ),
                        ),
                      ),
                      crossFadeState: _showDetails
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
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
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Card(
                        margin: const EdgeInsets.only(top: 16),
                        elevation: 2,
                        shadowColor: const Color(0x140D0A2C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                '외출 가이드',
                                style: TextStyle(
                                  fontSize:
                                      18 *
                                      ResponsiveUtil.getTextScaleFactor(
                                        context,
                                      ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // PM10 Gauge
                              RadialGauge(
                                value: _airQualityData?.pm10 ?? 45,
                                maxValue: 250,
                                size: 200,
                                label: 'PM10',
                              ),
                              const SizedBox(height: 24),
                              // Guide (Material 3)
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _getOutdoorGuideColor().withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 0,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      _getOutdoorGuideTitle(),
                                      style: TextStyle(
                                        fontSize:
                                            18 *
                                            ResponsiveUtil.getTextScaleFactor(
                                              context,
                                            ),
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _outdoorGuideData?['summary'] as String? ?? '오후 시간대는 미세먼지가 "보통" 수준이지만, 저녁 5시 이후로 조금씩 나빠질 예정이에요.',
                                      style: TextStyle(
                                        fontSize:
                                            14 *
                                            ResponsiveUtil.getTextScaleFactor(
                                              context,
                                            ),
                                        color: AppTheme.getRecommendationTextColor(Theme.of(context).brightness),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '권장사항',
                                style: TextStyle(
                                  fontSize:
                                      16 *
                                      ResponsiveUtil.getTextScaleFactor(
                                        context,
                                      ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ..._buildRecommendationsFromAPI(),
                            ],
                          ),
                        ),
                      ),
                      crossFadeState: _showOutdoorGuide
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
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

  Widget _buildDetailItem(
    String title,
    String value,
    String status,
    Color backgroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14 * ResponsiveUtil.getTextScaleFactor(context),
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12 * ResponsiveUtil.getTextScaleFactor(context),
                  color: AppTheme.getSecondaryTextColor(Theme.of(context).brightness),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18 * ResponsiveUtil.getTextScaleFactor(context),
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRecommendationsFromAPI() {
    final recommendations = _outdoorGuideData?['recommendations'] as List<dynamic>? ?? [];

    if (recommendations.isEmpty) {
      // 기본값: API에서 recommendations이 없을 때
      return [
        _buildRecommendationItem('✅', '일반 외출 가능', AppTheme.lightGreen),
        const SizedBox(height: 8),
        _buildRecommendationItem('⚠️', '필요 시 마스크 착용', AppTheme.lightYellow),
        const SizedBox(height: 8),
        _buildRecommendationItem('💧', '충분한 수분 섭취', AppTheme.lightBlue),
      ];
    }

    // API에서 받은 recommendations 렌더링
    final List<Widget> widgets = [];
    for (int i = 0; i < recommendations.length; i++) {
      final recommendation = recommendations[i] as String;
      final colors = [AppTheme.lightGreen, AppTheme.lightYellow, AppTheme.lightBlue];
      final emoji = ['✅', '⚠️', '💧'];

      widgets.add(
        _buildRecommendationItem(
          emoji[i % emoji.length],
          recommendation,
          colors[i % colors.length],
        ),
      );

      if (i < recommendations.length - 1) {
        widgets.add(const SizedBox(height: 8));
      }
    }

    return widgets;
  }

  Widget _buildRecommendationItem(
    String emoji,
    String text,
    Color backgroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      child: Row(
        children: [
          Text(
            emoji,
            style: TextStyle(
              fontSize: 20 * ResponsiveUtil.getTextScaleFactor(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14 * ResponsiveUtil.getTextScaleFactor(context),
                color: AppTheme.getRecommendationTextColor(Theme.of(context).brightness),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
