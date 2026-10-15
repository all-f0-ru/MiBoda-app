import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'navigation/shells.dart';
import 'routes.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/onboarding_budget_screen.dart';
import 'screens/auth/onboarding_date_screen.dart';
import 'screens/auth/role_screen.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/couple/budget_screen.dart';
import 'screens/couple/chat_screen.dart';
import 'screens/couple/marketplace_screen.dart';
import 'screens/couple/messages_screen.dart';
import 'screens/couple/notifications_screen.dart';
import 'screens/couple/quote_accepted_screen.dart';
import 'screens/couple/request_quote_screen.dart';
import 'screens/couple/send_invites_screen.dart';
import 'screens/couple/vendor_profile_screen.dart';
import 'screens/states/offline_screen.dart';
import 'screens/vendor/create_quote_screen.dart';
import 'screens/vendor/request_detail_screen.dart';
import 'state/app_state.dart';
import 'theme/theme.dart';

class MiBodaApp extends StatefulWidget {
  const MiBodaApp({super.key});

  @override
  State<MiBodaApp> createState() => _MiBodaAppState();
}

class _MiBodaAppState extends State<MiBodaApp> {
  final _state = AppState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: MaterialApp(
        title: 'MiBoda+',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        locale: const Locale('es', 'CL'),
        supportedLocales: const [Locale('es', 'CL'), Locale('es')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: Routes.splash,
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? Routes.splash;

    final coupleTab = Routes.coupleTabs.indexOf(name);
    if (coupleTab >= 0) return _page(settings, CoupleShell(initialIndex: coupleTab));
    final vendorTab = Routes.vendorTabs.indexOf(name);
    if (vendorTab >= 0) return _page(settings, VendorShell(initialIndex: vendorTab));

    final Widget screen = switch (name) {
      Routes.login => const LoginScreen(),
      Routes.role => const RoleScreen(),
      Routes.onboardingDate => const OnboardingDateScreen(),
      Routes.onboardingBudget => const OnboardingBudgetScreen(),
      Routes.notifications => const NotificationsScreen(),
      Routes.marketplaceLoading => const MarketplaceScreen(loading: true, standalone: true),
      Routes.vendorProfile => const VendorProfileScreen(),
      Routes.requestQuote => const RequestQuoteScreen(),
      Routes.messages => const MessagesScreen(),
      Routes.messagesEmpty => const MessagesScreen(empty: true),
      Routes.chat => const ChatScreen(),
      Routes.quoteAccepted => const QuoteAcceptedScreen(),
      Routes.budget => const BudgetScreen(),
      Routes.sendInvites => const SendInvitesScreen(),
      Routes.requestDetail => const RequestDetailScreen(),
      Routes.createQuote => const CreateQuoteScreen(),
      Routes.offline => const OfflineScreen(),
      _ => const SplashScreen(),
    };
    return _page(settings, screen);
  }

  // Transición instantánea entre pantallas, como en el prototipo.
  Route<dynamic> _page(RouteSettings settings, Widget child) => PageRouteBuilder(
        settings: settings,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => child,
      );
}
