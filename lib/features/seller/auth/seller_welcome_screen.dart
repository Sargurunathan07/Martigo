import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/responsive_mobile_container.dart';
import 'seller_register_screen.dart';
import 'seller_login_screen.dart';

class SellerWelcomeScreen extends StatelessWidget {
  const SellerWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ResponsiveMobileContainer(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Martigo',
                  style: textTheme.headlineMedium?.copyWith(
                    color: AppColors.primaryMaroon,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Seller Portal', style: textTheme.titleMedium),
                const Spacer(),
                Center(
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.softMaroon,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.storefront_rounded,
                      size: 52,
                      color: AppColors.primaryMaroon,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Welcome to Martigo', style: textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  'Manage your store, stock and pre-orders easily.',
                  style: textTheme.bodyMedium,
                ),
                const Spacer(),
                AppButton(
                  label: 'Create Seller Account',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SellerRegisterScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Login to Seller Account',
                  type: AppButtonType.secondary,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SellerLoginScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
