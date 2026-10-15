import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../navigation/shells.dart';
import '../../routes.dart';
import '../../state/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../widgets/buttons.dart';
import '../../widgets/layout.dart';

/// Calendario editable: toca un día para cambiar su estado.
class VendorCalendarScreen extends StatelessWidget {
  const VendorCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return ScreenList(
      gap: 14,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calendario', style: AppText.display),
            Text('Toca un día para cambiar su estado.', style: AppText.muted(AppText.bodyS)),
          ],
        ),
        const Wrap(
          spacing: 14,
          children: [
            _Legend('Disponible', AppColors.surfaceWhite),
            _Legend('Reservado', AppColors.ink),
            _Legend('Bloqueado', AppColors.surfaceBlush),
          ],
        ),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          child: Column(
            children: [
              Text('Marzo 2027', style: AppText.headingM),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (final d in const ['L', 'M', 'M', 'J', 'V', 'S', 'D'])
                    Expanded(child: Center(child: Text(d, style: AppText.muted(AppText.labelXS)))),
                ],
              ),
              const SizedBox(height: 6),
              for (var week = 0; week < 5; week++)
                Row(
                  children: [
                    for (var dow = 0; dow < 7; dow++)
                      Expanded(child: _DayCell(day: week * 7 + dow + 1, status: state.dayStatus(week * 7 + dow + 1))),
                  ],
                ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              const Icon(Icons.schedule, size: 18, color: AppColors.info),
              const SizedBox(width: 10),
              Expanded(child: Text('13 mar: cotización enviada a María y Juan', style: AppText.bodyS.copyWith(color: AppColors.info))),
            ],
          ),
        ),
        const SectionHeader('Reservas de marzo'),
        for (final (day, couple, detail) in const [
          ('Sáb 6', 'Fernanda y Tomás', 'Viña del Mar · Foto + video'),
          ('Sáb 20', 'Pía y Andrés', 'Colina · Esencial'),
          ('Sáb 27', 'Daniela y Pablo', 'Pirque · Cobertura completa'),
        ])
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            onTap: () => goTo(context, Routes.vendorMessagesTab),
            child: Row(
              children: [
                SizedBox(width: 56, child: Text(day, style: AppText.labelM.copyWith(color: AppColors.brassText))),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(couple, style: AppText.labelM), Text(detail, style: AppText.muted(AppText.bodyS))],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend(this.label, this.color);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4), border: Border.all(color: AppColors.borderDefault)),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppText.muted(AppText.bodyS).copyWith(fontSize: 12)),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.status});

  final int day;
  final DayStatus status;

  @override
  Widget build(BuildContext context) {
    if (day > 31) return const SizedBox(height: 46);
    final (bg, fg) = switch (status) {
      DayStatus.booked => (AppColors.ink, AppColors.textOnInk),
      DayStatus.blocked => (AppColors.surfaceBlush, AppColors.textPrimary),
      DayStatus.available => (AppColors.surfaceWhite, AppColors.textPrimary),
    };
    final label = switch (status) {
      DayStatus.booked => 'reservado',
      DayStatus.blocked => 'bloqueado',
      DayStatus.available => 'disponible',
    };

    return Semantics(
      button: true,
      label: '$day de marzo, $label',
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: Material(
          color: bg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: day == 13 && status == DayStatus.available
                ? const BorderSide(color: AppColors.brass, width: 1.5)
                : BorderSide.none,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => showAppSheet(context, _DaySheet(day: day)),
            child: SizedBox(
              height: 44,
              child: Center(child: Text('$day', style: AppText.labelS.copyWith(fontSize: 13, color: fg))),
            ),
          ),
        ),
      ),
    );
  }
}

class _DaySheet extends StatelessWidget {
  const _DaySheet({required this.day});

  final int day;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final current = state.dayStatus(day);

    Widget option(DayStatus s, String title, String text) {
      final on = s == current;
      return InkWell(
        onTap: () {
          state.setDayStatus(day, s);
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(on ? Icons.radio_button_checked : Icons.radio_button_off, color: on ? AppColors.ink : AppColors.brassDeep),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(title, style: AppText.labelM), Text(text, style: AppText.muted(AppText.bodyS))],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SheetScaffold(
      title: '$day de marzo de 2027',
      children: [
        Material(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              option(DayStatus.available, 'Disponible', 'Las parejas pueden pedirte cotización'),
              const Divider(height: 1),
              option(DayStatus.booked, 'Reservado', 'Ya tienes una boda confirmada'),
              const Divider(height: 1),
              option(DayStatus.blocked, 'Bloqueado', 'No trabajas ese día'),
            ],
          ),
        ),
        AppButton.ghost(label: 'Cancelar', onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}
