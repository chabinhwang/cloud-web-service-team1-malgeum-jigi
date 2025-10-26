import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive_util.dart';
import '../../models/air_quality_data.dart';
import '../common/app_card.dart';

/// 오늘의 환경 요약 카드 위젯
class EnvironmentSummaryCard extends StatelessWidget {
  final TodayEnvironmentData todayData;

  const EnvironmentSummaryCard({required this.todayData, super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppTheme.lightBlue.withValues(alpha: 0.5),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
            Text(
              '오늘의 환경 요약',
              style: TextStyle(
                fontSize: 18 * ResponsiveUtil.getTextScaleFactor(context),
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.thermostat,
                          size: 32,
                          color: AppTheme.badRed,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '기온',
                                style: TextStyle(
                                  fontSize:
                                      12 *
                                      ResponsiveUtil.getTextScaleFactor(
                                        context,
                                      ),
                                  color: AppTheme.getLocationTimeTextColor(
                                    Theme.of(context).brightness,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${todayData.minTemp.toStringAsFixed(1)}°C ~ ${todayData.maxTemp.toStringAsFixed(1)}°C',
                                style: TextStyle(
                                  fontSize:
                                      16 *
                                      ResponsiveUtil.getTextScaleFactor(
                                        context,
                                      ),
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.getLocationTimeTextColor(
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
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.water_drop,
                          size: 32,
                          color: AppTheme.accentBlue,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '습도',
                                style: TextStyle(
                                  fontSize:
                                      12 *
                                      ResponsiveUtil.getTextScaleFactor(
                                        context,
                                      ),
                                  color: AppTheme.getLocationTimeTextColor(
                                    Theme.of(context).brightness,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '평균 ${todayData.avgHumidity}%',
                                style: TextStyle(
                                  fontSize:
                                      16 *
                                      ResponsiveUtil.getTextScaleFactor(
                                        context,
                                      ),
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.getLocationTimeTextColor(
                                    Theme.of(context).brightness,
                                  ),
                                ),
                              ),
                              // API에서 evening_humidity를 제공하지 않으므로 표시하지 않음
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
  }
}
