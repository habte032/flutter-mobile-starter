import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system providing predefined text styles for the entire application.
///
/// Defines a complete typography scale including headings, body text, and labels
/// with consistent font families and sizing. All text styles use the Poppins font
/// family from Google Fonts and maintain proper line heights for readability.
///
/// Example usage:
/// ```dart
/// Text(
///   'Welcome',
///   style: AppTypography.title1,
/// )
/// ```
abstract class AppTypography {
  // Headings
  /// Title1 - Main title style
  static TextStyle title1 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 28 / 24, // line-height: 28px
  );

  /// Heading 1 - Largest heading style for page titles
  static TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
  );

  /// Subtitle - Subtitle style with specific color
  static TextStyle subtitle = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 32 / 20, // line-height: 32px
    color: const Color(0xFF212121), // MRP Text Black
  );

  /// Heading 2 - Secondary heading style for section titles
  static TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.3,
    height: 1.3,
  );

  /// Heading 3 - Tertiary heading style for subsection titles
  static TextStyle heading3 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Body Text
  /// Body Large - Large body text for emphasis
  static TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  /// Body Medium - Standard body text for main content
  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  /// Body Small - Small body text for secondary content
  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  // Labels
  /// Label Large - Large label text for prominent labels
  static TextStyle labelLarge = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  /// Label Medium - Medium label text for standard labels
  static TextStyle labelMedium = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  /// Label Small - Small label text for compact labels
  static TextStyle labelSmall = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
}
