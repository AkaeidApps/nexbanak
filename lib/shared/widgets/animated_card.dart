import 'package:flutter/material.dart';

/// Wraps any card or UI element with entry animations (fade + slide) and
/// interactive tap/hover scale and elevation feedback.
class AnimatedCard extends StatefulWidget {
  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.delayMs = 0,
    this.borderRadius = 16,
    this.padding,
    this.margin,
    this.color,
    this.border,
    this.elevation = 0,
    this.enableScaleAnimation = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final int delayMs;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final BoxBorder? border;
  final double elevation;
  final bool enableScaleAnimation;

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    if (widget.delayMs > 0) {
      Future.delayed(Duration(milliseconds: widget.delayMs), () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double scale = _isPressed
        ? 0.975
        : (_isHovered ? 1.015 : 1.0);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: AnimatedScale(
          scale: widget.enableScaleAnimation ? scale : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: widget.margin,
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: widget.color ?? Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: widget.border ??
                      Border.all(
                        color: _isHovered
                            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.4)
                            : Theme.of(context).dividerColor,
                      ),
                  boxShadow: <BoxShadow>[
                    if (widget.elevation > 0 || _isHovered)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: _isHovered ? 0.08 : 0.04),
                        blurRadius: _isHovered ? 14 : 8,
                        offset: Offset(0, _isHovered ? 6 : 3),
                      ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  clipBehavior: Clip.antiAlias,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
