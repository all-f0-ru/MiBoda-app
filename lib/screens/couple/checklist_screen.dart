import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../state/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/items.dart';
import '../../widgets/layout.dart';

enum _Filter { pending, done, all }

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  _Filter _filter = _Filter.all;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final pct = state.tasksDone / state.tasksTotal;

    bool visible(String id) => switch (_filter) {
          _Filter.pending => !state.isDone(id),
          _Filter.done => state.isDone(id),
          _Filter.all => true,
        };

    return ScreenList(
      gap: 12,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Checklist', style: AppText.display),
                  Text('${state.tasksDone} de ${state.tasksTotal} tareas · ${(pct * 100).round()}%', style: AppText.muted(AppText.bodyS)),
                ],
              ),
            ),
            CircleIconButton(
              icon: Icons.add,
              tooltip: 'Agregar tarea',
              background: AppColors.ink,
              foreground: AppColors.textOnInk,
              onPressed: () => showAppSheet(context, const AddTaskSheet()),
            ),
          ],
        ),
        AppProgress(value: pct),
        ChipScroller(children: [
          SelectChip(label: 'Todas', selected: _filter == _Filter.all, onTap: () => setState(() => _filter = _Filter.all)),
          SelectChip(label: 'Pendientes', selected: _filter == _Filter.pending, onTap: () => setState(() => _filter = _Filter.pending)),
          SelectChip(label: 'Completadas', selected: _filter == _Filter.done, onTap: () => setState(() => _filter = _Filter.done)),
        ]),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: AppColors.successBg, borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              const Icon(Icons.check, size: 18, color: AppColors.success),
              const SizedBox(width: 10),
              Text('12 meses o más · 8 de 8 completadas', style: AppText.labelS.copyWith(fontSize: 13, color: AppColors.success)),
            ],
          ),
        ),
        if (state.customTasks.isNotEmpty) ...[
          const Padding(padding: EdgeInsets.only(top: 6), child: OverlineLabel('AGREGADAS POR USTEDES')),
          for (final t in state.customTasks.where((t) => visible(t.id))) TaskTile(task: t),
        ],
        for (final g in Mock.taskGroups) ...[
          Padding(padding: const EdgeInsets.only(top: 6), child: OverlineLabel(g.label)),
          for (final t in g.tasks.where((t) => visible(t.id))) TaskTile(task: t),
        ],
      ],
    );
  }
}

/// Bottom sheet para agregar una tarea personalizada.
class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _title = TextEditingController(text: 'Degustación de tortas');
  String _category = 'Proveedores';
  String _assignee = 'Ambos';
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  void _save() {
    if (_title.text.trim().isEmpty) {
      setState(() => _error = 'Escribe un título para la tarea.');
      return;
    }
    AppScope.of(context).addTask(_title.text.trim(), 'Vence 20 nov · $_assignee');
    Navigator.pop(context);
    showToast(context, 'Tarea agregada al checklist');
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Nueva tarea',
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FieldLabel('Título'),
            const SizedBox(height: 6),
            TextField(
              controller: _title,
              style: AppText.bodyM,
              onChanged: (_) => setState(() => _error = null),
              decoration: InputDecoration(errorText: _error),
            ),
          ],
        ),
        const LabeledField(label: 'Fecha límite', initialValue: '20 nov 2026'),
        const FieldLabel('Categoría'),
        ChipWrap(children: [
          for (final c in const ['Proveedores', 'Invitados', 'Trámites', 'Look', 'Otro'])
            SelectChip(label: c, selected: c == _category, onTap: () => setState(() => _category = c)),
        ]),
        const FieldLabel('Asignar a'),
        ChipWrap(children: [
          for (final c in const ['María', 'Juan', 'Ambos'])
            SelectChip(label: c, selected: c == _assignee, onTap: () => setState(() => _assignee = c)),
        ]),
        const SizedBox(height: Space.xs),
        AppButton(label: 'Agregar tarea', onPressed: _save),
      ],
    );
  }
}
