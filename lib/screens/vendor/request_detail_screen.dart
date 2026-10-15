import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../navigation/shells.dart';
import '../../routes.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/items.dart';
import '../../widgets/layout.dart';

class RequestDetailScreen extends StatelessWidget {
  const RequestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(title: 'Solicitud'),
      body: ScreenList(
        top: 12,
        children: [
          Row(
            children: [
              const Initials('MJ', size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('María y Juan', style: AppText.headingL.copyWith(fontSize: 22)),
                    Text('Recibida hace 2 h', style: AppText.muted(AppText.bodyS)),
                  ],
                ),
              ),
              const StatusChip('Nueva', tone: StatusTone.info),
            ],
          ),
          const AppCard(
            child: Column(
              children: [
                KeyValueRow('Fecha', 'Sáb 13 mar 2027', trailing: StatusChip('Libre', tone: StatusTone.success)),
                SizedBox(height: 14),
                KeyValueRow('Lugar', 'Casona El Roble, Pirque'),
                SizedBox(height: 14),
                KeyValueRow('Invitados', '120'),
                SizedBox(height: 14),
                KeyValueRow('Paquete', 'Cobertura completa + álbum'),
                SizedBox(height: 14),
                KeyValueRow('Presupuesto', r'$1.000.000 – $1.500.000'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.backgroundSecondary, borderRadius: BorderRadius.circular(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const OverlineLabel('MENSAJE'),
                const SizedBox(height: 6),
                Text('“Hola, nos casamos en Casona El Roble. Nos gustaría incluir los preparativos de ambos.”', style: AppText.bodyM),
              ],
            ),
          ),
          const FieldLabel('Referencias adjuntas'),
          Row(
            children: [
              for (var i = 1; i <= 3; i++) ...[
                if (i > 1) const SizedBox(width: 10),
                PhotoPlaceholder(color: AppColors.photoPalette[i], width: 80, height: 80),
              ],
            ],
          ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderDefault))),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Space.screen, 12, Space.screen, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(label: 'Enviar cotización', onPressed: () => Navigator.pushNamed(context, Routes.createQuote)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: AppButton.secondary(label: 'Responder por chat', compact: true, onPressed: () => goTo(context, Routes.vendorMessagesTab))),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButton.ghost(
                        label: 'No disponible',
                        compact: true,
                        onPressed: () {
                          Navigator.pop(context);
                          showToast(context, 'Avisamos a la pareja que no tienes disponibilidad');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
