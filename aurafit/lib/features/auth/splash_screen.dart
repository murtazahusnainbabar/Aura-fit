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

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final auth = context.read<AuthProvider>();
    final onboarding = context.read<OnboardingProvider>();
    await Future.wait([
      auth.ensureInitialized(),
      onboarding.ensureInitialized(),
      Future<void>.delayed(const Duration(milliseconds: 1800)),
    ]);
    if (!mounted) return;
    final destination = destinationAfterSplash(
      auth: auth,
      onboarding: onboarding,
    );
    Navigator.of(context).pushReplacementNamed(destination);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: Stack(
          children: [
            Positioned(
              top: -90,
              left: -40,
              child: _blob(context.colors.primary.withOpacity(0.16), 260),
            ),
            Positioned(
              bottom: -40,
              right: -50,
              child: _blob(context.colors.secondary.withOpacity(0.18), 280),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppLogo(size: 92)
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .scale(
                        begin: const Offset(0.86, 0.86),
                        curve: Curves.easeOutBack,
                      ),
                  const SizedBox(height: 22),
                  Text(
                    'AuraFit',
                    style: context.textStyles.displayLarge.copyWith(
                      fontSize: 36,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 180.ms, duration: 450.ms)
                      .slideY(begin: 0.2),
                  const SizedBox(height: 8),
                  Text(
                    'Train smarter. Feel unstoppable.',
                    style: context.textStyles.bodyMedium.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ).animate().fadeIn(delay: 320.ms, duration: 450.ms),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: context.colors.primary,
                    ),
                  ).animate().fadeIn(delay: 500.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blob(Color color, double size) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
