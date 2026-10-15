import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../routes.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';
import '../../widgets/layout.dart';

class RequestQuoteScreen extends StatefulWidget {
  const RequestQuoteScreen({super.key});

  @override
  State<RequestQuoteScreen> createState() => _RequestQuoteScreenState();
}

class _RequestQuoteScreenState extends State<RequestQuoteScreen> {
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    final vendor = ModalRoute.of(context)?.settings.arguments as Vendor? ?? Mock.vendors.first;

    if (_sent) {
      return Scaffold(
        body: SuccessView(
          title: '¡Solicitud enviada!',
          text: '${vendor.name} suele responder en menos de 24 horas. Te avisaremos cuando llegue la cotización.',
          actions: [
            AppButton(label: 'Ir a la conversación', onPressed: () => Navigator.pushReplacementNamed(context, Routes.chat)),
            AppButton.ghost(label: 'Seguir explorando', onPressed: () => Navigator.pop(context)),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: const BackAppBar(title: 'Solicitar cotización'),
      body: ScreenList(
        top: 12,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.backgroundSecondary, borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                PhotoPlaceholder(color: vendor.photo, width: 48, height: 48, radius: 10, showIcon: false),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vendor.name, style: AppText.labelM),
                    Text('${_cap(vendor.category)} · responde en ~24 h', style: AppText.muted(AppText.bodyS)),
                  ],
                ),
              ],
            ),
          ),
          const Row(
            children: [
              Expanded(child: LabeledField(label: 'Fecha', initialValue: '13 mar 2027')),
              SizedBox(width: Space.md),
              Expanded(child: LabeledField(label: 'Invitados', initialValue: '120', keyboardType: TextInputType.number)),
            ],
          ),
          const LabeledField(label: 'Paquete de interés', initialValue: 'Cobertura completa + álbum'),
          const LabeledField(label: 'Presupuesto aproximado', initialValue: r'$1.000.000 – $1.500.000'),
          const LabeledField(
            label: 'Mensaje',
            maxLines: 4,
            initialValue: 'Hola, nos casamos en Casona El Roble. Nos gustaría incluir los preparativos de ambos.',
          ),
          OutlinedButton.icon(
            onPressed: () => showToast(context, 'Pronto: adjuntar fotos de referencia'),
            icon: const Icon(Icons.attach_file, size: 18),
            label: const Text('Adjuntar fotos de referencia (opcional)'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.borderDefault),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              alignment: Alignment.centerLeft,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.button)),
              textStyle: AppText.bodyS,
            ),
          ),
          AppButton(label: 'Enviar solicitud', onPressed: () => setState(() => _sent = true)),
          Text(
            'Tu teléfono no se comparte hasta que aceptes una cotización.',
            style: AppText.muted(AppText.bodyS),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static String _cap(String s) => s.isEmpty ? s : s[0] + s.substring(1).toLowerCase();
}
