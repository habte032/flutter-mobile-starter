import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui/app_ui.dart';
import 'package:flutter_boilerplate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_boilerplate/features/auth/presentation/bloc/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        titleText: 'Home',
        centerTitle: true,
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return AppIconButton.ghost(
                  icon: Icons.person,
                  onPressed: () {
                    // Navigate to profile
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome back!', style: AppTypography.heading3),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            state.user.firstName != null &&
                                    state.user.lastName != null
                                ? '${state.user.firstName} ${state.user.lastName}'
                                : state.user.email,
                            style: AppTypography.bodyLarge,
                          ),
                          if (state.user.email.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              state.user.email,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text('Quick Actions', style: AppTypography.heading3),
                  const SizedBox(height: AppSpacing.lg),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AppSpacing.lg,
                    crossAxisSpacing: AppSpacing.lg,
                    childAspectRatio: 1.5,
                    children: [
                      _buildActionCard(
                        context,
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () {
                          // Navigate to settings
                        },
                      ),
                      _buildActionCard(
                        context,
                        icon: Icons.person,
                        title: 'Profile',
                        onTap: () {
                          // Navigate to profile
                        },
                      ),
                      _buildActionCard(
                        context,
                        icon: Icons.notifications,
                        title: 'Notifications',
                        onTap: () {
                          // Navigate to notifications
                        },
                      ),
                      _buildActionCard(
                        context,
                        icon: Icons.help_outline,
                        title: 'Help',
                        onTap: () {
                          // Navigate to help
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: AppColors.primary),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
