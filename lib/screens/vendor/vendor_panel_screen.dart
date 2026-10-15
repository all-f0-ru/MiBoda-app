import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../navigation/shells.dart';
import '../../routes.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';
import '../../widgets/items.dart';
import '../../widgets/layout.dart';

class VendorPanelScreen extends StatelessWidget {
  const VendorPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final newRequests = Mock.requestsByTab['Nuevas']!.take(2);

    return ScreenList(
      gap: 20,
      children: [
        Row(
          children: [
            PhotoPlaceholder(color: Mock.vendors.first.photo, width: 44, height: 44, radius: 22, showIcon: false),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hola, Luz de Campo', style: AppText.headingL.copyWith(fontSize: 22)),
                  Row(children: [
                    const Icon(Icons.verified_outlined, size: 14, color: AppColors.success),
                    const SizedBox(width: 4),
                    Text('Proveedor verificado', style: AppText.bodyS.copyWith(color: AppColors.success)),
                  ]),
                ],
              ),
            ),
            CircleIconButton(
              icon: Icons.notifications_none,
              tooltip: 'Notificaciones, 3 nuevas',
              badge: true,
              onPressed: () => goTo(context, Routes.vendorRequestsTab),
            ),
          ],
        ),
        Row(
          children: [
            for (final (n, label, delta, route) in const [
              ('12', 'Solicitudes', '+4 vs. sept', Routes.vendorRequestsTab),
              ('92%', 'Respuesta', 'menos de 3 h', Routes.vendorMessagesTab),
              ('1.240', 'Visitas', '+18%', Routes.vendorProfile),
            ]) ...[
              if (label != 'Solicitudes') const SizedBox(width: 10),
              Expanded(
                child: AppCard(
                  padding: const EdgeInsets.fromLTRB(12, 14, 8, 14),
                  onTap: () => goTo(context, route),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n, style: AppText.headingL),
                      Text(label, style: AppText.labelS),
                      Text(delta, style: AppText.bodyS.copyWith(fontSize: 12, color: AppColors.success)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader('Solicitudes nuevas · 3', action: 'Ver todas', onAction: () => goTo(context, Routes.vendorRequestsTab)),
            for (final r in newRequests)
              Padding(
                padding: const EdgeInsets.only(top: Space.sm),
                child: RequestCard(request: r, onTap: () => Navigator.pushNamed(context, Routes.requestDetail)),
              ),
          ],
        ),
        AppCard(
          onTap: () => goTo(context, Routes.vendorCalendarTab),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeader('Próximas bodas', action: 'Calendario', onAction: () => goTo(context, Routes.vendorCalendarTab)),
              for (final (day, couple, place) in const [('6', 'Fernanda y Tomás', 'Viña del Mar'), ('20', 'Pía y Andrés', 'Colina')])
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(color: AppColors.backgroundSecondary, borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(day, style: AppText.headingM.copyWith(height: 1)),
                            Text('MAR', style: AppText.muted(AppText.labelXS).copyWith(fontSize: 10)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(couple, style: AppText.labelM), Text(place, style: AppText.muted(AppText.bodyS))],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: AppCard(
                onTap: () => goTo(context, Routes.vendorReviewsTab),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OverlineLabel('CALIFICACIÓN'),
                    const SizedBox(height: 4),
                    Text.rich(TextSpan(children: [
                      TextSpan(text: '4,9 ', style: AppText.display.copyWith(fontSize: 30)),
                      const TextSpan(text: '★', style: TextStyle(color: AppColors.brass, fontSize: 20)),
                    ])),
                    Text('2 sin responder', style: AppText.bodyS.copyWith(color: AppColors.warning)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AppCard(
                onTap: () => Navigator.pushNamed(context, Routes.vendorProfile),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OverlineLabel('TU PERFIL'),
                    const SizedBox(height: 4),
                    Text('85%', style: AppText.display.copyWith(fontSize: 30)),
                    const SizedBox(height: 4),
                    const AppProgress(value: 0.85, height: 6),
                    const SizedBox(height: 6),
                    Text('Agrega un video', style: AppText.labelS.copyWith(fontSize: 13, color: AppColors.brassText)),
                  ],
                ),
              ),
            ),
          ],
        ),
        MenuGroup(children: [
          MenuRow(icon: Icons.logout, label: 'Cerrar sesión', danger: true, onTap: () => Navigator.pushNamedAndRemoveUntil(context, Routes.splash, (_) => false)),
        ]),
      ],
    );
  }
}
