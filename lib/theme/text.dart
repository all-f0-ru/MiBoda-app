import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

/// Estilos de texto: Fraunces para títulos, Work Sans para el resto.
class AppText {
  AppText._();

  static TextStyle _serif(double size, double lineHeight) => GoogleFonts.fraunces(
        fontSize: size,
        height: lineHeight / size,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle _sans(double size, double lineHeight, FontWeight weight) => GoogleFonts.workSans(
        fontSize: size,
        height: lineHeight / size,
        fontWeight: weight,
        color: AppColors.textPrimary,
      );

  static final displayNumber = _serif(44, 48);
  static final display = _serif(32, 38);
  static final headingL = _serif(24, 30);
  static final headingM = _serif(18, 24);

  static final bodyM = _sans(15, 22, FontWeight.w400);
  static final bodyS = _sans(13, 18, FontWeight.w400);
  static final labelM = _sans(15, 20, FontWeight.w500);
  static final labelS = _sans(12, 16, FontWeight.w500);
  static final labelXS = _sans(11, 14, FontWeight.w600).copyWith(letterSpacing: 0.66);

  /// Atajo para texto secundario.
  static TextStyle muted(TextStyle base) => base.copyWith(color: AppColors.textSecondary);
}
