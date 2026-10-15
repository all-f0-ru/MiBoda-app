import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../routes.dart';
import '../../state/app_state.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/layout.dart';

class _Msg {
  const _Msg(this.text, this.time, {required this.mine});
  final String text;
  final String time;
  final bool mine;
}

/// Conversación de los novios con un proveedor, con tarjeta de cotización.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _input = TextEditingController();
  final List<_Msg> _extra = [];

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _send() {
    final t = _input.text.trim();
    if (t.isEmpty) return;
    setState(() => _extra.add(_Msg(t, 'Ahora', mine: true)));
    _input.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: BackAppBar(
        title: 'Luz de Campo',
        background: AppColors.backgroundSecondary,
        actions: [
          IconButton(
            tooltip: 'Ver perfil',
            icon: const Icon(Icons.more_horiz),
            onPressed: () => Navigator.pushNamed(context, Routes.vendorProfile),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              children: [
                Center(child: Text('Hoy', style: AppText.muted(AppText.labelXS))),
                const SizedBox(height: 10),
                const _Bubble(_Msg('Solicitud de cotización · 13 mar 2027 · 120 invitados · Cobertura completa + álbum', '09:02', mine: true)),
                const _Bubble(_Msg(
                  '¡Hola María y Juan! Gracias por escribirnos. Tenemos el 13 de marzo disponible. Les dejo la propuesta y nuestro portafolio.',
                  '10:22',
                  mine: false,
                )),
                const _FileBubble(),
                const SizedBox(height: 10),
                const Align(alignment: Alignment.centerLeft, child: _QuoteCard()),
                if (state.quoteStatus == QuoteStatus.changesRequested)
                  const _Bubble(_Msg('¿Podrían incluir sesión preboda y cambiar el álbum por uno de 20×20?', 'Ahora', mine: true)),
                for (final m in _extra) _Bubble(m),
              ],
            ),
          ),
          DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.backgroundPrimary,
              border: Border(top: BorderSide(color: AppColors.borderDefault)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Adjuntar archivo',
                      icon: const Icon(Icons.attach_file, color: AppColors.textSecondary),
                      onPressed: () => showToast(context, 'Pronto: adjuntar fotos y archivos'),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _input,
                        style: AppText.bodyM,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                        decoration: InputDecoration(
                          hintText: 'Escribe un mensaje',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.borderDefault)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.borderDefault)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.ink)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleIconButton(
                      icon: Icons.send_outlined,
                      tooltip: 'Enviar',
                      size: 40,
                      background: AppColors.ink,
                      foreground: AppColors.textOnInk,
                      onPressed: _send,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble(this.msg);

  final _Msg msg;

  @override
  Widget build(BuildContext context) {
    final mine = msg.mine;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: const BoxConstraints(maxWidth: 290),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
        decoration: BoxDecoration(
          color: mine ? AppColors.ink : AppColors.surfaceWhite,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(mine ? 16 : 4),
            bottomRight: Radius.circular(mine ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(msg.text, style: AppText.bodyM.copyWith(color: mine ? AppColors.textOnInk : AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text(msg.time, style: AppText.labelXS.copyWith(letterSpacing: 0, color: mine ? AppColors.surfaceBlush : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _FileBubble extends StatelessWidget {
  const _FileBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
        decoration: BoxDecoration(color: AppColors.surfaceWhite, borderRadius: BorderRadius.circular(14)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.errorBg, borderRadius: BorderRadius.circular(8)),
              child: Text('PDF', style: AppText.labelXS.copyWith(color: AppColors.error, letterSpacing: 0)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Portafolio_LuzDeCampo.pdf', style: AppText.labelS.copyWith(fontSize: 13)),
                Text('4,2 MB', style: AppText.muted(AppText.bodyS).copyWith(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta de cotización con Aceptar / Rechazar / Pedir cambios.
class _QuoteCard extends StatelessWidget {
  const _QuoteCard();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final status = state.quoteStatus;
    final chip = switch (status) {
      QuoteStatus.pending => const StatusChip('Por responder', tone: StatusTone.warning),
      QuoteStatus.accepted => const StatusChip('Aceptada', tone: StatusTone.success),
      QuoteStatus.rejected => const StatusChip('Rechazada', tone: StatusTone.error),
      QuoteStatus.changesRequested => const StatusChip('Cambios pedidos', tone: StatusTone.info),
    };

    return Container(
      width: 300,
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(Radii.card),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [Expanded(child: OverlineLabel('COTIZACIÓN', color: AppColors.brassText)), chip]),
          const SizedBox(height: 10),
          Text('Cobertura completa + álbum', style: AppText.headingM),
          const SizedBox(height: 4),
          Text('10 horas · 2 fotógrafos · 400 fotos editadas · álbum 30×30', style: AppText.muted(AppText.bodyS)),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(child: Text('Total', style: AppText.muted(AppText.bodyM))),
              Text(r'$1.250.000', style: AppText.headingL.copyWith(fontSize: 20)),
            ],
          ),
          Text('Válida hasta el 30 oct · Abono 30%', style: AppText.muted(AppText.bodyS)),
          const SizedBox(height: 12),
          switch (status) {
            QuoteStatus.pending || QuoteStatus.changesRequested => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppButton.secondary(
                          label: 'Rechazar',
                          compact: true,
                          onPressed: () => showAppSheet(context, const _RejectSheet()),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppButton(
                          label: 'Aceptar',
                          compact: true,
                          onPressed: () {
                            state.setQuoteStatus(QuoteStatus.accepted);
                            Navigator.pushNamed(context, Routes.quoteAccepted);
                          },
                        ),
                      ),
                    ],
                  ),
                  if (status == QuoteStatus.pending)
                    AppButton.ghost(
                      label: 'Pedir cambios',
                      compact: true,
                      onPressed: () => state.setQuoteStatus(QuoteStatus.changesRequested),
                    ),
                ],
              ),
            QuoteStatus.accepted => Text('✓ Aceptada. Se sumó a tu presupuesto.', style: AppText.bodyS.copyWith(color: AppColors.success)),
            QuoteStatus.rejected => Row(
                children: [
                  Expanded(child: Text('Rechazaste esta cotización.', style: AppText.bodyS.copyWith(color: AppColors.error))),
                  TextButton(onPressed: () => state.setQuoteStatus(QuoteStatus.pending), child: const Text('Deshacer')),
                ],
              ),
          },
        ],
      ),
    );
  }
}

class _RejectSheet extends StatefulWidget {
  const _RejectSheet();

  @override
  State<_RejectSheet> createState() => _RejectSheetState();
}

class _RejectSheetState extends State<_RejectSheet> {
  String _reason = 'El precio es alto';

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: '¿Por qué no sigues?',
      subtitle: 'El proveedor recibe tu motivo; le ayuda a mejorar.',
      children: [
        ChipWrap(children: [
          for (final r in const ['El precio es alto', 'Elegimos otro proveedor', 'No incluye lo que buscamos', 'Cambió nuestra fecha', 'Otro'])
            SelectChip(label: r, selected: r == _reason, onTap: () => setState(() => _reason = r)),
        ]),
        const LabeledField(label: 'Comentario (opcional)', maxLines: 3, hint: 'Nos encantó su trabajo, pero…'),
        AppButton(
          label: 'Rechazar cotización',
          variant: ButtonVariant.destructive,
          onPressed: () {
            AppScope.of(context).setQuoteStatus(QuoteStatus.rejected);
            Navigator.pop(context);
          },
        ),
        AppButton.ghost(label: 'Cancelar', onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}
