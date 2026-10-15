import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../theme/text.dart';
import '../../widgets/brand.dart';
import '../../widgets/buttons.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            children: [
              const Spacer(flex: 3),
              const MiBodaSymbol(size: 96),
              const SizedBox(height: 16),
              Wordmark(style: AppText.display.copyWith(fontSize: 40, height: 1.1)),
              const SizedBox(height: 8),
              Text('Tu boda, sin el caos', style: AppText.muted(AppText.bodyM).copyWith(fontSize: 16)),
              const Spacer(flex: 4),
              AppButton(label: 'Comenzar', onPressed: () => Navigator.pushNamed(context, Routes.role)),
              const SizedBox(height: 4),
              AppButton.ghost(label: 'Ya tengo cuenta', onPressed: () => Navigator.pushNamed(context, Routes.login)),
            ],
          ),
        ),
      ),
    );
  }
}
