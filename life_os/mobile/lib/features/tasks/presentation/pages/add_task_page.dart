import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/task_provider.dart';

class AddTaskPage extends ConsumerStatefulWidget {
  const AddTaskPage({super.key});

  @override
  ConsumerState<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends ConsumerState<AddTaskPage> {
  final _titleController = TextEditingController();

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isNotEmpty) {
      ref.read(taskListProvider.notifier).addTask(title);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      appBar: AppBar(
        title: const Text('Quick Add Task'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              autofocus: true,
              style: AppTheme.h3,
              decoration: const InputDecoration(
                hintText: 'Remind me to call John tomorrow at 3pm',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
            // AI Preview Mock
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.tasksLighter,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.tasksLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, size: 16, color: AppColors.tasksDark),
                      const SizedBox(width: 8),
                      Text('AI PREVIEW', style: AppTheme.caption.copyWith(color: AppColors.tasksDark)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Start typing to see AI suggestions...', style: AppTheme.small),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tasks,
                ),
                child: const Text('Add Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
