import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/tasks_repository.dart';
import '../../data/tasks_repository_impl.dart';
import '../../domain/task.dart';

final tasksRepositoryProvider = Provider<TasksRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TasksRepositoryImpl(dio);
});

class TaskListController extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() async {
    final repository = ref.watch(tasksRepositoryProvider);
    return repository.getTasks();
  }

  Future<void> addTask(String title, {String? description, DateTime? date, int priority = 0}) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(tasksRepositoryProvider);
      await repository.addTask(title, description: description, scheduledDate: date, priority: priority);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final taskListProvider = AsyncNotifierProvider<TaskListController, List<Task>>(TaskListController.new);
