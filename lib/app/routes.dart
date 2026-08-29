import 'package:flutter/material.dart';

import '../features/auth/splash_screen.dart';
import '../features/auth/onboarding_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/community/join_community_screen.dart';
import '../features/community/enter_community_code_screen.dart';
import '../features/community/scan_qr_screen.dart';
import '../features/community/community_confirmation_screen.dart';
import '../features/customer/customer_home_shell.dart';
import '../features/customer/my_orders_screen.dart';
import '../features/customer/notifications_screen.dart';
import '../features/customer/profile_screen.dart';
import '../features/admin/admin_dashboard_shell.dart';

class AppRoutes {
  AppRoutes._();

  // Auth & onboarding
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String joinCommunity = '/join-community';
  static const String enterCommunityCode = '/enter-community-code';
  static const String scanCommunityQr = '/scan-community-qr';
  static const String communityConfirmation = '/community-confirmation';

  // Customer
  static const String customerHome = '/customer-home';
  static const String productCategories = '/product-categories';
  static const String productDetails = '/product-details';
  static const String dateSelection = '/date-selection';
  static const String preOrderCart = '/pre-order-cart';
  static const String orderConfirmation = '/order-confirmation';
  static const String myOrders = '/my-orders';
  static const String notifications = '/notifications';
  static const String profile = '/profile';

  // Seller
  static const String sellerDashboard = '/seller-dashboard';
  static const String sellerPreOrders = '/seller-pre-orders';
  static const String stockManagement = '/stock-management';
  static const String canteenSellerDashboard = '/canteen-seller-dashboard';
  static const String communityManagement = '/community-management';
  static const String orderDeadline = '/order-deadline';

  // Admin
  static const String adminDashboard = '/admin-dashboard';

  static const String initial = splash;

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    joinCommunity: (context) => const JoinCommunityScreen(),

    enterCommunityCode: (context) => const EnterCommunityCodeScreen(),

    scanCommunityQr: (context) => const ScanQrScreen(),

    communityConfirmation: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args == null) {
        return const JoinCommunityScreen();
      }

      return CommunityConfirmationScreen(
        name: args['name'] as String? ?? '',
        type: args['type'] as String? ?? '',
        business: args['business'] as String? ?? '',
        code: args['code'] as String? ?? '',
      );
    },
    customerHome: (context) => const CustomerHomeShell(),
    productCategories: (context) =>
        const _PlaceholderScreen(title: 'Product Categories'),
    productDetails: (context) =>
        const _PlaceholderScreen(title: 'Product Details'),
    dateSelection: (context) =>
        const _PlaceholderScreen(title: 'Date Selection'),
    preOrderCart: (context) =>
        const _PlaceholderScreen(title: 'Pre-order Cart'),
    orderConfirmation: (context) =>
        const _PlaceholderScreen(title: 'Order Confirmation'),
    myOrders: (context) => const MyOrdersScreen(),
    notifications: (context) => const NotificationsScreen(),
    profile: (context) => const ProfileScreen(),
    sellerDashboard: (context) =>
        const _PlaceholderScreen(title: 'Seller Dashboard'),
    sellerPreOrders: (context) =>
        const _PlaceholderScreen(title: 'Seller Pre-orders'),
    stockManagement: (context) =>
        const _PlaceholderScreen(title: 'Stock Management'),
    canteenSellerDashboard: (context) =>
        const _PlaceholderScreen(title: 'Canteen Seller Dashboard'),
    communityManagement: (context) =>
        const _PlaceholderScreen(title: 'Community Management'),
    orderDeadline: (context) =>
        const _PlaceholderScreen(title: 'Order Deadline'),
    adminDashboard: (context) => const AdminDashboardShell(),
  };
}

/// Temporary placeholder page used for routes whose real feature
/// screens have not been built yet.
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title\n(coming soon)',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
