import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// API 데이터 로딩 상태를 처리하는 공용 위젯
///
/// 로딩, 에러, 데이터 표시를 일관되게 처리합니다.
class ApiDataBuilder<T> extends StatelessWidget {
  /// 로딩 중 여부
  final bool isLoading;

  /// 에러 메시지 (null이면 에러 없음)
  final String? error;

  /// 로드된 데이터
  final T? data;

  /// 데이터가 있을 때 표시할 위젯 빌더
  final Widget Function(T data) builder;

  /// 로딩 중일 때 표시할 커스텀 위젯 (생략하면 기본값 사용)
  final Widget? loadingWidget;

  /// 에러 발생 시 표시할 커스텀 위젯 빌더 (생략하면 기본값 사용)
  final Widget Function(String error)? errorBuilder;

  const ApiDataBuilder({
    required this.isLoading,
    required this.error,
    required this.data,
    required this.builder,
    this.loadingWidget,
    this.errorBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 로딩 상태 표시
    if (isLoading) {
      return loadingWidget ?? _defaultLoadingWidget();
    }

    // 에러 상태 표시
    if (error != null) {
      return errorBuilder?.call(error!) ?? _defaultErrorWidget(error!);
    }

    // 데이터가 없는 상태 표시
    if (data == null) {
      return const Center(
        child: Text('데이터가 없습니다'),
      );
    }

    // 데이터 표시
    return builder(data!);
  }

  /// 기본 로딩 위젯
  Widget _defaultLoadingWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            '데이터를 불러오는 중...',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.getSecondaryTextColor(Brightness.light),
            ),
          ),
        ],
      ),
    );
  }

  /// 기본 에러 위젯
  Widget _defaultErrorWidget(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.badRed,
            ),
            const SizedBox(height: 16),
            Text(
              '오류 발생',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.getSecondaryTextColor(Brightness.light),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
