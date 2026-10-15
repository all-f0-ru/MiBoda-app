import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../navigation/shells.dart';
import '../../routes.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/items.dart';
import '../../widgets/layout.dart';

class CoupleProfileScreen extends StatefulWidget {
  const CoupleProfileScreen({super.key});

  @override
  State<CoupleProfileScreen> createState() => _CoupleProfileScreenState();
}

class _CoupleProfileScreenState extends State<CoupleProfileScreen> {
  bool _resent = false;

  @override
  Widget build(BuildContext context) {
    return ScreenList(
      gap: 18,
      children: [
        Column(
          children: [
            const Initials('M&J', size: 88),
            const SizedBox(height: 8),
            Text(Mock.coupleNames, style: AppText.headingL),
            Text('13 mar 2027 · ${Mock.venue}', style: AppText.muted(AppText.bodyS)),
            const SizedBox(height: 10),
            AppButton.secondary(
              label: 'Editar datos de la boda',
              expand: false,
              compact: true,
              onPressed: () => Navigator.pushNamed(context, Routes.onboardingDate),
            ),
          ],
        ),
        const SectionHeader('Co-planificadores'),
        MenuGroup(children: [
          const _Planner(initials: 'JP', name: 'Juan Pérez', role: 'Puede editar', chip: StatusChip('Activo', tone: StatusTone.success)),
          _Planner(
            initials: 'PR',
            name: 'Paula Rojas · planner',
            role: 'Solo ver',
            chip: _resent
                ? const StatusChip('Invitación reenviada', tone: StatusTone.info)
                : const StatusChip('Pendiente', tone: StatusTone.warning),
          ),
          MenuRow(
            icon: Icons.add,
            label: 'Invitar a alguien',
            onTap: () {
              setState(() => _resent = true);
              showToast(context, 'Link de invitación copiado');
            },
          ),
        ]),
        MenuGroup(children: [
          MenuRow(icon: Icons.favorite_border, label: 'Favoritos', onTap: () => goTo(context, Routes.marketplaceTab)),
          MenuRow(icon: Icons.chat_bubble_outline, label: 'Mensajes', onTap: () => goTo(context, Routes.messages)),
          MenuRow(icon: Icons.account_balance_wallet_outlined, label: 'Presupuesto', onTap: () => goTo(context, Routes.budget)),
          MenuRow(icon: Icons.notifications_none, label: 'Notificaciones', onTap: () => goTo(context, Routes.notifications)),
        ]),
        MenuGroup(children: [
          MenuRow(
            icon: Icons.logout,
            label: 'Cerrar sesión',
            danger: true,
            onTap: () => Navigator.pushNamedAndRemoveUntil(context, Routes.splash, (_) => false),
          ),
        ]),
      ],
    );
  }
}

class _Planner extends StatelessWidget {
  const _Planner({required this.initials, required this.name, required this.role, required this.chip});

  final String initials;
  final String name;
  final String role;
  final Widget chip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Initials(initials, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppText.labelM),
                Text(role, style: AppText.muted(AppText.bodyS)),
              ],
            ),
          ),
          chip,
        ],
      ),
    );
  }
}

/// Color de fondo y de ícono según el tono (usado en notificaciones).
(Color, Color) noticeColors(StatusTone tone) =>
    tone == StatusTone.neutral ? (AppColors.backgroundSecondary, AppColors.brassDeep) : toneColors(tone);
