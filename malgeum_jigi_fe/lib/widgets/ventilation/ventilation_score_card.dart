import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive_util.dart';

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
    if (score >= 70) return '좋음 😊';
    if (score >= 40) return '보통 😐';
    return '나쁨 😟';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: const Color(0x140D0A2C),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      color: AppTheme.getScoreBackgroundColor(score).withValues(alpha: 0.5),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              '현재 환기 점수',
              style: TextStyle(
                fontSize:
                    16 * ResponsiveUtil.getTextScaleFactor(context),
                color: AppTheme.getRecommendationTextColor(
                  Theme.of(context).brightness,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$score',
              style: TextStyle(
                fontSize:
                    80 * ResponsiveUtil.getTextScaleFactor(context),
                fontWeight: FontWeight.bold,
                color: _getScoreColor(score),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getScoreStatus(score),
              style: TextStyle(
                fontSize:
                    24 * ResponsiveUtil.getTextScaleFactor(context),
                fontWeight: FontWeight.w600,
                color: _getScoreColor(score),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(
                fontSize:
                    18 * ResponsiveUtil.getTextScaleFactor(context),
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
