import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../models/community.dart';
import '../../models/product.dart';
import '../../widgets/product_card.dart';
import 'customer_cart_store.dart';
import 'customer_catalog_data.dart';
import 'customer_mock_data.dart';

class CustomerCatalogSection extends StatefulWidget {
  const CustomerCatalogSection({super.key});

  @override
  State<CustomerCatalogSection> createState() => _CustomerCatalogSectionState();
}

class _CustomerCatalogSectionState extends State<CustomerCatalogSection> {
  String _search = '';
  String _category = 'All';

  List<Product> get _filteredProducts {
    return CustomerCatalogData.currentProducts.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(
        _search.toLowerCase(),
      );

      final matchesCategory =
          _category == 'All' || product.category == _category;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _addToPreOrder(Product product) {
    CustomerCartStore.instance.addProduct(product);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to pre-order'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final community = CustomerMockData.currentCommunity;

    final isCanteen = community.businessType == BusinessType.canteen;

    final categories = ['All', ...CustomerCatalogData.currentCategories];

    if (!categories.contains(_category)) {
      _category = 'All';
    }

    final products = _filteredProducts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isCanteen ? 'Menu' : 'Products',
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 6),

        Text(
          isCanteen
              ? 'Choose meals, snacks and drinks for your pre-order.'
              : 'Choose products you want to pre-order.',
          style: Theme.of(context).textTheme.bodySmall,
        ),

        const SizedBox(height: 16),

        TextField(
          onChanged: (value) {
            setState(() {
              _search = value;
            });
          },
          decoration: InputDecoration(
            hintText: isCanteen
                ? 'Search meals, snacks or drinks'
                : 'Search products',
            prefixIcon: const Icon(Icons.search),
          ),
        ),

        const SizedBox(height: 14),

        SizedBox(
          height: 46,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = categories[index];

              return ChoiceChip(
                label: Text(category),
                selected: _category == category,
                onSelected: (_) {
                  setState(() {
                    _category = category;
                  });
                },
              );
            },
          ),
        ),

        const SizedBox(height: 18),

        if (products.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 36),
            child: Center(
              child: Text(
                isCanteen ? 'No menu items found.' : 'No products found.',
              ),
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              final count = width >= 1000
                  ? 4
                  : width >= 700
                  ? 3
                  : width < 380
                  ? 1
                  : 2;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: count,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: count == 1 ? 1.05 : 0.62,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];

                  return ProductCard(
                    product: product,
                    actionLabel: 'Add to Pre-order',
                    onAddToPreOrder: () {
                      _addToPreOrder(product);
                    },
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.productDetails, arguments: product);
                    },
                  );
                },
              );
            },
          ),
      ],
    );
  }
}
