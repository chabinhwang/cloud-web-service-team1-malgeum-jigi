import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../utils/responsive_util.dart';

class TabHeader extends StatelessWidget {
  final String title;
  final String backgroundImage;
  final String? subtitle;
  final ScrollController scrollController;

  const TabHeader({
    super.key,
    required this.title,
    required this.backgroundImage,
    this.subtitle,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: ResponsiveUtil.isMobile(context)
          ? AppConstants.mobileHeaderHeight
          : AppConstants.desktopHeaderHeight,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Calculate progress based on scroll position
          final double expandRatio =
              constraints.maxHeight /
              (ResponsiveUtil.isMobile(context)
                  ? AppConstants.mobileHeaderHeight
                  : AppConstants.desktopHeaderHeight);
          final bool isCollapsed = expandRatio <= 1.1;

          return FlexibleSpaceBar(
            centerTitle: true,
            title: AnimatedOpacity(
              opacity: isCollapsed ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                title,
                style: TextStyle(
                  color:
                      Color.lerp(
                        Colors.white,
                        Colors.black87,
                        (1.0 - expandRatio).clamp(0.0, 1.0),
                      ) ??
                      Colors.white,
                  fontSize: ResponsiveUtil.getCollapsedTitleFontSize(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Dynamic background color
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  color: isCollapsed ? Colors.white : Colors.transparent,
                ),
                // Background Image
                Image.network(
                  backgroundImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.4),
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
                // Title and Subtitle
                AnimatedOpacity(
                  opacity: isCollapsed ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveUtil.getTitleFontSize(
                                context,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              subtitle!,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: ResponsiveUtil.getSubtitleFontSize(
                                  context,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
