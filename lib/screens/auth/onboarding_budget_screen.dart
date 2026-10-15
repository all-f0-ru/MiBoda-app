import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/layout.dart';

class OnboardingBudgetScreen extends StatefulWidget {
  const OnboardingBudgetScreen({super.key});

  @override
  State<OnboardingBudgetScreen> createState() => _OnboardingBudgetScreenState();
}

class _OnboardingBudgetScreenState extends State<OnboardingBudgetScreen> {
  static const _ranges = [r'Hasta $10M', r'$10M – $20M', r'$20M – $30M', r'Más de $30M'];
  int _range = 1;

  void _finish() => Navigator.pushNamedAndRemoveUntil(context, Routes.coupleHome, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(title: 'Paso 3 de 3'),
      body: ScreenList(
        top: 8,
        children: [
          const AppProgress(value: 1, height: 6),
          Text('Presupuesto estimado', style: AppText.display),
          Text('Puedes cambiarlo cuando quieras.', style: AppText.muted(AppText.bodyM)),
          const LabeledField(label: 'Presupuesto total (CLP)', initialValue: r'$18.000.000', keyboardType: TextInputType.number),
          ChipWrap(children: [
            for (var i = 0; i < _ranges.length; i++)
              SelectChip(label: _ranges[i], selected: i == _range, onTap: () => setState(() => _range = i)),
          ]),
          AppCard(
            color: AppColors.backgroundSecondary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Planifiquen juntos', style: AppText.headingM),
                const SizedBox(height: 6),
                Text('Invita a tu pareja para que vea y edite el plan desde su teléfono.', style: AppText.muted(AppText.bodyS)),
                const SizedBox(height: 12),
                AppButton.secondary(label: 'Invitar a mi pareja', onPressed: () => showToast(context, 'Link de invitación copiado')),
              ],
            ),
          ),
          AppButton(label: 'Crear nuestro plan', onPressed: _finish),
          AppButton.ghost(label: 'Omitir por ahora', onPressed: _finish),
        ],
      ),
    );
  }
}
