import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/tasks/screens/task_list_screen.dart';
import '../features/tasks/screens/task_detail_screen.dart';
import '../features/tasks/screens/add_edit_task_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../models/task_model.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/tasks': (context) => const TaskListScreen(),
        '/add-task': (context) => const AddEditTaskScreen(),
        '/profile': (context) => const ProfileScreen(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/task-details') {
      final task = settings.arguments as TaskModel;
      return MaterialPageRoute(
        builder: (context) => TaskDetailScreen(task: task),
      );
    }
    if (settings.name == '/edit-task') {
      final task = settings.arguments as TaskModel;
      return MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(taskToEdit: task),
      );
    }
    return null;
  }
}
