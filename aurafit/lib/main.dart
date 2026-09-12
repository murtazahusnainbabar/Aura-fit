import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/auth/auth_provider.dart';
import 'core/constants/app_routes.dart';
import 'core/onboarding/onboarding_provider.dart';
import 'core/reminders/reminder_provider.dart';
import 'core/status/app_status_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/wellness/wellness_provider.dart';
import 'core/widgets/state_views.dart';
import 'main_screen.dart';

import 'features/auth/forgot_password_screen.dart';
import 'features/auth/reset_password_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/auth/splash_screen.dart';
import 'features/onboarding/welcome_screen.dart';
import 'features/onboarding/personalization_wizard_screen.dart';
import 'features/onboarding/permissions_setup_screen.dart';
import 'features/home/home_screen.dart';
import 'features/workouts/workout_library_screen.dart';
import 'features/workouts/workout_detail_screen.dart';
import 'features/workouts/live_workout_screen.dart';
import 'features/workouts/workout_completion_screen.dart';
import 'features/ai_coach/ai_plan_generation_screen.dart';
import 'features/ai_coach/ai_coach_chat_screen.dart';
import 'features/ai_coach/ai_voice_mode_screen.dart';
import 'features/ai_coach/ai_vision_scanner_screen.dart';
import 'features/analytics/analytics_screen.dart';
import 'features/logging/activity_logger_screen.dart';
import 'features/notifications/notifications_screen.dart';
import 'features/reminders/reminder_scheduler_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/subscription/subscription_screen.dart';
import 'features/system/system_status_screen.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..ensureInitialized()),
        ChangeNotifierProvider(
            create: (_) => OnboardingProvider()..ensureInitialized()),
        ChangeNotifierProvider(
            create: (_) => WellnessProvider()..ensureInitialized()),
        ChangeNotifierProvider(
            create: (_) => ReminderProvider()..ensureInitialized()),
        ChangeNotifierProvider(create: (_) => AppStatusProvider()),
      ],
      child: const AuraFitApp(),
    ),
  );
}

class AuraFitApp extends StatelessWidget {
  const AuraFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        AppColors.update(themeProvider.isDarkMode);
        AppTextStyles.update(themeProvider.isDarkMode);

        return MaterialApp(
          title: 'AuraFit',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: AppRoutes.splash,
          builder: (context, child) {
            final offline = context.watch<AppStatusProvider>().isOffline;
            return Column(
              children: [
                if (offline) const OfflineBanner(),
                Expanded(child: child ?? const SizedBox.shrink()),
              ],
            );
          },
          routes: {
            AppRoutes.splash: (context) => const SplashScreen(),
            AppRoutes.welcome: (context) => const WelcomeScreen(),
            AppRoutes.personalization: (context) =>
                const PersonalizationWizardScreen(),
            AppRoutes.permissions: (context) =>
                const PermissionsSetupScreen(),
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.signup: (context) => const SignupScreen(),
            AppRoutes.forgotPassword: (context) =>
                const ForgotPasswordScreen(),
            AppRoutes.resetPassword: (context) =>
                const ResetPasswordScreen(),
            AppRoutes.main: (context) => const MainScreen(),
            AppRoutes.home: (context) => const HomeScreen(),
            AppRoutes.workoutLibrary: (context) =>
                const WorkoutLibraryScreen(),
            AppRoutes.workoutDetail: (context) => const WorkoutDetailScreen(),
            AppRoutes.liveWorkout: (context) => const LiveWorkoutScreen(),
            AppRoutes.workoutCompletion: (context) =>
                const WorkoutCompletionScreen(),
            AppRoutes.aiPlanGeneration: (context) =>
                const AIPlanGenerationScreen(),
            AppRoutes.aiCoachChat: (context) => const AiCoachChatScreen(),
            AppRoutes.aiVoiceMode: (context) => const AiVoiceModeScreen(),
            AppRoutes.aiVision: (context) => const AiVisionScannerScreen(),
            AppRoutes.analytics: (context) => const AnalyticsScreen(),
            AppRoutes.activityLogger: (context) =>
                const ActivityLoggerScreen(),
            AppRoutes.notifications: (context) =>
                const NotificationsScreen(),
            AppRoutes.reminders: (context) =>
                const ReminderSchedulerScreen(),
            AppRoutes.profile: (context) => const ProfileScreen(),
            AppRoutes.settings: (context) => const SettingsScreen(),
            AppRoutes.subscription: (context) => const SubscriptionScreen(),
            AppRoutes.systemStatus: (context) => const SystemStatusScreen(),
          },
        );
      },
    );
  }
}
