import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/task_card.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../tasks/bloc/task_bloc.dart';
import '../../tasks/bloc/task_event.dart';
import '../../tasks/bloc/task_state.dart';
import '../../../models/task_status.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(const LoadTasksEvent());
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: 'Logout',
        message: 'Are you sure you want to log out of your session?',
        confirmText: 'Logout',
        onConfirm: () {
          context.read<AuthBloc>().add(AuthLogoutRequested());
          Navigator.of(context).pushReplacementNamed('/login');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Task Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.error),
            tooltip: 'Logout',
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoadingState) {
            return const LoadingWidget(message: 'Loading dashboard statistics...');
          }
          if (state is TaskErrorState) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => context.read<TaskBloc>().add(const LoadTasksEvent()),
            );
          }
          if (state is TaskLoadedState) {
            final recentTasks = state.tasks.take(4).toList();

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TaskBloc>().add(const LoadTasksEvent());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    const Text(
                      'Overview Statistics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _buildStatCard(
                          title: 'Total Tasks',
                          count: state.totalCount.toString(),
                          icon: Icons.assignment_outlined,
                          color: AppColors.primary,
                          bgColor: AppColors.primaryLight,
                        ),
                        _buildStatCard(
                          title: 'Pending',
                          count: state.pendingCount.toString(),
                          icon: Icons.pending_actions,
                          color: AppColors.pending,
                          bgColor: AppColors.pendingBg,
                        ),
                        _buildStatCard(
                          title: 'In Progress',
                          count: state.inProgressCount.toString(),
                          icon: Icons.autorenew,
                          color: AppColors.inProgress,
                          bgColor: AppColors.inProgressBg,
                        ),
                        _buildStatCard(
                          title: 'Completed',
                          count: state.completedCount.toString(),
                          icon: Icons.check_circle_outline,
                          color: AppColors.completed,
                          bgColor: AppColors.completedBg,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Tasks',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/tasks');
                          },
                          child: const Text(
                            'View All',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (recentTasks.isEmpty)
                      EmptyStateWidget(
                        title: 'No Tasks Yet',
                        subtitle: 'Tap the Quick Add button below to create your first task!',
                        action: ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/add-task'),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Task'),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recentTasks.length,
                        itemBuilder: (context, index) {
                          final task = recentTasks[index];
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
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.pushNamed(context, '/add-task');
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Quick Add',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        mainAxisAlignment: MainAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
            ],
          ),
          Text(
            count,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
