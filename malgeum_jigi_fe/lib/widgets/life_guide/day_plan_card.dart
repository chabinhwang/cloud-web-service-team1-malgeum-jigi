import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/weekly_plan.dart';
import '../../theme/app_theme.dart';
import '../../theme/text_styles.dart';
import 'activity_card.dart';

/// 날짜별 일일 계획 카드
///
/// 요일, 날짜, 그리고 해당 날짜의 모든 활동을 표시합니다.
/// "오늘" 배지가 있으면 강조 표시합니다.
class DayPlanCard extends StatelessWidget {
  final DayPlan day;

  const DayPlanCard({
    required this.day,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 날짜 헤더 (요일 + 날짜 + 오늘 배지)
          Row(
            children: [
              Text(
                '${day.dayOfWeek} ${day.date}',
                style: AppTextStyles.heading(context),
              ),
              if (day.isToday) ...[
                const SizedBox(width: 8),
                _buildTodayBadge(),
              ],
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          // 활동 목록
          ...day.activities.map(
            (activity) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ActivityCard(activity: activity),
            ),
          ),
        ],
      ),
    );
  }

  /// "오늘" 배지
  Widget _buildTodayBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        '오늘',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
