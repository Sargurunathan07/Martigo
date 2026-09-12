import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/community.dart';
import '../../models/order.dart';
import '../../widgets/app_card.dart';
import 'customer_mock_data.dart';

/// Customer home tab. Layout adapts to the current community's
/// business type:
/// - Apartment + Supermarket: search, upcoming orders, categories,
///   popular/available products.
/// - College + Canteen: today's meals, tomorrow's menu, upcoming orders.
///
/// Product/meal-specific screens are intentionally not implemented
/// here — this only lays out the home shell for each business type.
class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final community = CustomerMockData.currentCommunity;
    final upcomingOrders = CustomerMockData.orders
        .where(
          (o) =>
              o.status != OrderStatus.completed &&
              o.status != OrderStatus.cancelled,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(community.businessName ?? 'Home'),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.maroonGradient),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _CommunityBanner(community: community),
            const SizedBox(height: 20),
            if (community.businessType == BusinessType.canteen)
              _CanteenHomeContent(upcomingOrders: upcomingOrders)
            else
              _SupermarketHomeContent(upcomingOrders: upcomingOrders),
          ],
        ),
      ),
    );
  }
}

class _CommunityBanner extends StatelessWidget {
  final Community community;

  const _CommunityBanner({required this.community});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.softMaroon,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(
              community.businessType == BusinessType.canteen
                  ? Icons.restaurant_outlined
                  : Icons.storefront_outlined,
              color: AppColors.primaryMaroon,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(community.name, style: textTheme.titleMedium),
                Text(community.businessName ?? '', style: textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Home content for Apartment + Supermarket communities.
class _SupermarketHomeContent extends StatelessWidget {
  final List<Order> upcomingOrders;

  const _SupermarketHomeContent({required this.upcomingOrders});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search products',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _SectionHeader(title: 'Upcoming Orders'),
        const SizedBox(height: 8),
        _UpcomingOrdersList(orders: upcomingOrders),
        const SizedBox(height: 24),
        _SectionHeader(title: 'Categories'),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _CategoryChip(label: 'Dairy'),
              _CategoryChip(label: 'Bakery'),
              _CategoryChip(label: 'Vegetables'),
              _CategoryChip(label: 'Groceries'),
              _CategoryChip(label: 'Snacks'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _SectionHeader(title: 'Popular / Available Products'),
        const SizedBox(height: 8),
        Text(
          'Browse the full catalog from the Product Categories section.',
          style: textTheme.bodySmall,
        ),
      ],
    );
  }
}

/// Home content for College + Canteen communities.
class _CanteenHomeContent extends StatelessWidget {
  final List<Order> upcomingOrders;

  const _CanteenHomeContent({required this.upcomingOrders});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: "Today's Meals"),
        const SizedBox(height: 8),
        const _MealPlaceholderCard(
          label: 'Lunch menu is published by the canteen daily.',
        ),
        const SizedBox(height: 24),
        _SectionHeader(title: "Tomorrow's Menu"),
        const SizedBox(height: 8),
        const _MealPlaceholderCard(
          label: 'Pre-order from tomorrow\'s menu before the deadline.',
        ),
        const SizedBox(height: 24),
        _SectionHeader(title: 'Upcoming Orders'),
        const SizedBox(height: 8),
        _UpcomingOrdersList(orders: upcomingOrders),
      ],
    );
  }
}

class _MealPlaceholderCard extends StatelessWidget {
  final String label;

  const _MealPlaceholderCard({required this.label});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          const Icon(
            Icons.restaurant_menu_outlined,
            color: AppColors.primaryMaroon,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;

  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(label: Text(label)),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }
}

class _UpcomingOrdersList extends StatelessWidget {
  final List<Order> orders;

  const _UpcomingOrdersList({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return AppCard(
        child: Text(
          'No upcoming orders yet. Start a pre-order to see it here.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    return Column(
      children: orders
          .map(
            (order) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppCard(
                child: Row(
                  children: [
                    const Icon(
                      Icons.event_available_outlined,
                      color: AppColors.primaryMaroon,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pickup on ${_formatDate(order.preOrderDate)}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '${order.items.length} item(s) · ₹${order.total.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}
