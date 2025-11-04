import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_boilerplate/core/utils/constants/ui_constants.dart';
import 'package:flutter_boilerplate/core/widgets/app_appbar.dart';
import 'package:flutter_boilerplate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_boilerplate/features/auth/presentation/bloc/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home',
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    // Navigate to profile
                  },
                  tooltip: 'Profile',
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back!',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          kVerticalGap8,
                          Text(
                            state.user.firstName != null &&
                                    state.user.lastName != null
                                ? '${state.user.firstName} ${state.user.lastName}'
                                : state.user.email,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          if (state.user.email.isNotEmpty) ...[
                            kVerticalGap4,
                            Text(
                              state.user.email,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  kVerticalGap24,
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  kVerticalGap16,
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: kVerticalGap16.height!,
                    crossAxisSpacing: kHorizontalGap16.width!,
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
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32),
              kVerticalGap8,
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
