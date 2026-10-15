import 'package:flutter/widgets.dart';

import '../data/mock_data.dart';
import '../data/models.dart';

/// Estado en memoria de la app (sin backend todavía).
///
/// Cuando conectes Firebase o Supabase, este es el lugar para reemplazar
/// los valores de ejemplo por llamadas reales.
class AppState extends ChangeNotifier {
  // Favoritos
  final Set<String> _favorites = {'alma'};
  bool isFavorite(String id) => _favorites.contains(id);
  void toggleFavorite(String id) {
    _favorites.contains(id) ? _favorites.remove(id) : _favorites.add(id);
    notifyListeners();
  }

  // Checklist
  final Set<String> _doneTasks = {'r1', 'r4'};
  final List<TaskItem> customTasks = [];
  bool isDone(String id) => _doneTasks.contains(id);
  void toggleTask(String id) {
    _doneTasks.contains(id) ? _doneTasks.remove(id) : _doneTasks.add(id);
    notifyListeners();
  }

  void addTask(String title, String meta) {
    customTasks.add(TaskItem(id: 'c${customTasks.length}', title: title, meta: meta));
    notifyListeners();
  }

  int get tasksDone => Mock.completedOutsideList + _doneTasks.length;
  int get tasksTotal => Mock.totalTasks + customTasks.length;

  // Cotización de Luz de Campo
  QuoteStatus quoteStatus = QuoteStatus.pending;
  void setQuoteStatus(QuoteStatus s) {
    quoteStatus = s;
    notifyListeners();
  }

  // Presupuesto
  bool casonaPaid = false;
  void registerCasonaPayment() {
    casonaPaid = true;
    notifyListeners();
  }

  String get budgetPaid => casonaPaid ? r'$4.500.000' : r'$2.550.000';
  String get budgetDue => casonaPaid ? r'$4.450.000' : r'$6.400.000';

  // Mesas
  final Map<String, int> _seated = {}; // id invitado -> índice de mesa
  final Map<int, int> _extraAtTable = {};
  String? selectedGuest;

  void selectGuest(String? id) {
    selectedGuest = selectedGuest == id ? null : id;
    notifyListeners();
  }

  void seatSelectedAt(int tableIndex) {
    final id = selectedGuest;
    if (id == null) return;
    final guest = Mock.unseatedGuests.firstWhere((g) => g.id == id);
    _seated[id] = tableIndex;
    _extraAtTable[tableIndex] = (_extraAtTable[tableIndex] ?? 0) + guest.seats;
    selectedGuest = null;
    notifyListeners();
  }

  bool isSeated(String id) => _seated.containsKey(id);
  int occupiedAt(int tableIndex) => Mock.tables[tableIndex].occupied + (_extraAtTable[tableIndex] ?? 0);
  int get seatedCount => 65 + _extraAtTable.values.fold(0, (a, b) => a + b);

  // Invitaciones
  final Set<String> _inviteOff = {};
  bool isInviteSelected(String name) => !_inviteOff.contains(name);
  void toggleInvite(String name) {
    _inviteOff.contains(name) ? _inviteOff.remove(name) : _inviteOff.add(name);
    notifyListeners();
  }

  void selectAllInvites() {
    _inviteOff.clear();
    notifyListeners();
  }

  int get invitesSelected => Mock.inviteRecipients.length - _inviteOff.length;

  // Calendario del proveedor (marzo 2027)
  final Map<int, DayStatus> _days = {
    for (final d in Mock.bookedMarchDays) d: DayStatus.booked,
    for (final d in Mock.blockedMarchDays) d: DayStatus.blocked,
  };
  DayStatus dayStatus(int day) => _days[day] ?? DayStatus.available;
  void setDayStatus(int day, DayStatus s) {
    _days[day] = s;
    notifyListeners();
  }

  // Reseñas respondidas por el proveedor
  final Set<String> _replied = {};
  bool isReplied(String id) => _replied.contains(id);
  void reply(String id) {
    _replied.add(id);
    notifyListeners();
  }
}

/// Expone [AppState] a todo el árbol de widgets y reconstruye al cambiar.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child}) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No hay AppScope sobre este widget');
    return scope!.notifier!;
  }
}
