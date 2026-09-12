import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/auth/auth_provider.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'widgets/home_activity_card.dart';
import 'widgets/calorie_chart.dart';
import 'widgets/home_quick_action.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header
              _buildHeader(context),

              const SizedBox(height: 32),

              // Activity Cards Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  HomeActivityCard(
                    icon: Icons.directions_walk_rounded,
                    value: '6,500',
                    unit: 'Steps',
                    label: 'Steps',
                  ),
                  HomeActivityCard(
                    icon: Icons.fitness_center_rounded,
                    value: '28',
                    unit: 'min',
                    label: 'Workout',
                  ),
                  HomeActivityCard(
                    icon: Icons.water_drop_rounded,
                    value: '1.8',
                    unit: 'L',
                    label: 'Water',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Calorie Chart
              const CalorieChart(),

              const SizedBox(height: 24),

              // Recommendation Banner
              _buildRecommendationBanner(context),

              const SizedBox(height: 32),

              // Quick Actions
              Text(
                'Quick Actions',
                style: textStyles.h3.copyWith(color: Colors.white, fontSize: 22),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  HomeQuickAction(
                    label: 'AI Coach',
                    icon: Icons.auto_awesome_rounded,
                    color: const Color(0xFF00F0FF),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.aiCoachChat),
                  ),
                  const SizedBox(width: 16),
                  HomeQuickAction(
                    label: 'Progress',
                    icon: Icons.bar_chart_rounded,
                    color: const Color(0xFF22C55E),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.analytics),
                  ),
                  const SizedBox(width: 16),
                  HomeQuickAction(
                    label: 'Log',
                    icon: Icons.edit_note_rounded,
                    color: const Color(0xFFF97316),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.activityLogger),
                  ),
                ],
              ),
              const SizedBox(height: 100), // Space for navbar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textStyles = context.textStyles;
    final user = context.watch<AuthProvider>().user;

    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white12,
          backgroundImage: const NetworkImage(
            'https://i.pravatar.cc/150?u=murtaza', // Placeholder for profile pic
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back',
              style: textStyles.bodySmall.copyWith(
                color: const Color(0xFFC6FF00),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              user?.name ?? 'Murtaza Husnain',
              style: textStyles.h3.copyWith(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.notifications_rounded, color: Color(0xFFC6FF00), size: 24),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC6FF00),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationBanner(BuildContext context) {
    final textStyles = context.textStyles;

    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=1000&auto=format&fit=crop',
          ),
          fit: BoxFit.cover,
          opacity: 0.4,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC6FF00),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.grid_view_rounded, color: Colors.black, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aura Recommends',
                        style: textStyles.bodySmall.copyWith(
                          color: const Color(0xFFC6FF00),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Full Body Hit',
                        style: textStyles.h3.copyWith(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
