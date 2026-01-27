import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui/app_ui.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(titleText: 'Profile', centerTitle: true),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            final user = state.user;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.primary,
                    backgroundImage: user.profileImage != null
                        ? NetworkImage(user.profileImage!)
                        : null,
                    child: user.profileImage == null
                        ? Text(
                            user.firstName?.substring(0, 1).toUpperCase() ??
                                user.email.substring(0, 1).toUpperCase(),
                            style: AppTypography.heading1.copyWith(
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    user.firstName != null && user.lastName != null
                        ? '${user.firstName} ${user.lastName}'
                        : 'User',
                    style: AppTypography.heading3,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    user.email,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (user.phone != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      user.phone!,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xxl),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.email,
                            color: AppColors.primary,
                          ),
                          title: Text('Email', style: AppTypography.bodyLarge),
                          subtitle: Text(
                            user.email,
                            style: AppTypography.bodyMedium,
                          ),
                          trailing: user.isEmailVerified
                              ? const Icon(
                                  Icons.verified,
                                  color: AppColors.success,
                                )
                              : const Icon(
                                  Icons.cancel,
                                  color: AppColors.error,
                                ),
                        ),
                        if (user.phone != null)
                          ListTile(
                            leading: const Icon(
                              Icons.phone,
                              color: AppColors.primary,
                            ),
                            title: Text(
                              'Phone',
                              style: AppTypography.bodyLarge,
                            ),
                            subtitle: Text(
                              user.phone!,
                              style: AppTypography.bodyMedium,
                            ),
                            trailing: user.isPhoneVerified
                                ? const Icon(
                                    Icons.verified,
                                    color: AppColors.success,
                                  )
                                : const Icon(
                                    Icons.cancel,
                                    color: AppColors.error,
                                  ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.edit,
                            color: AppColors.primary,
                          ),
                          title: Text(
                            'Edit Profile',
                            style: AppTypography.bodyLarge,
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                          ),
                          onTap: () {
                            // Navigate to edit profile
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.notifications,
                            color: AppColors.primary,
                          ),
                          title: Text(
                            'Notifications',
                            style: AppTypography.bodyLarge,
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                          ),
                          onTap: () {
                            // Navigate to notifications
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.lock,
                            color: AppColors.primary,
                          ),
                          title: Text(
                            'Change Password',
                            style: AppTypography.bodyLarge,
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                          ),
                          onTap: () {
                            // Navigate to change password
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.settings,
                            color: AppColors.primary,
                          ),
                          title: Text(
                            'Settings',
                            style: AppTypography.bodyLarge,
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                          ),
                          onTap: () {
                            // Navigate to settings
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton.secondary(
                      label: 'Logout',
                      icon: Icons.logout,
                      onPressed: () {
                        AppDialog.confirm(
                          context: context,
                          title: 'Logout',
                          contentText: 'Are you sure you want to logout?',
                          confirmLabel: 'Logout',
                          cancelLabel: 'Cancel',
                        ).then((confirmed) {
                          if (confirmed == true) {
                            context.read<AuthBloc>().add(const LogoutEvent());
                          }
                        });
                      },
                    ),
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
}
