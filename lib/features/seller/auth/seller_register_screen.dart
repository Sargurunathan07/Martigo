import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/responsive_mobile_container.dart';
import '../membership/seller_membership_screen.dart';

class SellerRegisterScreen extends StatefulWidget {
  const SellerRegisterScreen({super.key});

  @override
  State<SellerRegisterScreen> createState() => _SellerRegisterScreenState();
}

class _SellerRegisterScreenState extends State<SellerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _acceptedLegal = false;

  @override
  void dispose() {
    _storeNameController.dispose();
    _ownerNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onCreateAccountPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!_acceptedLegal) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please accept the Terms & Conditions and Privacy Policy.',
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    // Mock registration delay — no backend involved.
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SellerMembershipScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Seller Registration')),
      body: SafeArea(
        child: ResponsiveMobileContainer(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create your seller account',
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Start receiving pre-orders on Martigo.',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  AppTextField(
                    controller: _storeNameController,
                    label: 'Business / Store Name',
                    prefixIcon: Icons.storefront_outlined,
                    validator: (v) =>
                        Validators.validateRequired(v, fieldName: 'Store name'),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _ownerNameController,
                    label: 'Owner Name',
                    prefixIcon: Icons.person_outline,
                    validator: Validators.validateName,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _mobileController,
                    label: 'Mobile Number',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: Validators.validateMobileNumber,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _addressController,
                    label: 'Store Address',
                    prefixIcon: Icons.location_on_outlined,
                    maxLines: 2,
                    validator: (v) => Validators.validateRequired(
                      v,
                      fieldName: 'Store address',
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _passwordController,
                    label: 'Password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    validator: Validators.validatePassword,
                  ),
                  const SizedBox(height: 20),

                  Semantics(
                    label: 'Accept Martigo Terms and Conditions and Privacy Policy',
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _acceptedLegal,
                      onChanged: (value) {
                        setState(() {
                          _acceptedLegal = value ?? false;
                        });
                      },
                      title: const Text(
                        'I agree to the Terms & Conditions and Privacy Policy.',
                      ),
                      subtitle: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(AppRoutes.legalCenter);
                        },
                        child: const Text('Read Legal & Privacy'),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  AppButton(
                    label: 'Create Seller Account',
                    isLoading: _isLoading,
                    onPressed: _onCreateAccountPressed,
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
