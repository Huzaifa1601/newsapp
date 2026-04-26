import 'package:flutter/material.dart';

import '../../../../core/widgets/glass_card.dart';

class AuthShell extends StatelessWidget {
  const AuthShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.12),
                  theme.scaffoldBackgroundColor,
                  theme.colorScheme.secondary.withValues(alpha: 0.08),
                ],
              ),
            ),
          ),
          Positioned(
            top: -120,
            right: -40,
            child: _GlowOrb(color: theme.colorScheme.primary),
          ),
          Positioned(
            bottom: -120,
            left: -40,
            child: _GlowOrb(color: theme.colorScheme.secondary),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PulseWire',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(title, style: theme.textTheme.displaySmall),
                  const SizedBox(height: 12),
                  Text(subtitle, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 28),
                  GlassCard(child: child),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.34), color.withValues(alpha: 0.0)],
        ),
      ),
    );
  }
}
