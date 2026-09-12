import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_navigation.dart';
import '../../core/auth/auth_provider.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/custom_button.dart';
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
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      await context.read<AuthProvider>().signup(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          );
      if (!mounted) return;
      await navigateAfterAuth(context);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;

    return AuthScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const AppLogo(size: 80),
            const SizedBox(height: 32),
            Text(
              'Create Your Account',
              style: textStyles.displayLarge.copyWith(fontSize: 32),
            ),
            const SizedBox(height: 12),
            Text(
              'Create your account to access personalized AI-Powered fitness insights tailored for you.',
              textAlign: TextAlign.center,
              style: textStyles.bodyMedium.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 40),
            AuthTextField(
              controller: _nameController,
              hint: 'Name',
              prefixIcon: const Icon(Icons.email_outlined, color: Colors.white60), // The design shows email icon for name field too? Looking closely at screenshot... actually both show mail icon for top two fields.
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _emailController,
              hint: 'Email',
              prefixIcon: const Icon(Icons.email_outlined, color: Colors.white60),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _passwordController,
              hint: 'Password',
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
            const SizedBox(height: 32),
            CustomButton(
              label: 'Sign Up',
              onTap: _submit,
              isLoading: _loading,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Or Continue with',
                    style: textStyles.bodySmall.copyWith(color: Colors.white38),
                  ),
                ),
                Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
              ],
            ),
            const SizedBox(height: 32),
            SocialAuthButton(
              label: 'Continue with Google',
              onTap: () {},
              iconPath: 'google',
            ),
            const SizedBox(height: 40),
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
