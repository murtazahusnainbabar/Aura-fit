import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/constants/app_routes.dart';
import '../../core/onboarding/onboarding_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'package:aurafit/features/auth/widgets/auth_widgets.dart';

class PermissionsSetupScreen extends StatelessWidget {
  const PermissionsSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();
    return AuthScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            Text('Connect Aura to your life',
                style: context.textStyles.displayMedium),
            const SizedBox(height: 8),
            Text(
              'These permissions power coaching, health sync, and vision features. You can change them later.',
              style: context.textStyles.bodyMedium
                  .copyWith(color: context.colors.textSecondary),
            ),
            const SizedBox(height: 24),
            _PermissionTile(
              icon: Icons.notifications_active_outlined,
              title: 'Push notifications',
              subtitle: 'Workout alarms, hydration nudges, and AI insights.',
              value: onboarding.notificationsGranted,
              onChanged: (v) =>
                  onboarding.setPermission(notifications: v),
            ),
            _PermissionTile(
              icon: Icons.favorite_outline_rounded,
              title: 'Health services',
              subtitle: 'Apple HealthKit / Google Health Connect sync.',
              value: onboarding.healthGranted,
              onChanged: (v) => onboarding.setPermission(health: v),
            ),
            _PermissionTile(
              icon: Icons.photo_camera_outlined,
              title: 'Camera',
              subtitle: 'Form checks, meal scans, and progress photos.',
              value: onboarding.cameraGranted,
              onChanged: (v) => onboarding.setPermission(camera: v),
            ),
            _PermissionTile(
              icon: Icons.mic_none_rounded,
              title: 'Microphone',
              subtitle: 'Hands-free voice coaching during workouts.',
              value: onboarding.microphoneGranted,
              onChanged: (v) => onboarding.setPermission(microphone: v),
            ),
            const Spacer(),
            TextButton(
              onPressed: () async {
                await onboarding.setPermission(
                  notifications: true,
                  health: true,
                  camera: true,
                  microphone: true,
                );
              },
              child: const Text('Allow all recommended'),
            ),
            AuthPrimaryButton(
              label: context.read<AuthProvider>().isLoggedIn
                  ? 'Finish setup'
                  : 'Continue to account',
              onPressed: () async {
                final loggedIn = context.read<AuthProvider>().isLoggedIn;
                if (loggedIn) {
                  await context.read<OnboardingProvider>().completeOnboarding();
                  if (!context.mounted) return;
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.main,
                    (_) => false,
                  );
                } else {
                  Navigator.pushNamed(context, AppRoutes.signup);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: context.colors.border),
        ),
        leading: Icon(icon, color: context.colors.primary),
        title: Text(title, style: context.textStyles.labelLarge),
        subtitle: Text(subtitle, style: context.textStyles.caption),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeThumbColor: context.colors.primary,
        ),
      ),
    );
  }
}
