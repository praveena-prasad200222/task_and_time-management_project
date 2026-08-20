import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
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

  Future<void> _handleRefresh() async {
    context.read<TaskBloc>().add(const LoadTasksEvent());
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: AppColors.primaryDark,
          content: Row(
            children: const [
              Icon(Icons.check_circle_outline, color: Color(0xFF10B981), size: 20),
              SizedBox(width: 10),
              Text(
                'Dashboard statistics refreshed',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }
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
      body: SafeArea(
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoadingState) {
              return const LoadingWidget(isDashboard: true);
            }
            if (state is TaskErrorState) {
              return RefreshIndicator(
                color: AppColors.primary,
                backgroundColor: AppColors.surface,
                displacement: 32,
                strokeWidth: 2.8,
                onRefresh: _handleRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: CustomErrorWidget(
                      message: state.message,
                      onRetry: () => context.read<TaskBloc>().add(const LoadTasksEvent()),
                    ),
                  ),
                ),
              );
            }
            if (state is TaskLoadedState) {
              final recentTasks = state.tasks.take(4).toList();

              return RefreshIndicator(
                color: AppColors.primary,
                backgroundColor: AppColors.surface,
                displacement: 32,
                strokeWidth: 2.8,
                onRefresh: _handleRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFDBEAFE), Color(0xFFEFF6FF), Color(0xFFF3F4F6)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(32),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1E3A8A).withValues(alpha: 0.05),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/profile');
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Color(0xFF93C5FD),
                                      child: Icon(Icons.person, color: Color(0xFF1E3A8A), size: 24),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFBFDBFE),
                                      width: 1,
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626)),
                                    tooltip: 'Logout',
                                    onPressed: _confirmLogout,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.5,
                                ),
                                children: const [
                                  TextSpan(text: 'Hello, '),
                                  TextSpan(
                                    text: 'User!',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1D4ED8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormatter.formatFullHeaderDate(DateTime.now()),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1D4ED8).withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Welcome Back 👋',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Track Your Productivity',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Stay focused and complete your daily goals',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.analytics_outlined,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Overview Statistics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.45,
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
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Tasks',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/tasks');
                          },
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                          return TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            duration: Duration(milliseconds: 350 + (index * 100)),
                            curve: Curves.easeOutQuad,
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(0, 24 * (1 - value)),
                                child: Opacity(
                                  opacity: value.clamp(0.0, 1.0),
                                  child: child,
                                ),
                              );
                            },
                            child: TaskCard(
                              task: task,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/task-details',
                                  arguments: task,
                                );
                              },
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
          return const SizedBox.shrink();
        },
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          Navigator.pushNamed(context, '/add-task');
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Quick Add',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7), width: 1),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
            ],
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              count,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
