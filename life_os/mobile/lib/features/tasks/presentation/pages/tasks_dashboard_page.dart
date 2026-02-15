import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/task_provider.dart';

class TasksDashboardPage extends ConsumerWidget {
  const TasksDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskListProvider);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.bgWhite,
        appBar: AppBar(
          title: Text("Today's Tasks", style: AppTheme.h2),
          backgroundColor: AppColors.bgWhite,
          actions: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
          ],
          bottom: TabBar(
            labelColor: AppColors.tasks,
            unselectedLabelColor: AppColors.textTertiary,
            indicatorColor: AppColors.tasks,
            tabs: const [
              Tab(text: 'Inbox'),
              Tab(text: 'Today'),
              Tab(text: 'Upcoming'),
              Tab(text: 'Projects'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _TaskList(tasksAsync: tasksAsync), // Inbox placeholder
            _TaskList(tasksAsync: tasksAsync), // Today
            const Center(child: Text('Calendar View Coming Soon')), // Upcoming
            const Center(child: Text('Projects View Coming Soon')), // Projects
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/tasks/add'),
          backgroundColor: AppColors.tasks,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  final AsyncValue<List<dynamic>> tasksAsync; // Dynamic for brevity, strongly type in prod

  const _TaskList({required this.tasksAsync});

  @override
  Widget build(BuildContext context) {
    return tasksAsync.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 64, color: AppColors.textDisabled),
                const SizedBox(height: 16),
                Text('No tasks yet', style: AppTheme.bodyLarge.copyWith(color: AppColors.textTertiary)),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Container(
              decoration: BoxDecoration(
                color: AppColors.bgWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.bgOffWhite),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.tasks, width: 2),
                  ),
                ),
                title: Text(task.title, style: AppTheme.bodyLarge),
                subtitle: task.description != null ? Text(task.description!, style: AppTheme.small) : null,
                trailing: task.priority > 0
                    ? Icon(Icons.flag, color: AppColors.tasks, size: 20)
                    : null,
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.tasks)),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
