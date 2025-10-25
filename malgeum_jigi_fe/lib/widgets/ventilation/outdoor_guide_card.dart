import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive_util.dart';

/// 외출 가이드를 표시하는 카드 위젯
class OutdoorGuideCard extends StatelessWidget {
  final Map<String, dynamic>? outdoorGuideData;
  final double pmValue;
  final bool isExpanded;

  const OutdoorGuideCard({
    required this.outdoorGuideData,
    required this.pmValue,
    this.isExpanded = false,
    super.key,
  });

  /// 외출 가능성에 따른 색상을 반환합니다.
  Color _getOutdoorGuideColor() {
    final advisability = outdoorGuideData?['advisability'] as String? ?? '';

    switch (advisability) {
      case '추천':
      case '좋음':
        return AppTheme.lightGreen;
      case '보통':
        return AppTheme.lightYellow;
      case '나쁨':
      case '주의':
        return AppTheme.lightRed;
      default:
        return AppTheme.lightGreen;
    }
  }

  /// 외출 가이드 제목을 반환합니다.
  String _getOutdoorGuideTitle() {
    final advisability = outdoorGuideData?['advisability'] as String? ?? '';

    switch (advisability) {
      case '추천':
      case '좋음':
        return '🚶 지금 외출 추천합니다';
      case '보통':
        return '⚠️ 외출 시 주의가 필요합니다';
      case '나쁨':
      case '주의':
        return '❌ 외출을 삼가시기 바랍니다';
      default:
        return '🚶 지금 외출 괜찮아요';
    }
  }

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
            children: [
              Text(
                '외출 가이드',
                style: TextStyle(
                  fontSize: 18 * ResponsiveUtil.getTextScaleFactor(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // PM10 Gauge는 기존 RadialGauge 위젯 사용
              const SizedBox(height: 24),
              // Guide container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getOutdoorGuideColor().withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 0,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      _getOutdoorGuideTitle(),
                      style: TextStyle(
                        fontSize: 18 *
                            ResponsiveUtil.getTextScaleFactor(context),
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      outdoorGuideData?['summary'] as String? ??
                          '오후 시간대는 미세먼지가 "보통" 수준이지만, 저녁 5시 이후로 조금씩 나빠질 예정이에요.',
                      style: TextStyle(
                        fontSize: 14 *
                            ResponsiveUtil.getTextScaleFactor(context),
                        color: AppTheme.getRecommendationTextColor(
                          Theme.of(context).brightness,
                        ),
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
                  fontSize: 16 *
                      ResponsiveUtil.getTextScaleFactor(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ..._buildRecommendationsFromAPI(),
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

  /// API에서 받은 권장사항을 표시합니다.
  List<Widget> _buildRecommendationsFromAPI() {
    final recommendations =
        outdoorGuideData?['recommendations'] as List<dynamic>? ?? [];

    if (recommendations.isEmpty) {
      // 기본값: API에서 recommendations이 없을 때
      return [
        _buildRecommendationItem(
          '✅',
          '일반 외출 가능',
          AppTheme.lightGreen,
        ),
        const SizedBox(height: 8),
        _buildRecommendationItem(
          '⚠️',
          '필요 시 마스크 착용',
          AppTheme.lightYellow,
        ),
        const SizedBox(height: 8),
        _buildRecommendationItem(
          '💧',
          '충분한 수분 섭취',
          AppTheme.lightBlue,
        ),
      ];
    }

    // API에서 받은 recommendations 렌더링
    final List<Widget> widgets = [];
    for (int i = 0; i < recommendations.length; i++) {
      final recommendation = recommendations[i] as String;
      final colors = [
        AppTheme.lightGreen,
        AppTheme.lightYellow,
        AppTheme.lightBlue
      ];
      final emoji = ['✅', '⚠️', '💧'];

      widgets.add(
        _buildRecommendationItem(
          emoji[i % emoji.length],
          recommendation,
          colors[i % colors.length],
        ),
      );

      if (i < recommendations.length - 1) {
        widgets.add(const SizedBox(height: 8));
      }
    }

    return widgets;
  }

  /// 권장사항 항목을 빌드합니다.
  Widget _buildRecommendationItem(
    String emoji,
    String text,
    Color backgroundColor,
  ) {
    return Builder(
      builder: (context) {
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
                  fontSize:
                      20 * ResponsiveUtil.getTextScaleFactor(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize:
                        14 * ResponsiveUtil.getTextScaleFactor(context),
                    color: AppTheme.getRecommendationTextColor(
                      Theme.of(context).brightness,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
