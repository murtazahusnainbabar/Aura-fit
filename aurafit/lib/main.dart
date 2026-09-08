import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'main_screen.dart';

// Import all screens for routing
import 'features/home/home_screen.dart';
import 'features/workouts/workout_library_screen.dart';
import 'features/workouts/workout_detail_screen.dart';
import 'features/workouts/live_workout_screen.dart';
import 'features/workouts/workout_completion_screen.dart';
import 'features/ai_coach/ai_plan_generation_screen.dart';
import 'features/ai_coach/ai_coach_chat_screen.dart';
import 'features/ai_coach/ai_voice_mode_screen.dart';
import 'features/analytics/analytics_screen.dart';
import 'features/notifications/notifications_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/subscription/subscription_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Add providers here later
        Provider(create: (_) => () {}),
      ],
      child: const AuraFitApp(),
    ),
  );
}

class AuraFitApp extends StatelessWidget {
  const AuraFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AuraFit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.main,
      routes: {
        AppRoutes.main: (context) => const MainScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.workoutLibrary: (context) => const WorkoutLibraryScreen(),
        // Note: For screens requiring arguments (like WorkoutDetailScreen),
        // we handle them via onGenerateRoute or extract arguments in the build method.
        AppRoutes.workoutDetail: (context) => const WorkoutDetailScreen(), 
        AppRoutes.liveWorkout: (context) => const LiveWorkoutScreen(),
        AppRoutes.workoutCompletion: (context) => const WorkoutCompletionScreen(),
        AppRoutes.aiPlanGeneration: (context) => const AiPlanGenerationScreen(),
        AppRoutes.aiCoachChat: (context) => const AiCoachChatScreen(),
        AppRoutes.aiVoiceMode: (context) => const AiVoiceModeScreen(),
        AppRoutes.analytics: (context) => const AnalyticsScreen(),
        AppRoutes.notifications: (context) => const NotificationsScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
        AppRoutes.subscription: (context) => const SubscriptionScreen(),
      },
    );
  }
}
