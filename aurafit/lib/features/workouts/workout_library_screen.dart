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
  String _duration = 'Any';
  String _difficulty = 'Any';

  final List<String> _categories = [
    WorkoutCategory.all,
    WorkoutCategory.strength,
    WorkoutCategory.hiit,
    WorkoutCategory.yoga,
    WorkoutCategory.recovery,
  ];

  List<Workout> get _filteredWorkouts {
    return WorkoutData.workouts.where((w) {
      final matchesCategory =
          _selectedCategory == WorkoutCategory.all ||
              w.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          w.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesDuration = _duration == 'Any' ||
          (_duration == '<30' && w.durationMinutes < 30) ||
          (_duration == '30-45' &&
              w.durationMinutes >= 30 &&
              w.durationMinutes <= 45) ||
          (_duration == '45+' && w.durationMinutes > 45);
      final matchesDifficulty =
          _difficulty == 'Any' || w.difficulty == _difficulty;
      return matchesCategory &&
          matchesSearch &&
          matchesDuration &&
          matchesDifficulty;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      backgroundColor: colors.background,
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
                      Text('Workouts', style: textStyles.h1),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: colors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: colors.primary.withOpacity(0.4)),
                        ),
                        child: Text(
                          '${WorkoutData.workouts.length} Programs',
                          style: textStyles.labelSmall
                              .copyWith(color: colors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search
                  TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: TextStyle(
                        color: colors.textPrimary, fontFamily: 'Inter'),
                    decoration: InputDecoration(
                      hintText: 'Search workouts…',
                      prefixIcon: Icon(Icons.search_rounded,
                          color: colors.textMuted, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              child: Icon(Icons.close_rounded,
                                  color: colors.textMuted, size: 18),
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
                                  ? colors.primary
                                  : colors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? colors.primary
                                    : colors.border,
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
                                    ? colors.background
                                    : colors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 34,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...['Any', '<30', '30-45', '45+'].map((d) {
                          final selected = _duration == d;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(d == 'Any' ? 'Duration' : '$d min'),
                              selected: selected && d != 'Any',
                              onSelected: (_) =>
                                  setState(() => _duration = d),
                            ),
                          );
                        }),
                        ...['Any', 'Beginner', 'Intermediate', 'Advanced']
                            .skip(1)
                            .map((d) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(d),
                              selected: _difficulty == d,
                              onSelected: (_) => setState(() {
                                _difficulty =
                                    _difficulty == d ? 'Any' : d;
                              }),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  GlassCard(
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.aiPlanGeneration),
                    child: Row(
                      children: [
                        Icon(Icons.auto_awesome_rounded,
                            color: colors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('AI-generated programs',
                              style: textStyles.labelLarge),
                        ),
                        Text('Open',
                            style: textStyles.caption
                                .copyWith(color: colors.primary)),
                      ],
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
                          Icon(Icons.search_off_rounded,
                              color: colors.textMuted, size: 48),
                          const SizedBox(height: 12),
                          Text('No workouts found',
                              style: textStyles.bodyMedium
                                  .copyWith(color: colors.textMuted)),
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
                              style: textStyles.caption
                                  .copyWith(color: color)),
                        ),
                        if (workout.isFeatured) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: colors.accentGreen.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Featured',
                                style: textStyles.caption.copyWith(
                                    color: colors.accentGreen)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      workout.title,
                      style: textStyles.h4,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.timer_outlined,
                            color: colors.textMuted, size: 12),
                        const SizedBox(width: 3),
                        Text('${workout.durationMinutes} min',
                            style: textStyles.caption),
                        const SizedBox(width: 12),
                        Icon(Icons.local_fire_department_outlined,
                            color: colors.textMuted, size: 12),
                        const SizedBox(width: 3),
                        Text('${workout.calories} kcal',
                            style: textStyles.caption),
                        const SizedBox(width: 12),
                        Icon(Icons.signal_cellular_alt_rounded,
                            color: colors.textMuted, size: 12),
                        const SizedBox(width: 3),
                        Text(workout.difficulty,
                            style: textStyles.caption),
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
