import 'package:hive/hive.dart';
import '../core/constants/app_constants.dart';
import '../models/task_model.dart';
import '../models/task_status.dart';
import '../models/task_priority.dart';

class TaskRepository {
  Box<TaskModel> get _tasksBox => Hive.box<TaskModel>(AppConstants.tasksBoxName);

  Future<List<TaskModel>> getTasks({
    String? searchQuery,
    TaskStatus? statusFilter,
    TaskPriority? priorityFilter,
    DateTime? dueDateFilter,
  }) async {
    // Simulate slight delay for loading state
    await Future.delayed(const Duration(milliseconds: 300));

    List<TaskModel> tasks = _tasksBox.values.toList();

    // Search by title or description
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final query = searchQuery.toLowerCase().trim();
      tasks = tasks.where((task) {
        return task.title.toLowerCase().contains(query) ||
            task.description.toLowerCase().contains(query);
      }).toList();
    }

    // Filter by Status
    if (statusFilter != null) {
      tasks = tasks.where((task) => task.status == statusFilter).toList();
    }

    // Filter by Priority
    if (priorityFilter != null) {
      tasks = tasks.where((task) => task.priority == priorityFilter).toList();
    }

    // Filter by Due Date
    if (dueDateFilter != null) {
      tasks = tasks.where((task) {
        return task.dueDate.year == dueDateFilter.year &&
            task.dueDate.month == dueDateFilter.month &&
            task.dueDate.day == dueDateFilter.day;
      }).toList();
    }

    // Sort by created at descending
    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return tasks;
  }

  Future<TaskModel?> getTaskById(String id) async {
    return _tasksBox.get(id);
  }

  Future<void> addTask(TaskModel task) async {
    await _tasksBox.put(task.id, task);
  }

  Future<void> updateTask(TaskModel task) async {
    final updatedTask = task.copyWith(updatedAt: DateTime.now());
    await _tasksBox.put(task.id, updatedTask);
  }

  Future<void> updateTaskStatus(String id, TaskStatus status) async {
    final task = _tasksBox.get(id);
    if (task != null) {
      final updatedTask = task.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
      await _tasksBox.put(id, updatedTask);
    }
  }

  Future<void> deleteTask(String id) async {
    await _tasksBox.delete(id);
  }
}
