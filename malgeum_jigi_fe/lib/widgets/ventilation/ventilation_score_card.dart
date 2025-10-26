import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../theme/app_theme.dart';
import '../../theme/text_styles.dart';
import '../common/app_card.dart';

/// 환기 점수를 표시하는 카드 위젯
class VentilationScoreCard extends StatelessWidget {
  final int score;
  final String description;

  const VentilationScoreCard({
    required this.score,
    required this.description,
    super.key,
  });

  /// 점수에 따른 색상을 반환합니다.
  Color _getScoreColor(int score) {
    return AppTheme.getScoreColor(score);
  }

  /// 점수에 따른 상태 텍스트를 반환합니다.
  String _getScoreStatus(int score) {
    if (score >= AppConstants.scoreThresholdGood) return '좋음 😊';
    if (score >= AppConstants.scoreThresholdOk) return '보통 😐';
    return '나쁨 😟';
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppTheme.getScoreBackgroundColor(score).withValues(alpha: 0.5),
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Text(
              '현재 환기 점수',
              style: AppTextStyles.secondary(context),
            ),
            const SizedBox(height: 16),
            Text(
              '$score',
              style: AppTextStyles.score(context).copyWith(
                color: _getScoreColor(score),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getScoreStatus(score),
              style: AppTextStyles.statusDescription(context).copyWith(
                color: _getScoreColor(score),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: AppTextStyles.bodyLarge(context).copyWith(
                color: AppTheme.getRecommendationTextColor(
                  Theme.of(context).brightness,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
