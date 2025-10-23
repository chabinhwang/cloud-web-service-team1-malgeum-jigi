import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// 정보를 표시하는 재사용 가능한 카드 위젯
class InfoCard extends StatelessWidget {
  /// 카드 제목
  final String title;

  /// 카드 배경색
  final Color backgroundColor;

  /// 카드 테두리 색
  final Color borderColor;

  /// 카드 내용
  final Widget child;

  /// 카드 높이 (선택사항)
  final double? height;

  /// 카드 여백 (기본값: 16)
  final double padding;

  /// 카드의 모서리 반경 (기본값: 16)
  final double borderRadius;

  /// 카드 그림자 높이 (기본값: 4)
  final double elevation;

  const InfoCard({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.borderColor,
    required this.child,
    this.height,
    this.padding = AppConstants.spacingLarge,
    this.borderRadius = AppConstants.radiusLarge,
    this.elevation = AppConstants.cardElevation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: borderColor, width: 2),
      ),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: backgroundColor,
        ),
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: height != null ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (title.isNotEmpty) ...[
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.spacingMedium),
            ],
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}
