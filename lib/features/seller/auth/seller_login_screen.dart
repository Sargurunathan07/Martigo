import 'package:flutter/material.dart';

import '../../../core/utils/validators.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/responsive_mobile_container.dart';
import '../dashboard/seller_home_shell.dart';
import '../membership/seller_membership_screen.dart';
import '../seller_mock_data.dart';
import '../seller_models.dart';

class SellerLoginScreen extends StatefulWidget {
  const SellerLoginScreen({super.key});

  @override
  State<SellerLoginScreen> createState() => _SellerLoginScreenState();
}

class _SellerLoginScreenState extends State<SellerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isLoading = false);

    final membershipActive =
        SellerDataStore.instance.membership.status == MembershipStatus.active;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => membershipActive
            ? const SellerHomeShell()
            : const SellerMembershipScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Seller Login')),
      body: SafeArea(
        child: ResponsiveMobileContainer(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome back, seller', style: textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Login to manage your store on Martigo.',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  AppTextField(
                    controller: _emailController,
                    label: 'Email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _passwordController,
                    label: 'Password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    validator: Validators.validatePassword,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Login',
                    isLoading: _isLoading,
                    onPressed: _onLoginPressed,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
