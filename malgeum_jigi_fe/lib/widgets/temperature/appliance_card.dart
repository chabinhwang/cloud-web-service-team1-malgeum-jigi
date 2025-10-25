import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive_util.dart';
import '../../utils/appliance_config.dart';
import '../../models/air_quality_data.dart';

/// 가전제품 가이드 카드 위젯
class ApplianceCard extends StatelessWidget {
  final ApplianceGuide appliance;

  const ApplianceCard({
    required this.appliance,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 가전제품 설정 가져오기
    final config = ApplianceConfig.get(appliance.name);

    // 필요/불필요에 따라 색상 결정
    final backgroundColor = appliance.isRequired
        ? config.activeBackgroundColor
        : AppTheme.getUnnecessaryBackgroundColor(
            Theme.of(context).brightness,
          );
    final textColor = appliance.isRequired
        ? config.activeTextColor
        : AppTheme.getRecommendationTextColor(
            Theme.of(context).brightness,
          );

    return Card(
      elevation: 2,
      shadowColor: const Color(0x140D0A2C),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.transparent, width: 0),
      ),
      color: backgroundColor.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.transparent,
                  width: 0,
                ),
              ),
              child: Icon(config.icon, size: 24, color: textColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        appliance.name,
                        style: TextStyle(
                          fontSize: 18 *
                              ResponsiveUtil.getTextScaleFactor(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: appliance.isRequired
                              ? AppTheme.lightBlue
                              : AppTheme
                                  .getUnnecessaryBadgeBackgroundColor(
                                Theme.of(context).brightness,
                              ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          appliance.status,
                          style: TextStyle(
                            fontSize: 12 *
                                ResponsiveUtil.getTextScaleFactor(context),
                            fontWeight: FontWeight.w600,
                            color: appliance.isRequired
                                ? AppTheme.primaryBlue
                                : AppTheme.getRecommendationTextColor(
                                    Theme.of(context).brightness,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (appliance.time != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '사용 시간: ',
                          style: TextStyle(
                            fontSize: 12 *
                                ResponsiveUtil.getTextScaleFactor(context),
                            color: AppTheme.getRecommendationTextColor(
                              Theme.of(context).brightness,
                            ),
                          ),
                        ),
                        Text(
                          appliance.time!,
                          style: TextStyle(
                            fontSize: 12 *
                                ResponsiveUtil.getTextScaleFactor(context),
                            fontWeight: FontWeight.w600,
                            color: AppTheme.getRecommendationTextColor(
                              Theme.of(context).brightness,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '이유: ',
                        style: TextStyle(
                          fontSize: 12 *
                              ResponsiveUtil.getTextScaleFactor(context),
                          color: AppTheme.getRecommendationTextColor(
                            Theme.of(context).brightness,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '"${appliance.reason}"',
                          style: TextStyle(
                            fontSize: 12 *
                                ResponsiveUtil.getTextScaleFactor(context),
                            color: AppTheme.getRecommendationTextColor(
                              Theme.of(context).brightness,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (appliance.setting != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.transparent,
                          width: 0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '권장 설정: ',
                            style: TextStyle(
                              fontSize: 12 *
                                  ResponsiveUtil.getTextScaleFactor(
                                    context,
                                  ),
                              color: AppTheme.getLocationTimeTextColor(
                                Theme.of(context).brightness,
                              ),
                            ),
                          ),
                          Text(
                            appliance.setting!,
                            style: TextStyle(
                              fontSize: 12 *
                                  ResponsiveUtil.getTextScaleFactor(
                                    context,
                                  ),
                              fontWeight: FontWeight.w600,
                              color: AppTheme.getLocationTimeTextColor(
                                Theme.of(context).brightness,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
