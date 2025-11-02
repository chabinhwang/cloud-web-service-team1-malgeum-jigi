import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/text_styles.dart';
import '../../utils/responsive_util.dart';
import '../common/radial_gauge.dart';
import '../common/app_card.dart';

/// 외출 가이드를 표시하는 카드 위젯
class OutdoorGuideCard extends StatelessWidget {
  final Map<String, dynamic>? outdoorGuideData;
  final double pmValue;
  final bool isExpanded;

  // 외출 가능성 매핑 (색상, 제목, 이모지)
  static const Map<String, (Color, String, String)> _advisabilityMap = {
    '추천': (AppTheme.lightGreen, '🚶 지금 외출 추천합니다', '✅'),
    '좋음': (AppTheme.lightGreen, '🚶 지금 외출 추천합니다', '✅'),
    '보통': (AppTheme.lightYellow, '⚠️ 외출 시 주의가 필요합니다', '⚠️'),
    '나쁨': (AppTheme.lightRed, '❌ 외출을 삼가시기 바랍니다', '❌'),
    '주의': (AppTheme.lightRed, '❌ 외출을 삼가시기 바랍니다', '❌'),
  };

  const OutdoorGuideCard({
    required this.outdoorGuideData,
    required this.pmValue,
    this.isExpanded = false,
    super.key,
  });

  /// 외출 가능성 정보를 반환합니다 (색상, 제목, 기본 이모지).
  (Color, String, String) _getAdvisabilityInfo() {
    final advisability = outdoorGuideData?['advisability'] as String? ?? '';
    return _advisabilityMap[advisability] ??
        (AppTheme.lightGreen, '🚶 지금 외출 괜찮아요', '✅');
  }

  /// 외출 가능성에 따른 색상을 반환합니다.
  Color _getOutdoorGuideColor() {
    return _getAdvisabilityInfo().$1;
  }

  /// 외출 가이드 제목을 반환합니다.
  String _getOutdoorGuideTitle() {
    return _getAdvisabilityInfo().$2;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: const SizedBox.shrink(),
      secondChild: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('외출 가이드', style: AppTextStyles.heading(context)),
            const SizedBox(height: 24),
            RadialGauge(
              value: pmValue,
              maxValue: 250,
              size: 200,
              strokeWidth: 20,
              label: 'PM10 농도',
            ),
            const SizedBox(height: 24),
            _buildGuideContainer(context),
            const SizedBox(height: 16),
            Text('권장사항', style: AppTextStyles.headingSmall(context)),
            const SizedBox(height: 12),
            ..._buildRecommendationsFromAPI(context),
          ],
        ),
      ),
      crossFadeState: isExpanded
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildGuideContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getOutdoorGuideColor().withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            _getOutdoorGuideTitle(),
            style: AppTextStyles.heading(context),
          ),
          const SizedBox(height: 8),
          Text(
            outdoorGuideData?['summary'] as String? ??
                '오후 시간대는 미세먼지가 "보통" 수준이지만, 저녁 5시 이후로 조금씩 나빠질 예정이에요.',
            style: AppTextStyles.recommendation(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 권장사항 아이템 매핑 (이모지, 텍스트)
  static const List<(String, Color)> _recommendationEmojisAndColors = [
    ('✅', AppTheme.lightGreen),
    ('⚠️', AppTheme.lightYellow),
    ('💧', AppTheme.lightBlue),
  ];

  /// API에서 받은 권장사항을 표시합니다.
  List<Widget> _buildRecommendationsFromAPI(BuildContext context) {
    final recommendations =
        outdoorGuideData?['recommendations'] as List<dynamic>? ?? [];

    final defaultRecommendations = [
      ('✅', '일반 외출 가능', AppTheme.lightGreen),
      ('⚠️', '필요 시 마스크 착용', AppTheme.lightYellow),
      ('💧', '충분한 수분 섭취', AppTheme.lightBlue),
    ];

    final itemsToShow = recommendations.isEmpty
        ? defaultRecommendations
        : recommendations
            .asMap()
            .entries
            .map((e) {
              final (emoji, color) =
                  _recommendationEmojisAndColors[e.key % _recommendationEmojisAndColors.length];
              return (emoji, e.value as String, color);
            })
            .toList();

    return [
      for (int i = 0; i < itemsToShow.length; i++) ...[
        _buildRecommendationItem(
          itemsToShow[i].$1,
          itemsToShow[i].$2,
          itemsToShow[i].$3,
          context,
        ),
        if (i < itemsToShow.length - 1) const SizedBox(height: 8),
      ]
    ];
  }

  /// 권장사항 항목을 빌드합니다.
  Widget _buildRecommendationItem(
    String emoji,
    String text,
    Color backgroundColor,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            emoji,
            style: TextStyle(
              fontSize: 20 * ResponsiveUtil.getTextScaleFactor(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.recommendation(context),
            ),
          ),
        ],
      ),
    );
  }
}
