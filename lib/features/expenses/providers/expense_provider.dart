import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masraf_app/features/expenses/models/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpenseState {
  final List<Expense> expenses;
  final bool isLoading;
  final String? error;

  const ExpenseState({
    this.expenses = const [],
    this.isLoading = false,
    this.error,
  });

  ExpenseState copyWith({
    List<Expense>? expenses,
    bool? isLoading,
    String? error,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ExpenseNotifier extends StateNotifier<ExpenseState> {
  ExpenseNotifier() : super(const ExpenseState(isLoading: true)) {
    _loadExpenses();
  }

  // Expenses getter
  List<Expense> get expenses => state.expenses;

  // State property getters
  bool get isLoading => state.isLoading;
  String? get error => state.error;

  Future<void> _loadExpenses() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('User not logged in');
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('expenses')
          .get();
      final expenses = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Expense.fromJson(data);
      }).toList();
      state = ExpenseState(expenses: expenses, isLoading: false);
    } catch (e) {
      state = ExpenseState(isLoading: false, error: e.toString());
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('User not logged in');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('expenses')
          .doc(expense.id)
          .set(expense.toJson());
      final newExpenses = [...state.expenses, expense];
      state = ExpenseState(expenses: newExpenses, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateExpense(Expense updatedExpense) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('User not logged in');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('expenses')
          .doc(updatedExpense.id)
          .update(updatedExpense.toJson());
      final newExpenses = state.expenses.map((expense) {
        return expense.id == updatedExpense.id ? updatedExpense : expense;
      }).toList();
      state = ExpenseState(expenses: newExpenses, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('User not logged in');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('expenses')
          .doc(expenseId)
          .delete();
      final newExpenses = state.expenses.where((expense) => expense.id != expenseId).toList();
      state = ExpenseState(expenses: newExpenses, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// StateNotifierProvider tanımı
final expenseProvider =
    StateNotifierProvider<ExpenseNotifier, ExpenseState>((ref) {
  return ExpenseNotifier();
});

// Legacy provider için uyumluluk sağlayıcı
final myExpenseProvider = Provider<ExpenseNotifier>((ref) {
  return ref.watch(expenseProvider.notifier);
});

// Filtered expenses by date range
final filteredExpensesProvider =
    Provider.family<List<Expense>, DateRange>((ref, dateRange) {
  final expenses = ref.watch(expenseProvider).expenses;

  return expenses.where((expense) {
    return expense.date
            .isAfter(dateRange.start.subtract(const Duration(days: 1))) &&
        expense.date.isBefore(dateRange.end.add(const Duration(days: 1)));
  }).toList();
});

// Expenses by category
final expensesByCategoryProvider = Provider<Map<String, double>>((ref) {
  final expenses = ref.watch(expenseProvider).expenses;

  final Map<String, double> result = {};
  for (final expense in expenses) {
    final category = expense.category;
    result[category] = (result[category] ?? 0) + expense.amount;
  }

  return result;
});

// Total expenses
final totalExpensesProvider = Provider<double>((ref) {
  final expenses = ref.watch(expenseProvider).expenses;

  return expenses.fold(0, (sum, expense) => sum + expense.amount);
});

// Date range class for filtering
class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange({
    required this.start,
    required this.end,
  });

  // Current month
  static DateRange currentMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);

    return DateRange(start: start, end: end);
  }

  // Previous month
  static DateRange previousMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 1, 1);
    final end = DateTime(now.year, now.month, 0);

    return DateRange(start: start, end: end);
  }

  // Last 7 days
  static DateRange lastWeek() {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 7));

    return DateRange(start: start, end: now);
  }

  // Last 30 days
  static DateRange last30Days() {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 30));

    return DateRange(start: start, end: now);
  }

  // Custom range
  static DateRange custom(DateTime start, DateTime end) {
    return DateRange(start: start, end: end);
  }
}
