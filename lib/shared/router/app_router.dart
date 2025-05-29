import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masraf_app/auth/presentation/screens/login_screen.dart';
import 'package:masraf_app/auth/presentation/screens/register_screen.dart';
import 'package:masraf_app/auth/providers/auth_provider.dart';
import 'package:masraf_app/features/expenses/presentation/screens/add_expense_screen.dart';
import 'package:masraf_app/features/expenses/presentation/screens/expense_details_screen.dart';
import 'package:masraf_app/features/expenses/presentation/screens/settings_screen.dart';
import 'package:masraf_app/features/expenses/presentation/screens/profile_settings_screen.dart';
import 'package:masraf_app/home/presentation/screens/home_screen.dart';
import 'package:masraf_app/shared/widgets/error_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = authState.isAuthenticated;
      final isOnLoginPage = state.uri.path == '/login';
      final isOnRegisterPage = state.uri.path == '/register';

      if (!isLoggedIn && !isOnLoginPage && !isOnRegisterPage) {
        return '/login';
      }

      if (isLoggedIn && (isOnLoginPage || isOnRegisterPage)) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/add-expense',
        name: 'add-expense',
        builder: (context, state) => const AddExpenseScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/profile-settings',
        name: 'profile-settings',
        builder: (context, state) => const ProfileSettingsScreen(),
      ),
      GoRoute(
        path: '/expense/:id',
        name: 'expense-details',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ExpenseDetailsScreen(expenseId: id);
        },
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
});
