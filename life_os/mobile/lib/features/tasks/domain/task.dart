import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime? scheduledDate;
  final bool isCompleted;
  final int priority; // 0-3
  final String? projectId;

  const Task({
    required this.id,
    required this.title,
    this.description,
    this.scheduledDate,
    this.isCompleted = false,
    this.priority = 0,
    this.projectId,
  });

  @override
  List<Object?> get props => [id, title, description, scheduledDate, isCompleted, priority, projectId];

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      scheduledDate: json['scheduled_date'] != null ? DateTime.parse(json['scheduled_date'] as String) : null,
      isCompleted: json['status'] == 'completed',
      priority: json['priority'] as int? ?? 0,
      projectId: json['project_id'] as String?,
    );
  }
}
