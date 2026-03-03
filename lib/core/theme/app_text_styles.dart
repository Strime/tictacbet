import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Material 3 typography with casino-friendly font.
class AppTextStyles {
  AppTextStyles._();

  static TextTheme get textTheme => TextTheme(
    displayLarge: GoogleFonts.dmSerifDisplay(
      fontSize: 32,
      fontWeight: FontWeight.normal,
    ),
    displayMedium: GoogleFonts.dmSerifDisplay(
      fontSize: 28,
      fontWeight: FontWeight.normal,
    ),
    headlineLarge: GoogleFonts.plusJakartaSans(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: GoogleFonts.plusJakartaSans(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.plusJakartaSans(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.plusJakartaSans(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.plusJakartaSans(
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: GoogleFonts.plusJakartaSans(
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    labelLarge: GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );
}
