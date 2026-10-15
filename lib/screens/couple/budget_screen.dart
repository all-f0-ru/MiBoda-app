import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/layout.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final payments = [
      Payment(
        id: 'roble',
        concept: 'Casona El Roble · 2° abono',
        due: 'Vence 30 oct',
        amount: r'$1.950.000',
        tone: state.casonaPaid ? StatusTone.success : StatusTone.warning,
        label: state.casonaPaid ? 'Pagado' : 'En 15 días',
      ),
      const Payment(id: 'luz', concept: 'Luz de Campo · abono 30%', due: 'Vence 30 oct', amount: r'$375.000', tone: StatusTone.warning, label: 'En 15 días'),
      const Payment(id: 'noa', concept: 'Atelier Noa · saldo', due: 'Vence 15 ene', amount: r'$600.000', tone: StatusTone.neutral, label: 'Programado'),
    ];

    return Scaffold(
      appBar: const BackAppBar(title: 'Presupuesto'),
      body: ScreenList(
        top: 12,
        gap: 22,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const OverlineLabel('COMPROMETIDO', color: AppColors.surfaceBlush),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(r'$8.950.000', style: AppText.display.copyWith(color: AppColors.textOnInk)),
                    const SizedBox(width: 6),
                    Text('de ${Mock.budgetTotal}', style: AppText.bodyS.copyWith(color: AppColors.surfaceBlush)),
                  ],
                ),
                const SizedBox(height: 12),
                const AppProgress(value: 0.5, track: AppColors.textSecondary),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: Text('Pagado ${state.budgetPaid}', style: AppText.bodyS.copyWith(color: AppColors.textOnInk))),
                    Text('Por pagar ${state.budgetDue}', style: AppText.bodyS.copyWith(color: AppColors.textOnInk)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeader('Próximos pagos'),
              for (final p in payments)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: AppCard(
                    onTap: p.id == 'roble' && !state.casonaPaid ? () => showAppSheet(context, const RegisterPaymentSheet()) : null,
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.concept, style: AppText.labelM),
                              Text(p.due, style: AppText.muted(AppText.bodyS)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(p.amount, style: AppText.labelM),
                            const SizedBox(height: 4),
                            StatusChip(p.label, tone: p.tone),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionHeader('Por categoría'),
                for (final c in Mock.budgetCategories) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: Text(c.name, style: AppText.bodyM)),
                      Text(c.real, style: AppText.labelM.copyWith(color: c.over ? AppColors.error : AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  AppProgress(value: c.progress, color: c.over ? AppColors.error : AppColors.brass),
                  const SizedBox(height: 4),
                  Text(c.estimate, style: AppText.bodyS.copyWith(fontSize: 12, color: c.over ? AppColors.error : AppColors.textSecondary)),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderDefault))),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Space.screen, 12, Space.screen, 12),
            child: Row(
              children: [
                Expanded(child: AppButton.secondary(label: 'Agregar gasto', onPressed: () => showAppSheet(context, const RegisterPaymentSheet(expense: true)))),
                const SizedBox(width: 10),
                Expanded(child: AppButton(label: 'Registrar pago', onPressed: () => showAppSheet(context, const RegisterPaymentSheet()))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet para registrar un pago o agregar un gasto.
class RegisterPaymentSheet extends StatefulWidget {
  const RegisterPaymentSheet({super.key, this.expense = false});

  final bool expense;

  @override
  State<RegisterPaymentSheet> createState() => _RegisterPaymentSheetState();
}

class _RegisterPaymentSheetState extends State<RegisterPaymentSheet> {
  String _method = 'Transferencia';

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: widget.expense ? 'Agregar gasto' : 'Registrar pago',
      children: [
        LabeledField(
          label: 'Proveedor o concepto',
          initialValue: widget.expense ? 'Recuerdos para invitados' : 'Casona El Roble · 2° abono',
        ),
        Row(
          children: [
            Expanded(child: LabeledField(label: 'Monto', initialValue: widget.expense ? r'$240.000' : r'$1.950.000', keyboardType: TextInputType.number)),
            const SizedBox(width: Space.md),
            const Expanded(child: LabeledField(label: 'Fecha', initialValue: '15 oct 2026')),
          ],
        ),
        const FieldLabel('Método'),
        ChipWrap(children: [
          for (final m in const ['Transferencia', 'Tarjeta', 'Efectivo'])
            SelectChip(label: m, selected: m == _method, onTap: () => setState(() => _method = m)),
        ]),
        AppButton.secondary(
          label: 'Adjuntar comprobante',
          icon: Icons.attach_file,
          onPressed: () => showToast(context, 'Pronto: adjuntar comprobante'),
        ),
        AppButton(
          label: widget.expense ? 'Guardar gasto' : 'Guardar pago',
          onPressed: () {
            if (!widget.expense) AppScope.of(context).registerCasonaPayment();
            Navigator.pop(context);
            showToast(context, widget.expense ? 'Gasto agregado' : r'Pago de $1.950.000 registrado');
          },
        ),
      ],
    );
  }
}
