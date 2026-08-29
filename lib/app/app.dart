import 'package:flutter/material.dart';
import 'routes.dart';
import 'theme.dart';

/// Root widget of the Martigo application.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Martigo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.initial,
      routes: AppRoutes.routes,
    );
  }
}