import 'task.dart';

abstract class TasksRepository {
  Future<List<Task>> getTasks();
  Future<Task> addTask(String title, {String? description, DateTime? scheduledDate, int priority = 0});
}
