import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/community.dart';
import 'customer_cart_screen.dart';
import 'customer_home_screen.dart';
import 'customer_mock_data.dart';
import 'customer_products_screen.dart';
import 'my_orders_screen.dart';
import 'profile_screen.dart';

class CustomerHomeShell extends StatefulWidget {
  final int initialIndex;

  const CustomerHomeShell({super.key, this.initialIndex = 0});

  @override
  State<CustomerHomeShell> createState() => _CustomerHomeShellState();
}

class _CustomerHomeShellState extends State<CustomerHomeShell> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.initialIndex.clamp(0, 4);
  }

  @override
  Widget build(BuildContext context) {
    final community = CustomerMockData.currentCommunity;

    final isCanteen = community.businessType == BusinessType.canteen;

    const tabs = <Widget>[
      CustomerHomeScreen(),
      CustomerProductsScreen(),
      MyOrdersScreen(),
      CustomerCartScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: tabs),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryMaroon,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              isCanteen
                  ? Icons.restaurant_menu_outlined
                  : Icons.shopping_bag_outlined,
            ),
            activeIcon: Icon(
              isCanteen ? Icons.restaurant_menu : Icons.shopping_bag,
            ),
            label: isCanteen ? 'Menu' : 'Products',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Pre-orders',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
