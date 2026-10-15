import 'package:flutter/material.dart';

import '../data/models.dart';
import '../state/app_state.dart';
import '../theme/colors.dart';
import '../theme/text.dart';
import '../theme/tokens.dart';
import 'chips.dart';
import 'layout.dart';

/// Botón de favorito: alterna el corazón sin cambiar de pantalla.
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.vendorId, this.size = 36});

  final String vendorId;
  final double size;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final on = state.isFavorite(vendorId);
    return Semantics(
      button: true,
      toggled: on,
      label: on ? 'Quitar de favoritos' : 'Guardar en favoritos',
      child: Material(
        color: AppColors.surfaceWhite,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => state.toggleFavorite(vendorId),
          child: SizedBox.square(
            dimension: size,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Icon(
                on ? Icons.favorite : Icons.favorite_border,
                key: ValueKey(on),
                size: size * 0.55,
                color: AppColors.brass,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tarjeta de proveedor del marketplace.
class VendorCard extends StatelessWidget {
  const VendorCard({super.key, required this.vendor, required this.onTap});

  final Vendor vendor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Material(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(Radii.card),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PhotoPlaceholder(color: vendor.photo, height: 120, width: double.infinity, radius: 0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vendor.category, style: AppText.labelXS.copyWith(color: AppColors.brassText)),
                      const SizedBox(height: 2),
                      Text(vendor.name, style: AppText.headingM.copyWith(fontSize: 17), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(
                        '★ ${vendor.rating.toStringAsFixed(1).replaceAll('.', ',')} (${vendor.reviews}) · ${vendor.location}',
                        style: AppText.muted(AppText.bodyS).copyWith(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(vendor.priceFrom, style: AppText.labelS.copyWith(fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(top: 8, right: 8, child: FavoriteButton(vendorId: vendor.id)),
      ],
    );
  }
}

/// Casilla de verificación de la marca.
class BrandCheckbox extends StatelessWidget {
  const BrandCheckbox({super.key, required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: checked ? AppColors.ink : AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(7),
        border: checked ? null : Border.all(color: AppColors.brassDeep, width: 1.5),
      ),
      child: checked ? const Icon(Icons.check, size: 16, color: AppColors.textOnInk) : null,
    );
  }
}

/// Fila de tarea con checkbox que alterna en el lugar.
class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

  final TaskItem task;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final done = state.isDone(task.id);
    return Semantics(
      checked: done,
      child: Material(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => state.toggleTask(task.id),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                BrandCheckbox(checked: done),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: AppText.bodyM.copyWith(
                          color: done ? AppColors.textSecondary : AppColors.textPrimary,
                          decoration: done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      Text(
                        task.meta,
                        style: AppText.bodyS.copyWith(color: task.overdue && !done ? AppColors.error : AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Fila de invitado con chip RSVP.
class GuestTile extends StatelessWidget {
  const GuestTile({super.key, required this.guest, this.onTap});

  final Guest guest;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final meta = guest.extra.isEmpty ? guest.group : '${guest.group} · ${guest.extra}';
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Initials(guest.initials),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(guest.name, style: AppText.labelM),
                  Text(meta, style: AppText.muted(AppText.bodyS)),
                ],
              ),
            ),
            rsvpChip(guest.rsvp),
          ],
        ),
      ),
    );
  }
}

/// Fila de conversación con badge de no leídos.
class ConversationTile extends StatelessWidget {
  const ConversationTile({super.key, required this.conversation, required this.onTap});

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = conversation;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.screen, vertical: 14),
        child: Row(
          children: [
            Initials(c.initials, size: 48),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.name, style: AppText.labelM),
                  const SizedBox(height: 3),
                  Text(c.lastMessage, style: AppText.muted(AppText.bodyS), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(c.time, style: AppText.muted(AppText.bodyS).copyWith(fontSize: 12)),
                const SizedBox(height: 6),
                if (c.unread > 0)
                  Container(
                    constraints: const BoxConstraints(minWidth: 20),
                    height: 20,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(10)),
                    child: Text('${c.unread}', style: AppText.labelXS.copyWith(color: AppColors.textOnInk, letterSpacing: 0)),
                  )
                else
                  const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta de solicitud de cotización (vista proveedor).
class RequestCard extends StatelessWidget {
  const RequestCard({super.key, required this.request, required this.onTap});

  final QuoteRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = request;
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Initials(r.initials),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.couple, style: AppText.labelM),
                    Text(r.ago, style: AppText.muted(AppText.bodyS)),
                  ],
                ),
              ),
              StatusChip(r.status, tone: r.tone),
            ],
          ),
          const SizedBox(height: 10),
          Text(r.summary, style: AppText.muted(AppText.bodyS)),
        ],
      ),
    );
  }
}

/// Fila "clave · valor" para resúmenes.
class KeyValueRow extends StatelessWidget {
  const KeyValueRow(this.label, this.value, {super.key, this.valueStyle, this.trailing});

  final String label;
  final String value;
  final TextStyle? valueStyle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: AppText.muted(AppText.bodyM)),
        const SizedBox(width: 12),
        Expanded(child: Text(value, style: valueStyle ?? AppText.labelM, textAlign: TextAlign.right)),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    );
  }
}

/// Elemento de menú con ícono y flecha (perfil).
class MenuRow extends StatelessWidget {
  const MenuRow({super.key, required this.icon, required this.label, required this.onTap, this.danger = false});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.error : AppColors.textPrimary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: danger ? AppColors.error : AppColors.brassDeep),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppText.bodyM.copyWith(color: color))),
            if (!danger) const Icon(Icons.chevron_right, size: 20, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

/// Grupo de filas dentro de una tarjeta blanca con divisores.
class MenuGroup extends StatelessWidget {
  const MenuGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceWhite,
      borderRadius: BorderRadius.circular(Radii.card),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.backgroundSecondary),
            children[i],
          ],
        ],
      ),
    );
  }
}
