import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1D4ED8);
  static const Color primaryDark = Color(0xFF1E3A8A);
  static const Color primaryLight = Color(0xFFEFF6FF);
  static const Color secondary = Color(0xFF0284C7);
  static const Color headerGradientStart = Color(0xFF0F172A);
  static const Color headerGradientEnd = Color(0xFF1D4ED8);

  static const Color background = Color(0xFFF3F4F6);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textOnPrimary = Colors.white;
  static const Color border = Color(0xFFE5E7EB);
  static const Color inputBackground = Color(0xFFF8FAFC);

  static const Color pending = Color(0xFFF59E0B);
  static const Color pendingBg = Color(0xFFFEF3C7);
  static const Color inProgress = Color(0xFF2563EB);
  static const Color inProgressBg = Color(0xFFDBEAFE);
  static const Color completed = Color(0xFF10B981);
  static const Color completedBg = Color(0xFFD1FAE5);

  static const Color priorityLow = Color(0xFF10B981);
  static const Color priorityLowBg = Color(0xFFD1FAE5);
  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityMediumBg = Color(0xFFFEF3C7);
  static const Color priorityHigh = Color(0xFFEF4444);
  static const Color priorityHighBg = Color(0xFFFEE2E2);

  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, 6),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: const Color(0xFF1D4ED8).withValues(alpha: 0.03),
          blurRadius: 6,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ];
}
