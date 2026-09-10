import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../core/status/app_status_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/state_views.dart';

class SystemStatusScreen extends StatelessWidget {
  const SystemStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          title: const Text('Fallback states'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Empty'),
              Tab(text: 'Offline'),
              Tab(text: 'Error'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            EmptyStateView(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'No conversations yet',
              message:
                  'Start a chat with Aura or log your first workout to see history here.',
              actionLabel: 'Start a workout',
              onAction: () =>
                  Navigator.pushNamed(context, AppRoutes.workoutLibrary),
            ),
            Column(
              children: [
                const OfflineBanner(),
                Expanded(
                  child: EmptyStateView(
                    icon: Icons.wifi_off_rounded,
                    title: 'You\'re offline',
                    message:
                        'Cached workouts and saved routines are still available. Logging syncs when you reconnect.',
                    actionLabel: 'Go to library',
                    onAction: () =>
                        Navigator.pushNamed(context, AppRoutes.workoutLibrary),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: FilledButton(
                    onPressed: () =>
                        context.read<AppStatusProvider>().setOffline(false),
                    child: const Text('I\'m back online'),
                  ),
                ),
              ],
            ),
            ErrorStateView(
              onRetry: () {
                context.read<AppStatusProvider>().setLastActionFailed(false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Retrying… you\'re good.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
