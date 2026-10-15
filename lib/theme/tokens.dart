/// Espaciado (grilla de 4), radios y medidas comunes.
class Space {
  Space._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double screen = 20; // margen lateral de pantalla
}

class Radii {
  Radii._();
  static const double chip = 6;
  static const double button = 10;
  static const double card = 16;
  static const double sheet = 24;
}

/// Área táctil mínima (guía de iOS).
const double kMinTap = 44;
