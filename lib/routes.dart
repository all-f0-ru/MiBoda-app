/// Nombres de rutas de la app.
class Routes {
  Routes._();

  // Acceso y onboarding
  static const splash = '/';
  static const login = '/login';
  static const role = '/rol';
  static const onboardingDate = '/onboarding/fecha';
  static const onboardingBudget = '/onboarding/presupuesto';

  // Novios: pestañas
  static const coupleHome = '/novios';
  static const marketplaceTab = '/novios/proveedores';
  static const checklistTab = '/novios/checklist';
  static const guestsTab = '/novios/invitados';
  static const coupleProfileTab = '/novios/perfil';

  // Novios: pantallas secundarias
  static const notifications = '/notificaciones';
  static const marketplaceLoading = '/proveedores/cargando';
  static const vendorProfile = '/proveedor-publico';
  static const requestQuote = '/cotizacion/solicitar';
  static const messages = '/mensajes';
  static const messagesEmpty = '/mensajes/vacio';
  static const chat = '/chat';
  static const quoteAccepted = '/cotizacion/aceptada';
  static const budget = '/presupuesto';
  static const sendInvites = '/invitaciones/enviar';

  // Proveedor: pestañas
  static const vendorHome = '/proveedor';
  static const vendorRequestsTab = '/proveedor/solicitudes';
  static const vendorCalendarTab = '/proveedor/calendario';
  static const vendorMessagesTab = '/proveedor/mensajes';
  static const vendorReviewsTab = '/proveedor/resenas';

  // Proveedor: pantallas secundarias
  static const requestDetail = '/proveedor/solicitud';
  static const createQuote = '/proveedor/cotizacion';

  // Estados
  static const offline = '/sin-conexion';

  static const coupleTabs = [coupleHome, marketplaceTab, checklistTab, guestsTab, coupleProfileTab];
  static const vendorTabs = [vendorHome, vendorRequestsTab, vendorCalendarTab, vendorMessagesTab, vendorReviewsTab];
}
