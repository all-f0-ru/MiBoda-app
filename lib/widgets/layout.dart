import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/text.dart';
import '../theme/tokens.dart';
import 'brand.dart';
import 'buttons.dart';

/// Barra superior con botón atrás y título centrado.
class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackAppBar({super.key, required this.title, this.actions, this.background});

  final String title;
  final List<Widget>? actions;
  final Color? background;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: background,
      title: Text(title),
      leading: IconButton(
        tooltip: 'Volver',
        icon: const Icon(Icons.chevron_left, size: 28),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      actions: actions ?? const [SizedBox(width: 48)],
    );
  }
}

/// Lista con el margen lateral estándar de la app.
class ScreenList extends StatelessWidget {
  const ScreenList({super.key, required this.children, this.gap = Space.lg, this.top = Space.xl, this.bottom = Space.xl});

  final List<Widget> children;
  final double gap;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(Space.screen, top, Space.screen, bottom),
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          children[i],
        ],
      ],
    );
  }
}

/// Tarjeta blanca con radio 16 y sombra suave. Si tiene [onTap], es tocable.
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.all(Space.lg), this.color = AppColors.surfaceWhite, this.border});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Color color;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(Radii.card);
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: radius,
        border: border,
        boxShadow: color == AppColors.surfaceWhite && border == null
            ? const [BoxShadow(color: Color(0x143A322C), blurRadius: 8, offset: Offset(0, 2))]
            : null,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Título de sección con acción opcional a la derecha ("Ver todas").
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action, this.onAction, this.trailing});

  final String title;
  final String? action;
  final VoidCallback? onAction;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppText.headingM)),
        if (trailing != null) trailing!,
        if (action != null && onAction != null) TextLink(action!, onTap: onAction!),
      ],
    );
  }
}

/// Etiqueta en mayúsculas pequeñas (HOY, 6 A 12 MESES ANTES...).
class OverlineLabel extends StatelessWidget {
  const OverlineLabel(this.text, {super.key, this.color = AppColors.textSecondary});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Text(text, style: AppText.labelXS.copyWith(color: color));
}

/// Barra de progreso de la marca.
class AppProgress extends StatelessWidget {
  const AppProgress({super.key, required this.value, this.color = AppColors.brass, this.track = AppColors.backgroundSecondary, this.height = 8});

  final double value;
  final Color color;
  final Color track;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: track)),
            FractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0),
              child: DecoratedBox(
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(height / 2)),
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bloque de color en lugar de foto (hasta tener imágenes reales).
class PhotoPlaceholder extends StatelessWidget {
  const PhotoPlaceholder({super.key, required this.color, this.width, this.height, this.radius = 12, this.showIcon = true});

  final Color color;
  final double? width;
  final double? height;
  final double radius;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(radius)),
      alignment: Alignment.center,
      child: showIcon ? const Icon(Icons.image_outlined, color: AppColors.brass, size: 26, semanticLabel: 'Foto') : null,
    );
  }
}

/// Avatar con iniciales.
class Initials extends StatelessWidget {
  const Initials(this.text, {super.key, this.size = 40});

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: AppColors.surfaceBlush, shape: BoxShape.circle),
      child: Text(text, style: AppText.labelM.copyWith(color: AppColors.brassDeep, fontSize: size * 0.34)),
    );
  }
}

/// Campo de texto con etiqueta arriba (los valores de ejemplo vienen precargados).
class LabeledField extends StatelessWidget {
  const LabeledField({super.key, required this.label, this.initialValue, this.hint, this.maxLines = 1, this.obscure = false, this.errorText, this.keyboardType});

  final String label;
  final String? initialValue;
  final String? hint;
  final int maxLines;
  final bool obscure;
  final String? errorText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppText.muted(AppText.labelS)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          maxLines: obscure ? 1 : maxLines,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: AppText.bodyM,
          decoration: InputDecoration(hintText: hint, errorText: errorText, errorMaxLines: 2),
        ),
      ],
    );
  }
}

/// Estado vacío: ilustración con el símbolo, título, texto y botón.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.title, required this.text, this.actionLabel, this.onAction, this.icon, this.iconTone});

  final String title;
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;
  final (Color, Color)? iconTone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = iconTone ?? (AppColors.backgroundSecondary, AppColors.brass);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.xl, vertical: Space.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 112,
            height: 112,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: icon != null ? Icon(icon, size: 48, color: fg) : const MiBodaSymbol(size: 56),
          ),
          const SizedBox(height: Space.lg),
          Text(title, style: AppText.headingL.copyWith(fontSize: 22), textAlign: TextAlign.center),
          const SizedBox(height: Space.sm),
          Text(text, style: AppText.muted(AppText.bodyM), textAlign: TextAlign.center),
          if (actionLabel != null) ...[
            const SizedBox(height: Space.xl),
            AppButton(label: actionLabel!, onPressed: onAction, expand: false),
          ],
        ],
      ),
    );
  }
}

/// Pantalla de éxito (círculo verde con check).
class SuccessView extends StatelessWidget {
  const SuccessView({super.key, required this.title, required this.text, required this.actions, this.extra});

  final String title;
  final String text;
  final List<Widget> actions;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 72, 24, 24),
        child: Column(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(color: AppColors.successBg, shape: BoxShape.circle),
              child: const Icon(Icons.check, size: 44, color: AppColors.success),
            ),
            const SizedBox(height: Space.lg),
            Text(title, style: AppText.headingL.copyWith(fontSize: 26), textAlign: TextAlign.center),
            const SizedBox(height: Space.sm),
            Text(text, style: AppText.muted(AppText.bodyM), textAlign: TextAlign.center),
            if (extra != null) ...[const SizedBox(height: Space.xl), extra!],
            const Spacer(),
            for (var i = 0; i < actions.length; i++) ...[
              if (i > 0) const SizedBox(height: Space.sm),
              actions[i],
            ],
          ],
        ),
      ),
    );
  }
}

/// Contenido base de un bottom sheet: manilla, título y botón cerrar.
class SheetScaffold extends StatelessWidget {
  const SheetScaffold({super.key, required this.title, required this.children, this.subtitle});

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(Space.screen, 10, Space.screen, Space.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(color: AppColors.borderDefault, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: Space.md),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppText.headingL),
                        if (subtitle != null) Text(subtitle!, style: AppText.muted(AppText.bodyS)),
                      ],
                    ),
                  ),
                  CircleIconButton(
                    icon: Icons.close,
                    tooltip: 'Cerrar',
                    size: 40,
                    background: AppColors.backgroundSecondary,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: Space.lg),
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const SizedBox(height: Space.lg),
                children[i],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

Future<T?> showAppSheet<T>(BuildContext context, Widget sheet) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    builder: (_) => sheet,
  );
}

void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
}

/// Wrap de chips con el espaciado estándar.
class ChipWrap extends StatelessWidget {
  const ChipWrap({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Wrap(spacing: Space.sm, runSpacing: Space.sm, children: children);
}

/// Etiqueta de grupo para formularios.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: AppText.muted(AppText.labelS));
}
