import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../core/onboarding/onboarding_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _onGetStarted(BuildContext context) {
    context.read<OnboardingProvider>().setSeenWelcome();
    Navigator.pushNamed(context, AppRoutes.login);
  }

  void _onRegister(BuildContext context) {
    context.read<OnboardingProvider>().setSeenWelcome();
    Navigator.pushNamed(context, AppRoutes.signup);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Subtitle
              Text(
                'Build. Break. Benchmark.',
                style: textStyles.labelLarge.copyWith(
                  color: const Color(0xFFC6FF00), // Lime green from image
                  letterSpacing: 0.5,
                ),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),

              const SizedBox(height: 12),

              // Title
              Text(
                'Ready to Crush Your\nGoals?',
                textAlign: TextAlign.center,
                style: textStyles.displayLarge.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

              const Spacer(),

              // Main Image Placeholder
              // In a real app, this would be an Image.asset or similar
              Container(
                height: 380,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: colors.surface,
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=1000&auto=format&fit=crop',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 800.ms).scale(begin: const Offset(0.9, 0.9)),

              const Spacer(),

              // Primary Button
              CustomButton(
                label: 'Start Unleashing Your Potential',
                onTap: () => _onGetStarted(context),
              ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideY(begin: 0.2),

              const SizedBox(height: 24),

              // Register Link
              RichText(
                text: TextSpan(
                  style: textStyles.bodyMedium.copyWith(color: colors.textSecondary),
                  children: [
                    const TextSpan(text: "Don't have any account? "),
                    TextSpan(
                      text: 'Register Now',
                      style: textStyles.labelLarge.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _onRegister(context),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 800.ms, duration: 600.ms),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
