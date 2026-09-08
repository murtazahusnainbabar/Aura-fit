import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/constants/app_routes.dart';

class AIPlanGenerationScreen extends StatefulWidget {
  const AIPlanGenerationScreen({super.key});

  @override
  State<AIPlanGenerationScreen> createState() => _AIPlanGenerationScreenState();
}

class _AIPlanGenerationScreenState extends State<AIPlanGenerationScreen> {
  int _step = 0;
  final int _totalSteps = 4;
  String? _selectedGoal;
  String? _fitnessLevel;
  final Set<String> _equipment = {};
  int _daysPerWeek = 4;
  bool _isGenerating = false;

  final List<_GoalOption> _goals = [
    _GoalOption('Build Muscle', Icons.fitness_center_rounded, AppColors.secondary),
    _GoalOption('Fat Loss', Icons.local_fire_department_rounded, AppColors.accentOrange),
    _GoalOption('Endurance', Icons.directions_run_rounded, AppColors.primary),
    _GoalOption('Flexibility', Icons.self_improvement_rounded, AppColors.accentGreen),
  ];

  final List<String> _levels = ['Beginner', 'Intermediate', 'Advanced'];
  final List<String> _equipmentOptions = [
    'No Equipment',
    'Dumbbells',
    'Barbell',
    'Resistance Bands',
    'Kettlebells',
    'Pull-up Bar',
    'Full Gym',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  if (_step > 0)
                    GestureDetector(
                      onTap: () => setState(() => _step--),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 16, color: AppColors.textSecondary),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.close_rounded,
                            size: 18, color: AppColors.textSecondary),
                      ),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Build Your AI Plan',
                            style: AppTextStyles.h3),
                        Text('Step ${_step + 1} of $_totalSteps',
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome_rounded,
                            color: AppColors.primary, size: 14),
                        const SizedBox(width: 4),
                        Text('AI',
                            style: AppTextStyles.labelSmall
                                .copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Progress
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (_step + 1) / _totalSteps,
                  backgroundColor: AppColors.border,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 28),
              // Step content
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildStep(_step),
                ),
              ),
              // CTA
              if (!_isGenerating)
                GradientButton(
                  label: _step < _totalSteps - 1
                      ? 'Continue →'
                      : '✨ Generate My Plan',
                  gradient: _step < _totalSteps - 1
                      ? AppColors.primaryGradient
                      : AppColors.cyanPurpleGradient,
                  onTap: _onContinue,
                ),
              if (_isGenerating) _buildGeneratingState(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        return _buildGoalStep();
      case 1:
        return _buildLevelStep();
      case 2:
        return _buildEquipmentStep();
      case 3:
        return _buildFrequencyStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildGoalStep() {
    return Column(
      key: const ValueKey('goal'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What\'s your primary goal?', style: AppTextStyles.h2),
        const SizedBox(height: 8),
        Text(
          'Aura will craft a plan perfectly tailored to your objective.',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 24),
        ...List.generate(
          _goals.length,
          (i) => GestureDetector(
            onTap: () => setState(() => _selectedGoal = _goals[i].label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _selectedGoal == _goals[i].label
                    ? _goals[i].color.withOpacity(0.15)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _selectedGoal == _goals[i].label
                      ? _goals[i].color
                      : AppColors.border,
                  width: _selectedGoal == _goals[i].label ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _goals[i].color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_goals[i].icon, color: _goals[i].color),
                  ),
                  const SizedBox(width: 14),
                  Text(_goals[i].label, style: AppTextStyles.h4),
                  const Spacer(),
                  if (_selectedGoal == _goals[i].label)
                    Icon(Icons.check_circle_rounded,
                        color: _goals[i].color, size: 22),
                ],
              ),
            ).animate(delay: (i * 60).ms).fadeIn().slideX(begin: 0.05),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelStep() {
    return Column(
      key: const ValueKey('level'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What\'s your fitness level?', style: AppTextStyles.h2),
        const SizedBox(height: 8),
        Text('Be honest — Aura adapts to you perfectly.',
            style: AppTextStyles.bodySmall),
        const SizedBox(height: 24),
        ..._levels.asMap().entries.map(
              (e) => GestureDetector(
                onTap: () => setState(() => _fitnessLevel = e.value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _fitnessLevel == e.value
                        ? AppColors.primary.withOpacity(0.12)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _fitnessLevel == e.value
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        ['🌱', '⚡', '🔥'][e.key],
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 14),
                      Text(e.value, style: AppTextStyles.h4),
                      const Spacer(),
                      if (_fitnessLevel == e.value)
                        const Icon(Icons.check_circle_rounded,
                            color: AppColors.primary, size: 22),
                    ],
                  ),
                ).animate(delay: (e.key * 80).ms).fadeIn().slideX(begin: 0.05),
              ),
            ),
      ],
    );
  }

  Widget _buildEquipmentStep() {
    return Column(
      key: const ValueKey('equipment'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Available equipment?', style: AppTextStyles.h2),
        const SizedBox(height: 8),
        Text('Select all that apply.', style: AppTextStyles.bodySmall),
        const SizedBox(height: 24),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _equipmentOptions
              .map(
                (eq) => GestureDetector(
                  onTap: () => setState(() {
                    if (_equipment.contains(eq)) {
                      _equipment.remove(eq);
                    } else {
                      _equipment.add(eq);
                    }
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: _equipment.contains(eq)
                          ? AppColors.primary.withOpacity(0.15)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _equipment.contains(eq)
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      eq,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _equipment.contains(eq)
                            ? AppColors.primary
                            : AppColors.textSecondary,
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

  Widget _buildFrequencyStep() {
    return Column(
      key: const ValueKey('frequency'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Days per week?', style: AppTextStyles.h2),
        const SizedBox(height: 8),
        Text('Consistency is the key to results.',
            style: AppTextStyles.bodySmall),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (_daysPerWeek > 2) {
                  setState(() => _daysPerWeek--);
                }
              },
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.remove_rounded,
                    color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(width: 24),
            Text(
              '$_daysPerWeek',
              style: AppTextStyles.displayLarge.copyWith(
                color: AppColors.primary,
                fontSize: 56,
              ),
            ),
            const SizedBox(width: 24),
            GestureDetector(
              onTap: () {
                if (_daysPerWeek < 7) {
                  setState(() => _daysPerWeek++);
                }
              },
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.add_rounded, color: Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'days per week',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 32),
        GlassCard(
          borderColor: AppColors.primary.withOpacity(0.3),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded,
                      color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text('Your Plan Summary',
                      style: AppTextStyles.labelLarge
                          .copyWith(color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 12),
              _buildSummaryRow('Goal', _selectedGoal ?? '—'),
              _buildSummaryRow('Level', _fitnessLevel ?? '—'),
              _buildSummaryRow(
                  'Equipment',
                  _equipment.isEmpty
                      ? 'None selected'
                      : _equipment.take(2).join(', ')),
              _buildSummaryRow('Frequency', '$_daysPerWeek days/week'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label,
              style:
                  AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
          const Spacer(),
          Text(value, style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }

  Widget _buildGeneratingState() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Text('Aura is generating your plan…',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.primary)),
          ],
        ),
      ],
    );
  }

  void _onContinue() {
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
    } else {
      setState(() => _isGenerating = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.aiCoachChat);
        }
      });
    }
  }
}

class _GoalOption {
  final String label;
  final IconData icon;
  final Color color;
  const _GoalOption(this.label, this.icon, this.color);
}
