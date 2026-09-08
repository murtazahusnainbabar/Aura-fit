import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/constants/app_routes.dart';
import '../../models/workout.dart';
import '../../models/exercise.dart';

class WorkoutDetailScreen extends StatelessWidget {
  const WorkoutDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workout =
        ModalRoute.of(context)?.settings.arguments as Workout? ??
            WorkoutData.workouts.first;

    final categoryColors = {
      WorkoutCategory.hiit: AppColors.accentOrange,
      WorkoutCategory.strength: AppColors.secondary,
      WorkoutCategory.cardio: AppColors.primary,
      WorkoutCategory.yoga: AppColors.accentGreen,
    };
    final color = categoryColors[workout.category] ?? AppColors.primary;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Hero Header
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppColors.background,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.bookmark_border_rounded,
                          color: Colors.white, size: 22),
                      onPressed: () {},
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.7),
                          AppColors.background,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Icon(Icons.fitness_center_rounded,
                              color: color, size: 48),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            workout.category,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(workout.title, style: AppTextStyles.h1)
                          .animate()
                          .fadeIn(duration: 400.ms),
                      const SizedBox(height: 6),
                      Text(workout.equipment,
                              style: AppTextStyles.bodySmall)
                          .animate()
                          .fadeIn(delay: 100.ms),
                      const SizedBox(height: 20),
                      // Stats row
                      Row(
                        children: [
                          _buildStatPill(Icons.timer_outlined,
                              '${workout.durationMinutes} min', color),
                          const SizedBox(width: 10),
                          _buildStatPill(
                              Icons.local_fire_department_outlined,
                              '${workout.calories} kcal',
                              AppColors.accentOrange),
                          const SizedBox(width: 10),
                          _buildStatPill(
                              Icons.signal_cellular_alt_rounded,
                              workout.difficulty,
                              AppColors.secondary),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Target muscles
                      if (workout.targetMuscles.isNotEmpty) ...[
                        Text('Target Muscles', style: AppTextStyles.h4),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: workout.targetMuscles
                              .map(
                                (m) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: color.withOpacity(0.3)),
                                  ),
                                  child: Text(m,
                                      style: AppTextStyles.labelMedium
                                          .copyWith(color: color)),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                      ],
                      // Exercises
                      Row(
                        children: [
                          Text('Exercises', style: AppTextStyles.h4),
                          const Spacer(),
                          Text(
                            '${workout.exercises.length} exercises',
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      if (workout.exercises.isEmpty)
                        _buildPlaceholderExercises(color)
                      else
                        ...workout.exercises.asMap().entries.map(
                              (e) => _buildExerciseRow(
                                  e.value, e.key + 1, color),
                            ),
                      const SizedBox(height: 20),
                      // AI tip card
                      GlassCard(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF0D1A2D),
                            Color(0xFF1A0D2D),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderColor: AppColors.primary.withOpacity(0.3),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.lightbulb_outline_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Aura AI Tip',
                                    style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColors.primary),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Focus on form over speed. Rest 60s between sets for optimal muscle activation.',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Sticky bottom CTA
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.background.withOpacity(0),
                    AppColors.background,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: GradientButton(
                label: '▶  Start Workout',
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                ),
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.liveWorkout,
                  arguments: workout,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color)),
        ],
      ),
    );
  }

  Widget _buildExerciseRow(Exercise exercise, int index, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercise.name, style: AppTextStyles.labelLarge),
                const SizedBox(height: 2),
                Text(exercise.muscleGroup,
                    style: AppTextStyles.caption),
              ],
            ),
          ),
          Text(
            exercise.durationSeconds != null
                ? '${exercise.sets} × ${exercise.durationSeconds}s'
                : '${exercise.sets} × ${exercise.reps} reps',
            style: AppTextStyles.labelMedium
                .copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    )
        .animate(delay: (index * 50).ms)
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.05);
  }

  Widget _buildPlaceholderExercises(Color color) {
    final placeholders = [
      ('Jumping Jacks', 'Full Body', '3 × 20 reps'),
      ('Goblet Squats', 'Legs', '4 × 12 reps'),
      ('Push-ups', 'Chest', '3 × 15 reps'),
      ('Mountain Climbers', 'Core', '3 × 30 reps'),
      ('Plank', 'Core', '3 × 45s'),
    ];
    return Column(
      children: placeholders.indexed
          .map(
            (entry) => _buildStaticExerciseRow(
                entry.$2.$1, entry.$2.$2, entry.$2.$3, entry.$1 + 1, color),
          )
          .toList(),
    );
  }

  Widget _buildStaticExerciseRow(
      String name, String muscle, String setsReps, int index, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.labelLarge),
                Text(muscle, style: AppTextStyles.caption),
              ],
            ),
          ),
          Text(setsReps,
              style: AppTextStyles.labelMedium
                  .copyWith(color: AppColors.textPrimary)),
        ],
      ),
    )
        .animate(delay: (index * 50).ms)
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.05);
  }
}
