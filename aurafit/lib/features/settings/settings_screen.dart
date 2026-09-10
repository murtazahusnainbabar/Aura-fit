import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../core/onboarding/onboarding_provider.dart';
import '../../core/status/app_status_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final onboarding = context.watch<OnboardingProvider>();
    final status = context.watch<AppStatusProvider>();

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: const Text('Settings & integrations')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Appearance', style: context.textStyles.h4),
          SwitchListTile.adaptive(
            title: const Text('Dark mode'),
            value: theme.isDarkMode,
            onChanged: (_) => theme.toggleTheme(),
          ),
          const Divider(height: 32),
          Text('Subscription', style: context.textStyles.h4),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Aura Pro'),
            subtitle: const Text('Manage plan, billing, and trial'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.pushNamed(context, AppRoutes.subscription),
          ),
          const Divider(height: 32),
          Text('Health sync', style: context.textStyles.h4),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Apple Health / Health Connect'),
            subtitle: Text(onboarding.healthGranted ? 'Connected' : 'Not connected'),
            trailing: Switch.adaptive(
              value: onboarding.healthGranted,
              onChanged: (v) => onboarding.setPermission(health: v),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Notifications'),
            trailing: Switch.adaptive(
              value: onboarding.notificationsGranted,
              onChanged: (v) => onboarding.setPermission(notifications: v),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Camera & mic for AI'),
            trailing: Switch.adaptive(
              value: onboarding.cameraGranted && onboarding.microphoneGranted,
              onChanged: (v) => onboarding.setPermission(
                camera: v,
                microphone: v,
              ),
            ),
          ),
          const Divider(height: 32),
          Text('Security & privacy', style: context.textStyles.h4),
          SwitchListTile.adaptive(
            title: const Text('Face ID / biometric unlock'),
            value: onboarding.biometricUnlockEnabled,
            onChanged: onboarding.setBiometricUnlock,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Export my data'),
            subtitle: const Text('Download workouts, logs, and profile JSON'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export queued. Check downloads.')),
              );
            },
          ),
          const Divider(height: 32),
          Text('Developer / status', style: context.textStyles.h4),
          SwitchListTile.adaptive(
            title: const Text('Simulate offline'),
            subtitle: const Text('Shows cached workouts and an offline banner'),
            value: status.isOffline,
            onChanged: status.setOffline,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Empty, offline & error states'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.pushNamed(context, AppRoutes.systemStatus),
          ),
        ],
      ),
    );
  }
}
