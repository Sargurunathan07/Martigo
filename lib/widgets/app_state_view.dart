import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class AppStateView extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String message;

  final IconData icon;

  final String? primaryButtonText;
  final VoidCallback? onPrimaryPressed;

  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;

  const AppStateView({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.message,
    required this.icon,
    this.primaryButtonText,
    this.onPrimaryPressed,
    this.secondaryButtonText,
    this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.softMaroon,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(icon, size: 34, color: AppColors.primaryMaroon),
                ),

                const SizedBox(height: 26),

                Text(
                  eyebrow.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    letterSpacing: 2.2,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black45,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),

                if (primaryButtonText != null && onPrimaryPressed != null) ...[
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: onPrimaryPressed,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryMaroon,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(primaryButtonText!),
                    ),
                  ),
                ],

                if (secondaryButtonText != null &&
                    onSecondaryPressed != null) ...[
                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: onSecondaryPressed,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryMaroon,
                        side: const BorderSide(color: AppColors.primaryMaroon),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(secondaryButtonText!),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
