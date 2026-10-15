import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../routes.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/layout.dart';
import 'budget_screen.dart';

class QuoteAcceptedScreen extends StatelessWidget {
  const QuoteAcceptedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SuccessView(
        title: '¡Cotización aceptada!',
        text: 'Luz de Campo ya está contratado y lo sumamos a tu presupuesto.',
        extra: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [
                Expanded(child: Text('Luz de Campo', style: AppText.headingM)),
                const StatusChip('Contratado', tone: StatusTone.success),
              ]),
              const SizedBox(height: 4),
              Text('Cobertura completa + álbum', style: AppText.muted(AppText.bodyS)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: Text('Total', style: AppText.muted(AppText.bodyM))),
                Text(r'$1.250.000', style: AppText.headingL.copyWith(fontSize: 20)),
              ]),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.warningBg, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  const Icon(Icons.schedule, size: 20, color: AppColors.warning),
                  const SizedBox(width: 10),
                  Expanded(child: Text(r'Abono 30%: $375.000 · vence el 30 oct', style: AppText.bodyS.copyWith(color: AppColors.warning))),
                ]),
              ),
            ],
          ),
        ),
        actions: [
          AppButton(label: 'Ver presupuesto', onPressed: () => Navigator.pushReplacementNamed(context, Routes.budget)),
          AppButton.secondary(label: 'Registrar abono', onPressed: () => showAppSheet(context, const RegisterPaymentSheet())),
          AppButton.ghost(label: 'Volver a la conversación', onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
