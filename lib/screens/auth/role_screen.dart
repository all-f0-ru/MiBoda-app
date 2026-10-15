import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../widgets/layout.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(tooltip: 'Volver', icon: const Icon(Icons.chevron_left, size: 28), onPressed: () => Navigator.maybePop(context)),
      ),
      body: ScreenList(
        top: 32,
        children: [
          Text('¿Cómo vas a usar MiBoda+?', style: AppText.display),
          Text('Así te mostramos lo que necesitas.', style: AppText.muted(AppText.bodyM)),
          const SizedBox(height: 4),
          _RoleCard(
            icon: Icons.people_outline,
            title: 'Estamos planificando nuestra boda',
            text: 'Proveedores, invitados, presupuesto y tareas en un solo lugar.',
            onTap: () => Navigator.pushNamed(context, Routes.onboardingDate),
          ),
          _RoleCard(
            icon: Icons.storefront_outlined,
            title: 'Ofrezco servicios para bodas',
            text: 'Recibe solicitudes de cotización y muestra tu trabajo.',
            onTap: () => Navigator.pushNamedAndRemoveUntil(context, Routes.vendorHome, (_) => false),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.icon, required this.title, required this.text, required this.onTap});

  final IconData icon;
  final String title;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      border: Border.all(color: AppColors.borderDefault),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.backgroundSecondary, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.brassDeep),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.headingM),
                const SizedBox(height: 4),
                Text(text, style: AppText.muted(AppText.bodyS)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
