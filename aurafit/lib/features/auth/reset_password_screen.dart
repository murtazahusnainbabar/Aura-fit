import 'package:flutter/material.dart';

import '../../core/constants/app_routes.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/custom_button.dart';
import 'widgets/auth_widgets.dart';

enum _ResetStep { input, success }

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  _ResetStep _step = _ResetStep.input;
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onConfirm() async {
    if (_passwordController.text.isEmpty || _confirmController.text.isEmpty) return;

    setState(() => _loading = true);
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _loading = false;
        _step = _ResetStep.success;
      });
    }
  }

  void _onContinueToLogin() {
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
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
            if (_step == _ResetStep.input) ...[
              const AppLogo(size: 80),
              const SizedBox(height: 32),
              Text(
                'Change Password',
                style: textStyles.displayLarge.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 12),
              Text(
                'Enter your new password',
                textAlign: TextAlign.center,
                style: textStyles.bodyMedium.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 48),
              AuthTextField(
                controller: _passwordController,
                hint: 'New Password',
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_outline, color: Colors.white60),
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _confirmController,
                hint: 'Re-type Password',
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_outline, color: Colors.white60),
              ),
              const SizedBox(height: 48),
              CustomButton(
                label: 'Confirm',
                onTap: _onConfirm,
                isLoading: _loading,
              ),
            ] else ...[
              const SizedBox(height: 40),
              Transform.rotate(
                angle: -0.7,
                child: const Icon(
                  Icons.key,
                  size: 120,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'Password Updated',
                style: textStyles.displayLarge.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 16),
              Text(
                'Your password was successfully updated.\nPlease login with your new credentials.',
                textAlign: TextAlign.center,
                style: textStyles.bodyMedium.copyWith(color: Colors.white70, height: 1.5),
              ),
              const SizedBox(height: 60),
              CustomButton(
                label: 'Continue to Login',
                onTap: _onContinueToLogin,
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
