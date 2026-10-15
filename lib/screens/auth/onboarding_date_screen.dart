import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../theme/text.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/layout.dart';

class OnboardingDateScreen extends StatefulWidget {
  const OnboardingDateScreen({super.key});

  @override
  State<OnboardingDateScreen> createState() => _OnboardingDateScreenState();
}

class _OnboardingDateScreenState extends State<OnboardingDateScreen> {
  bool _noDate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(title: 'Paso 2 de 3'),
      body: ScreenList(
        top: 8,
        children: [
          const AppProgress(value: 2 / 3, height: 6),
          Text('La gran fecha', style: AppText.display),
          Text('Con esto armamos tu checklist y te mostramos proveedores disponibles ese día.', style: AppText.muted(AppText.bodyM)),
          if (!_noDate) const LabeledField(label: 'Fecha de la boda', initialValue: 'Sábado 13 de marzo de 2027'),
          Align(
            alignment: Alignment.centerLeft,
            child: SelectChip(label: 'Aún no tenemos fecha', selected: _noDate, onTap: () => setState(() => _noDate = !_noDate)),
          ),
          const LabeledField(label: 'Comuna o región', initialValue: 'Pirque, Región Metropolitana'),
          const LabeledField(label: 'Invitados aproximados', initialValue: '120', keyboardType: TextInputType.number),
          const SizedBox(height: 8),
          AppButton(label: 'Continuar', onPressed: () => Navigator.pushNamed(context, Routes.onboardingBudget)),
        ],
      ),
    );
  }
}
