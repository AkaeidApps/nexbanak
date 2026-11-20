import 'package:flutter/widgets.dart';
import 'package:nexbanak/app/constants/app_constants.dart';

extension ResponsiveX on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isMobile => screenWidth < AppConstants.mobileBreakpoint;
  bool get isTablet =>
      screenWidth >= AppConstants.mobileBreakpoint &&
      screenWidth < AppConstants.desktopBreakpoint;
  bool get isDesktop => screenWidth >= AppConstants.desktopBreakpoint;
  bool get isCompact => screenWidth < AppConstants.tabletBreakpoint;

  /// Pick a value for the active breakpoint.
  T responsive<T>({required T mobile, T? tablet, required T desktop}) {
    if (isMobile) return mobile;
    if (isTablet) return tablet ?? mobile;
    return desktop;
  }

  int get gridColumns => responsive(mobile: 1, tablet: 2, desktop: 4);
  double get contentMaxWidth =>
      isDesktop ? AppConstants.desktopBreakpoint - 160 : double.infinity;
}

/// Adaptive [LayoutBuilder] wrapper used by every role shell.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double w = constraints.maxWidth;
        if (w < AppConstants.mobileBreakpoint) return mobile;
        if (w < AppConstants.desktopBreakpoint) return tablet ?? mobile;
        return desktop;
      },
    );
  }
}
