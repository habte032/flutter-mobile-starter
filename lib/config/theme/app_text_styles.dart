import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Light Theme Text Styles
  static TextStyle headline1 = GoogleFonts.heebo(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    letterSpacing: -1.5,
  );

  static TextStyle headline2 = GoogleFonts.heebo(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    letterSpacing: -0.5,
  );

  static TextStyle headline3 = GoogleFonts.heebo(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
  static TextStyle headline3_1 = GoogleFonts.heebo(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: 24 * 0.05,
  );

  static TextStyle headline4 = GoogleFonts.heebo(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 0,
    height: 1,
  );

  static TextStyle headline5 = GoogleFonts.heebo(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    letterSpacing: 0,
  );

  static TextStyle headline6 = GoogleFonts.heebo(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
    letterSpacing: 0.15,
  );

  static TextStyle bodyText1 = GoogleFonts.heebo(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
    height: 1.5,
  );
  static TextStyle bodyText1Black = GoogleFonts.heebo(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.5,
  );
  static TextStyle bodyText2 = GoogleFonts.heebo(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.text,
  );

  static TextStyle bodyText2Black = GoogleFonts.heebo(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static TextStyle bodyText3 = GoogleFonts.heebo(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    letterSpacing: 0.15,
    height: 1.6,
  );

  static TextStyle bodyText3Black = GoogleFonts.heebo(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    letterSpacing: 0.15,
    height: 1.6,
  );

  static TextStyle bodyText3Faded = GoogleFonts.heebo(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.fadedGrey,
    letterSpacing: 0.15,
    height: 1.6,
  );

  static TextStyle bodyText4 = GoogleFonts.heebo(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.labelText,
    letterSpacing: 0.15,
    height: 1.6,
  );

  static TextStyle button = GoogleFonts.heebo(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0,
  );

  static TextStyle caption = GoogleFonts.heebo(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.primary,
    letterSpacing: 0,
  );

  static TextStyle labelText = GoogleFonts.heebo(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.labelText,
    letterSpacing: 0,
    height: 1.125,
  );

  static TextStyle leadingText = GoogleFonts.heebo(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
    letterSpacing: 0,
    height: 1.125,
  );

  static TextStyle subheadingText = GoogleFonts.heebo(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    letterSpacing: 0,
  );

  static TextStyle hintText = GoogleFonts.heebo(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.subtext,
    letterSpacing: 0,
  );

  static TextStyle errorText = GoogleFonts.heebo(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
    letterSpacing: 0,
  );

  static TextStyle buttonText = GoogleFonts.heebo(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: 0,
    height: 1.4,
  );

  static TextStyle buttonText2 = GoogleFonts.heebo(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 0,
    height: 1.4,
  );

  // Dark Theme Text Styles
  static TextStyle headline1Dark = GoogleFonts.heebo(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
    letterSpacing: -1.5,
  );

  static TextStyle headline2Dark = GoogleFonts.heebo(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
    letterSpacing: -0.5,
  );

  static TextStyle headline3Dark = GoogleFonts.heebo(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
    letterSpacing: 0,
  );

  static TextStyle headline4Dark = GoogleFonts.heebo(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
    letterSpacing: 0.25,
  );

  static TextStyle headline5Dark = GoogleFonts.heebo(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
    letterSpacing: 0,
  );

  static TextStyle headline6Dark = GoogleFonts.heebo(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
    letterSpacing: 0.15,
  );

  static TextStyle bodyText1Dark = GoogleFonts.heebo(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColors.darkText,
    letterSpacing: 0.5,
  );

  static TextStyle bodyText2Dark = GoogleFonts.heebo(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.darkText,
    letterSpacing: 0.25,
  );

  static TextStyle buttonDark = GoogleFonts.heebo(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 1.25,
  );

  static TextStyle captionDark = GoogleFonts.heebo(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.darkSubtext,
    letterSpacing: 0.4,
  );
}
