import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/finance/presentation/pages/finance_dashboard_page.dart';
import '../../features/finance/presentation/pages/add_transaction_page.dart';
import '../../features/tasks/presentation/pages/tasks_dashboard_page.dart';
import '../../features/tasks/presentation/pages/add_task_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/finance',
        builder: (context, state) => const FinanceDashboardPage(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddTransactionPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/tasks',
        builder: (context, state) => const TasksDashboardPage(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddTaskPage(),
          ),
        ],
      ),
    ],
  );
});
