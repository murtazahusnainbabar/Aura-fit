import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../core/onboarding/onboarding_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'package:aurafit/features/auth/widgets/auth_widgets.dart';

class PersonalizationWizardScreen extends StatefulWidget {
  const PersonalizationWizardScreen({super.key});

  @override
  State<PersonalizationWizardScreen> createState() =>
      _PersonalizationWizardScreenState();
}

class _PersonalizationWizardScreenState
    extends State<PersonalizationWizardScreen> {
  int _step = 0;
  late OnboardingProfile _draft;

  @override
  void initState() {
    super.initState();
    _draft = context.read<OnboardingProvider>().profile;
  }

  Future<void> _next() async {
    if (!_canContinue) return;
    await context.read<OnboardingProvider>().updateProfile(_draft);
    if (_step < 4) {
      setState(() => _step++);
      return;
    }
    if (!mounted) return;
    Navigator.pushNamed(context, AppRoutes.permissions);
  }

  bool get _canContinue {
    switch (_step) {
      case 0:
        return _draft.gender.isNotEmpty;
      case 2:
        return _draft.fitnessLevel.isNotEmpty;
      case 3:
        return _draft.goal.isNotEmpty;
      case 4:
        return _draft.equipment.isNotEmpty;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (_step == 0) {
                      Navigator.maybePop(context);
                    } else {
                      setState(() => _step--);
                    }
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: (_step + 1) / 5,
                      minHeight: 6,
                      backgroundColor: context.colors.border,
                      color: context.colors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text('${_step + 1}/5', style: context.textStyles.caption),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: _buildStep(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: AuthPrimaryButton(
              label: _step == 4 ? 'Continue' : 'Next',
              onPressed: _canContinue ? _next : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _AboutYouStep(
          age: _draft.age,
          gender: _draft.gender,
          onAge: (v) => setState(() => _draft = _draft.copyWith(age: v)),
          onGender: (v) => setState(() => _draft = _draft.copyWith(gender: v)),
        );
      case 1:
        return _BodyStep(
          height: _draft.heightCm,
          weight: _draft.weightKg,
          target: _draft.targetWeightKg,
          onHeight: (v) =>
              setState(() => _draft = _draft.copyWith(heightCm: v)),
          onWeight: (v) =>
              setState(() => _draft = _draft.copyWith(weightKg: v)),
          onTarget: (v) =>
              setState(() => _draft = _draft.copyWith(targetWeightKg: v)),
        );
      case 2:
        return _ChoiceStep(
          title: 'What\'s your fitness level?',
          subtitle: 'Aura uses this to set starting intensity.',
          options: const ['Beginner', 'Intermediate', 'Advanced'],
          selected: _draft.fitnessLevel,
          onSelect: (v) =>
              setState(() => _draft = _draft.copyWith(fitnessLevel: v)),
        );
      case 3:
        return _ChoiceStep(
          title: 'What\'s your primary goal?',
          subtitle: 'You can change this anytime in settings.',
          options: const ['Strength', 'Weight Loss', 'Mobility'],
          selected: _draft.goal,
          onSelect: (v) => setState(() => _draft = _draft.copyWith(goal: v)),
        );
      default:
        return _EquipmentStep(
          selected: _draft.equipment,
          onToggle: (item) {
            final next = [..._draft.equipment];
            if (next.contains(item)) {
              next.remove(item);
            } else {
              next.add(item);
            }
            setState(() => _draft = _draft.copyWith(equipment: next));
          },
        );
    }
  }
}

class _AboutYouStep extends StatelessWidget {
  final int age;
  final String gender;
  final ValueChanged<int> onAge;
  final ValueChanged<String> onGender;

  const _AboutYouStep({
    required this.age,
    required this.gender,
    required this.onAge,
    required this.onGender,
  });

  @override
  Widget build(BuildContext context) {
    const genders = ['Male', 'Female', 'Non-binary', 'Prefer not to say'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tell Aura about you', style: context.textStyles.displayMedium),
        const SizedBox(height: 8),
        Text(
          'Age and gender help calibrate calorie burn and recovery.',
          style: context.textStyles.bodyMedium
              .copyWith(color: context.colors.textSecondary),
        ),
        const SizedBox(height: 28),
        Text('Age · $age', style: context.textStyles.h4),
        Slider(
          value: age.toDouble(),
          min: 14,
          max: 80,
          divisions: 66,
          label: '$age',
          onChanged: (v) => onAge(v.round()),
        ),
        const SizedBox(height: 12),
        Text('Gender', style: context.textStyles.h4),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: genders
              .map(
                (g) => ChoiceChip(
                  label: Text(g),
                  selected: gender == g,
                  onSelected: (_) => onGender(g),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _BodyStep extends StatelessWidget {
  final double height;
  final double weight;
  final double target;
  final ValueChanged<double> onHeight;
  final ValueChanged<double> onWeight;
  final ValueChanged<double> onTarget;

  const _BodyStep({
    required this.height,
    required this.weight,
    required this.target,
    required this.onHeight,
    required this.onWeight,
    required this.onTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Body metrics', style: context.textStyles.displayMedium),
        const SizedBox(height: 8),
        Text(
          'Used for BMI context, load suggestions, and progress tracking.',
          style: context.textStyles.bodyMedium
              .copyWith(color: context.colors.textSecondary),
        ),
        const SizedBox(height: 24),
        _metric(context, 'Height', '${height.round()} cm', height, 140, 220,
            onHeight),
        _metric(context, 'Current weight', '${weight.toStringAsFixed(1)} kg',
            weight, 40, 180, onWeight),
        _metric(context, 'Target weight', '${target.toStringAsFixed(1)} kg',
            target, 40, 180, onTarget),
      ],
    );
  }

  Widget _metric(
    BuildContext context,
    String label,
    String value,
    double current,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: context.textStyles.h4),
            const Spacer(),
            Text(value,
                style: context.textStyles.labelLarge
                    .copyWith(color: context.colors.primary)),
          ],
        ),
        Slider(
          value: current.clamp(min, max),
          min: min,
          max: max,
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _ChoiceStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;

  const _ChoiceStep({
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.textStyles.displayMedium),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: context.textStyles.bodyMedium
              .copyWith(color: context.colors.textSecondary),
        ),
        const SizedBox(height: 24),
        ...options.map((option) {
          final active = selected == option;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              onTap: () => onSelect(option),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: active
                      ? context.colors.primary
                      : context.colors.border,
                ),
              ),
              tileColor: active
                  ? context.colors.primary.withOpacity(0.1)
                  : context.colors.surface,
              title: Text(option, style: context.textStyles.h4),
              trailing: active
                  ? Icon(Icons.check_circle, color: context.colors.primary)
                  : null,
            ),
          );
        }),
      ],
    );
  }
}

class _EquipmentStep extends StatelessWidget {
  final List<String> selected;
  final ValueChanged<String> onToggle;

  const _EquipmentStep({required this.selected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    const items = [
      'Bodyweight',
      'Dumbbells',
      'Barbell',
      'Resistance bands',
      'Machines',
      'Cardio equipment',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What equipment can you access?',
            style: context.textStyles.displayMedium),
        const SizedBox(height: 8),
        Text(
          'Aura will only prescribe movements you can actually do.',
          style: context.textStyles.bodyMedium
              .copyWith(color: context.colors.textSecondary),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map(
                (item) => FilterChip(
                  label: Text(item),
                  selected: selected.contains(item),
                  onSelected: (_) => onToggle(item),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
