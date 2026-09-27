import 'package:flutter/material.dart';

/// Palet warna minimalis elegan dengan sentuhan cyberpunk/futuristik
class AppColors {
  // Backgrounds
  static const Color bgDark = Color(0xFF090D16);
  static const Color bgSurface = Color(0xFF0F172A);
  static const Color bgCard = Color(0xFF1E293B);
  static const Color bgCardHover = Color(0xFF273549);

  // Accents
  static const Color primary = Color(0xFF6366F1); // Indigo neon
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color secondary = Color(0xFF06B6D4); // Cyan glow
  static const Color secondaryLight = Color(0xFF22D3EE);
  static const Color accent = Color(0xFF10B981); // Emerald pulse
  static const Color accentRose = Color(0xFFF43F5E); // Neon Rose
  static const Color accentAmber = Color(0xFFF59E0B); // Amber warning

  // Text
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Glassmorphism borders & fills
  static const Color glassFill = Color(0x1A1E293B);
  static const Color glassBorder = Color(0x26FFFFFF);
  static const Color glassBorderHover = Color(0x4D6366F1);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGlowGradient = LinearGradient(
    colors: [Color(0x336366F1), Color(0x1A06B6D4), Colors.transparent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient avatarBorderGradient = LinearGradient(
    colors: [primary, secondary, accent, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
