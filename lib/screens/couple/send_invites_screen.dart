import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../state/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';
import '../../widgets/items.dart';
import '../../widgets/layout.dart';

class SendInvitesScreen extends StatefulWidget {
  const SendInvitesScreen({super.key});

  @override
  State<SendInvitesScreen> createState() => _SendInvitesScreenState();
}

class _SendInvitesScreenState extends State<SendInvitesScreen> {
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final count = state.invitesSelected;

    if (_sent) {
      return Scaffold(
        body: SuccessView(
          title: 'Invitaciones enviadas',
          text: '$count invitados recibieron su link. Te avisaremos cada vez que alguien confirme.',
          actions: [AppButton(label: 'Volver a invitados', onPressed: () => Navigator.pop(context))],
        ),
      );
    }

    return Scaffold(
      appBar: const BackAppBar(title: 'Enviar invitaciones'),
      body: ScreenList(
        top: 8,
        children: [
          Text(
            'Cada invitado recibe un link personal para confirmar asistencia, acompañante y restricciones alimentarias.',
            style: AppText.muted(AppText.bodyM),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.backgroundSecondary, borderRadius: BorderRadius.circular(Radii.card)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const OverlineLabel('VISTA PREVIA DEL MENSAJE'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Hola Ana! Nos casamos el sábado 13 de marzo de 2027 en ${Mock.venue}, y nos encantaría que nos acompañes.',
                        style: AppText.bodyM,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'miboda.cl/maria-y-juan/rsvp',
                        style: AppText.labelS.copyWith(fontSize: 13, color: AppColors.info, decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SectionHeader('Destinatarios · $count', action: 'Seleccionar todos', onAction: state.selectAllInvites),
          MenuGroup(children: [
            for (final r in Mock.inviteRecipients)
              Semantics(
                checked: state.isInviteSelected(r[0]),
                child: InkWell(
                  onTap: () => state.toggleInvite(r[0]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        BrandCheckbox(checked: state.isInviteSelected(r[0])),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r[0], style: AppText.labelM),
                            Text(r[1], style: AppText.muted(AppText.bodyS)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ]),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderDefault))),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Space.screen, 12, Space.screen, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(
                  label: 'Enviar por WhatsApp ($count)',
                  onPressed: count == 0 ? null : () => setState(() => _sent = true),
                ),
                AppButton.ghost(label: 'Copiar link de RSVP', onPressed: () => showToast(context, 'Link de RSVP copiado')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
