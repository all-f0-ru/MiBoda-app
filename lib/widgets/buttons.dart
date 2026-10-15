import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/text.dart';
import '../theme/tokens.dart';

enum ButtonVariant { primary, secondary, ghost, destructive }

/// Botón de la marca. Primary: fondo tinta. Secondary: borde dorado.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.expand = true,
    this.icon,
    this.compact = false,
  });

  const AppButton.secondary({super.key, required this.label, required this.onPressed, this.expand = true, this.icon, this.compact = false})
      : variant = ButtonVariant.secondary;

  const AppButton.ghost({super.key, required this.label, required this.onPressed, this.expand = true, this.icon, this.compact = false})
      : variant = ButtonVariant.ghost;

  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool expand;
  final IconData? icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border) = switch (variant) {
      ButtonVariant.primary => (AppColors.ink, AppColors.textOnInk, null),
      ButtonVariant.secondary => (Colors.transparent, AppColors.textPrimary, const BorderSide(color: AppColors.brass, width: 1.5)),
      ButtonVariant.ghost => (Colors.transparent, AppColors.textPrimary, null),
      ButtonVariant.destructive => (AppColors.errorBg, AppColors.error, null),
    };

    final style = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return variant == ButtonVariant.primary ? AppColors.borderDefault : Colors.transparent;
        }
        if (states.contains(WidgetState.pressed)) {
          return variant == ButtonVariant.primary ? AppColors.textSecondary : AppColors.backgroundSecondary;
        }
        return bg;
      }),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled) ? AppColors.textSecondary : fg,
      ),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      side: border == null ? null : WidgetStatePropertyAll(border),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.button))),
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 20, vertical: compact ? 10 : 15)),
      minimumSize: const WidgetStatePropertyAll(Size(kMinTap, kMinTap)),
      textStyle: WidgetStatePropertyAll(AppText.labelM),
      elevation: const WidgetStatePropertyAll(0),
    );

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
        Flexible(child: Text(label, textAlign: TextAlign.center)),
      ],
    );

    final button = TextButton(onPressed: onPressed, style: style, child: child);
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Botón circular con ícono (campana, favoritos, agregar...).
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.background = AppColors.surfaceWhite,
    this.foreground = AppColors.textPrimary,
    this.size = 44,
    this.badge = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color background;
  final Color foreground;
  final double size;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: Material(
          color: background,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox.square(
              dimension: size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(icon, size: size * 0.5, color: foreground),
                  if (badge)
                    Positioned(
                      top: size * 0.22,
                      right: size * 0.24,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Enlace de texto en dorado oscuro (accesible en tamaño pequeño).
class TextLink extends StatelessWidget {
  const TextLink(this.label, {super.key, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: kMinTap),
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: 1,
            child: Text(label, style: AppText.labelS.copyWith(fontSize: 13, color: AppColors.brassText)),
          ),
        ),
      ),
    );
  }
}
