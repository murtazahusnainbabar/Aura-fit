import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/wellness/wellness_provider.dart';
import 'package:aurafit/features/auth/widgets/auth_widgets.dart';

class ActivityLoggerScreen extends StatefulWidget {
  const ActivityLoggerScreen({super.key});

  @override
  State<ActivityLoggerScreen> createState() => _ActivityLoggerScreenState();
}

class _ActivityLoggerScreenState extends State<ActivityLoggerScreen> {
  final _mealController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _mealController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wellness = context.watch<WellnessProvider>();
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: const Text('Log activity')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Water', style: context.textStyles.h4),
          const SizedBox(height: 8),
          Text(
            '${wellness.waterLiters.toStringAsFixed(1)} L today',
            style: context.textStyles.bodyMedium
                .copyWith(color: context.colors.textSecondary),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _chip(context, '+250 ml', () => wellness.addWater(0.25)),
              const SizedBox(width: 8),
              _chip(context, '+500 ml', () => wellness.addWater(0.5)),
            ],
          ),
          const SizedBox(height: 24),
          Text('Daily weight', style: context.textStyles.h4),
          const SizedBox(height: 8),
          AuthTextField(
            controller: _weightController,
            label: 'Weight (kg)',
            hint: wellness.weightKg.toStringAsFixed(1),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: () {
                final value = double.tryParse(_weightController.text);
                if (value != null) wellness.setWeight(value);
              },
              child: const Text('Save weight'),
            ),
          ),
          const SizedBox(height: 24),
          Text('Sleep', style: context.textStyles.h4),
          Text(
            '${wellness.sleepHours.toStringAsFixed(1)} hours',
            style: context.textStyles.bodyMedium
                .copyWith(color: context.colors.textSecondary),
          ),
          Slider(
            value: wellness.sleepHours,
            min: 4,
            max: 12,
            divisions: 16,
            label: '${wellness.sleepHours.toStringAsFixed(1)}h',
            onChanged: wellness.setSleep,
          ),
          const SizedBox(height: 12),
          Text('Mood', style: context.textStyles.h4),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Energized', 'Okay', 'Tired', 'Sore']
                .map(
                  (mood) => ChoiceChip(
                    label: Text(mood),
                    selected: wellness.mood == mood,
                    onSelected: (_) => wellness.setMood(mood),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          Text('Custom meal', style: context.textStyles.h4),
          const SizedBox(height: 8),
          AuthTextField(
            controller: _mealController,
            label: 'What did you eat?',
            hint: 'Greek yogurt + honey',
          ),
          const SizedBox(height: 8),
          AuthPrimaryButton(
            label: 'Log meal',
            onPressed: () {
              wellness.addMeal(_mealController.text);
              _mealController.clear();
            },
          ),
          const SizedBox(height: 16),
          ...wellness.meals.map(
            (meal) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.restaurant_rounded,
                  color: context.colors.primary),
              title: Text(meal, style: context.textStyles.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label, VoidCallback onTap) {
    return ActionChip(label: Text(label), onPressed: onTap);
  }
}
