import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive_util.dart';
import '../../models/air_quality_data.dart';

/// 공기질 상세 정보를 표시하는 카드 위젯
class AirQualityDetailsCard extends StatelessWidget {
  final AirQualityData airQualityData;
  final bool isExpanded;

  const AirQualityDetailsCard({
    required this.airQualityData,
    this.isExpanded = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
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
                  fontSize: 18 * ResponsiveUtil.getTextScaleFactor(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailItem(
                context,
                '미세먼지 (PM10)',
                '${airQualityData.pm10.toStringAsFixed(0)} ㎍/㎥',
                airQualityData.getPM10Status(),
                AppTheme.lightYellow,
              ),
              const SizedBox(height: 12),
              _buildDetailItem(
                context,
                '초미세먼지 (PM2.5)',
                '${airQualityData.pm25.toStringAsFixed(0)} ㎍/㎥',
                airQualityData.getPM25Status(),
                AppTheme.lightYellow,
              ),
              const SizedBox(height: 12),
              _buildDetailItem(
                context,
                '기온',
                '${airQualityData.temperature.toStringAsFixed(0)}°C',
                airQualityData.getTemperatureStatus(),
                AppTheme.lightGreen,
              ),
              const SizedBox(height: 12),
              _buildDetailItem(
                context,
                '습도',
                '${airQualityData.humidity.toStringAsFixed(0)}%',
                airQualityData.getHumidityStatus(),
                AppTheme.lightGreen,
              ),
            ],
          ),
        ),
      ),
      crossFadeState: isExpanded
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }

  /// 상세 항목을 빌드합니다.
  Widget _buildDetailItem(
    BuildContext context,
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
                  fontSize:
                      14 * ResponsiveUtil.getTextScaleFactor(context),
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(
                  fontSize:
                      12 * ResponsiveUtil.getTextScaleFactor(context),
                  color: AppTheme.getSecondaryTextColor(
                    Theme.of(context).brightness,
                  ),
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
}
