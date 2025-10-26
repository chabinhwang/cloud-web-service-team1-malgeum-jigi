import 'package:flutter/material.dart';

/// 재사용 가능한 앱 카드 위젯
///
/// 일관된 카드 디자인을 제공하며, 다양한 커스터마이징이 가능합니다.
/// 그림자, 모서리 반경, 배경색 등을 통합 관리합니다.
class AppCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final double elevation;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;
  final Color shadowColor;

  const AppCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(16),
    this.elevation = 2,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.onTap,
    this.shadowColor = const Color(0x140D0A2C),
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: elevation,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: const BorderSide(color: Colors.transparent, width: 0),
      ),
      color: backgroundColor,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: card,
      );
    }

    return card;
  }
}
