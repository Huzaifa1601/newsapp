import 'package:flutter/material.dart';

class AnimatedSkeleton extends StatefulWidget {
  const AnimatedSkeleton({
    super.key,
    required this.height,
    this.width = double.infinity,
    this.borderRadius = 18,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  State<AnimatedSkeleton> createState() => _AnimatedSkeletonState();
}

class _AnimatedSkeletonState extends State<AnimatedSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.colorScheme.surfaceContainerHighest;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1 + (_controller.value * 2), -0.3),
              end: Alignment(1 + (_controller.value * 2), 0.3),
              colors: [
                base.withValues(alpha: 0.64),
                theme.colorScheme.surface.withValues(alpha: 0.92),
                base.withValues(alpha: 0.64),
              ],
            ),
          ),
        );
      },
    );
  }
}
