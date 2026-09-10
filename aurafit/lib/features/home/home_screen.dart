import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/auth/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/constants/app_routes.dart';
import '../../core/wellness/wellness_provider.dart';
import '../../models/workout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 24),
                    _buildActivityRings(context),
                    const SizedBox(height: 20),
                    _buildAIRecommendationBanner(context),
                    const SizedBox(height: 24),
                    _buildQuickActions(context),
                    const SizedBox(height: 24),
                    _buildSchedule(context),
                    const SizedBox(height: 24),
                    Text('Recommended for You', style: textStyles.h3),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: WorkoutData.workouts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) =>
                      _buildWorkoutCard(context, WorkoutData.workouts[index]),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Widget _buildHeader(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_greeting()}, ${context.watch<AuthProvider>().user?.firstName ?? 'there'} 👋',
              style: textStyles.h2.copyWith(fontSize: 22),
            ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
            const SizedBox(height: 4),
            Text(
              'Monday, Sep 8 · Ready to crush it?',
              style: textStyles.bodySmall,
            ).animate().fadeIn(delay: 100.ms),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.border),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(Icons.notifications_outlined,
                      color: colors.textSecondary, size: 22),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 150.ms),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: colors.cyanPurpleGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text(
                'AC',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildActivityRings(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.accentGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.accentGreen.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_fire_department_rounded,
                        color: colors.accentGreen, size: 14),
                    const SizedBox(width: 4),
                    Text('7-Day Streak!',
                        style: textStyles.labelMedium
                            .copyWith(color: colors.accentGreen)),
                  ],
                ),
              ),
              const Spacer(),
              Text("Today's Activity", style: textStyles.labelMedium),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.spaceAround,
            spacing: 8,
            runSpacing: 16,
            children: [
              _buildRing(
                context,
                label: 'Active Cal',
                value: '347',
                unit: 'kcal',
                progress: 0.67,
                color: colors.accentOrange,
              ),
              _buildRing(
                context,
                label: 'Workout',
                value: '28',
                unit: 'min',
                progress: 0.62,
                color: colors.primary,
              ),
              _buildRing(
                context,
                label: 'Water',
                value: context.watch<WellnessProvider>().waterLiters.toStringAsFixed(1),
                unit: 'L',
                progress: (context.watch<WellnessProvider>().waterLiters / 2.5)
                    .clamp(0, 1),
                color: colors.secondary,
              ),
              _buildRing(
                context,
                label: 'Sleep',
                value: context.watch<WellnessProvider>().sleepHours.toStringAsFixed(1),
                unit: 'h',
                progress: (context.watch<WellnessProvider>().sleepHours / 8)
                    .clamp(0, 1),
                color: colors.primaryLight,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05);
  }

  Widget _buildRing(
    BuildContext context, {
    required String label,
    required String value,
    required String unit,
    required double progress,
    required Color color,
  }) {
    final textStyles = context.textStyles;
    final colors = context.colors;

    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 8,
                  color: color.withOpacity(0.15),
                  strokeCap: StrokeCap.round,
                ),
              ),
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  color: color,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  Text(
                    unit,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: textStyles.labelSmall),
      ],
    );
  }

  Widget _buildAIRecommendationBanner(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.workoutDetail,
        arguments: WorkoutData.workouts.first,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: colors.chatAiGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.auto_awesome_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aura Recommends',
                    style: textStyles.labelSmall.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Full Body HIIT • 32 min',
                    style: textStyles.h4.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Based on your sleep & recovery data',
                    style: textStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.65),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white, size: 16),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.05);
  }

  Widget _buildQuickActions(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    final actions = [
      _QuickAction(
        label: 'AI Coach',
        icon: Icons.auto_awesome_rounded,
        color: colors.primary,
        route: AppRoutes.aiCoachChat,
      ),
      _QuickAction(
        label: 'Workouts',
        icon: Icons.fitness_center_rounded,
        color: colors.secondary,
        route: AppRoutes.workoutLibrary,
      ),
      _QuickAction(
        label: 'Progress',
        icon: Icons.bar_chart_rounded,
        color: colors.accentGreen,
        route: AppRoutes.analytics,
      ),
      _QuickAction(
        label: 'Log',
        icon: Icons.edit_note_rounded,
        color: colors.accentOrange,
        route: AppRoutes.activityLogger,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: textStyles.h3),
        const SizedBox(height: 14),
        Row(
          children: actions
              .asMap()
              .entries
              .map(
                (e) => Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, e.value.route),
                    child: Animate(
                      delay: (250 + e.key * 60).ms,
                      effects: [
                        FadeEffect(duration: 400.ms),
                        SlideEffect(
                            begin: const Offset(0, 0.1),
                            duration: 400.ms),
                      ],
                      child: Container(
                        margin: EdgeInsets.only(
                            right: e.key < actions.length - 1 ? 10 : 0),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: e.value.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: e.value.color.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            Icon(e.value.icon,
                                color: e.value.color, size: 26),
                            const SizedBox(height: 6),
                            Text(
                              e.value.label,
                              style: textStyles.labelSmall
                                  .copyWith(color: e.value.color),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSchedule(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Upcoming', style: textStyles.h3),
        const SizedBox(height: 12),
        GlassCard(
          onTap: () => Navigator.pushNamed(context, AppRoutes.reminders),
          child: Column(
            children: [
              _scheduleRow(context, '7:00 AM', 'Upper Strength', 'Today'),
              Divider(color: colors.border, height: 20),
              _scheduleRow(context, '6:30 PM', 'Mobility flow', 'Tomorrow'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _scheduleRow(
    BuildContext context,
    String time,
    String title,
    String when,
  ) {
    return Row(
      children: [
        Text(time, style: context.textStyles.labelMedium),
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: context.textStyles.labelLarge)),
        Text(when,
            style: context.textStyles.caption
                .copyWith(color: context.colors.textMuted)),
      ],
    );
  }

  Widget _buildWorkoutCard(BuildContext context, Workout workout) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    final categoryColors = {
      WorkoutCategory.hiit: colors.accentOrange,
      WorkoutCategory.strength: colors.secondary,
      WorkoutCategory.cardio: colors.primary,
      WorkoutCategory.yoga: colors.accentGreen,
    };
    final color = categoryColors[workout.category] ?? colors.primary;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.workoutDetail,
          arguments: workout),
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.6), color.withOpacity(0.2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(Icons.fitness_center_rounded,
                        color: color, size: 36),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: color.withOpacity(0.5)),
                      ),
                      child: Text(
                        workout.category,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.title,
                    style: textStyles.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          color: colors.textMuted, size: 12),
                      const SizedBox(width: 3),
                      Text('${workout.durationMinutes}m',
                          style: textStyles.caption),
                      const SizedBox(width: 10),
                      Icon(Icons.local_fire_department_outlined,
                          color: colors.textMuted, size: 12),
                      const SizedBox(width: 3),
                      Text('${workout.calories} kcal',
                          style: textStyles.caption),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Start →',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  final String route;

  const _QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  });
}
