import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/weekly_plan.dart';

/// 활동 상태를 표시하는 배지 위젯
class StatusBadge extends StatelessWidget {
  final ActivityStatus status;
  final String label;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.status,
    required this.label,
    this.fontSize = AppConstants.fontSizeSmall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMedium,
        vertical: AppConstants.spacingXs,
      ),
      decoration: BoxDecoration(
        color: status.getBadgeColor(),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: status.getBorderColor()),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: status.getBadgeTextColor(),
        ),
      ),
    );
  }
}
