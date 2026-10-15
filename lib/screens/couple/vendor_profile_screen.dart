import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../routes.dart';
import '../../theme/colors.dart';
import '../../theme/text.dart';
import '../../theme/tokens.dart';
import '../../widgets/buttons.dart';
import '../../widgets/chips.dart';
import '../../widgets/items.dart';
import '../../widgets/layout.dart';

/// Perfil público de un proveedor (lo ven los novios y el propio proveedor).
class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  final _gallery = PageController();
  int _page = 0;

  @override
  void dispose() {
    _gallery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vendor = ModalRoute.of(context)?.settings.arguments as Vendor? ?? Mock.vendors.first;
    final rating = vendor.rating.toStringAsFixed(1).replaceAll('.', ',');

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 300,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _gallery,
                          itemCount: 5,
                          onPageChanged: (i) => setState(() => _page = i),
                          itemBuilder: (_, i) => PhotoPlaceholder(color: i == 0 ? vendor.photo : Mock.photoFor(i + 1), radius: 0),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 16,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var i = 0; i < 5; i++)
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  width: i == _page ? 16 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: i == _page ? AppColors.surfaceWhite : AppColors.backgroundPrimary.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                CircleIconButton(icon: Icons.chevron_left, tooltip: 'Volver', size: 40, onPressed: () => Navigator.maybePop(context)),
                                const Spacer(),
                                CircleIconButton(
                                  icon: Icons.ios_share,
                                  tooltip: 'Compartir',
                                  size: 40,
                                  onPressed: () => showToast(context, 'Link del perfil copiado'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(Space.screen, 20, Space.screen, 24),
                  sliver: SliverList.list(
                    children: [
                      Text(vendor.category, style: AppText.labelXS.copyWith(color: AppColors.brassText)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Flexible(child: Text(vendor.name, style: AppText.display)),
                          const SizedBox(width: 8),
                          const Icon(Icons.verified_outlined, color: AppColors.success, semanticLabel: 'Verificado'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text.rich(TextSpan(children: [
                        const TextSpan(text: '★ ', style: TextStyle(color: AppColors.brass)),
                        TextSpan(text: '$rating · ${vendor.reviews} reseñas', style: AppText.labelS.copyWith(fontSize: 13)),
                        TextSpan(text: '  ·  ${vendor.location} y alrededores', style: AppText.muted(AppText.bodyS)),
                      ])),
                      const SizedBox(height: 18),
                      Text(
                        'Trabajo documental y natural. Cubrimos desde los preparativos hasta la fiesta, sin poses forzadas. Entrega en 6 semanas con galería online.',
                        style: AppText.muted(AppText.bodyM),
                      ),
                      const SizedBox(height: 24),
                      const SectionHeader('Paquetes'),
                      for (final p in Mock.packages)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: AppCard(
                            border: Border.all(color: AppColors.borderDefault),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.name, style: AppText.labelM),
                                      Text(p.detail, style: AppText.muted(AppText.bodyS)),
                                    ],
                                  ),
                                ),
                                Text(p.price, style: AppText.headingM),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      const SectionHeader('Disponibilidad', trailing: StatusChip('Libre tu fecha', tone: StatusTone.success)),
                      const SizedBox(height: 10),
                      const AppCard(child: MarchCalendar()),
                      const SizedBox(height: 24),
                      const SectionHeader('Reseñas'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(rating, style: AppText.displayNumber),
                              Text('${vendor.reviews} reseñas', style: AppText.muted(AppText.bodyS)),
                            ],
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              children: [
                                for (final (stars, value) in const [(5, 0.9), (4, 0.08), (3, 0.02)])
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      children: [
                                        Text('$stars', style: AppText.muted(AppText.labelS)),
                                        const SizedBox(width: 8),
                                        Expanded(child: AppProgress(value: value, height: 6)),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      for (final r in Mock.vendorReviews.where((r) => r.stars == 5))
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Text(r.author, style: AppText.labelM)),
                                    Text('★' * r.stars, style: const TextStyle(color: AppColors.brass, fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(r.text, style: AppText.bodyS),
                                const SizedBox(height: 6),
                                Text(r.date, style: AppText.muted(AppText.bodyS).copyWith(fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Barra fija inferior
          DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.backgroundPrimary,
              border: Border(top: BorderSide(color: AppColors.borderDefault)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(Space.screen, 12, Space.screen, 12),
                child: Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.borderDefault)),
                      child: FavoriteButton(vendorId: vendor.id, size: 48),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        label: 'Solicitar cotización',
                        onPressed: () => Navigator.pushNamed(context, Routes.requestQuote, arguments: vendor),
                      ),
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

/// Calendario de marzo de 2027 con la fecha de la boda y los días reservados.
class MarchCalendar extends StatelessWidget {
  const MarchCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Marzo 2027', style: AppText.labelM),
        const SizedBox(height: 10),
        Row(
          children: [
            for (final d in const ['L', 'M', 'M', 'J', 'V', 'S', 'D'])
              Expanded(child: Center(child: Text(d, style: AppText.muted(AppText.labelXS)))),
          ],
        ),
        const SizedBox(height: 6),
        for (var week = 0; week < 5; week++)
          Row(
            children: [
              for (var dow = 0; dow < 7; dow++)
                Expanded(child: _day(week * 7 + dow + 1)),
            ],
          ),
      ],
    );
  }

  Widget _day(int n) {
    if (n > 31) return const SizedBox(height: 36);
    final mine = n == 13;
    final booked = Mock.bookedMarchDays.contains(n);
    return Container(
      height: 36,
      margin: const EdgeInsets.all(1),
      alignment: Alignment.center,
      decoration: mine ? const BoxDecoration(color: AppColors.ink, shape: BoxShape.circle) : null,
      child: Text(
        '$n',
        style: AppText.bodyS.copyWith(
          color: mine ? AppColors.textOnInk : (booked ? AppColors.textSecondary : AppColors.textPrimary),
          decoration: booked ? TextDecoration.lineThrough : null,
          fontWeight: mine ? FontWeight.w600 : null,
        ),
      ),
    );
  }
}
