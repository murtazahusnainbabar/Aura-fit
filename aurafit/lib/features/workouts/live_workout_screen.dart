import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/constants/app_routes.dart';
import '../../models/workout.dart';

class LiveWorkoutScreen extends StatefulWidget {
  const LiveWorkoutScreen({super.key});

  @override
  State<LiveWorkoutScreen> createState() => _LiveWorkoutScreenState();
}

class _LiveWorkoutScreenState extends State<LiveWorkoutScreen>
    with TickerProviderStateMixin {
  int _currentExercise = 0;
  int _currentSet = 1;
  bool _isPaused = false;
  int _countdownSeconds = 45;
  late Timer _timer;
  int _totalSeconds = 0;
  int _calories = 0;
  int _bpm = 128;

  late AnimationController _pulseController;

  final List<Map<String, String>> _exercises = [
    {'name': 'Jumping Jacks', 'target': 'Full Body'},
    {'name': 'Goblet Squats', 'target': 'Legs'},
    {'name': 'Push-ups', 'target': 'Chest'},
    {'name': 'Mountain Climbers', 'target': 'Core'},
    {'name': 'Plank', 'target': 'Core'},
    {'name': 'Burpees', 'target': 'Full Body'},
    {'name': 'High Knees', 'target': 'Cardio'},
    {'name': 'Cool Down Stretch', 'target': 'Flexibility'},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!_isPaused) {
        setState(() {
          _totalSeconds++;
          _calories = (_totalSeconds * 0.13).round();
          if (_countdownSeconds > 0) {
            _countdownSeconds--;
          } else {
            _nextExercise();
          }
        });
      }
    });
  }

  void _nextExercise() {
    if (_currentExercise < _exercises.length - 1) {
      setState(() {
        _currentExercise++;
        _currentSet = 1;
        _countdownSeconds = 45;
      });
    } else {
      _timer.cancel();
      Navigator.pushReplacementNamed(context, AppRoutes.workoutCompletion);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final m = _totalSeconds ~/ 60;
    final s = _totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_exercises.length - _countdownSeconds / 45) /
        _exercises.length;
    final currentExercise = _exercises[_currentExercise];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _showExitDialog(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: AppColors.textSecondary, size: 20),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Text(_formattedTime,
                          style: AppTextStyles.h2
                              .copyWith(color: AppColors.primary)),
                      Text('Duration',
                          style: AppTextStyles.labelSmall),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.mic_rounded,
                        color: AppColors.primary, size: 20),
                  ),
                ],
              ),
            ),
            // Progress bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Exercise ${_currentExercise + 1} of ${_exercises.length}',
                        style: AppTextStyles.labelMedium,
                      ),
                      Text(
                        '${(progress * 100).toInt()}% Complete',
                        style: AppTextStyles.labelMedium
                            .copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (_currentExercise + 1) / _exercises.length,
                      backgroundColor: AppColors.border,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Exercise visual
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary
                            .withOpacity(0.15 + _pulseController.value * 0.1),
                        AppColors.background,
                      ],
                    ),
                    border: Border.all(
                      color: AppColors.primary
                          .withOpacity(0.5 + _pulseController.value * 0.3),
                      width: 2 + _pulseController.value * 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(
                            0.15 + _pulseController.value * 0.15),
                        blurRadius: 40 + _pulseController.value * 20,
                        spreadRadius: 5 + _pulseController.value * 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.fitness_center_rounded,
                          color: AppColors.primary, size: 56),
                      const SizedBox(height: 12),
                      Text(
                        currentExercise['name']!,
                        style: AppTextStyles.h4.copyWith(fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        currentExercise['target']!,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Countdown
            Text(
              '$_countdownSeconds',
              style: AppTextStyles.displayLarge.copyWith(
                fontSize: 72,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ).animate(key: ValueKey(_countdownSeconds)).scale(
                  begin: const Offset(1.1, 1.1),
                  end: const Offset(1.0, 1.0),
                  duration: 200.ms,
                ),
            Text('seconds remaining',
                style: AppTextStyles.bodySmall),
            const SizedBox(height: 24),
            // Live stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      Icons.favorite_rounded,
                      '$_bpm',
                      'BPM',
                      AppColors.accentRed,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      Icons.local_fire_department_rounded,
                      '$_calories',
                      'kcal',
                      AppColors.accentOrange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      Icons.repeat_rounded,
                      '$_currentSet',
                      'Set',
                      AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isPaused = !_isPaused),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Icon(
                          _isPaused
                              ? Icons.play_arrow_rounded
                              : Icons.pause_rounded,
                          color: AppColors.textPrimary,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: GradientButton(
                      label: 'Next Exercise',
                      onTap: _nextExercise,
                      icon: const Icon(Icons.skip_next_rounded,
                          color: AppColors.background, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              )),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('End Workout?', style: AppTextStyles.h3),
        content: Text(
          'You\'ve completed ${_currentExercise + 1} of ${_exercises.length} exercises. End now?',
          style: AppTextStyles.bodyMedium
              .copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Continue',
                style:
                    AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
          ),
          TextButton(
            onPressed: () {
              _timer.cancel();
              Navigator.pop(context);
              Navigator.pushReplacementNamed(
                  context, AppRoutes.workoutCompletion);
            },
            child: Text('End',
                style: AppTextStyles.labelLarge
                    .copyWith(color: AppColors.accentRed)),
          ),
        ],
      ),
    );
  }
}
