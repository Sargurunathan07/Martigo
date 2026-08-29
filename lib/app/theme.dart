import 'package:flutter/material.dart';

/// Centralized Martigo design system theme.
class AppTheme {
  AppTheme._();

  // Brand palette
  static const Color primaryMaroon = Color(0xFF800020);
  static const Color deepMaroon = Color(0xFF5A0015);
  static const Color softMaroon = Color(0xFFF5E1E5);
  static const Color cream = Color(0xFFFFF7F0);
  static const Color backgroundColor = Color(0xFFFFFDFC);
  static const Color textColor = Color(0xFF292323);

  static const double _radius = 16;
  static const double _spacing = 16;

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryMaroon,
      brightness: Brightness.light,
    ).copyWith(
      primary: primaryMaroon,
      secondary: deepMaroon,
      surface: cream,
      onPrimary: cream,
      onSecondary: cream,
      onSurface: textColor,
    );

    final baseTextTheme = _buildTextTheme(textColor);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: baseTextTheme,

      appBarTheme: AppBarTheme(
        backgroundColor: primaryMaroon,
        foregroundColor: cream,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(
          color: cream,
          fontWeight: FontWeight.w600,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryMaroon,
          foregroundColor: cream,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(
            horizontal: _spacing * 1.5,
            vertical: _spacing,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          textStyle: baseTextTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryMaroon,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(
            horizontal: _spacing * 1.5,
            vertical: _spacing,
          ),
          side: const BorderSide(color: primaryMaroon, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          textStyle: baseTextTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryMaroon,
          textStyle: baseTextTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: softMaroon.withValues(alpha: 0.35),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: _spacing,
          vertical: _spacing,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: primaryMaroon, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
        ),
        labelStyle: baseTextTheme.bodyMedium?.copyWith(
          color: textColor.withValues(alpha: 0.7),
        ),
        hintStyle: baseTextTheme.bodyMedium?.copyWith(
          color: textColor.withValues(alpha: 0.5),
        ),
      ),

      cardTheme: CardThemeData(
        color: cream,
        elevation: 2,
        margin: const EdgeInsets.symmetric(
          vertical: _spacing / 2,
          horizontal: 0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cream,
        selectedItemColor: primaryMaroon,
        unselectedItemColor: textColor.withValues(alpha: 0.5),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: baseTextTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: baseTextTheme.labelSmall,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: backgroundColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius * 1.25),
        ),
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: baseTextTheme.bodyMedium,
      ),

      dividerTheme: DividerThemeData(
        color: textColor.withValues(alpha: 0.08),
        thickness: 1,
        space: _spacing,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: deepMaroon,
        contentTextStyle: baseTextTheme.bodyMedium?.copyWith(color: cream),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius / 1.5),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: softMaroon,
        labelStyle: baseTextTheme.bodySmall?.copyWith(color: textColor),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
      ),

      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static TextTheme _buildTextTheme(Color color) {
    return TextTheme(
      displayLarge: TextStyle(
        color: color,
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: TextStyle(
        color: color,
        fontSize: 28,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: color,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        color: color,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: color,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: color,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: color.withValues(alpha: 0.7),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        color: color,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: TextStyle(
        color: color.withValues(alpha: 0.8),
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}