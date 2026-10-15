import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../navigation/shells.dart';
import '../../routes.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/items.dart';
import '../../widgets/layout.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key, this.loading = false, this.standalone = false});

  /// Empieza mostrando el estado de carga (skeleton).
  final bool loading;

  /// Se abre como pantalla aparte (con su propio Scaffold).
  final bool standalone;

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  late bool _loading = widget.loading;
  int _category = 0;
  bool _cheapOnly = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (_loading) _finishLoadingSoon();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _finishLoadingSoon() {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  void _search() {
    setState(() => _loading = true);
    _finishLoadingSoon();
  }

  @override
  Widget build(BuildContext context) {
    final category = Mock.vendorCategories[_category];
    final vendors = Mock.vendors.where((v) {
      if (_cheapOnly) return false; // ningún proveedor de ejemplo cuesta menos de $300.000
      if (_category == 0) return true;
      return v.category.toLowerCase() == category.toLowerCase();
    }).toList();

    final list = ScreenList(
      gap: 14,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Proveedores', style: AppText.display),
                  Text('Para el 13 mar 2027 · Pirque', style: AppText.muted(AppText.bodyS)),
                ],
              ),
            ),
            CircleIconButton(icon: Icons.favorite_border, tooltip: 'Favoritos', onPressed: () => goTo(context, Routes.coupleProfileTab)),
          ],
        ),
        TextField(
          readOnly: true,
          onTap: _search,
          style: AppText.bodyM,
          decoration: const InputDecoration(
            hintText: 'Buscar proveedores…',
            prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          ),
        ),
        ChipScroller(children: [
          for (var i = 0; i < Mock.vendorCategories.length; i++)
            SelectChip(label: Mock.vendorCategories[i], selected: i == _category, onTap: () => setState(() => _category = i)),
        ]),
        ChipScroller(children: [
          SelectChip(label: 'Filtros · 2', icon: Icons.tune, selected: false, outlined: true, onTap: () => showAppSheet(context, const FiltersSheet())),
          const SelectChip(label: 'Disponible 13 mar', selected: true, onTap: null),
          SelectChip(label: r'Bajo $300.000', selected: _cheapOnly, onTap: () => setState(() => _cheapOnly = !_cheapOnly)),
        ]),
        Text(
          _loading ? 'Buscando…' : '${vendors.length} proveedores disponibles en tu fecha',
          style: AppText.muted(AppText.bodyS),
        ),
        if (_loading)
          const _VendorGrid(children: [_SkeletonCard(), _SkeletonCard(), _SkeletonCard(), _SkeletonCard()])
        else if (vendors.isEmpty)
          EmptyState(
            title: 'Sin resultados con esos filtros',
            text: 'Prueba quitando el filtro de precio o ampliando las comunas.',
            actionLabel: 'Quitar filtros',
            onAction: () => setState(() {
              _cheapOnly = false;
              _category = 0;
            }),
          )
        else
          _VendorGrid(children: [
            for (final v in vendors)
              VendorCard(vendor: v, onTap: () => Navigator.pushNamed(context, Routes.vendorProfile, arguments: v)),
          ]),
      ],
    );

    if (!widget.standalone) return list;
    return Scaffold(appBar: const BackAppBar(title: 'Proveedores'), body: list);
  }
}

class _VendorGrid extends StatelessWidget {
  const _VendorGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = (c.maxWidth - 14) / 2;
        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [for (final child in children) SizedBox(width: w, child: child)],
        );
      },
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    Widget bar(double w, double h) => Container(
          width: w,
          height: h,
          decoration: BoxDecoration(color: AppColors.backgroundSecondary, borderRadius: BorderRadius.circular(6)),
        );
    return ExcludeSemantics(
      child: Container(
        decoration: BoxDecoration(color: AppColors.surfaceWhite, borderRadius: BorderRadius.circular(Radii.card)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 120, color: AppColors.backgroundSecondary),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [bar(60, 10), const SizedBox(height: 8), bar(110, 14), const SizedBox(height: 8), bar(90, 10)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet de filtros del marketplace.
class FiltersSheet extends StatefulWidget {
  const FiltersSheet({super.key});

  @override
  State<FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<FiltersSheet> {
  RangeValues _price = const RangeValues(300000, 1500000);
  final Set<String> _comunas = {'Pirque', 'Santiago'};
  int _minRating = 2;
  bool _verified = false;

  static String _clp(double v) {
    final s = v.round().toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return '\$$b';
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Filtros',
      children: [
        const FieldLabel('Rango de precio'),
        RangeSlider(
          values: _price,
          min: 100000,
          max: 3000000,
          divisions: 29,
          activeColor: AppColors.ink,
          inactiveColor: AppColors.borderDefault,
          labels: RangeLabels(_clp(_price.start), _clp(_price.end)),
          onChanged: (v) => setState(() => _price = v),
        ),
        Row(
          children: [
            Expanded(child: Text(_clp(_price.start), style: AppText.labelS.copyWith(fontSize: 13))),
            Text(_clp(_price.end), style: AppText.labelS.copyWith(fontSize: 13)),
          ],
        ),
        const FieldLabel('Comunas'),
        ChipWrap(children: [
          for (final c in const ['Pirque', 'Santiago', 'Colina', 'Providencia', 'Viña del Mar'])
            SelectChip(
              label: c,
              selected: _comunas.contains(c),
              onTap: () => setState(() => _comunas.contains(c) ? _comunas.remove(c) : _comunas.add(c)),
            ),
        ]),
        const FieldLabel('Calificación mínima'),
        ChipWrap(children: [
          for (var i = 0; i < 4; i++)
            SelectChip(label: const ['Todas', '4,0+', '4,5+', '4,8+'][i], selected: i == _minRating, onTap: () => setState(() => _minRating = i)),
        ]),
        const FieldLabel('Fecha'),
        ChipWrap(children: [
          const SelectChip(label: 'Disponible el 13 mar 2027', selected: true, onTap: null),
          SelectChip(label: 'Solo verificados', selected: _verified, onTap: () => setState(() => _verified = !_verified)),
        ]),
        Row(
          children: [
            Expanded(child: AppButton.secondary(label: 'Limpiar', onPressed: () => Navigator.pop(context))),
            const SizedBox(width: 10),
            Expanded(child: AppButton(label: 'Ver 32 resultados', onPressed: () => Navigator.pop(context))),
          ],
        ),
      ],
    );
  }
}
