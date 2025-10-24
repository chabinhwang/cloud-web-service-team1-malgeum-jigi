import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_util.dart';
import '../widgets/tab_header.dart';
import '../widgets/radial_gauge.dart';
import '../models/air_quality_data.dart';

class VentilationTab extends StatefulWidget {
  final ScrollController scrollController;

  const VentilationTab({super.key, required this.scrollController});

  @override
  State<VentilationTab> createState() => _VentilationTabState();
}

class _VentilationTabState extends State<VentilationTab> {
  bool _showDetails = false;
  bool _showOutdoorGuide = false;

  // Mock data
  final int ventilationScore = 78;
  final AirQualityData airQualityData = const AirQualityData(
    pm10: 45,
    pm25: 22,
    temperature: 18,
    humidity: 62,
    precipitation: false,
  );

  Color _getScoreColor(int score) {
    return AppTheme.getScoreColor(score);
  }

  String _getScoreStatus(int score) {
    if (score >= 70) return '좋음 😊';
    if (score >= 40) return '보통 😐';
    return '나쁨 😟';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy년 MM월 dd일 EEEE a h:mm', 'ko_KR');

    return CustomScrollView(
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
                child: Column(
                  children: [
                    // Current Location & Time
                    Text(
                      '서울특별시 강남구',
                      style: TextStyle(
                        fontSize:
                            14 * ResponsiveUtil.getTextScaleFactor(context),
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(now),
                      style: TextStyle(
                        fontSize:
                            14 * ResponsiveUtil.getTextScaleFactor(context),
                        color: Colors.grey[600],
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
                      color: AppTheme.getScoreBackgroundColor(ventilationScore)
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
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '$ventilationScore',
                              style: TextStyle(
                                fontSize:
                                    80 *
                                    ResponsiveUtil.getTextScaleFactor(context),
                                fontWeight: FontWeight.bold,
                                color: _getScoreColor(ventilationScore),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getScoreStatus(ventilationScore),
                              style: TextStyle(
                                fontSize:
                                    24 *
                                    ResponsiveUtil.getTextScaleFactor(context),
                                fontWeight: FontWeight.w600,
                                color: _getScoreColor(ventilationScore),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '지금 창문을 열어도 좋습니다! 🪟',
                              style: TextStyle(
                                fontSize:
                                    18 *
                                    ResponsiveUtil.getTextScaleFactor(context),
                                color: AppTheme.textSecondary,
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
                          Text('상세 정보 보기'),
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
                      firstChild: SizedBox.shrink(),
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
                                '${airQualityData.pm10.toStringAsFixed(0)} ㎍/㎥',
                                '보통 🟡',
                                AppTheme.lightYellow,
                              ),
                              const SizedBox(height: 12),
                              _buildDetailItem(
                                '초미세먼지 (PM2.5)',
                                '${airQualityData.pm25.toStringAsFixed(0)} ㎍/㎥',
                                '보통 🟡',
                                AppTheme.lightYellow,
                              ),
                              const SizedBox(height: 12),
                              _buildDetailItem(
                                '기온',
                                '${airQualityData.temperature.toStringAsFixed(0)}°C',
                                '쾌적 🟢',
                                AppTheme.lightGreen,
                              ),
                              const SizedBox(height: 12),
                              _buildDetailItem(
                                '습도',
                                '${airQualityData.humidity.toStringAsFixed(0)}%',
                                '적정 🟢',
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
                            ? AppTheme.primaryBlue
                            : Colors.white,
                        foregroundColor: _showOutdoorGuide
                            ? Colors.white
                            : AppTheme.primaryBlue,
                        side: _showOutdoorGuide
                            ? null
                            : const BorderSide(color: AppTheme.primaryBlue),
                      ),
                      child: Text(
                        _showOutdoorGuide ? '외출 가이드 닫기' : '외출 가이드 보기',
                      ),
                    ),

                    // Outdoor Guide
                    AnimatedCrossFade(
                      firstChild: SizedBox.shrink(),
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
                                value: airQualityData.pm10,
                                maxValue: 250,
                                size: 200,
                                label: 'PM10',
                              ),
                              const SizedBox(height: 24),
                              // Guide (Material 3)
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightGreen.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 0,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '🚶 지금 외출 괜찮아요',
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
                                      '오후 시간대는 미세먼지가 "보통" 수준이지만, 저녁 5시 이후로 조금씩 나빠질 예정이에요.',
                                      style: TextStyle(
                                        fontSize:
                                            14 *
                                            ResponsiveUtil.getTextScaleFactor(
                                              context,
                                            ),
                                        color: AppTheme.textSecondary,
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
                              _buildRecommendationItem(
                                '✅',
                                '일반 외출 가능',
                                AppTheme.lightGreen,
                              ),
                              const SizedBox(height: 8),
                              _buildRecommendationItem(
                                '⚠️',
                                '장시간 야외 활동 시 마스크 휴대 권장',
                                AppTheme.lightYellow,
                              ),
                              const SizedBox(height: 8),
                              _buildRecommendationItem(
                                '💧',
                                '물 자주 마시기',
                                AppTheme.lightBlue,
                              ),
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
                  color: AppTheme.textSecondary,
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
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
