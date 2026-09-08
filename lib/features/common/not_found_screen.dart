import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/app_state_view.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Navigator.of(context).canPop() ? const BackButton() : null,
      ),
      body: AppStateView(
        eyebrow: '404',
        title: 'Page not found.',
        message:
            'The page you are looking for does not exist or may have moved.',
        icon: Icons.search_off_rounded,
        primaryButtonText: 'Back to Martigo',
        onPrimaryPressed: () {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.roleSelection, (route) => false);
        },
      ),
    );
  }
}
