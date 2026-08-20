import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/task_card.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/filter_bottom_sheet.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../../../models/task_status.dart';
import '../../../models/task_priority.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();
  TaskStatus? _selectedStatus;
  TaskPriority? _selectedPriority;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    context.read<TaskBloc>().add(
          LoadTasksEvent(
            searchQuery: _searchController.text,
            statusFilter: _selectedStatus,
            priorityFilter: _selectedPriority,
          ),
        );
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FilterBottomSheet(
        initialStatus: _selectedStatus,
        initialPriority: _selectedPriority,
        onApply: (status, priority) {
          setState(() {
            _selectedStatus = status;
            _selectedPriority = priority;
          });
          _loadTasks();
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('All Tasks'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: (_selectedStatus != null || _selectedPriority != null)
                  ? AppColors.primary
                  : AppColors.textPrimary,
            ),
            onPressed: _openFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _loadTasks(),
              decoration: InputDecoration(
                hintText: 'Search title or description...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                        onPressed: () {
                          _searchController.clear();
                          _loadTasks();
                        },
                      )
                    : null,
              ),
            ),
          ),
          if (_selectedStatus != null || _selectedPriority != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  const Text('Filters: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  if (_selectedStatus != null) ...[
                    Chip(
                      label: Text(_selectedStatus!.displayName),
                      onDeleted: () {
                        setState(() => _selectedStatus = null);
                        _loadTasks();
                      },
                    ),
                    const SizedBox(width: 6),
                  ],
                  if (_selectedPriority != null) ...[
                    Chip(
                      label: Text(_selectedPriority!.displayName),
                      onDeleted: () {
                        setState(() => _selectedPriority = null);
                        _loadTasks();
                      },
                    ),
                  ],
                ],
              ),
            ),
          Expanded(
            child: BlocConsumer<TaskBloc, TaskState>(
              listener: (context, state) {
                if (state is TaskOperationSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is TaskLoadingState) {
                  return const LoadingWidget(message: 'Fetching task list...');
                }
                if (state is TaskErrorState) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: _loadTasks,
                  );
                }
                if (state is TaskLoadedState) {
                  if (state.tasks.isEmpty) {
                    return EmptyStateWidget(
                      title: state.hasActiveFilter
                          ? 'No matching tasks found'
                          : 'No tasks available',
                      subtitle: state.hasActiveFilter
                          ? 'Try clearing filters or search query'
                          : 'Create your first task by tapping + Add Task below',
                      action: state.hasActiveFilter
                          ? ElevatedButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _selectedStatus = null;
                                  _selectedPriority = null;
                                });
                                _loadTasks();
                              },
                              child: const Text('Clear Search & Filters'),
                            )
                          : ElevatedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, '/add-task'),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Task'),
                            ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _loadTasks(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: state.tasks.length,
                      itemBuilder: (context, index) {
                        final task = state.tasks[index];
                        return TaskCard(
                          task: task,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/task-details',
                              arguments: task,
                            );
                          },
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.pushNamed(context, '/add-task'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
