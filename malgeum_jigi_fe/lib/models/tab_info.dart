import 'package:flutter/material.dart';

/// 탭 정보를 담는 모델 클래스
class TabInfo {
  /// 탭 ID (인덱스)
  final int id;

  /// 탭 라벨
  final String label;

  /// 탭 아이콘
  final IconData icon;

  const TabInfo({
    required this.id,
    required this.label,
    required this.icon,
  });
}
