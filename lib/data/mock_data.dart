import 'package:flutter/material.dart';

import '../routes.dart';
import '../theme/colors.dart';
import 'models.dart';

/// Datos de ejemplo (Chile). Reemplazar por un repositorio real al conectar el backend.
class Mock {
  Mock._();

  static const coupleNames = 'María y Juan';
  static const weddingDate = 'Sáb 13 mar 2027';
  static const weddingPlace = 'Pirque';
  static const venue = 'Casona El Roble, Pirque';
  static const budgetTotal = r'$18.000.000';

  static final vendors = <Vendor>[
    const Vendor(id: 'luz', category: 'FOTOGRAFÍA', name: 'Luz de Campo', rating: 4.9, reviews: 128, location: 'Pirque', priceFrom: r'Desde $850.000', photo: Color(0xFFE7CFC6)),
    const Vendor(id: 'alma', category: 'BANQUETERÍA', name: 'Banquetería Alma', rating: 4.9, reviews: 211, location: 'Colina', priceFrom: r'Desde $32.000 p/p', photo: Color(0xFFDCCCB3)),
    const Vendor(id: 'maqui', category: 'FLORISTERÍA', name: 'Flor de Maqui', rating: 4.7, reviews: 54, location: 'Providencia', priceFrom: r'Desde $380.000', photo: Color(0xFFD1D9C9)),
    const Vendor(id: 'andes', category: 'MÚSICA / DJ', name: 'Sonido Andes', rating: 4.8, reviews: 77, location: 'Santiago', priceFrom: r'Desde $450.000', photo: Color(0xFFEDDBCC)),
    const Vendor(id: 'dulce', category: 'PASTELERÍA', name: 'Dulce Ceremonia', rating: 4.6, reviews: 41, location: 'Ñuñoa', priceFrom: r'Desde $180.000', photo: Color(0xFFF1E8DD)),
    const Vendor(id: 'roble', category: 'CENTRO DE EVENTOS', name: 'Casona El Roble', rating: 4.8, reviews: 96, location: 'Pirque', priceFrom: r'Desde $6.500.000', photo: Color(0xFFE2D6C8)),
  ];

  static const vendorCategories = ['Todos', 'Fotografía', 'Centro de eventos', 'Banquetería', 'Floristería', 'Música / DJ'];

  static const packages = [
    VendorPackage('Esencial', '6 h · 1 fotógrafo · 250 fotos', r'$850.000'),
    VendorPackage('Cobertura completa + álbum', '10 h · 2 fotógrafos · 400 fotos', r'$1.250.000'),
    VendorPackage('Foto + video', '10 h · video resumen de 4 min', r'$2.400.000'),
  ];

  static const vendorReviews = [
    Review(id: 'a', author: 'Fernanda y Tomás', stars: 5, text: 'Capturaron todo sin que nos diéramos cuenta. Las fotos de la fiesta son increíbles.', date: '12 feb 2026'),
    Review(id: 'b', author: 'Constanza y Matías', stars: 4, text: 'Muy lindas fotos. La entrega se atrasó una semana, pero avisaron con tiempo.', date: '3 feb 2026'),
    Review(
      id: 'c',
      author: 'Daniela y Pablo',
      stars: 5,
      text: 'Muy profesionales, puntuales y la entrega llegó antes de lo prometido.',
      date: '20 ene 2026',
      reply: '¡Gracias, Dani y Pablo! Fue un placer acompañarlos.',
    ),
  ];

  static const reviewReplies = {
    'a': '¡Gracias, Feña y Tomás! Fue un placer acompañarlos.',
    'b': '¡Gracias, Coni y Mati! Tienen razón con el plazo; ya ajustamos nuestro proceso de edición.',
  };

  static const taskGroups = [
    TaskGroup('6 A 12 MESES ANTES', [
      TaskItem(id: 'r1', title: 'Reservar centro de eventos', meta: 'Completada · 2 sep'),
      TaskItem(id: 'r2', title: 'Contratar banquetería', meta: 'Vencida hace 2 días · María', overdue: true),
      TaskItem(id: 'r3', title: 'Elegir fotógrafo', meta: 'Vence 30 oct · Juan'),
      TaskItem(id: 'r4', title: 'Comprar vestido', meta: 'Completada · 20 sep'),
    ]),
    TaskGroup('3 A 6 MESES ANTES', [
      TaskItem(id: 'r5', title: 'Enviar invitaciones', meta: 'Vence 15 nov · Ambos'),
      TaskItem(id: 'r6', title: 'Contratar música / DJ', meta: 'Vence 30 nov · Juan'),
      TaskItem(id: 'r7', title: 'Prueba de maquillaje', meta: 'Vence 15 dic · María'),
    ]),
    TaskGroup('1 A 3 MESES ANTES', [
      TaskItem(id: 'r8', title: 'Confirmar menú y degustación', meta: 'Vence 15 ene · Ambos'),
      TaskItem(id: 'r9', title: 'Distribución de mesas', meta: 'Vence 20 feb · María'),
    ]),
  ];

  /// Tareas que ya estaban completadas antes de las que muestra la lista (12+ meses, etc.).
  static const totalTasks = 66;
  static const completedOutsideList = 40;

  static const guests = [
    Guest(id: 'cm', initials: 'CM', name: 'Carolina Muñoz', group: 'Familia novia', extra: '+1 · Vegetariana', rsvp: Rsvp.confirmed, seats: 2),
    Guest(id: 'ag', initials: 'AG', name: 'Ana González (tía)', group: 'Familia novia', extra: '+1', rsvp: Rsvp.notSent, seats: 2),
    Guest(id: 'ps', initials: 'PS', name: 'Pedro Soto', group: 'Familia novio', extra: 'Celíaco', rsvp: Rsvp.confirmed),
    Guest(id: 'jr', initials: 'JR', name: 'Javiera Rojas', group: 'Amigos', extra: '+1', rsvp: Rsvp.pending, seats: 2),
    Guest(id: 'ip', initials: 'IP', name: 'Ignacio Pérez', group: 'Trabajo', rsvp: Rsvp.declined),
    Guest(id: 'ff', initials: 'FF', name: 'Familia Fuentes', group: 'Familia novio', extra: '4 personas · 2 niños', rsvp: Rsvp.pending, seats: 4),
    Guest(id: 'vd', initials: 'VD', name: 'Valentina Díaz', group: 'Amigos', extra: 'Vegana', rsvp: Rsvp.confirmed),
  ];

  static const guestGroups = ['Todos', 'Familia novia', 'Familia novio', 'Amigos', 'Trabajo'];

  static const unseatedGuests = [
    Guest(id: 'cm', initials: 'CM', name: 'Carolina M. +1', group: '', rsvp: Rsvp.confirmed, seats: 2),
    Guest(id: 'ps', initials: 'PS', name: 'Pedro S.', group: '', rsvp: Rsvp.confirmed),
    Guest(id: 'jr', initials: 'JR', name: 'Javiera R. +1', group: '', rsvp: Rsvp.pending, seats: 2),
    Guest(id: 'vd', initials: 'VD', name: 'Valentina D.', group: '', rsvp: Rsvp.confirmed),
    Guest(id: 'tl', initials: 'TL', name: 'Tomás L.', group: '', rsvp: Rsvp.confirmed),
    Guest(id: 'sa', initials: 'SA', name: 'Sofía A. +1', group: '', rsvp: Rsvp.confirmed, seats: 2),
  ];

  static const tables = [
    SeatingTable('Novios', 10, 10),
    SeatingTable('Mesa 1', 8, 8),
    SeatingTable('Mesa 2', 6, 8),
    SeatingTable('Mesa 3', 7, 8),
    SeatingTable('Mesa 4', 9, 8),
    SeatingTable('Mesa 5', 8, 8),
    SeatingTable('Mesa 6', 5, 8),
    SeatingTable('Mesa 7', 8, 8),
    SeatingTable('Mesa 8', 4, 8),
  ];

  static const inviteRecipients = [
    ['Ana González (tía)', '+56 9 5123 4410'],
    ['Tomás Lagos', '+56 9 7781 0932'],
    ['Sofía Araya', '+56 9 6654 2287'],
    ['Martín Silva', '+56 9 9012 3456'],
    ['Familia Herrera', '+56 9 8890 1122'],
    ['Rocío Vidal', '+56 9 4432 1180'],
    ['Diego Bravo', '+56 9 3321 7765'],
  ];

  static const coupleConversations = [
    Conversation(initials: 'LC', name: 'Luz de Campo Fotografía', lastMessage: 'Te envié la cotización', time: '10:24', unread: 2),
    Conversation(initials: 'FM', name: 'Flor de Maqui', lastMessage: '¿Prefieren flores de estación o peonías?', time: 'Ayer', unread: 1),
    Conversation(initials: 'CR', name: 'Casona El Roble', lastMessage: 'Perfecto, quedan reservados', time: 'Lun'),
    Conversation(initials: 'SA', name: 'Sonido Andes', lastMessage: 'Te comparto la lista de canciones sugeridas', time: '12 oct'),
    Conversation(initials: 'AN', name: 'Atelier Noa', lastMessage: 'La prueba de vestido es el 4 de diciembre', time: '8 oct'),
  ];

  static const vendorConversations = [
    Conversation(initials: 'MJ', name: 'María y Juan', lastMessage: r'Tú: Cotización · $1.250.000', time: 'Ahora'),
    Conversation(initials: 'CD', name: 'Catalina y Diego', lastMessage: '¿Incluye sesión preboda?', time: '09:15', unread: 2),
    Conversation(initials: 'FT', name: 'Fernanda y Tomás', lastMessage: 'Les comparto el cronograma del día', time: 'Ayer'),
    Conversation(initials: 'PA', name: 'Pía y Andrés', lastMessage: 'Perfecto, nos vemos en la prueba de luz', time: 'Lun'),
  ];

  static const budgetCategories = [
    BudgetCategory('Centro de eventos', r'$6.500.000', r'est. $6.000.000 · excedido en $500.000', 1, over: true),
    BudgetCategory('Fotografía', r'$1.250.000', r'est. $1.500.000', 0.83),
    BudgetCategory('Vestido y traje', r'$1.200.000', r'est. $1.400.000', 0.86),
    BudgetCategory('Banquetería', r'$0', r'est. $4.800.000', 0),
    BudgetCategory('Floristería y deco', r'$0', r'est. $1.300.000', 0),
    BudgetCategory('Música / DJ', r'$0', r'est. $800.000', 0),
  ];

  static final notifications = <(String, List<AppNotification>)>[
    (
      'HOY',
      const [
        AppNotification(icon: Icons.chat_bubble_outline, tone: StatusTone.info, text: r'Luz de Campo te envió una cotización: $1.250.000', time: 'Hace 10 min', route: Routes.chat, unread: true),
        AppNotification(icon: Icons.check, tone: StatusTone.success, text: 'Carolina Muñoz confirmó asistencia (+1)', time: 'Hace 2 h', route: Routes.guestsTab, unread: true),
      ],
    ),
    (
      'ESTA SEMANA',
      const [
        AppNotification(icon: Icons.schedule, tone: StatusTone.warning, text: 'Contratar banquetería vence en 5 días', time: 'Ayer', route: Routes.checklistTab),
        AppNotification(icon: Icons.account_balance_wallet_outlined, tone: StatusTone.warning, text: r'Abono a Casona El Roble vence el 30 oct: $1.950.000', time: 'Lunes', route: Routes.budget),
        AppNotification(icon: Icons.star_outline, tone: StatusTone.neutral, text: 'Flor de Maqui respondió tu solicitud', time: 'Domingo', route: Routes.messages),
      ],
    ),
  ];

  static const requestsByTab = {
    'Nuevas': [
      QuoteRequest(initials: 'MJ', couple: 'María y Juan', ago: 'Hace 2 h', summary: r'13 mar 2027 · 120 invitados · $1–1,5M', status: 'Nueva', tone: StatusTone.info),
      QuoteRequest(initials: 'CD', couple: 'Catalina y Diego', ago: 'Hace 5 h', summary: r'24 abr 2027 · 80 invitados · $800 mil', status: 'Nueva', tone: StatusTone.info),
      QuoteRequest(initials: 'IF', couple: 'Isidora y Felipe', ago: 'Hace 1 día', summary: r'9 ene 2027 · 150 invitados · $2M', status: 'Responde hoy', tone: StatusTone.warning),
    ],
    'Cotizadas': [
      QuoteRequest(initials: 'RS', couple: 'Rocío y Sebastián', ago: 'Enviada hace 2 días', summary: r'17 abr 2027 · $1.250.000', status: 'Esperando', tone: StatusTone.warning),
      QuoteRequest(initials: 'AL', couple: 'Antonia y Lucas', ago: 'Enviada hace 4 días', summary: r'5 jun 2027 · $850.000', status: 'Vista', tone: StatusTone.info),
    ],
    'Aceptadas': [
      QuoteRequest(initials: 'FT', couple: 'Fernanda y Tomás', ago: 'Aceptada 12 ago', summary: r'6 mar 2027 · $2.400.000', status: 'Contratado', tone: StatusTone.success),
      QuoteRequest(initials: 'PA', couple: 'Pía y Andrés', ago: 'Aceptada 2 sep', summary: r'20 mar 2027 · $850.000', status: 'Contratado', tone: StatusTone.success),
    ],
    'Rechazadas': [
      QuoteRequest(initials: 'CM', couple: 'Coni y Martín', ago: 'Hace 3 semanas', summary: 'Motivo: el precio es alto', status: 'Rechazada', tone: StatusTone.error),
    ],
  };

  static const requestTabCounts = {'Nuevas': 3, 'Cotizadas': 5, 'Aceptadas': 8, 'Rechazadas': 2};

  static const quotePackages = [
    QuotePackage('Esencial', r'$850.000', r'30% · $255.000', [
      QuoteLine('Cobertura 6 horas', '1 fotógrafo · 250 fotos', r'$850.000'),
    ]),
    QuotePackage('Cobertura completa', r'$1.250.000', r'30% · $375.000', [
      QuoteLine('Cobertura 10 horas', '2 fotógrafos · 400 fotos', r'$950.000'),
      QuoteLine('Álbum 30×30', '40 páginas, tapa de lino', r'$200.000'),
      QuoteLine('Sesión preboda', '1 hora en exterior', r'$100.000'),
    ]),
    QuotePackage('Foto + video', r'$2.400.000', r'30% · $720.000', [
      QuoteLine('Cobertura 10 horas', '2 fotógrafos · 400 fotos', r'$950.000'),
      QuoteLine('Video resumen', '4 minutos + ceremonia completa', r'$1.250.000'),
      QuoteLine('Álbum 30×30', '40 páginas', r'$200.000'),
    ]),
  ];

  /// Marzo de 2027: el día 1 cae lunes.
  static const marchFirstWeekday = DateTime.monday;
  static const bookedMarchDays = {6, 20, 27};
  static const blockedMarchDays = {14, 21, 28};

  static Color photoFor(int i) => AppColors.photoPalette[i % AppColors.photoPalette.length];
}
