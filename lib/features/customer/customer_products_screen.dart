import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../models/community.dart';
import '../../models/product.dart';
import '../../widgets/product_card.dart';
import 'customer_cart_store.dart';
import 'customer_catalog_data.dart';
import 'customer_mock_data.dart';

class CustomerProductsScreen extends StatefulWidget {
  const CustomerProductsScreen({super.key});

  @override
  State<CustomerProductsScreen> createState() => _CustomerProductsScreenState();
}

class _CustomerProductsScreenState extends State<CustomerProductsScreen> {
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

  void _addToCart(Product product) {
    CustomerCartStore.instance.addProduct(product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final community = CustomerMockData.currentCommunity;
    final isCanteen = community.businessType == BusinessType.canteen;

    final categories = ['All', ...CustomerCatalogData.currentCategories];

    final products = _filteredProducts;

    return Scaffold(
      appBar: AppBar(title: Text(isCanteen ? 'Menu' : 'Products')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: TextField(
                onChanged: (value) {
                  setState(() => _search = value);
                },
                decoration: InputDecoration(
                  hintText: isCanteen
                      ? 'Search meals, drinks or snacks'
                      : 'Search products',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
            const SizedBox(height: 12),
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text('No items found.'))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;

                        final count = width >= 1000
                            ? 4
                            : width >= 700
                            ? 3
                            : 2;

                        return GridView.builder(
                          padding: const EdgeInsets.all(20),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: count,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                                childAspectRatio: 0.62,
                              ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];

                            return ProductCard(
                              product: product,
                              actionLabel: 'Add to Cart',
                              onAddToPreOrder: () {
                                _addToCart(product);
                              },
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.productDetails,
                                  arguments: product,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
