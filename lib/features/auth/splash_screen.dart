import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

/// First screen shown on app launch. Displays the Martigo brand mark
/// and tagline, then navigates on to onboarding.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(AppConstants.splashDuration);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.primaryMaroon,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.storefront_rounded,
                size: 52,
                color: AppColors.primaryMaroon,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppConstants.appName,
              style: textTheme.displayMedium?.copyWith(color: AppColors.cream),
            ),
            const SizedBox(height: 8),
            Text(
              AppConstants.appTagline,
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.cream.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}