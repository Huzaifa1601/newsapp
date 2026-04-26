import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_palette.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: isDark ? AppPalette.cyan : AppPalette.electric,
      onPrimary: Colors.white,
      secondary: isDark ? AppPalette.gold : AppPalette.coral,
      onSecondary: AppPalette.ink,
      error: const Color(0xFFFF5B79),
      onError: Colors.white,
      surface: isDark ? const Color(0xFF0F1B2D) : AppPalette.snow,
      onSurface: isDark ? const Color(0xFFF6FAFF) : AppPalette.ink,
      surfaceContainerHighest: isDark
          ? const Color(0xFF152338)
          : const Color(0xFFF1F5FB),
      onSurfaceVariant: isDark ? AppPalette.glacier : AppPalette.slate,
      outline: isDark ? const Color(0xFF31435C) : const Color(0xFFD6E0EE),
      shadow: Colors.black.withValues(alpha: 0.2),
      scrim: Colors.black.withValues(alpha: 0.3),
      inverseSurface: isDark ? AppPalette.snow : AppPalette.midnight,
      onInverseSurface: isDark ? AppPalette.midnight : AppPalette.snow,
      inversePrimary: isDark ? AppPalette.electric : AppPalette.cyan,
    );

    final baseTextTheme = GoogleFonts.manropeTextTheme(
      ThemeData(brightness: brightness).textTheme,
    );
    final displayStyle = GoogleFonts.spaceGrotesk(
      color: colorScheme.onSurface,
      fontWeight: FontWeight.w700,
    );

    final textTheme = baseTextTheme.copyWith(
      displayLarge: displayStyle.copyWith(fontSize: 40, height: 1.1),
      displayMedium: displayStyle.copyWith(fontSize: 34, height: 1.1),
      headlineLarge: displayStyle.copyWith(fontSize: 30, height: 1.15),
      headlineMedium: displayStyle.copyWith(fontSize: 24, height: 1.2),
      titleLarge: GoogleFonts.spaceGrotesk(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        height: 1.55,
        color: colorScheme.onSurface,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        height: 1.55,
        color: colorScheme.onSurfaceVariant,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF07111E)
          : const Color(0xFFF8FBFF),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface.withValues(alpha: isDark ? 0.64 : 0.88),
        shadowColor: colorScheme.shadow,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.35)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        disabledColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primary.withValues(alpha: 0.18),
        secondarySelectedColor: colorScheme.primary.withValues(alpha: 0.18),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        labelStyle: textTheme.labelLarge!,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        side: BorderSide.none,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface.withValues(alpha: isDark ? 0.72 : 0.9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.22),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: colorScheme.primary,
          minimumSize: const Size(double.infinity, 58),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface.withValues(
          alpha: isDark ? 0.92 : 0.96,
        ),
        indicatorColor: colorScheme.primary.withValues(alpha: 0.16),
        shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      dividerColor: colorScheme.outline.withValues(alpha: 0.18),
    );
  }
}
