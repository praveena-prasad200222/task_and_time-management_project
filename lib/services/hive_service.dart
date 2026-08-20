import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants/app_constants.dart';
import '../models/task_model.dart';
import '../models/task_status.dart';
import '../models/task_priority.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Hive Adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskPriorityAdapter());
    }

    // Open Boxes
    final tasksBox = await Hive.openBox<TaskModel>(AppConstants.tasksBoxName);
    await Hive.openBox(AppConstants.authBoxName);

    // Seed mock data if empty
    if (tasksBox.isEmpty) {
      await _seedMockTasks(tasksBox);
    }
  }

  static Future<void> _seedMockTasks(Box<TaskModel> box) async {
    final mockTasks = [
      TaskModel(
        id: '1',
        title: 'Design Authentication Flow UI',
        description: 'Create responsive login screen with input validation and state feedback.',
        status: TaskStatus.completed,
        priority: TaskPriority.high,
        assignedUser: 'John Doe',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TaskModel(
        id: '2',
        title: 'Implement Hive Local Database',
        description: 'Setup local persistence for tasks, statuses, priorities and user auth session.',
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
        assignedUser: 'Jane Smith',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
      ),
      TaskModel(
        id: '3',
        title: 'Setup BLoC State Management',
        description: 'Configure AuthBloc and TaskBloc with clean architecture separation.',
        status: TaskStatus.inProgress,
        priority: TaskPriority.medium,
        assignedUser: 'Alex Johnson',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      TaskModel(
        id: '4',
        title: 'Write Unit & Widget Tests',
        description: 'Cover login validation, task filtering logic, search logic, and CRUD operations with tests.',
        status: TaskStatus.pending,
        priority: TaskPriority.low,
        assignedUser: 'Sarah Connor',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    for (var task in mockTasks) {
      await box.put(task.id, task);
    }
  }
}
