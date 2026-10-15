import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../navigation/shells.dart';
import '../../routes.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/layout.dart';

class CreateQuoteScreen extends StatefulWidget {
  const CreateQuoteScreen({super.key});

  @override
  State<CreateQuoteScreen> createState() => _CreateQuoteScreenState();
}

class _CreateQuoteScreenState extends State<CreateQuoteScreen> {
  int _package = 1;

  @override
  Widget build(BuildContext context) {
    final p = Mock.quotePackages[_package];
    return Scaffold(
      appBar: const BackAppBar(title: 'Nueva cotización'),
      body: ScreenList(
        top: 8,
        gap: 14,
        children: [
          Text('Para María y Juan · 13 mar 2027 · 120 invitados', style: AppText.muted(AppText.bodyS)),
          const FieldLabel('Parte desde un paquete'),
          ChipWrap(children: [
            for (var i = 0; i < Mock.quotePackages.length; i++)
              SelectChip(label: Mock.quotePackages[i].name, selected: i == _package, onTap: () => setState(() => _package = i)),
          ]),
          AppCard(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Column(
              children: [
                for (final l in p.lines)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.backgroundSecondary))),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text(l.name, style: AppText.labelM), Text(l.detail, style: AppText.muted(AppText.bodyS))],
                          ),
                        ),
                        Text(l.price, style: AppText.labelM),
                      ],
                    ),
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => showToast(context, 'Pronto: agregar ítems personalizados'),
                    icon: const Icon(Icons.add, size: 18, color: AppColors.brassText),
                    label: Text('Agregar ítem', style: AppText.labelS.copyWith(fontSize: 13, color: AppColors.brassText)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(color: AppColors.backgroundSecondary, borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                Expanded(child: Text('Total', style: AppText.headingM)),
                Text(p.total, style: AppText.headingL),
              ],
            ),
          ),
          Row(
            children: [
              const Expanded(child: LabeledField(label: 'Válida hasta', initialValue: '30 oct 2026')),
              const SizedBox(width: Space.md),
              Expanded(child: LabeledField(key: ValueKey(p.deposit), label: 'Abono para reservar', initialValue: p.deposit)),
            ],
          ),
          const LabeledField(
            label: 'Condiciones',
            maxLines: 3,
            initialValue: 'Saldo 7 días antes de la boda. Traslados fuera de la RM se cotizan aparte.',
          ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderDefault))),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Space.screen, 12, Space.screen, 12),
            child: AppButton(
              label: 'Enviar cotización',
              onPressed: () {
                goTo(context, Routes.vendorMessagesTab);
              },
            ),
          ),
        ),
      ),
    );
  }
}
