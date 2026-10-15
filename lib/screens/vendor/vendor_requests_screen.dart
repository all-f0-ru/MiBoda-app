import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../routes.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../widgets/chips.dart';
import '../../widgets/items.dart';
import '../../widgets/layout.dart';

class VendorRequestsScreen extends StatefulWidget {
  const VendorRequestsScreen({super.key});

  @override
  State<VendorRequestsScreen> createState() => _VendorRequestsScreenState();
}

class _VendorRequestsScreenState extends State<VendorRequestsScreen> {
  String _tab = 'Nuevas';

  @override
  Widget build(BuildContext context) {
    final requests = Mock.requestsByTab[_tab] ?? const [];
    return ScreenList(
      gap: 14,
      children: [
        Text('Solicitudes', style: AppText.display),
        ChipScroller(children: [
          for (final e in Mock.requestTabCounts.entries)
            SelectChip(label: '${e.key} · ${e.value}', selected: e.key == _tab, onTap: () => setState(() => _tab = e.key)),
        ]),
        if (requests.isEmpty)
          const EmptyState(
            title: 'Aún no llegan solicitudes',
            text: 'Los perfiles con 10+ fotos y precios claros reciben 3 veces más solicitudes.',
          ),
        for (final r in requests) RequestCard(request: r, onTap: () => Navigator.pushNamed(context, Routes.requestDetail)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(color: AppColors.backgroundSecondary, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              const Icon(Icons.schedule, size: 20, color: AppColors.brassDeep),
              const SizedBox(width: 10),
              Expanded(child: Text('Responder en menos de 24 h mejora tu posición en el buscador.', style: AppText.muted(AppText.bodyS))),
            ],
          ),
        ),
      ],
    );
  }
}
