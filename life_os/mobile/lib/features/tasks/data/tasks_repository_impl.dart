import 'package:dio/dio.dart';
import '../domain/tasks_repository.dart';
import '../domain/task.dart';

class TasksRepositoryImpl implements TasksRepository {
  final Dio _dio;

  TasksRepositoryImpl(this._dio);

  @override
  Future<List<Task>> getTasks() async {
    try {
      final response = await _dio.get('/tasks/tasks');
      final List<dynamic> data = response.data;
      return data.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  @override
  Future<Task> addTask(String title, {String? description, DateTime? scheduledDate, int priority = 0}) async {
    try {
      final response = await _dio.post('/tasks/tasks', data: {
        'title': title,
        'description': description,
        'scheduled_date': scheduledDate?.toIso8601String().split('T')[0],
        'priority': priority,
      });
      return Task.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }
}
