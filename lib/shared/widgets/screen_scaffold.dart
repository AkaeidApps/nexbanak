import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/constants/app_constants.dart';
import 'package:nexbanak/core/base_controller.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';

/// Standard padding + inline loading indicator for every feature screen.
class ScreenScaffold extends StatelessWidget {
  const ScreenScaffold({
    super.key,
    required this.controller,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final BaseController controller;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          SingleChildScrollView(padding: padding, child: child),
          if (AppConstants.useMock)
            const Positioned(
              top: 6,
              right: 6,
              child: IgnorePointer(child: DemoBanner(dense: true)),
            ),
          Obx(
            () => controller.isLoading.value
                ? const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(minHeight: 2),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      );
}
