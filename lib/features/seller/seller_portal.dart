import 'package:flutter/material.dart';

import '../../app/routes.dart';

import 'preorders/seller_preorders_connected_screen.dart';
import 'demand/seller_demand_connected_screen.dart';

import 'seller_mock_data.dart';
import 'products/seller_products_connected_screen.dart';
import 'stock/seller_stock_connected_screen.dart';

class MartigoSellerColors {
  static const maroon = Color(0xFF800020);
  static const deepMaroon = Color(0xFF5A0015);
  static const softMaroon = Color(0xFFF5E1E5);
  static const cream = Color(0xFFFFF7F0);
  static const background = Color(0xFFFFFDFC);
  static const text = Color(0xFF292323);
}

class SellerPortalApp extends StatelessWidget {
  const SellerPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Martigo Seller',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: MartigoSellerColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: MartigoSellerColors.maroon,
          primary: MartigoSellerColors.maroon,
          surface: MartigoSellerColors.background,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: MartigoSellerColors.background,
          foregroundColor: MartigoSellerColors.text,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: MartigoSellerColors.cream,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: MartigoSellerColors.softMaroon),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: MartigoSellerColors.maroon,
              width: 2,
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: MartigoSellerColors.maroon,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      home: const SellerWelcomeScreen(),
    );
  }
}

Widget sellerPageFrame({required Widget child, double maxWidth = 560}) {
  return SafeArea(
    child: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    ),
  );
}

class SellerWelcomeScreen extends StatelessWidget {
  const SellerWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sellerPageFrame(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: MartigoSellerColors.softMaroon,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  size: 48,
                  color: MartigoSellerColors.maroon,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Martigo',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: MartigoSellerColors.deepMaroon,
                ),
              ),
              const Text(
                'Seller Portal',
                style: TextStyle(
                  fontSize: 18,
                  color: MartigoSellerColors.maroon,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 36),
              const Text(
                'Welcome to Martigo',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: MartigoSellerColors.text,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Manage your store, stock and pre-orders easily.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SellerRegistrationScreen(),
                    ),
                  );
                },
                child: const Text('Create Seller Account'),
              ),
              const SizedBox(height: 14),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  foregroundColor: MartigoSellerColors.maroon,
                  side: const BorderSide(color: MartigoSellerColors.maroon),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SellerLoginScreen(),
                    ),
                  );
                },
                child: const Text('Login to Seller Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SellerRegistrationScreen extends StatefulWidget {
  const SellerRegistrationScreen({super.key});

  @override
  State<SellerRegistrationScreen> createState() =>
      _SellerRegistrationScreenState();
}

class _SellerRegistrationScreenState extends State<SellerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  Widget field(String label, IconData icon, {bool password = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        obscureText: password,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seller Registration')),
      body: sellerPageFrame(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Create seller account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Start planning demand and reducing waste with Martigo.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 28),
                field('Business / Store Name', Icons.store_outlined),
                field('Owner Name', Icons.person_outline),
                field('Mobile Number', Icons.phone_outlined),
                field('Email Address', Icons.email_outlined),
                field('Store Address', Icons.location_on_outlined),
                field('Create Password', Icons.lock_outline, password: true),
                const SizedBox(height: 10),
                FilledButton(
                  onPressed: () {
                    if (!(_formKey.currentState?.validate() ?? false)) return;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SellerMembershipScreen(),
                      ),
                    );
                  },
                  child: const Text('Create Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SellerLoginScreen extends StatefulWidget {
  const SellerLoginScreen({super.key});

  @override
  State<SellerLoginScreen> createState() => _SellerLoginScreenState();
}

class _SellerLoginScreenState extends State<SellerLoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void login() {
    if (email.text.trim().toLowerCase() == 'seller@martigo.com' &&
        password.text == 'seller123') {
      SellerDataStore.instance.activateMembership();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SellerDashboardShell()),
        (_) => false,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SellerMembershipScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seller Login')),
      body: sellerPageFrame(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome back',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Login to manage your Martigo business.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Demo active seller: seller@martigo.com / seller123',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 28),
              FilledButton(onPressed: login, child: const Text('Login')),
            ],
          ),
        ),
      ),
    );
  }
}

class SellerMembershipScreen extends StatelessWidget {
  const SellerMembershipScreen({super.key});

  static const benefits = [
    'Manage Products & Stock',
    'Receive Pre-orders',
    'View Customer Demand',
    'Pre-order Planning',
    'Order Notifications',
    'Seller Dashboard & Analytics',
    'Priority Support',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seller Membership')),
      body: sellerPageFrame(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  color: MartigoSellerColors.cream,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: MartigoSellerColors.softMaroon),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.workspace_premium_rounded,
                      size: 54,
                      color: MartigoSellerColors.maroon,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Martigo Seller Membership',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      '₹1,000',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: MartigoSellerColors.deepMaroon,
                      ),
                    ),
                    const Text(
                      '/ month',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Billed monthly • Cancel anytime',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 26),
                    ...benefits.map(
                      (benefit) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: MartigoSellerColors.maroon,
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(benefit)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SellerPaymentScreen(),
                    ),
                  );
                },
                child: const Text('Subscribe Now – ₹1,000 / month'),
              ),
              const SizedBox(height: 12),
              const Text(
                'Secure payment by Razorpay',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SellerPaymentScreen extends StatelessWidget {
  const SellerPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: sellerPageFrame(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Complete Your Payment',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'You are subscribing to Martigo Seller Membership.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 30),
              const SellerCard(
                child: Column(
                  children: [
                    PaymentRow(
                      label: 'Plan',
                      value: 'Martigo Seller Membership',
                    ),
                    Divider(height: 28),
                    PaymentRow(label: 'Price', value: '₹1,000 / month'),
                    Divider(height: 28),
                    PaymentRow(label: 'Payment Method', value: 'Razorpay'),
                  ],
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SellerPaymentSuccessScreen(),
                    ),
                  );
                },
                child: const Text('Pay ₹1,000'),
              ),
              const SizedBox(height: 12),
              const Text(
                'Secure payment powered by Razorpay\n(Mock payment for development)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentRow extends StatelessWidget {
  final String label;
  final String value;

  const PaymentRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.black54)),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class SellerPaymentSuccessScreen extends StatelessWidget {
  const SellerPaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sellerPageFrame(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  color: MartigoSellerColors.softMaroon,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 64,
                  color: MartigoSellerColors.maroon,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Payment Successful',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your Martigo Seller Membership is now active.\nWelcome to Martigo!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 34),
              FilledButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SellerDashboardShell(),
                    ),
                    (_) => false,
                  );
                },
                child: const Text('Go to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SellerDashboardShell extends StatefulWidget {
  const SellerDashboardShell({super.key});

  @override
  State<SellerDashboardShell> createState() => _SellerDashboardShellState();
}

class _SellerDashboardShellState extends State<SellerDashboardShell> {
  int index = 0;

  final pages = const [
    SellerHomePage(),
    ConnectedSellerProductsPage(),
    ConnectedSellerPreOrdersPage(),
    ConnectedSellerStockPage(),
    SellerProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: pages[index],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          setState(() => index = value);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2_rounded),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note_rounded),
            label: 'Pre-orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_outlined),
            selectedIcon: Icon(Icons.inventory_rounded),
            label: 'Stock',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class SellerHomePage extends StatelessWidget {
  const SellerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Martigo',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: MartigoSellerColors.deepMaroon,
                      ),
                    ),
                    Text(
                      'Sunrise Supermarket',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SellerNotificationsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.notifications_none_rounded),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SellerCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning, Store Owner!',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "Here's what's happening in your store.",
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SellerCard(
            background: MartigoSellerColors.softMaroon,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Membership',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    StatusBadge(text: 'ACTIVE'),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '₹1,000 / month',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: MartigoSellerColors.deepMaroon,
                  ),
                ),
                const Text(
                  'Next billing: 03 October',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SellerSubscriptionScreen(),
                      ),
                    );
                  },
                  child: const Text('View Details'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(
                child: MetricCard(
                  value: '128',
                  label: 'Products',
                  icon: Icons.inventory_2_outlined,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: MetricCard(
                  value: '24',
                  label: 'Pre-orders',
                  icon: Icons.event_note_outlined,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: MetricCard(
                  value: '12',
                  label: "Today's",
                  icon: Icons.shopping_bag_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Upcoming Demand',
            action: 'Plan Demand',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const ConnectedSellerDemandScreen(period: 'week'),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          SellerCard(
            child: Column(
              children: const [
                DemandRow(name: 'Milk', quantity: '×12'),
                DemandRow(name: 'Bread', quantity: '×8'),
                DemandRow(name: 'Eggs', quantity: '×15'),
                DemandRow(name: 'Curd', quantity: '×6'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Low Stock Alerts'),
          const SizedBox(height: 10),
          const SellerCard(
            child: Column(
              children: [
                StockAlert(name: 'Bread', stock: 'Only 18 left'),
                Divider(),
                StockAlert(name: 'Milk', stock: 'Only 10 left'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SellerPreOrdersPage extends StatelessWidget {
  const SellerPreOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Pre-orders',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              FilterChip(
                label: Text('Today'),
                selected: false,
                onSelected: null,
              ),
              SizedBox(width: 8),
              FilterChip(
                label: Text('Tomorrow'),
                selected: true,
                onSelected: null,
              ),
              SizedBox(width: 8),
              FilterChip(
                label: Text('This Week'),
                selected: false,
                onSelected: null,
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            'Tomorrow • 03 September',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
          ),
          const Text('24 Pre-orders', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 16),
          const SellerCard(
            child: Column(
              children: [
                DemandRow(name: 'Milk', quantity: '×18'),
                DemandRow(name: 'Bread', quantity: '×12'),
                DemandRow(name: 'Eggs', quantity: '×30'),
                DemandRow(name: 'Curd', quantity: '×14'),
                DemandRow(name: 'Rice', quantity: '×8'),
                Divider(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total items required',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      '82',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: MartigoSellerColors.maroon,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const ConnectedSellerDemandScreen(period: 'week'),
                ),
              );
            },
            child: const Text("Prepare Tomorrow's Stock"),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SellerOrdersScreen()),
              );
            },
            child: const Text('View Individual Orders'),
          ),
        ],
      ),
    );
  }
}

class SellerProductsPage extends StatelessWidget {
  const SellerProductsPage({super.key});

  static const products = [
    ('Milk', '1 L', '₹30', '42'),
    ('Bread', '400 g', '₹40', '18'),
    ('Eggs', '6 pcs', '₹42', '86'),
    ('Curd', '500 g', '₹45', '25'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: MartigoSellerColors.maroon,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SellerAddProductScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Products',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: 18),
            ...products.map(
              (product) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SellerCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: MartigoSellerColors.softMaroon,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        color: MartigoSellerColors.maroon,
                      ),
                    ),
                    title: Text(
                      product.$1,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${product.$2} • ${product.$3}\nStock: ${product.$4} • Pre-order ON',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SellerAddProductScreen extends StatefulWidget {
  const SellerAddProductScreen({super.key});

  @override
  State<SellerAddProductScreen> createState() => _SellerAddProductScreenState();
}

class _SellerAddProductScreenState extends State<SellerAddProductScreen> {
  bool preorder = true;
  String category = 'Dairy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: sellerPageFrame(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: const Text('Add Product Image'),
            ),
            const SizedBox(height: 18),
            const TextField(
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: const [
                DropdownMenuItem(value: 'Dairy', child: Text('Dairy')),
                DropdownMenuItem(value: 'Groceries', child: Text('Groceries')),
                DropdownMenuItem(value: 'Beverages', child: Text('Beverages')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => category = value);
                }
              },
            ),
            const SizedBox(height: 16),
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Price', prefixText: '₹ '),
            ),
            const SizedBox(height: 16),
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Available Stock'),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: preorder,
              activeThumbColor: MartigoSellerColors.maroon,
              title: const Text('Available for Pre-order'),
              onChanged: (value) {
                setState(() => preorder = value);
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.calendar_month_outlined),
              label: const Text('Select Pre-order Date Availability'),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product saved locally')),
                );
                Navigator.pop(context);
              },
              child: const Text('Save Product'),
            ),
          ],
        ),
      ),
    );
  }
}

class SellerStockPage extends StatefulWidget {
  const SellerStockPage({super.key});

  @override
  State<SellerStockPage> createState() => _SellerStockPageState();
}

class _SellerStockPageState extends State<SellerStockPage> {
  final Map<String, int> stock = {
    'Milk': 42,
    'Bread': 18,
    'Eggs': 86,
    'Curd': 25,
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Stock Management',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...stock.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SellerCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${entry.value} available',
                            style: TextStyle(
                              color: entry.value <= 18
                                  ? MartigoSellerColors.maroon
                                  : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (entry.value > 0) {
                          setState(() => stock[entry.key] = entry.value - 1);
                        }
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      '${entry.value}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() => stock[entry.key] = entry.value + 1);
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'LOW STOCK',
            style: TextStyle(
              color: MartigoSellerColors.maroon,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const SellerCard(
            background: MartigoSellerColors.softMaroon,
            child: StockAlert(name: 'Bread', stock: 'Only 18 remaining'),
          ),
        ],
      ),
    );
  }
}

class SellerDemandPlanningScreen extends StatelessWidget {
  const SellerDemandPlanningScreen({super.key});

  static const demand = {'Milk': 18, 'Bread': 12, 'Eggs': 30, 'Curd': 14};

  @override
  Widget build(BuildContext context) {
    const max = 30.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Demand Planning')),
      body: sellerPageFrame(
        maxWidth: 650,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Tomorrow',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const Text('03 September', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 24),
            const SellerCard(
              background: MartigoSellerColors.softMaroon,
              child: Text(
                'Based on current pre-orders, prepare 18 units of Milk for tomorrow.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Expected Demand',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            ...demand.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(entry.key)),
                        Text(
                          '${entry.value} units',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        minHeight: 9,
                        value: entry.value / max,
                        backgroundColor: MartigoSellerColors.softMaroon,
                        color: MartigoSellerColors.maroon,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SellerOrdersScreen extends StatelessWidget {
  const SellerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      ('#MRT1024', 'Apartment Resident', '03 Sep • 8:00 AM', '₹144'),
      ('#MRT1025', 'Apartment Resident', '03 Sep • 9:30 AM', '₹210'),
      ('#MRT1026', 'Apartment Resident', '03 Sep • 10:00 AM', '₹95'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: sellerPageFrame(
        maxWidth: 650,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ...orders.map(
              (order) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SellerCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SellerPreOrderDetailsScreen(orderId: order.$1),
                      ),
                    );
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Order ${order.$1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${order.$2}\n${order.$3}'),
                    trailing: Text(
                      order.$4,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SellerPreOrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const SellerPreOrderDetailsScreen({super.key, required this.orderId});

  @override
  State<SellerPreOrderDetailsScreen> createState() =>
      _SellerPreOrderDetailsScreenState();
}

class _SellerPreOrderDetailsScreenState
    extends State<SellerPreOrderDetailsScreen> {
  int status = 0;

  static const statuses = [
    'Pre-order Received',
    'Preparing',
    'Ready',
    'Completed',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order ${widget.orderId}')),
      body: sellerPageFrame(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SellerCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer', style: TextStyle(color: Colors.black54)),
                  Text(
                    'Apartment Resident',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 14),
                  Text('Pickup', style: TextStyle(color: Colors.black54)),
                  Text(
                    '03 September • 8:00 AM',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const SellerCard(
              child: Column(
                children: [
                  DemandRow(name: 'Milk', quantity: '×2'),
                  DemandRow(name: 'Bread', quantity: '×1'),
                  DemandRow(name: 'Eggs', quantity: '×6'),
                  Divider(),
                  PaymentRow(label: 'Total', value: '₹144'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Order Status',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...List.generate(
              statuses.length,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    setState(() {
                      status = i;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: status == i
                          ? MartigoSellerColors.softMaroon
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: status == i
                            ? MartigoSellerColors.maroon
                            : MartigoSellerColors.softMaroon,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          status == i
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: MartigoSellerColors.maroon,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            statuses[i],
                            style: TextStyle(
                              fontWeight: status == i
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                setState(() => status = 2);
              },
              child: const Text('Mark as Ready'),
            ),
          ],
        ),
      ),
    );
  }
}

class SellerNotificationsScreen extends StatelessWidget {
  const SellerNotificationsScreen({super.key});

  static const notifications = [
    '18 customers pre-ordered Milk for tomorrow.',
    'Low stock alert: Bread has only 18 units remaining.',
    'New pre-order received.',
    'Your Martigo membership payment was successful.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: sellerPageFrame(
        maxWidth: 650,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ...notifications.map(
              (notification) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SellerCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.notifications_none_rounded,
                        color: MartigoSellerColors.maroon,
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Text(notification)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SellerProfilePage extends StatelessWidget {
  const SellerProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout?', textAlign: TextAlign.center),
          content: const Text(
            'Are you sure you want to logout\n'
            'from your Martigo seller account?',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: MartigoSellerColors.maroon,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true || !context.mounted) {
      return;
    }

    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.roleSelection, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Profile',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const SellerCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sunrise Supermarket',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Owner: Store Owner'),
                Text('Mobile: +91 98765 43210'),
                Text('Email: seller@martigo.com'),
                Text('Address: Sunrise Apartments'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ProfileOption(
            icon: Icons.business_outlined,
            title: 'Business Details',
          ),
          ProfileOption(
            icon: Icons.workspace_premium_outlined,
            title: 'Subscription',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SellerSubscriptionScreen(),
                ),
              );
            },
          ),
          const ProfileOption(
            icon: Icons.receipt_long_outlined,
            title: 'Payment History',
          ),
          const ProfileOption(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
          ),
          const ProfileOption(
            icon: Icons.support_agent_outlined,
            title: 'Help & Support',
          ),
          const SizedBox(height: 12),
          const Divider(),
          ProfileOption(
            icon: Icons.logout_rounded,
            title: 'Logout',
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}

class SellerSubscriptionScreen extends StatelessWidget {
  const SellerSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscription')),
      body: sellerPageFrame(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const [
            SellerCard(
              background: MartigoSellerColors.softMaroon,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.workspace_premium_rounded,
                        color: MartigoSellerColors.maroon,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Martigo Seller Membership',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      StatusBadge(text: 'ACTIVE'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    '₹1,000 / month',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: MartigoSellerColors.deepMaroon,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Next billing date: 03 October'),
                  Text('Payment Method: Razorpay'),
                ],
              ),
            ),
            SizedBox(height: 18),
            ProfileOption(
              icon: Icons.receipt_long_outlined,
              title: 'Payment History',
            ),
            ProfileOption(
              icon: Icons.settings_outlined,
              title: 'Manage Subscription',
            ),
            ProfileOption(
              icon: Icons.credit_card_outlined,
              title: 'Billing Details',
            ),
            ProfileOption(
              icon: Icons.cancel_outlined,
              title: 'Cancel Subscription',
            ),
          ],
        ),
      ),
    );
  }
}

class SellerCard extends StatelessWidget {
  final Widget child;
  final Color? background;
  final VoidCallback? onTap;

  const SellerCard({
    super.key,
    required this.child,
    this.background,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: background ?? Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MartigoSellerColors.softMaroon),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return content;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: content,
    );
  }
}

class MetricCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const MetricCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SellerCard(
      child: Column(
        children: [
          Icon(icon, color: MartigoSellerColors.maroon),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class DemandRow extends StatelessWidget {
  final String name;
  final String quantity;

  const DemandRow({super.key, required this.name, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(child: Text(name)),
          Text(
            quantity,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: MartigoSellerColors.deepMaroon,
            ),
          ),
        ],
      ),
    );
  }
}

class StockAlert extends StatelessWidget {
  final String name;
  final String stock;

  const StockAlert({super.key, required this.name, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.warning_amber_rounded,
          color: MartigoSellerColors.maroon,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(stock, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String text;

  const StatusBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: MartigoSellerColors.maroon,
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        if (action != null) TextButton(onPressed: onTap, child: Text(action!)),
      ],
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SellerCard(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: MartigoSellerColors.maroon),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
