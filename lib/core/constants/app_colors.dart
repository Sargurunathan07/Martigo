import 'package:flutter/material.dart';

/// Centralized color palette for Martigo.
class AppColors {
  AppColors._();

  static const Color primaryMaroon = Color(0xFF800020);
  static const Color deepMaroon = Color(0xFF5A0015);
  static const Color richMaroon = Color(0xFF9F1239);
  static const Color roseMaroon = Color(0xFFB03052);

  static const Color softMaroon = Color(0xFFF5E1E5);
  static const Color cream = Color(0xFFFFF7F0);
  static const Color background = Color(0xFFFFFDFC);
  static const Color text = Color(0xFF292323);

  static const LinearGradient maroonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepMaroon, primaryMaroon, richMaroon, roseMaroon],
    stops: [0.0, 0.35, 0.72, 1.0],
  );

  // Default page gradient used by AppGradientBackground.
  static const LinearGradient page = maroonGradient;

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [deepMaroon, primaryMaroon, richMaroon],
  );
}
