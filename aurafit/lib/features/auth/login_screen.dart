import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_navigation.dart';
import '../../core/onboarding/onboarding_provider.dart';
import '../../core/auth/auth_provider.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_logo.dart';
import 'auth_validators.dart';
import 'widgets/auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _emailError;
  String? _passwordError;
  String? _formError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillDemo() {
    setState(() {
      _emailController.text = AuthProvider.demoEmail;
      _passwordController.text = AuthProvider.demoPassword;
      _emailError = null;
      _passwordError = null;
      _formError = null;
    });
  }

  Future<void> _submit() async {
    final emailError = AuthValidators.email(_emailController.text);
    final passwordError = AuthValidators.password(_passwordController.text);
    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
      _formError = null;
    });
    if (emailError != null || passwordError != null) return;

    setState(() => _loading = true);
    try {
      await context.read<AuthProvider>().login(
            email: _emailController.text,
            password: _passwordController.text,
          );
      if (!mounted) return;
      if (_emailController.text.trim().toLowerCase() ==
          AuthProvider.demoEmail) {
        await context.read<OnboardingProvider>().completeOnboarding();
      }
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      await navigateAfterAuth(context);
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _formError = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: AutofillGroup(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const AppLogo(size: 56)
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(begin: const Offset(0.9, 0.9)),
              const SizedBox(height: 28),
              Text('Welcome back', style: context.textStyles.displayMedium)
                  .animate()
                  .fadeIn(delay: 80.ms)
                  .slideY(begin: 0.08),
              const SizedBox(height: 8),
              Text(
                'Sign in to pick up your training exactly where you left off.',
                style: context.textStyles.bodyMedium.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),
              AuthTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'you@email.com',
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                prefixIcon: const Icon(Icons.mail_outline_rounded),
                errorText: _emailError,
                onChanged: (_) {
                  if (_emailError != null) {
                    setState(() => _emailError = null);
                  }
                },
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _passwordController,
                label: 'Password',
                hint: 'Your password',
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffix: IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  tooltip: _obscure ? 'Show password' : 'Hide password',
                ),
                errorText: _passwordError,
                onChanged: (_) {
                  if (_passwordError != null) {
                    setState(() => _passwordError = null);
                  }
                },
                onSubmitted: _submit,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.forgotPassword,
                  ),
                  child: Text(
                    'Forgot password?',
                    style: context.textStyles.labelLarge.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ),
              ),
              if (_formError != null) ...[
                _ErrorBanner(message: _formError!),
                const SizedBox(height: 16),
              ],
              AuthPrimaryButton(
                label: 'Sign in',
                isLoading: _loading,
                onPressed: _loading ? null : _submit,
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: _fillDemo,
                  child: Text(
                    'Use demo account',
                    style: context.textStyles.labelLarge.copyWith(
                      color: context.colors.secondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New to AuraFit?',
                    style: context.textStyles.bodyMedium.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.signup,
                    ),
                    child: Text(
                      'Create account',
                      style: context.textStyles.labelLarge.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.accentRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.accentRed.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded,
              color: context.colors.accentRed, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: context.textStyles.bodySmall.copyWith(
                color: context.colors.accentRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
