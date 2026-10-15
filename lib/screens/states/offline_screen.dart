import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../theme/colors.dart';
import '../../widgets/layout.dart';

/// Estado sin conexión. Se puede abrir con la ruta [Routes.offline].
class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: EmptyState(
            icon: Icons.wifi_off,
            iconTone: (AppColors.errorBg, AppColors.error),
            title: 'Sin conexión',
            text: 'Puedes ver lo último guardado. Tus cambios se sincronizarán cuando vuelvas a tener internet.',
            actionLabel: 'Reintentar',
            onAction: () => Navigator.pushNamedAndRemoveUntil(context, Routes.coupleHome, (_) => false),
          ),
        ),
      ),
    );
  }
}
