import 'package:flutter/material.dart';

import '../features/common/not_found_screen.dart';
import '../widgets/app_gradient_background.dart';
import 'routes.dart';
import 'theme.dart';

/// Root widget of the MartiGo application.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Martigo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,

      /// Purely visual wrapper.
      /// Navigation and route behavior remain unchanged.
      builder: (context, child) {
        return AppGradientBackground(child: child ?? const SizedBox.shrink());
      },

      initialRoute: AppRoutes.initial,
      routes: AppRoutes.routes,
      onUnknownRoute: (_) {
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());
      },
    );
  }
}
