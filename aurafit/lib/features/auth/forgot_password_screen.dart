import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/custom_button.dart';
import 'widgets/auth_widgets.dart';

enum _ResetState { request, sent }

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  _ResetState _state = _ResetState.request;
  final _emailController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSendCode() async {
    if (_emailController.text.isEmpty) return;

    setState(() => _loading = true);
    try {
      await context.read<AuthProvider>().sendResetCode(_emailController.text);
      if (!mounted) return;
      setState(() => _state = _ResetState.sent);
    } catch (_) {
      // Handle error if needed
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onGoToEmail() {
    // In a real app, this could use url_launcher to open a mail app
    debugPrint('Opening email app...');
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;

    return AuthScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const AppLogo(size: 80),
            const SizedBox(height: 32),

            if (_state == _ResetState.request) ...[
              Text(
                'Forgot Password',
                style: textStyles.displayLarge.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 12),
              Text(
                'Enter your registered email and we will send a recover password link.',
                textAlign: TextAlign.center,
                style: textStyles.bodyMedium.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 48),
              AuthTextField(
                controller: _emailController,
                hint: 'Email',
                prefixIcon: const Icon(Icons.email_outlined, color: Colors.white60),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 32),
              CustomButton(
                label: 'Send Code',
                onTap: _onSendCode,
                isLoading: _loading,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Sign in using password',
                  style: textStyles.labelLarge.copyWith(color: Colors.white70),
                ),
              ),
            ] else ...[
              Text(
                'Check Your Email',
                style: textStyles.displayLarge.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 12),
              Text(
                'We have sent you a reset password link on your registered email address',
                textAlign: TextAlign.center,
                style: textStyles.bodyMedium.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 48),
              CustomButton(
                label: 'Go To Email',
                onTap: _onGoToEmail,
              ),
            ],

            const SizedBox(height: 60),
            RichText(
              text: TextSpan(
                style: textStyles.bodyMedium.copyWith(color: Colors.white70),
                children: [
                  const TextSpan(text: "Already have an account? "),
                  TextSpan(
                    text: 'Sign In',
                    style: textStyles.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
