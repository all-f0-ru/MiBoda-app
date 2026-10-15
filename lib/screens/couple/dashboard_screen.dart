import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../navigation/shells.dart';
import '../../routes.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../theme/tokens.dart';
import '../../widgets/brand.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/items.dart';
import '../../widgets/layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nextTasks = Mock.taskGroups.expand((g) => g.tasks).where((t) => ['r2', 'r3', 'r5'].contains(t.id)).toList();

    return ScreenList(
      gap: 20,
      children: [
        // Encabezado
        Row(
          children: [
            const MiBodaSymbol(size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hola ${Mock.coupleNames}', style: AppText.headingL),
                  Text('${Mock.weddingDate} · ${Mock.weddingPlace}', style: AppText.muted(AppText.bodyS)),
                ],
              ),
            ),
            CircleIconButton(
              icon: Icons.notifications_none,
              tooltip: 'Notificaciones, 2 nuevas',
              badge: true,
              onPressed: () => goTo(context, Routes.notifications),
            ),
          ],
        ),

        // Cuenta regresiva
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OverlineLabel('FALTAN', color: AppColors.surfaceBlush),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('${_daysLeft()}', style: AppText.displayNumber.copyWith(color: AppColors.textOnInk)),
                        const SizedBox(width: 8),
                        Text('días', style: AppText.headingM.copyWith(color: AppColors.textOnInk)),
                      ],
                    ),
                    Text('para el gran día · 64% del plan listo', style: AppText.bodyS.copyWith(color: AppColors.surfaceBlush)),
                  ],
                ),
              ),
              const MiBodaSymbol(size: 64),
            ],
          ),
        ),

        // Accesos rápidos
        Row(
          children: [
            for (final (icon, label, route) in const [
              (Icons.storefront_outlined, 'Proveedores', Routes.marketplaceTab),
              (Icons.people_outline, 'Invitados', Routes.guestsTab),
              (Icons.check_box_outlined, 'Checklist', Routes.checklistTab),
              (Icons.chat_bubble_outline, 'Mensajes', Routes.messages),
            ]) ...[
              if (label != 'Proveedores') const SizedBox(width: 10),
              Expanded(
                child: AppCard(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  onTap: () => goTo(context, route),
                  child: Column(
                    children: [
                      Icon(icon, color: AppColors.brassDeep),
                      const SizedBox(height: 6),
                      Text(label, style: AppText.labelXS.copyWith(letterSpacing: 0, color: AppColors.textPrimary)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),

        // Presupuesto
        AppCard(
          onTap: () => goTo(context, Routes.budget),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeader('Presupuesto', action: 'Ver detalle', onAction: () => goTo(context, Routes.budget)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(r'$7.700.000', style: AppText.headingL),
                  const SizedBox(width: 6),
                  Text('de ${Mock.budgetTotal}', style: AppText.muted(AppText.bodyS)),
                ],
              ),
              const SizedBox(height: 10),
              const AppProgress(value: 0.43),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: Text('43% comprometido', style: AppText.muted(AppText.bodyS))),
                  Text(r'$10.300.000 disponible', style: AppText.labelS.copyWith(fontSize: 13)),
                ],
              ),
            ],
          ),
        ),

        // Proveedores
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeader('Tus proveedores', action: 'Buscar más', onAction: () => goTo(context, Routes.marketplaceTab)),
              const SizedBox(height: 4),
              for (final (name, tone, label) in const [
                ('Centro de eventos · Casona El Roble', StatusTone.success, 'Contratado'),
                ('Vestido · Atelier Noa', StatusTone.success, 'Contratado'),
                ('Fotografía · 2 cotizaciones', StatusTone.warning, 'Cotizando'),
                ('Banquetería', StatusTone.neutral, 'Falta'),
              ])
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Expanded(child: Text(name, style: AppText.bodyS)),
                      StatusChip(label, tone: tone),
                    ],
                  ),
                ),
            ],
          ),
        ),

        // Próximas tareas
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader('Próximas tareas', action: 'Ver todas', onAction: () => goTo(context, Routes.checklistTab)),
            for (final t in nextTasks) Padding(padding: const EdgeInsets.only(top: Space.sm), child: TaskTile(task: t)),
          ],
        ),

        // Invitados
        AppCard(
          onTap: () => goTo(context, Routes.guestsTab),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeader('Invitados', action: 'Gestionar', onAction: () => goTo(context, Routes.guestsTab)),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const SizedBox(
                  height: 8,
                  child: Row(
                    children: [
                      Expanded(flex: 52, child: ColoredBox(color: AppColors.success)),
                      SizedBox(width: 3),
                      Expanded(flex: 21, child: ColoredBox(color: AppColors.brass)),
                      SizedBox(width: 3),
                      Expanded(flex: 6, child: ColoredBox(color: AppColors.error)),
                      SizedBox(width: 3),
                      Expanded(flex: 7, child: ColoredBox(color: AppColors.borderDefault)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 14,
                children: [
                  for (final t in const ['52 confirmados', '21 pendientes', '6 no asisten']) Text(t, style: AppText.muted(AppText.bodyS)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Días que faltan para el 13 de marzo de 2027.
  static int _daysLeft() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff = DateTime(2027, 3, 13).difference(today).inDays;
    return diff < 0 ? 0 : diff;
  }
}
