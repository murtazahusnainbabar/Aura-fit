import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/constants/app_routes.dart';
import '../../models/workout.dart';

class WorkoutLibraryScreen extends StatefulWidget {
  const WorkoutLibraryScreen({super.key});

  @override
  State<WorkoutLibraryScreen> createState() => _WorkoutLibraryScreenState();
}

class _WorkoutLibraryScreenState extends State<WorkoutLibraryScreen> {
  String _selectedCategory = WorkoutCategory.all;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _categories = [
    WorkoutCategory.all,
    WorkoutCategory.strength,
    WorkoutCategory.hiit,
    WorkoutCategory.cardio,
    WorkoutCategory.yoga,
  ];

  List<Workout> get _filteredWorkouts {
    return WorkoutData.workouts.where((w) {
      final matchesCategory =
          _selectedCategory == WorkoutCategory.all ||
              w.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          w.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Workouts', style: AppTextStyles.h1),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.4)),
                        ),
                        child: Text(
                          '${WorkoutData.workouts.length} Programs',
                          style: AppTextStyles.labelSmall
                              .copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search
                  TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontFamily: 'Inter'),
                    decoration: InputDecoration(
                      hintText: 'Search workouts…',
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppColors.textMuted, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              child: const Icon(Icons.close_rounded,
                                  color: AppColors.textMuted, size: 18),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Filter chips
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final cat = _categories[i];
                        final isSelected = _selectedCategory == cat;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCategory = cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? AppColors.background
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // Workout list
            Expanded(
              child: _filteredWorkouts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search_off_rounded,
                              color: AppColors.textMuted, size: 48),
                          const SizedBox(height: 12),
                          Text('No workouts found',
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: AppColors.textMuted)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _filteredWorkouts.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final workout = _filteredWorkouts[index];
                        return _buildWorkoutListCard(context, workout, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutListCard(
      BuildContext context, Workout workout, int index) {
    final categoryColors = {
      WorkoutCategory.hiit: AppColors.accentOrange,
      WorkoutCategory.strength: AppColors.secondary,
      WorkoutCategory.cardio: AppColors.primary,
      WorkoutCategory.yoga: AppColors.accentGreen,
    };
    final color = categoryColors[workout.category] ?? AppColors.primary;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.workoutDetail,
          arguments: workout),
      child: GlassCard(
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.6), color.withOpacity(0.2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Icon(Icons.fitness_center_rounded, color: color, size: 30),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(workout.category,
                              style: AppTextStyles.caption
                                  .copyWith(color: color)),
                        ),
                        if (workout.isFeatured) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.accentGreen.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Featured',
                                style: AppTextStyles.caption.copyWith(
                                    color: AppColors.accentGreen)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      workout.title,
                      style: AppTextStyles.h4,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined,
                            color: AppColors.textMuted, size: 12),
                        const SizedBox(width: 3),
                        Text('${workout.durationMinutes} min',
                            style: AppTextStyles.caption),
                        const SizedBox(width: 12),
                        const Icon(Icons.local_fire_department_outlined,
                            color: AppColors.textMuted, size: 12),
                        const SizedBox(width: 3),
                        Text('${workout.calories} kcal',
                            style: AppTextStyles.caption),
                        const SizedBox(width: 12),
                        Icon(Icons.signal_cellular_alt_rounded,
                            color: AppColors.textMuted, size: 12),
                        const SizedBox(width: 3),
                        Text(workout.difficulty,
                            style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Icon(Icons.play_circle_filled_rounded,
                  color: color, size: 36),
            ),
          ],
        ),
      )
          .animate(delay: (index * 60).ms)
          .fadeIn(duration: 400.ms)
          .slideX(begin: 0.05),
    );
  }
}
