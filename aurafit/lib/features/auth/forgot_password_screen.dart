import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'auth_validators.dart';
import 'widgets/auth_widgets.dart';

enum _ResetStep { email, code, password, success }

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  _ResetStep _step = _ResetStep.email;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final List<TextEditingController> _codeControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _codeFocus = List.generate(6, (_) => FocusNode());

  bool _loading = false;
  bool _obscure = true;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  String? _formError;
  String? _demoCode;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    for (final c in _codeControllers) {
      c.dispose();
    }
    for (final f in _codeFocus) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _codeControllers.map((c) => c.text).join();

  Future<void> _sendCode() async {
    final emailError = AuthValidators.email(_emailController.text);
    setState(() {
      _emailError = emailError;
      _formError = null;
    });
    if (emailError != null) return;

    setState(() => _loading = true);
    try {
      final auth = context.read<AuthProvider>();
      await auth.sendResetCode(_emailController.text);
      if (!mounted) return;
      setState(() {
        _step = _ResetStep.code;
        _demoCode = auth.peekDemoResetCode(_emailController.text);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _codeFocus.first.requestFocus();
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _formError = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _verifyCode() async {
    if (_code.length != 6) {
      setState(() => _formError = 'Enter the 6-digit code from your email.');
      return;
    }
    setState(() {
      _loading = true;
      _formError = null;
    });
    try {
      await context.read<AuthProvider>().verifyResetCode(
            email: _emailController.text,
            code: _code,
          );
      if (!mounted) return;
      setState(() => _step = _ResetStep.password);
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _formError = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _savePassword() async {
    final passwordError = AuthValidators.newPassword(_passwordController.text);
    final confirmError = AuthValidators.confirmPassword(
      _confirmController.text,
      _passwordController.text,
    );
    setState(() {
      _passwordError = passwordError;
      _confirmError = confirmError;
      _formError = null;
    });
    if (passwordError != null || confirmError != null) return;

    setState(() => _loading = true);
    try {
      await context.read<AuthProvider>().resetPassword(
            email: _emailController.text,
            code: _code,
            newPassword: _passwordController.text,
          );
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      setState(() => _step = _ResetStep.success);
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _formError = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onCodeChanged(int index, String value) {
    setState(() => _formError = null);
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 1) {
      for (var i = 0; i < 6; i++) {
        _codeControllers[i].text = i < digits.length ? digits[i] : '';
      }
      final next = digits.length.clamp(0, 5);
      _codeFocus[next].requestFocus();
      if (digits.length >= 6) _verifyCode();
      return;
    }
    if (value.length == 1 && index < 5) {
      _codeFocus[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _codeFocus[index - 1].requestFocus();
    }
    if (_code.length == 6) {
      _verifyCode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (_step == _ResetStep.email ||
                        _step == _ResetStep.success) {
                      Navigator.pop(context);
                    } else if (_step == _ResetStep.code) {
                      setState(() {
                        _step = _ResetStep.email;
                        _formError = null;
                      });
                    } else {
                      setState(() {
                        _step = _ResetStep.code;
                        _formError = null;
                      });
                    }
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                Expanded(
                  child: Text(
                    _titleForStep(),
                    textAlign: TextAlign.center,
                    style: context.textStyles.h3,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          if (_step != _ResetStep.success) ...[
            const SizedBox(height: 8),
            _StepDots(current: _stepIndex()),
          ],
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              physics: const BouncingScrollPhysics(),
              child: _buildStep(),
            ),
          ),
        ],
      ),
    );
  }

  String _titleForStep() {
    switch (_step) {
      case _ResetStep.email:
        return 'Reset password';
      case _ResetStep.code:
        return 'Check your email';
      case _ResetStep.password:
        return 'New password';
      case _ResetStep.success:
        return 'You\'re all set';
    }
  }

  int _stepIndex() {
    switch (_step) {
      case _ResetStep.email:
        return 0;
      case _ResetStep.code:
        return 1;
      case _ResetStep.password:
        return 2;
      case _ResetStep.success:
        return 2;
    }
  }

  Widget _buildStep() {
    switch (_step) {
      case _ResetStep.email:
        return _EmailStep(
          controller: _emailController,
          errorText: _emailError,
          formError: _formError,
          loading: _loading,
          onChanged: (_) => setState(() {
            _emailError = null;
            _formError = null;
          }),
          onSubmit: _sendCode,
        );
      case _ResetStep.code:
        return _CodeStep(
          email: _emailController.text.trim(),
          controllers: _codeControllers,
          focusNodes: _codeFocus,
          demoCode: _demoCode,
          formError: _formError,
          loading: _loading,
          onChanged: _onCodeChanged,
          onSubmit: _verifyCode,
          onResend: _sendCode,
        );
      case _ResetStep.password:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a new password for your AuraFit account.',
              style: context.textStyles.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            AuthTextField(
              controller: _passwordController,
              label: 'New password',
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
            const SizedBox(height: 16),
            AuthTextField(
              controller: _confirmController,
              label: 'Confirm password',
              hint: 'Re-enter password',
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              errorText: _confirmError,
              onChanged: (_) => setState(() => _confirmError = null),
              onSubmitted: _savePassword,
            ),
            if (_formError != null) ...[
              const SizedBox(height: 12),
              Text(
                _formError!,
                style: context.textStyles.bodySmall
                    .copyWith(color: context.colors.accentRed),
              ),
            ],
            const SizedBox(height: 24),
            AuthPrimaryButton(
              label: 'Update password',
              isLoading: _loading,
              onPressed: _loading ? null : _savePassword,
            ),
          ],
        );
      case _ResetStep.success:
        return Column(
          children: [
            const SizedBox(height: 24),
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: context.colors.greenGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 44),
            ),
            const SizedBox(height: 24),
            Text('Password updated', style: context.textStyles.h2),
            const SizedBox(height: 8),
            Text(
              'You can now sign in with your new password.',
              textAlign: TextAlign.center,
              style: context.textStyles.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            AuthPrimaryButton(
              label: 'Back to sign in',
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.login,
                (route) => false,
              ),
            ),
          ],
        );
    }
  }
}

class _EmailStep extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final String? formError;
  final bool loading;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;

  const _EmailStep({
    required this.controller,
    required this.errorText,
    required this.formError,
    required this.loading,
    required this.onChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter the email you use for AuraFit. We\'ll send a 6-digit code to reset your password.',
          style: context.textStyles.bodyMedium.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        AuthTextField(
          controller: controller,
          label: 'Email',
          hint: 'you@email.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.email],
          prefixIcon: const Icon(Icons.mail_outline_rounded),
          errorText: errorText,
          onChanged: onChanged,
          onSubmitted: onSubmit,
        ),
        if (formError != null) ...[
          const SizedBox(height: 12),
          Text(
            formError!,
            style: context.textStyles.bodySmall
                .copyWith(color: context.colors.accentRed),
          ),
        ],
        const SizedBox(height: 24),
        AuthPrimaryButton(
          label: 'Send code',
          isLoading: loading,
          onPressed: loading ? null : onSubmit,
        ),
      ],
    );
  }
}

class _CodeStep extends StatelessWidget {
  final String email;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final String? demoCode;
  final String? formError;
  final bool loading;
  final void Function(int, String) onChanged;
  final VoidCallback onSubmit;
  final VoidCallback onResend;

  const _CodeStep({
    required this.email,
    required this.controllers,
    required this.focusNodes,
    required this.demoCode,
    required this.formError,
    required this.loading,
    required this.onChanged,
    required this.onSubmit,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'We sent a 6-digit code to $email. It expires in 10 minutes.',
          style: context.textStyles.bodyMedium.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        if (demoCode != null) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.colors.primary.withOpacity(0.3)),
            ),
            child: Text(
              'Demo code: $demoCode',
              style: context.textStyles.labelLarge.copyWith(
                color: context.colors.primary,
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        Row(
          children: List.generate(6, (index) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: TextField(
                  controller: controllers[index],
                  focusNode: focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: context.textStyles.h2,
                  decoration: const InputDecoration(counterText: ''),
                  onChanged: (value) => onChanged(index, value),
                ),
              ),
            );
          }),
        ),
        if (formError != null) ...[
          const SizedBox(height: 12),
          Text(
            formError!,
            style: context.textStyles.bodySmall
                .copyWith(color: context.colors.accentRed),
          ),
        ],
        const SizedBox(height: 24),
        AuthPrimaryButton(
          label: 'Verify code',
          isLoading: loading,
          onPressed: loading ? null : onSubmit,
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: loading ? null : onResend,
            child: Text(
              'Resend code',
              style: context.textStyles.labelLarge.copyWith(
                color: context.colors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StepDots extends StatelessWidget {
  final int current;
  const _StepDots({required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final active = i <= current;
        return Container(
          width: i == current ? 22 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: active ? context.colors.primary : context.colors.border,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}
