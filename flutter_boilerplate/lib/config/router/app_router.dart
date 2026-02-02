import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/config/router/app_routes.dart';
import 'package:flutter_boilerplate/config/router/navigation_service.dart';
import 'package:flutter_boilerplate/core/storage/storage_adapter.dart';
import 'package:flutter_boilerplate/core/storage/storage_key_constants.dart';
import 'package:flutter_boilerplate/core/utils/functions/base_functions/data_functions.dart';
import 'package:flutter_boilerplate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_boilerplate/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_boilerplate/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_boilerplate/features/auth/presentation/screens/otp_screen.dart';
import 'package:flutter_boilerplate/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:flutter_boilerplate/features/auth/presentation/screens/signup_screen.dart';
import 'package:flutter_boilerplate/features/auth/presentation/screens/verify_reset_password_screen.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_boilerplate/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter_boilerplate/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_ui/app_ui.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final IStorageService storageService;

  AppRouter({required this.storageService});

  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> homeTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> profileTabNavigatorKey =
      GlobalKey<NavigatorState>();

  bool _isRedirecting = false;
  int _redirectCount = 0;
  static const int _maxRedirects = 3;

  bool get isAuthenticatedSync {
    try {
      final loginTimestamp = storageService.getData(StorageKeys.loginTimestamp);
      if (loginTimestamp != null) {
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        const oneDayInMillis = 24 * 60 * 60 * 1000;
        final timestampInt = loginTimestamp is int
            ? loginTimestamp
            : int.tryParse(loginTimestamp.toString()) ?? 0;

        if (currentTime - timestampInt < oneDayInMillis) {
          final userJson = storageService.getData(StorageKeys.user);
          return userJson != null;
        }
      }
      return false;
    } catch (e) {
      outlog('Error checking auth status: $e');
      return false;
    }
  }

  bool get hasSelectedProfileSync {
    try {
      final selectedProfileId = storageService.getData(
        StorageKeys.selectedProfile,
      );
      final hasProfile =
          selectedProfileId != null && selectedProfileId.toString().isNotEmpty;
      outlog(
        'Router - Has selected profile: $hasProfile (ID: $selectedProfileId)',
      );
      return hasProfile;
    } catch (e) {
      outlog('Error checking selected profile: $e');
      return false;
    }
  }

  bool get isOnboardingCompletedSync {
    try {
      final onboardingStateValue = storageService.getData(
        StorageKeys.onboardingState,
      );
      if (onboardingStateValue == null) {
        return false;
      }

      // Support both enum string and boolean for backward compatibility
      if (onboardingStateValue is bool) {
        return onboardingStateValue;
      }

      final stateString = onboardingStateValue.toString();
      return stateString == 'completed';
    } catch (e) {
      outlog('Error checking onboarding status: $e');
      return false;
    }
  }

  late final GoRouter router = GoRouter(
    navigatorKey: parentNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    initialLocation: AppRoutes.onBoarding.path,
    routes: [
      // Main shell route for bottom navigation
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: parentNavigatorKey,
        builder: (context, state, navigationShell) {
          // Set navigation shell in NavigationService
          NavigationService().setNavigationShell(navigationShell);
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          // Home tab
          StatefulShellBranch(
            navigatorKey: homeTabNavigatorKey,
            routes: [
              GoRoute(
                name: AppRoutes.home.name,
                path: AppRoutes.home.path,
                pageBuilder: (context, state) => getPage(
                  child: BlocListener<AuthBloc, AuthState>(
                    listener: (context, authState) {
                      if (authState is AuthUnauthenticated) {
                        context.goNamed(AppRoutes.login.name);
                      }
                    },
                    child: const HomeScreen(),
                  ),
                  state: state,
                ),
              ),
            ],
          ),
          // Profile tab
          StatefulShellBranch(
            navigatorKey: profileTabNavigatorKey,
            routes: [
              GoRoute(
                name: AppRoutes.profile.name,
                path: AppRoutes.profile.path,
                pageBuilder: (context, state) => getPage(
                  child: BlocListener<AuthBloc, AuthState>(
                    listener: (context, authState) {
                      if (authState is AuthUnauthenticated) {
                        context.goNamed(AppRoutes.login.name);
                      }
                    },
                    child: const ProfileScreen(),
                  ),
                  state: state,
                ),
              ),
            ],
          ),
        ],
      ),

      // Auth routes
      GoRoute(
        name: AppRoutes.login.name,
        path: AppRoutes.login.path,
        pageBuilder: (context, state) => getPage(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, authState) {
              if (authState is AuthAuthenticated) {
                context.goNamed(AppRoutes.home.name);
              } else if (authState is AuthVerificationRequired) {
                context.goNamed(
                  AppRoutes.otp.name,
                  extra: authState.verificationKey,
                );
              }
            },
            child: const LoginScreen(),
          ),
          state: state,
        ),
      ),
      GoRoute(
        name: AppRoutes.signUp.name,
        path: AppRoutes.signUp.path,
        pageBuilder: (context, state) => getPage(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, authState) {
              if (authState is AuthAuthenticated) {
                context.goNamed(AppRoutes.home.name);
              } else if (authState is AuthVerificationRequired) {
                context.goNamed(
                  AppRoutes.otp.name,
                  extra: authState.verificationKey,
                );
              }
            },
            child: const SignUpScreen(),
          ),
          state: state,
        ),
      ),
      GoRoute(
        name: AppRoutes.otp.name,
        path: AppRoutes.otp.path,
        pageBuilder: (context, state) {
          final verificationKey = state.extra as String?;
          return getPage(
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, authState) {
                if (authState is AuthAuthenticated) {
                  context.goNamed(AppRoutes.home.name);
                }
              },
              child: OtpScreen(verificationKey: verificationKey),
            ),
            state: state,
          );
        },
      ),
      GoRoute(
        name: AppRoutes.resetPassword.name,
        path: AppRoutes.resetPassword.path,
        pageBuilder: (context, state) =>
            getPage(child: const ResetPasswordScreen(), state: state),
      ),
      GoRoute(
        name: AppRoutes.verifyReset.name,
        path: AppRoutes.verifyReset.path,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return getPage(
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, authState) {
                if (authState is ResetPasswordVerified) {
                  context.goNamed(AppRoutes.login.name);
                }
              },
              child: VerifyResetPasswordScreen(
                userId: extra?['userId'] as String?,
                isPhone: extra?['isPhone'] as bool?,
              ),
            ),
            state: state,
          );
        },
      ),
      GoRoute(
        name: AppRoutes.onBoarding.name,
        path: AppRoutes.onBoarding.path,
        pageBuilder: (context, state) =>
            getPage(child: const OnboardingScreen(), state: state),
      ),
    ],
    redirect: (context, state) {
      // Prevent redirect loops
      if (_isRedirecting) {
        _redirectCount++;
        if (_redirectCount > _maxRedirects) {
          outlog('Redirect loop detected - resetting');
          _redirectCount = 0;
          _isRedirecting = false;
          return AppRoutes.login.path;
        }
        return null;
      }

      final location = state.matchedLocation;
      final authPages = [
        AppRoutes.login.path,
        AppRoutes.signUp.path,
        AppRoutes.otp.path,
        AppRoutes.resetPassword.path,
        AppRoutes.verifyReset.path,
        AppRoutes.onBoarding.path,
      ];
      final isInAuthPage = authPages.contains(location);

      outlog('Router - Location: $location');

      try {
        _isRedirecting = true;

        // Check onboarding status first
        final isOnboardingCompleted = isOnboardingCompletedSync;
        final isOnboardingPage = location == AppRoutes.onBoarding.path;

        // If onboarding not completed and not on onboarding page, redirect to onboarding
        if (!isOnboardingCompleted && !isOnboardingPage) {
          outlog('Onboarding not completed - redirecting to onboarding');
          return AppRoutes.onBoarding.path;
        }

        // If onboarding completed and on onboarding page, redirect to login
        if (isOnboardingCompleted && isOnboardingPage) {
          outlog('Onboarding completed - redirecting to login');
          return AppRoutes.login.path;
        }

        // Protected routes that require authentication
        final protectedRoutes = [AppRoutes.home.path, AppRoutes.profile.path];

        // If user is authenticated and on auth pages, redirect to home
        if (isAuthenticatedSync && isInAuthPage && !isOnboardingPage) {
          outlog('Authenticated user on auth page - redirecting to home');
          return AppRoutes.home.path;
        }

        // If user is not authenticated and on protected routes, redirect to login
        if (!isAuthenticatedSync &&
            protectedRoutes.any((route) => location.startsWith(route))) {
          outlog('Redirecting unauthenticated user to login from: $location');
          return AppRoutes.login.path;
        }

        return null;
      } finally {
        _isRedirecting = false;
        _redirectCount = 0;
      }
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: AppSpacing.lg),
            Text('Page not found', style: AppTypography.heading2),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'The page you are looking for does not exist.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton.primary(
              label: 'Go Home',
              icon: Icons.home,
              onPressed: () {
                context.goNamed(AppRoutes.home.name);
              },
            ),
          ],
        ),
      ),
    ),
  );

  static Page<dynamic> getPage({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}

// Main screen with bottom navigation
class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.goNamed(AppRoutes.login.name);
        }
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
