import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RadialGauge extends StatelessWidget {
  final double value;
  final double maxValue;
  final double size;
  final double strokeWidth;
  final String label;

  const RadialGauge({
    super.key,
    required this.value,
    this.maxValue = 250,
    this.size = 200,
    this.strokeWidth = 20,
    this.label = 'PM10',
  });

  Color _getColor() {
    if (value <= 30) return AppTheme.goodGreen; // 좋음
    if (value <= 80) return AppTheme.accentBlue; // 보통
    if (value <= 150) return AppTheme.cautionYellow; // 나쁨
    return AppTheme.badRed; // 매우나쁨
  }

  String _getStatus() {
    if (value <= 30) return '좋음';
    if (value <= 80) return '보통';
    if (value <= 150) return '나쁨';
    return '매우나쁨';
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final percentage = min((value / maxValue) * 100, 100).toDouble();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // CustomPaint for the circular gauge
              CustomPaint(
                size: Size(size, size),
                painter: _RadialGaugePainter(
                  percentage: percentage,
                  color: color,
                  strokeWidth: strokeWidth,
                ),
              ),
              // Center text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    '㎍/㎥',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _getStatus(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _RadialGaugePainter extends CustomPainter {
  final double percentage;
  final Color color;
  final double strokeWidth;

  _RadialGaugePainter({
    required this.percentage,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw from top (-90 degrees / -pi/2 radians)
    // Sweep angle based on percentage
    final sweepAngle = (percentage / 100) * 2 * pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RadialGaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
