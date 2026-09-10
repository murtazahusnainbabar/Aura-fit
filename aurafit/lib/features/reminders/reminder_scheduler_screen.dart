import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/reminders/reminder_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/state_views.dart';

class ReminderSchedulerScreen extends StatelessWidget {
  const ReminderSchedulerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reminders = context.watch<ReminderProvider>().reminders;
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: const Text('Reminders')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context),
        icon: const Icon(Icons.add),
        label: const Text('New reminder'),
      ),
      body: reminders.isEmpty
          ? EmptyStateView(
              icon: Icons.alarm_off_rounded,
              title: 'No reminders yet',
              message:
                  'Set workout alarms, hydration nudges, posture checks, or a bedtime wind-down.',
              actionLabel: 'Create reminder',
              onAction: () => _add(context),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              itemCount: reminders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final item = reminders[i];
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: context.colors.border),
                  ),
                  title: Text(item.title, style: context.textStyles.h4),
                  subtitle: Text('${item.type} · ${item.timeLabel}'),
                  trailing: Switch.adaptive(
                    value: item.enabled,
                    onChanged: (_) =>
                        context.read<ReminderProvider>().toggle(item.id),
                  ),
                  onTap: () => _edit(context, item),
                  onLongPress: () =>
                      context.read<ReminderProvider>().remove(item.id),
                );
              },
            ),
    );
  }

  Future<void> _add(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 7, minute: 0),
    );
    if (time == null || !context.mounted) return;
    final type = await _pickType(context);
    if (type == null || !context.mounted) return;
    await context.read<ReminderProvider>().add(
          AppReminder(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: type,
            type: type,
            hour: time.hour,
            minute: time.minute,
          ),
        );
  }

  Future<void> _edit(BuildContext context, AppReminder item) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: item.hour, minute: item.minute),
    );
    if (time == null || !context.mounted) return;
    await context.read<ReminderProvider>().update(
          item.copyWith(hour: time.hour, minute: time.minute),
        );
  }

  Future<String?> _pickType(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        const types = [
          'Workout',
          'Hydration',
          'Posture check-in',
          'Bedtime wind-down',
        ];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: types
                .map(
                  (type) => ListTile(
                    title: Text(type),
                    onTap: () => Navigator.pop(context, type),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
