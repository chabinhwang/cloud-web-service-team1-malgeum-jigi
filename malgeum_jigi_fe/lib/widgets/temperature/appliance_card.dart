import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/text_styles.dart';
import '../../utils/appliance_config.dart';
import '../../models/air_quality_data.dart';
import '../common/app_card.dart';

/// 가전제품 가이드 카드 위젯
class ApplianceCard extends StatelessWidget {
  final ApplianceGuide appliance;

  const ApplianceCard({
    required this.appliance,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final config = ApplianceConfig.get(appliance.name);
    final backgroundColor = appliance.isRequired
        ? config.activeBackgroundColor
        : AppTheme.getUnnecessaryBackgroundColor(
            Theme.of(context).brightness,
          );

    return AppCard(
      backgroundColor: backgroundColor.withValues(alpha: 0.5),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(config.icon, size: 32, color: config.activeTextColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(appliance.name, style: AppTextStyles.heading(context)),
                    const SizedBox(width: 8),
                    _buildStatusBadge(context),
                  ],
                ),
                if (appliance.time != null) ...[
                  const SizedBox(height: 8),
                  _buildTimeRow(context),
                ],
                const SizedBox(height: 8),
                _buildReasonRow(context),
                if (appliance.setting != null) ...[
                  const SizedBox(height: 12),
                  _buildSettingBox(context),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final badgeColor = appliance.isRequired
        ? AppTheme.primaryBlue
        : AppTheme.getRecommendationTextColor(brightness);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: appliance.isRequired
            ? AppTheme.lightBlue
            : AppTheme.getUnnecessaryBadgeBackgroundColor(brightness),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        appliance.status,
        style: AppTextStyles.badge(context).copyWith(color: badgeColor),
      ),
    );
  }

  Widget _buildTimeRow(BuildContext context) {
    return Row(
      children: [
        Text('사용 시간: ', style: AppTextStyles.recommendationLabel(context)),
        Text(
          appliance.time!,
          style: AppTextStyles.recommendationLabelBold(context),
        ),
      ],
    );
  }

  Widget _buildReasonRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('이유: ', style: AppTextStyles.recommendationLabel(context)),
        Expanded(
          child: Text(
            '"${appliance.reason}"',
            style: AppTextStyles.recommendation(context),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text('권장 설정: ', style: AppTextStyles.locationTimeLabel(context)),
          Text(
            appliance.setting!,
            style: AppTextStyles.recommendationLabelBold(context).copyWith(
              color: AppTheme.getLocationTimeTextColor(
                Theme.of(context).brightness,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
