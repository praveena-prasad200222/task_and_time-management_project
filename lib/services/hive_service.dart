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
    await Hive.openBox<TaskModel>(AppConstants.tasksBoxName);
    await Hive.openBox(AppConstants.authBoxName);
  }
}
