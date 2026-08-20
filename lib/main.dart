import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'services/hive_service.dart';
import 'repositories/auth_repository.dart';
import 'repositories/task_repository.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/bloc/auth_state.dart';
import 'features/tasks/bloc/task_bloc.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => TaskRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(AuthCheckRequested()),
          ),
          BlocProvider(
            create: (context) => TaskBloc(
              taskRepository: context.read<TaskRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Task Manager',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routes: AppRoutes.routes,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return AppRoutes.routes['/dashboard']!(context);
              }
              return AppRoutes.routes['/login']!(context);
            },
          ),
        ),
      ),
    );
  }
}
