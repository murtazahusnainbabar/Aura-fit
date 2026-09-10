import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_navigation.dart';
import '../../core/auth/auth_provider.dart';
import '../../core/constants/app_routes.dart';
import '../../core/onboarding/onboarding_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_logo.dart';
import '../auth/widgets/auth_widgets.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _socialLoading = false;

  Future<void> _social(String provider) async {
    setState(() => _socialLoading = true);
    try {
      await context.read<AuthProvider>().loginWithSocial(provider);
      if (!mounted) return;
      await context.read<OnboardingProvider>().completeOnboarding();
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      await navigateAfterAuth(context);
    } finally {
      if (mounted) setState(() => _socialLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppLogo(size: 64)
                .animate()
                .fadeIn()
                .scale(begin: const Offset(0.9, 0.9)),
            const Spacer(),
            Text(
              'Your AI coach.\nEvery workout.\nEvery day.',
              style: context.textStyles.displayLarge.copyWith(height: 1.15),
            ).animate().fadeIn(delay: 120.ms).slideY(begin: 0.08),
            const SizedBox(height: 12),
            Text(
              'Personalized training, recovery, and nutrition — driven by an agent that actually knows you.',
              style: context.textStyles.bodyLarge.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const Spacer(),
            AuthPrimaryButton(
              label: 'Get Started',
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.personalization),
            ),
            const SizedBox(height: 12),
            _SocialButton(
              icon: Icons.apple,
              label: 'Continue with Apple',
              loading: _socialLoading,
              onTap: () => _social('apple'),
            ),
            const SizedBox(height: 10),
            _SocialButton(
              icon: Icons.g_mobiledata_rounded,
              label: 'Continue with Google',
              loading: _socialLoading,
              onTap: () => _social('google'),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                child: Text(
                  'I already have an account',
                  style: context.textStyles.labelLarge.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool loading;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: loading ? null : onTap,
        icon: Icon(icon, size: 22),
        label: Text(label),
      ),
    );
  }
}
