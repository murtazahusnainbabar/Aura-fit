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
import 'auth_validators.dart';
import 'widgets/auth_widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;
  bool _obscureConfirm = true;
  bool _acceptedTerms = false;
  bool _loading = false;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  String? _formError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final nameError = AuthValidators.name(_nameController.text);
    final emailError = AuthValidators.email(_emailController.text);
    final passwordError = AuthValidators.newPassword(_passwordController.text);
    final confirmError = AuthValidators.confirmPassword(
      _confirmController.text,
      _passwordController.text,
    );
    setState(() {
      _nameError = nameError;
      _emailError = emailError;
      _passwordError = passwordError;
      _confirmError = confirmError;
      _formError = _acceptedTerms
          ? null
          : 'Please accept the terms to continue.';
    });
    if (nameError != null ||
        emailError != null ||
        passwordError != null ||
        confirmError != null ||
        !_acceptedTerms) {
      return;
    }

    setState(() => _loading = true);
    try {
      await context.read<AuthProvider>().signup(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          );
      await context.read<OnboardingProvider>().completeOnboarding();
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
    final strength = AuthValidators.passwordStrength(_passwordController.text);
    return AuthScaffold(
      child: AutofillGroup(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    tooltip: 'Back to sign in',
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create your account',
                            style: context.textStyles.displayMedium)
                        .animate()
                        .fadeIn(duration: 350.ms)
                        .slideY(begin: 0.08),
                    const SizedBox(height: 8),
                    Text(
                      'A few details and you\'re ready to train with your AI coach.',
                      style: context.textStyles.bodyMedium.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AuthTextField(
                      controller: _nameController,
                      label: 'Full name',
                      hint: 'Alex Chen',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      errorText: _nameError,
                      onChanged: (_) => setState(() => _nameError = null),
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'you@email.com',
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      prefixIcon: const Icon(Icons.mail_outline_rounded),
                      errorText: _emailError,
                      onChanged: (_) => setState(() => _emailError = null),
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'At least 8 characters',
                      obscureText: _obscure,
                      autofillHints: const [AutofillHints.newPassword],
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffix: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      errorText: _passwordError,
                      onChanged: (_) => setState(() => _passwordError = null),
                    ),
                    const SizedBox(height: 10),
                    _PasswordStrengthMeter(strength: strength),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _confirmController,
                      label: 'Confirm password',
                      hint: 'Re-enter password',
                      obscureText: _obscureConfirm,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffix: IconButton(
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      errorText: _confirmError,
                      onChanged: (_) => setState(() => _confirmError = null),
                      onSubmitted: _submit,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _acceptedTerms,
                          onChanged: (v) => setState(() {
                            _acceptedTerms = v ?? false;
                            if (_acceptedTerms) _formError = null;
                          }),
                          activeColor: context.colors.primary,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              'I agree to the Terms of Service and Privacy Policy.',
                              style: context.textStyles.bodySmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_formError != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _formError!,
                        style: context.textStyles.bodySmall.copyWith(
                          color: context.colors.accentRed,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Enable Face ID / biometric unlock',
                          style: context.textStyles.labelLarge),
                      subtitle: Text(
                        'Lock your training data behind device biometrics.',
                        style: context.textStyles.caption,
                      ),
                      value: context.watch<OnboardingProvider>().biometricUnlockEnabled,
                      onChanged: (v) => context
                          .read<OnboardingProvider>()
                          .setBiometricUnlock(v),
                    ),
                    const SizedBox(height: 12),
                    AuthPrimaryButton(
                      label: 'Create account',
                      isLoading: _loading,
                      onPressed: _loading ? null : _submit,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: context.textStyles.bodyMedium.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Sign in',
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
          ],
        ),
      ),
    );
  }
}

class _PasswordStrengthMeter extends StatelessWidget {
  final int strength;
  const _PasswordStrengthMeter({required this.strength});

  @override
  Widget build(BuildContext context) {
    final labels = ['Too short', 'Weak', 'Good', 'Strong'];
    final colors = [
      context.colors.textMuted,
      context.colors.accentRed,
      context.colors.accentOrange,
      context.colors.accentGreen,
    ];
    final index = strength.clamp(0, 3);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(3, (i) {
            final active = strength > i;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: i == 2 ? 0 : 6),
                decoration: BoxDecoration(
                  color: active ? colors[strength] : context.colors.border,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Text(
          'Password strength: ${labels[index]}',
          style: context.textStyles.caption.copyWith(color: colors[index]),
        ),
      ],
    );
  }
}
