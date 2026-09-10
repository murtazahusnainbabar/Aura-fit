import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/auth/auth_provider.dart';
import 'core/onboarding/onboarding_provider.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_colors.dart';
import 'core/widgets/bottom_nav_bar.dart';

import 'features/home/home_screen.dart';
import 'features/workouts/workout_library_screen.dart';
import 'features/ai_coach/ai_coach_chat_screen.dart';
import 'features/analytics/analytics_screen.dart';
import 'features/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final onboarding = context.read<OnboardingProvider>();
      if (!mounted) return;
      if (!auth.isLoggedIn) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
      } else if (!onboarding.isComplete) {
        Navigator.of(context)
            .pushReplacementNamed(AppRoutes.personalization);
      }
    });
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    WorkoutLibraryScreen(),
    AiCoachChatScreen(),
    AnalyticsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
