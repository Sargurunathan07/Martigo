import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../widgets/app_card.dart';
import '../products/seller_products_connected_screen.dart';
import '../seller_mock_data.dart';
import '../seller_models.dart';

class SellerProductsHomeSection extends StatefulWidget {
  final bool isCanteen;
  final VoidCallback? onChanged;

  const SellerProductsHomeSection({
    super.key,
    required this.isCanteen,
    this.onChanged,
  });

  @override
  State<SellerProductsHomeSection> createState() =>
      _SellerProductsHomeSectionState();
}

class _SellerProductsHomeSectionState extends State<SellerProductsHomeSection> {
  final SellerDataStore store = SellerDataStore.instance;

  String _search = '';

  List<SellerProduct> get _modeProducts {
    return store.productsForMode(widget.isCanteen);
  }

  List<SellerProduct> get _filteredProducts {
    final query = _search.trim().toLowerCase();

    if (query.isEmpty) {
      return _modeProducts;
    }

    return _modeProducts.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
    }).toList();
  }

  void _notifyChanged() {
    widget.onChanged?.call();
  }

  Future<void> _addProduct() async {
    final product = await Navigator.of(context).push<SellerProduct>(
      MaterialPageRoute(
        builder: (_) => SellerProductFormScreen(isCanteen: widget.isCanteen),
      ),
    );

    if (product == null) {
      return;
    }

    setState(() {
      _modeProducts.add(product);
    });

    _notifyChanged();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isCanteen
              ? 'Food item added successfully'
              : 'Product added successfully',
        ),
      ),
    );
  }

  Future<void> _editProduct(SellerProduct product) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => SellerProductFormScreen(
          product: product,
          isCanteen: widget.isCanteen,
        ),
      ),
    );

    if (updated == true && mounted) {
      setState(() {});
      _notifyChanged();
    }
  }

  Future<void> _deleteProduct(SellerProduct product) async {
    final itemName = widget.isCanteen ? 'Food Item' : 'Product';

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Delete $itemName?'),
          content: Text('Remove ${product.name}?'),
          actions: [
            TextButton(
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
                backgroundColor: AppColors.primaryMaroon,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    setState(() {
      _modeProducts.removeWhere((item) => item.id == product.id);
    });

    _notifyChanged();
  }

  void _togglePreOrder(SellerProduct product) {
    setState(() {
      product.preOrderEnabled = !product.preOrderEnabled;
    });

    _notifyChanged();
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;

    final title = widget.isCanteen ? 'Manage Menu' : 'Manage Products';

    final addLabel = widget.isCanteen ? 'Add Food Item' : 'Add Product';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        Text(
          widget.isCanteen
              ? 'Manage food items, prices, quantities and pre-order availability.'
              : 'Manage products, prices, stock and pre-order availability.',
          style: const TextStyle(color: Colors.black54),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton.icon(
            onPressed: _addProduct,
            icon: const Icon(Icons.add),
            label: Text(addLabel),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryMaroon,
              foregroundColor: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 16),

        TextField(
          onChanged: (value) {
            setState(() {
              _search = value;
            });
          },
          decoration: InputDecoration(
            hintText: widget.isCanteen ? 'Search menu' : 'Search products',
            prefixIcon: const Icon(Icons.search),
          ),
        ),

        const SizedBox(height: 18),

        if (products.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                widget.isCanteen
                    ? 'No food items found.'
                    : 'No products found.',
              ),
            ),
          )
        else
          ...products.map(
            (product) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: AppColors.softMaroon,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        widget.isCanteen
                            ? Icons.restaurant_menu_rounded
                            : Icons.inventory_2_outlined,
                        color: AppColors.primaryMaroon,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            '${product.category} • '
                            '${product.unit}',
                          ),

                          const SizedBox(height: 3),

                          Text(
                            widget.isCanteen
                                ? '₹${product.price.toStringAsFixed(2)} • '
                                      '${product.stock} available'
                                : '₹${product.price.toStringAsFixed(2)} • '
                                      '${product.stock} in stock',
                            style: const TextStyle(
                              color: AppColors.primaryMaroon,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            product.preOrderEnabled
                                ? 'Pre-order ON'
                                : 'Pre-order OFF',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: product.preOrderEnabled
                                  ? AppColors.primaryMaroon
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editProduct(product);
                        } else if (value == 'toggle') {
                          _togglePreOrder(product);
                        } else if (value == 'delete') {
                          _deleteProduct(product);
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text(
                            widget.isCanteen
                                ? 'Edit Food Item'
                                : 'Edit Product',
                          ),
                        ),
                        PopupMenuItem(
                          value: 'toggle',
                          child: Text(
                            product.preOrderEnabled
                                ? 'Disable Pre-order'
                                : 'Enable Pre-order',
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            widget.isCanteen
                                ? 'Delete Food Item'
                                : 'Delete Product',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
