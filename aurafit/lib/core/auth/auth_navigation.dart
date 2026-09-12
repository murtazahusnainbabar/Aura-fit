import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';
import '../constants/app_routes.dart';
import '../onboarding/onboarding_provider.dart';

Future<void> navigateAfterAuth(BuildContext context) async {
  final onboarding = context.read<OnboardingProvider>();
  await onboarding.ensureInitialized();
  if (!context.mounted) return;
  final dest = onboarding.isComplete
      ? AppRoutes.main
      : AppRoutes.personalization;
  Navigator.of(context).pushNamedAndRemoveUntil(dest, (_) => false);
}

String destinationAfterSplash({
  required AuthProvider auth,
  required OnboardingProvider onboarding,
}) {
  if (!auth.isLoggedIn) {
    return onboarding.hasSeenWelcome ? AppRoutes.login : AppRoutes.welcome;
  }
  if (!onboarding.isComplete) return AppRoutes.personalization;
  return AppRoutes.main;
}
