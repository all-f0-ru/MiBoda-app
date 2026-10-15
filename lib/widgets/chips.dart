import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/colors.dart';
import '../theme/text.dart';
import '../theme/tokens.dart';

/// Chip de filtro seleccionable (categoría, comuna, grupo...).
class SelectChip extends StatelessWidget {
  const SelectChip({super.key, required this.label, required this.selected, required this.onTap, this.icon, this.outlined = false});

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  /// Borde dorado (para el botón "Filtros").
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? AppColors.ink : AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.ink : (outlined ? AppColors.brass : AppColors.borderDefault),
            width: outlined ? 1.5 : 1,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16, color: selected ? AppColors.textOnInk : AppColors.textPrimary),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    label,
                    style: AppText.labelS.copyWith(
                      fontSize: 13,
                      color: selected ? AppColors.textOnInk : AppColors.textPrimary,
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

/// Fila de chips con scroll horizontal hasta el borde de la pantalla.
class ChipScroller extends StatelessWidget {
  const ChipScroller({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: Space.sm),
            children[i],
          ],
        ],
      ),
    );
  }
}

(Color, Color) toneColors(StatusTone tone) => switch (tone) {
      StatusTone.success => (AppColors.successBg, AppColors.success),
      StatusTone.warning => (AppColors.warningBg, AppColors.warning),
      StatusTone.error => (AppColors.errorBg, AppColors.error),
      StatusTone.info => (AppColors.infoBg, AppColors.info),
      StatusTone.neutral => (AppColors.backgroundSecondary, AppColors.textSecondary),
    };

/// Chip de estado (Confirmado, Pendiente, Contratado...).
class StatusChip extends StatelessWidget {
  const StatusChip(this.label, {super.key, required this.tone});

  final String label;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = toneColors(tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(Radii.chip)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: fg, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(label, style: AppText.labelS.copyWith(color: fg)),
        ],
      ),
    );
  }
}

/// Chip RSVP a partir del estado del invitado.
StatusChip rsvpChip(Rsvp rsvp) => switch (rsvp) {
      Rsvp.confirmed => const StatusChip('Confirmado', tone: StatusTone.success),
      Rsvp.pending => const StatusChip('Pendiente', tone: StatusTone.warning),
      Rsvp.declined => const StatusChip('No asiste', tone: StatusTone.error),
      Rsvp.notSent => const StatusChip('Sin enviar', tone: StatusTone.neutral),
    };
