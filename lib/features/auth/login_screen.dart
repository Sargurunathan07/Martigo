import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/utils/validators.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

/// Martigo shared login screen.
///
/// Current authentication is mock/local only.
///
/// Development roles:
///
/// Customer:
/// Any valid email/password.
///
/// Seller:
/// seller@martigo.com
/// seller123
///
/// Admin:
/// admin@martigo.com
/// admin123
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  static const String _sellerEmail = 'seller@martigo.com';
  static const String _sellerPassword = 'seller123';

  static const String _adminEmail = 'admin@martigo.com';
  static const String _adminPassword = 'admin123';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    setState(() {
      _isLoading = false;
    });

    // ADMIN
    if (email == _adminEmail && password == _adminPassword) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.adminDashboard, (route) => false);
      return;
    }

    // SELLER
    if (email == _sellerEmail && password == _sellerPassword) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.sellerDashboard, (route) => false);
      return;
    }

    // CUSTOMER
    //
    // During mock development, every other valid login
    // is considered a Customer account.
    Navigator.of(context).pushNamed(AppRoutes.joinCommunity);
  }

  void _onForgotPasswordPressed() {
    Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
  }

  void _onCreateAccountPressed() {
    Navigator.of(context).pushNamed(AppRoutes.register);
  }

  void _openSellerPortal() {
    Navigator.of(context).pushNamed(AppRoutes.sellerWelcome);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: Navigator.of(context).canPop() ? const BackButton() : null,
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back', style: textTheme.headlineMedium),

                    const SizedBox(height: 4),

                    Text(
                      'Login to continue with Martigo.',
                      style: textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 32),

                    AppTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'you@example.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                    ),

                    const SizedBox(height: 16),

                    AppTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      validator: Validators.validatePassword,
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _onForgotPasswordPressed,
                        child: const Text('Forgot Password?'),
                      ),
                    ),

                    const SizedBox(height: 16),

                    AppButton(
                      label: 'Login',
                      isLoading: _isLoading,
                      onPressed: _onLoginPressed,
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: _onCreateAccountPressed,
                          child: const Text('Create Account'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Center(
                      child: TextButton.icon(
                        onPressed: _openSellerPortal,
                        icon: const Icon(Icons.storefront_outlined),
                        label: const Text('Open Seller Portal'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
