import 'package:flutter/material.dart';

import '../routes.dart';
import '../screens/couple/checklist_screen.dart';
import '../screens/couple/couple_profile_screen.dart';
import '../screens/couple/dashboard_screen.dart';
import '../screens/couple/guests_screen.dart';
import '../screens/couple/marketplace_screen.dart';
import '../screens/vendor/vendor_calendar_screen.dart';
import '../screens/vendor/vendor_messages_screen.dart';
import '../screens/vendor/vendor_panel_screen.dart';
import '../screens/vendor/vendor_requests_screen.dart';
import '../screens/vendor/vendor_reviews_screen.dart';

enum ShellKind { couple, vendor }

/// Permite a las pestañas cambiar de pestaña sin crear otra pantalla.
class ShellScope extends InheritedWidget {
  const ShellScope({super.key, required this.kind, required this.select, required super.child});

  final ShellKind kind;
  final ValueChanged<int> select;

  static ShellScope? maybeOf(BuildContext context) => context.dependOnInheritedWidgetOfExactType<ShellScope>();

  @override
  bool updateShouldNotify(ShellScope oldWidget) => kind != oldWidget.kind;
}

/// Navega a cualquier ruta. Si es una pestaña del shell actual, solo cambia de pestaña.
void goTo(BuildContext context, String route) {
  final shell = ShellScope.maybeOf(context);
  final coupleIdx = Routes.coupleTabs.indexOf(route);
  final vendorIdx = Routes.vendorTabs.indexOf(route);

  if (shell != null && shell.kind == ShellKind.couple && coupleIdx >= 0) {
    shell.select(coupleIdx);
    return;
  }
  if (shell != null && shell.kind == ShellKind.vendor && vendorIdx >= 0) {
    shell.select(vendorIdx);
    return;
  }
  if (coupleIdx >= 0 || vendorIdx >= 0) {
    // Volver a un shell desde una pantalla secundaria: se reinicia la pila.
    Navigator.of(context).pushNamedAndRemoveUntil(route, (_) => false);
    return;
  }
  Navigator.of(context).pushNamed(route);
}

class _TabSpec {
  const _TabSpec(this.label, this.icon, this.selectedIcon);
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class _Shell extends StatefulWidget {
  const _Shell({required this.kind, required this.initialIndex, required this.pages, required this.tabs});

  final ShellKind kind;
  final int initialIndex;
  final List<Widget> pages;
  final List<_TabSpec> tabs;

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  late int _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return ShellScope(
      kind: widget.kind,
      select: (i) => setState(() => _index = i),
      child: Scaffold(
        body: SafeArea(bottom: false, child: IndexedStack(index: _index, children: widget.pages)),
        bottomNavigationBar: DecoratedBox(
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFE2D6C8)))),
          child: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              for (final t in widget.tabs)
                NavigationDestination(icon: Icon(t.icon), selectedIcon: Icon(t.selectedIcon), label: t.label),
            ],
          ),
        ),
      ),
    );
  }
}

/// Navegación principal de los novios.
class CoupleShell extends StatelessWidget {
  const CoupleShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return _Shell(
      kind: ShellKind.couple,
      initialIndex: initialIndex,
      pages: const [DashboardScreen(), MarketplaceScreen(), ChecklistScreen(), GuestsScreen(), CoupleProfileScreen()],
      tabs: const [
        _TabSpec('Inicio', Icons.home_outlined, Icons.home),
        _TabSpec('Proveedores', Icons.storefront_outlined, Icons.storefront),
        _TabSpec('Checklist', Icons.check_box_outlined, Icons.check_box),
        _TabSpec('Invitados', Icons.people_outline, Icons.people),
        _TabSpec('Perfil', Icons.person_outline, Icons.person),
      ],
    );
  }
}

/// Navegación principal del proveedor.
class VendorShell extends StatelessWidget {
  const VendorShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return _Shell(
      kind: ShellKind.vendor,
      initialIndex: initialIndex,
      pages: const [VendorPanelScreen(), VendorRequestsScreen(), VendorCalendarScreen(), VendorMessagesScreen(), VendorReviewsScreen()],
      tabs: const [
        _TabSpec('Panel', Icons.grid_view_outlined, Icons.grid_view_rounded),
        _TabSpec('Solicitudes', Icons.inbox_outlined, Icons.inbox),
        _TabSpec('Calendario', Icons.calendar_month_outlined, Icons.calendar_month),
        _TabSpec('Mensajes', Icons.chat_bubble_outline, Icons.chat_bubble),
        _TabSpec('Reseñas', Icons.star_outline, Icons.star),
      ],
    );
  }
}
