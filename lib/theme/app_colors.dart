import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color background = Color(0xFF0F172A);
  static const Color cardBackground = Color(0xFF1E293B);
  static const Color primaryStart = Color(0xFF6A11CB);
  static const Color primaryEnd = Color(0xFF2575FC);

  // Status Colors
  static const Color normalBMI = Color(0xFF22C55E);
  static const Color overweightBMI = Color(0xFFF59E0B);
  static const Color obeseBMI = Color(0xFFEF4444);
  static const Color underweightBMI = Color(0xFF3B82F6);

  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);

  // Additional Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryStart, primaryEnd],
  );

  static const LinearGradient normalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
  );

  static const LinearGradient overweightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
  );

  static const LinearGradient obesesGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
  );

  static const LinearGradient underweightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
  );

  static LinearGradient getGradientByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'normal':
        return normalGradient;
      case 'overweight':
        return overweightGradient;
      case 'obese':
        return obesesGradient;
      case 'underweight':
        return underweightGradient;
      default:
        return primaryGradient;
    }
  }

  static Color getColorByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'normal':
        return normalBMI;
      case 'overweight':
        return overweightBMI;
      case 'obese':
        return obeseBMI;
      case 'underweight':
        return underweightBMI;
      default:
        return textSecondary;
    }
  }
}
