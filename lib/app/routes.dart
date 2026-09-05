import 'package:flutter/material.dart';

import '../features/admin/admin_dashboard_shell.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/onboarding_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/splash_screen.dart';
import '../features/community/join_college_screen.dart';
import '../features/community/join_community_screen.dart';
import '../features/community/join_supermarket_screen.dart';
import '../features/customer/customer_cart_screen.dart';
import '../features/customer/customer_home_shell.dart';
import '../features/customer/customer_products_screen.dart';
import '../features/customer/date_selection_screen.dart';
import '../features/customer/my_orders_screen.dart';
import '../features/customer/notifications_screen.dart';
import '../features/customer/order_confirmation_screen.dart';
import '../features/customer/product_details_screen.dart';
import '../features/customer/profile_screen.dart';
import '../features/seller/auth/seller_welcome_screen.dart';
import '../features/seller/dashboard/seller_home_shell.dart';
import '../features/seller/preorders/seller_preorders_screen.dart';
import '../features/seller/stock/stock_management_screen.dart';

class AppRoutes {
  AppRoutes._();

  // Auth
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Community
  static const String joinCommunity = '/join-community';
  static const String joinSupermarket = '/join-supermarket';
  static const String joinCollege = '/join-college';

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
  static const String sellerWelcome = '/seller-welcome';
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
    joinSupermarket: (context) => const JoinSupermarketScreen(),
    joinCollege: (context) => const JoinCollegeScreen(),

    customerHome: (context) {
      final initialIndex =
          ModalRoute.of(context)?.settings.arguments as int? ?? 0;

      return CustomerHomeShell(initialIndex: initialIndex);
    },

    productCategories: (context) => const CustomerProductsScreen(),
    productDetails: (context) => const ProductDetailsScreen(),
    dateSelection: (context) => const DateSelectionScreen(),
    preOrderCart: (context) => const CustomerCartScreen(),
    orderConfirmation: (context) => const OrderConfirmationScreen(),
    myOrders: (context) => const MyOrdersScreen(),
    notifications: (context) => const NotificationsScreen(),
    profile: (context) => const ProfileScreen(),

    sellerWelcome: (context) => const SellerWelcomeScreen(),
    sellerDashboard: (context) => const SellerHomeShell(),
    sellerPreOrders: (context) => const SellerPreOrdersScreen(),
    stockManagement: (context) => const StockManagementScreen(),

    canteenSellerDashboard: (context) =>
        const _PlaceholderScreen(title: 'Canteen Seller Dashboard'),

    communityManagement: (context) =>
        const _PlaceholderScreen(title: 'Community Management'),

    orderDeadline: (context) =>
        const _PlaceholderScreen(title: 'Order Deadline'),

    adminDashboard: (context) => const AdminDashboardShell(),
  };
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('$title\n(coming soon)', textAlign: TextAlign.center),
      ),
    );
  }
}
