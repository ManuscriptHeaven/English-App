import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Child-first typography system.
/// Fredoka for headings/display (rounded, friendly).
/// Nunito for body/interactive (highly readable, open letterforms).
///
/// Age-adaptive sizes: young children get much larger text.
class AppTypography {
  // ══════════════════════════════════════════════
  // DISPLAY — Big, dramatic, world-level headings
  // ══════════════════════════════════════════════

  /// Hero word — the focal vocabulary word, huge and bold
  static TextStyle get heroWord => GoogleFonts.fredoka(
        fontSize: 52,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
        height: 1.0,
      );

  /// Scene title — world name, section header
  static TextStyle get sceneTitle => GoogleFonts.fredoka(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: 0.3,
      );

  static TextStyle get displayLarge => GoogleFonts.fredoka(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get displayMedium => GoogleFonts.fredoka(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get displaySmall => GoogleFonts.fredoka(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  // ══════════════════════════════════════════════
  // INSTRUCTION — What Pip says, what child should do
  // ══════════════════════════════════════════════

  /// Clear instruction — large, readable Nunito
  static TextStyle get instruction => GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get headlineLarge => GoogleFonts.fredoka(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineMedium => GoogleFonts.fredoka(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  // ══════════════════════════════════════════════
  // SENTENCE / STORY text
  // ══════════════════════════════════════════════

  /// Sentence in picture book or vocabulary screen
  static TextStyle get sentenceText => GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get titleLarge => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  // ══════════════════════════════════════════════
  // BODY
  // ══════════════════════════════════════════════

  static TextStyle get bodyLarge => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get bodyMedium => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get bodySmall => GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.3,
      );

  // ══════════════════════════════════════════════
  // LABELS & BUTTONS
  // ══════════════════════════════════════════════

  static TextStyle get labelLarge => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  /// Button text — large Fredoka, always white
  static TextStyle get buttonText => GoogleFonts.fredoka(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
        letterSpacing: 0.5,
      );

  /// Small button / secondary action
  static TextStyle get buttonTextSm => GoogleFonts.fredoka(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
        letterSpacing: 0.3,
      );

  static TextStyle get badgeText => GoogleFonts.fredoka(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  // ══════════════════════════════════════════════
  // PHONETIC / DETAIL (older ages only)
  // ══════════════════════════════════════════════

  static TextStyle get phoneticText => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        fontStyle: FontStyle.italic,
        height: 1.2,
      );

  // ══════════════════════════════════════════════
  // AGE-ADAPTIVE HELPERS
  // ══════════════════════════════════════════════

  /// Returns appropriate vocabulary word size based on child age
  static TextStyle wordForAge(int age) {
    if (age <= 4) return heroWord.copyWith(fontSize: 56);
    if (age <= 6) return heroWord.copyWith(fontSize: 48);
    if (age <= 8) return heroWord.copyWith(fontSize: 40);
    return heroWord.copyWith(fontSize: 36);
  }

  /// Returns appropriate instruction size based on child age
  static TextStyle instructionForAge(int age) {
    if (age <= 4) return instruction.copyWith(fontSize: 24);
    if (age <= 6) return instruction.copyWith(fontSize: 22);
    if (age <= 8) return instruction.copyWith(fontSize: 20);
    return instruction.copyWith(fontSize: 18);
  }

  /// Button label size based on age
  static TextStyle buttonForAge(int age) {
    if (age <= 4) return buttonText.copyWith(fontSize: 22);
    if (age <= 6) return buttonText.copyWith(fontSize: 20);
    return buttonText.copyWith(fontSize: 18);
  }
}
