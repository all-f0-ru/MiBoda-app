import 'package:flutter/material.dart';

/// Tokens de color de MiBoda+ (mismos nombres que los estilos de Figma).
class AppColors {
  AppColors._();

  // Fondos y superficies
  static const backgroundPrimary = Color(0xFFFAF5EF);
  static const backgroundSecondary = Color(0xFFF1E8DD);
  static const surfaceWhite = Color(0xFFFFFFFF);
  static const surfaceBlush = Color(0xFFE7CFC6);
  static const borderDefault = Color(0xFFE2D6C8);

  // Acentos
  static const ink = Color(0xFF3A322C);
  static const brass = Color(0xFFB08A4E); // solo decorativo: símbolo, "+", íconos, bordes
  static const brassDeep = Color(0xFF8E6E38);
  static const brassText = Color(0xFF7A5E2F); // acento para texto pequeño (cumple 4,5:1)

  // Texto
  static const textPrimary = Color(0xFF3A322C);
  static const textSecondary = Color(0xFF6B5F55);
  static const textOnInk = Color(0xFFFAF5EF);

  // Estados (texto sobre fondo)
  static const success = Color(0xFF4F6B4A);
  static const successBg = Color(0xFFE3EADF);
  static const warning = Color(0xFF8A5F1A);
  static const warningBg = Color(0xFFF4E6CC);
  static const error = Color(0xFF9A4532);
  static const errorBg = Color(0xFFF3DCD5);
  static const info = Color(0xFF4A5F73);
  static const infoBg = Color(0xFFDFE6EC);

  // Colores de relleno para fotos de ejemplo
  static const photoPalette = [
    Color(0xFFE7CFC6),
    Color(0xFFDCCCB3),
    Color(0xFFD1D9C9),
    Color(0xFFEDDBCC),
    Color(0xFFF1E8DD),
    Color(0xFFE2D6C8),
  ];
}
