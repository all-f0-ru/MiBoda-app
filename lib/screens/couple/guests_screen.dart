import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../navigation/shells.dart';
import '../../routes.dart';
import '../../state/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/items.dart';
import '../../widgets/layout.dart';

/// Invitados con dos vistas: Lista y Mesas.
class GuestsScreen extends StatefulWidget {
  const GuestsScreen({super.key});

  @override
  State<GuestsScreen> createState() => _GuestsScreenState();
}

class _GuestsScreenState extends State<GuestsScreen> {
  bool _tables = false;
  String _group = 'Todos';

  @override
  Widget build(BuildContext context) {
    return ScreenList(
      gap: 14,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Invitados', style: AppText.display),
                  Text('86 invitados · 12 acompañantes', style: AppText.muted(AppText.bodyS)),
                ],
              ),
            ),
            CircleIconButton(
              icon: Icons.add,
              tooltip: 'Agregar invitado',
              background: AppColors.ink,
              foreground: AppColors.textOnInk,
              onPressed: () => showAppSheet(context, const AddGuestSheet()),
            ),
          ],
        ),
        _Segmented(tables: _tables, onChanged: (v) => setState(() => _tables = v)),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _tables ? const _TablesView(key: ValueKey('mesas')) : _listView(context),
        ),
      ],
    );
  }

  Widget _listView(BuildContext context) {
    final guests = Mock.guests.where((g) => _group == 'Todos' || g.group == _group).toList();
    return Column(
      key: const ValueKey('lista'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (final (n, label, tone) in const [
              ('52', 'Confirmados', (AppColors.successBg, AppColors.success)),
              ('21', 'Pendientes', (AppColors.warningBg, AppColors.warning)),
              ('6', 'No asisten', (AppColors.errorBg, AppColors.error)),
              ('7', 'Sin enviar', (AppColors.backgroundSecondary, AppColors.textSecondary)),
            ]) ...[
              if (label != 'Confirmados') const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 6, 10),
                  decoration: BoxDecoration(color: tone.$1, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n, style: AppText.headingL.copyWith(fontSize: 22, color: tone.$2)),
                      Text(label, style: AppText.labelXS.copyWith(letterSpacing: 0, color: tone.$2)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 14),
        AppCard(
          border: Border.all(color: AppColors.brass),
          padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
          child: Row(
            children: [
              const Icon(Icons.send_outlined, size: 20, color: AppColors.brassDeep),
              const SizedBox(width: 12),
              Expanded(child: Text('7 invitados aún no reciben su invitación', style: AppText.bodyS)),
              AppButton(label: 'Enviar', expand: false, compact: true, onPressed: () => goTo(context, Routes.sendInvites)),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ChipScroller(children: [
          for (final g in Mock.guestGroups) SelectChip(label: g, selected: g == _group, onTap: () => setState(() => _group = g)),
        ]),
        const SizedBox(height: 14),
        if (guests.isEmpty)
          const EmptyState(title: 'Nadie en este grupo', text: 'Agrega invitados con el botón + o importa tus contactos.')
        else
          MenuGroup(children: [
            for (final g in guests) GuestTile(guest: g, onTap: () => showAppSheet(context, const AddGuestSheet())),
          ]),
      ],
    );
  }
}

class _Segmented extends StatelessWidget {
  const _Segmented({required this.tables, required this.onChanged});

  final bool tables;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget seg(String label, bool value) {
      final on = tables == value;
      return Expanded(
        child: Semantics(
          button: true,
          selected: on,
          child: GestureDetector(
            onTap: () => onChanged(value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: on ? AppColors.surfaceWhite : Colors.transparent,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(label, style: AppText.labelS.copyWith(fontSize: 13, color: on ? AppColors.textPrimary : AppColors.textSecondary)),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: AppColors.backgroundSecondary, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [seg('Lista', false), const SizedBox(width: 4), seg('Mesas', true)]),
    );
  }
}

/// Plano de mesas: toca un invitado y luego una mesa para asignarlo.
class _TablesView extends StatelessWidget {
  const _TablesView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final pending = Mock.unseatedGuests.where((g) => !state.isSeated(g.id)).toList();
    final pendingSeats = pending.fold<int>(0, (a, g) => a + g.seats) + 9;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          state.selectedGuest == null ? 'Toca un invitado y luego una mesa para asignarlo.' : 'Ahora toca una mesa.',
          style: AppText.muted(AppText.bodyS),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(color: AppColors.backgroundSecondary, borderRadius: BorderRadius.circular(20)),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            runSpacing: 14,
            spacing: 8,
            children: [
              for (var i = 0; i < Mock.tables.length; i++) _TableWidget(index: i),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 14,
          children: [
            Text('○ Con espacio', style: AppText.muted(AppText.bodyS)),
            Text('● Llena', style: AppText.bodyS.copyWith(color: AppColors.warning)),
            Text('● Excedida', style: AppText.bodyS.copyWith(color: AppColors.error)),
          ],
        ),
        const SizedBox(height: 16),
        Text('Sin asignar · $pendingSeats', style: AppText.headingM),
        const SizedBox(height: 4),
        Text('${state.seatedCount} personas ya tienen mesa', style: AppText.muted(AppText.bodyS)),
        const SizedBox(height: 10),
        ChipWrap(children: [
          for (final g in pending)
            Semantics(
              button: true,
              selected: state.selectedGuest == g.id,
              child: GestureDetector(
                onTap: () => state.selectGuest(g.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.fromLTRB(6, 6, 12, 6),
                  decoration: BoxDecoration(
                    color: state.selectedGuest == g.id ? AppColors.ink : AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: state.selectedGuest == g.id ? AppColors.ink : AppColors.borderDefault),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Initials(g.initials, size: 24),
                      const SizedBox(width: 6),
                      Text(
                        g.name,
                        style: AppText.labelS.copyWith(
                          fontSize: 13,
                          color: state.selectedGuest == g.id ? AppColors.textOnInk : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ]),
      ],
    );
  }
}

class _TableWidget extends StatelessWidget {
  const _TableWidget({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final table = Mock.tables[index];
    final occ = state.occupiedAt(index);
    final full = occ == table.capacity;
    final over = occ > table.capacity;
    final bg = over ? AppColors.errorBg : (full ? AppColors.warningBg : AppColors.surfaceWhite);
    final fg = over ? AppColors.error : (full ? AppColors.warning : AppColors.textSecondary);

    return Semantics(
      button: true,
      label: '${table.name}, $occ de ${table.capacity}',
      child: GestureDetector(
        onTap: () {
          if (state.selectedGuest == null) {
            showToast(context, 'Primero elige un invitado de “Sin asignar”.');
            return;
          }
          state.seatSelectedAt(index);
        },
        child: SizedBox.square(
          dimension: 96,
          child: Stack(
            children: [
              for (var k = 0; k < table.capacity; k++)
                Positioned(
                  left: 48 + 42 * math.cos(k / table.capacity * 2 * math.pi - math.pi / 2) - 6,
                  top: 48 + 42 * math.sin(k / table.capacity * 2 * math.pi - math.pi / 2) - 6,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: k < occ ? AppColors.brass : AppColors.surfaceWhite,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.brass),
                    ),
                  ),
                ),
              Positioned(
                left: 18,
                top: 18,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(table.name, style: AppText.labelXS.copyWith(letterSpacing: 0, color: AppColors.textPrimary)),
                      Text('$occ/${table.capacity}', style: AppText.labelS.copyWith(color: fg)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet para agregar (o editar) un invitado.
class AddGuestSheet extends StatefulWidget {
  const AddGuestSheet({super.key});

  @override
  State<AddGuestSheet> createState() => _AddGuestSheetState();
}

class _AddGuestSheetState extends State<AddGuestSheet> {
  String _group = 'Amigos';
  final Set<String> _companions = {'+1'};
  String _diet = 'Celíaco';

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Agregar invitado',
      children: [
        AppButton.secondary(
          label: 'Importar desde contactos',
          icon: Icons.contacts_outlined,
          onPressed: () {
            Navigator.pop(context);
            showToast(context, 'Pronto: importar desde tus contactos');
          },
        ),
        const Row(
          children: [
            Expanded(child: LabeledField(label: 'Nombre', initialValue: 'Tomás Lagos')),
            SizedBox(width: Space.md),
            Expanded(child: LabeledField(label: 'Teléfono', initialValue: '+56 9 7781 0932', keyboardType: TextInputType.phone)),
          ],
        ),
        const FieldLabel('Grupo'),
        ChipWrap(children: [
          for (final g in const ['Familia novia', 'Familia novio', 'Amigos', 'Trabajo'])
            SelectChip(label: g, selected: g == _group, onTap: () => setState(() => _group = g)),
        ]),
        const FieldLabel('Acompañantes'),
        ChipWrap(children: [
          for (final c in const ['+1', 'Con niños'])
            SelectChip(
              label: c,
              selected: _companions.contains(c),
              onTap: () => setState(() => _companions.contains(c) ? _companions.remove(c) : _companions.add(c)),
            ),
        ]),
        const FieldLabel('Restricción alimentaria'),
        ChipWrap(children: [
          for (final d in const ['Ninguna', 'Vegetariano', 'Vegano', 'Celíaco', 'Alergias'])
            SelectChip(label: d, selected: d == _diet, onTap: () => setState(() => _diet = d)),
        ]),
        AppButton(
          label: 'Guardar invitado',
          onPressed: () {
            Navigator.pop(context);
            showToast(context, 'Invitado guardado');
          },
        ),
      ],
    );
  }
}
