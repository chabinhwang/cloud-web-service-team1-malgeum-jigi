import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/weekly_plan.dart';
import '../../theme/text_styles.dart';
import '../../utils/responsive_util.dart';
import '../common/status_badge.dart';
import '../common/app_card.dart';

/// 개별 활동 카드
///
/// 활동 제목, 상태 배지, 권장 시간, 사유를 표시합니다.
/// 상태(optimal, recommended, caution, prohibited)에 따라
/// 배경색이 동적으로 변경됩니다.
class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({
    required this.activity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: activity.status.getBadgeColor().withValues(alpha: 0.4),
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이모지 아이콘
          Text(
            activity.emoji,
            style: const TextStyle(fontSize: AppConstants.iconSizeXlarge),
          ),
          const SizedBox(width: AppConstants.spacingMedium),
          // 활동 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목 + 상태 배지
                Row(
                  children: [
                    Text(
                      activity.title,
                      style: AppTextStyles.heading(context),
                    ),
                    const SizedBox(width: AppConstants.spacingSmall),
                    StatusBadge(
                      status: activity.status,
                      label: activity.statusLabel,
                      fontSize: 12 *
                          ResponsiveUtil.getTextScaleFactor(context),
                    ),
                  ],
                ),
                // 시간 정보 (있을 경우)
                if (activity.time != null) ...[
                  const SizedBox(height: AppConstants.spacingSmall),
                  _buildTimeInfo(context),
                ],
                // 사유
                const SizedBox(height: AppConstants.spacingSmall),
                _buildReasonInfo(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 권장 시간 정보
  Widget _buildTimeInfo(BuildContext context) {
    return Row(
      children: [
        Text('시간: ', style: AppTextStyles.recommendationLabel(context)),
        Text(
          activity.time!,
          style: AppTextStyles.recommendationLabelBold(context),
        ),
      ],
    );
  }

  /// 사유 정보
  Widget _buildReasonInfo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('이유: ', style: AppTextStyles.recommendationLabel(context)),
        Expanded(
          child: Text(
            '"${activity.reason}"',
            style: AppTextStyles.recommendation(context),
          ),
        ),
      ],
    );
  }
}
