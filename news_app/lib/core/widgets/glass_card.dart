import 'dart:ui';

import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = const BorderRadius.all(Radius.circular(28)),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: theme.colorScheme.surface.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.62 : 0.84,
            ),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.22),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                blurRadius: 36,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          padding: padding,
          child: child,
        ),
      ),
    );

    if (onTap == null) {
      return card;
    }

    return InkWell(borderRadius: borderRadius, onTap: onTap, child: card);
  }
}
