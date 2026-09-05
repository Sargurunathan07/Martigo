import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../widgets/app_card.dart';
import '../seller_mock_data.dart';
import '../seller_models.dart';

class ConnectedSellerProductsPage extends StatefulWidget {
  const ConnectedSellerProductsPage({super.key});

  @override
  State<ConnectedSellerProductsPage> createState() =>
      _ConnectedSellerProductsPageState();
}

class _ConnectedSellerProductsPageState
    extends State<ConnectedSellerProductsPage> {
  final store = SellerDataStore.instance;

  String search = '';

  List<SellerProduct> get filteredProducts {
    final query = search.trim().toLowerCase();

    if (query.isEmpty) {
      return store.products;
    }

    return store.products.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _addProduct() async {
    final product = await Navigator.of(context).push<SellerProduct>(
      MaterialPageRoute(builder: (_) => const SellerProductFormScreen()),
    );

    if (product == null) return;

    setState(() {
      store.products.add(product);
    });

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Product added successfully')));
  }

  Future<void> _editProduct(SellerProduct product) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => SellerProductFormScreen(product: product),
      ),
    );

    if (updated == true) {
      setState(() {});
    }
  }

  Future<void> _deleteProduct(SellerProduct product) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Product?'),
          content: Text('Remove ${product.name} from your Martigo store?'),
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

    if (shouldDelete != true) return;

    setState(() {
      store.products.removeWhere((item) => item.id == product.id);
    });
  }

  void _togglePreOrder(SellerProduct product) {
    setState(() {
      product.preOrderEnabled = !product.preOrderEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addProduct,
        backgroundColor: AppColors.primaryMaroon,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Products',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Manage products, prices, stock and pre-order availability.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.cream,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (products.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: Text('No products found.')),
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
                          child: const Icon(
                            Icons.inventory_2_outlined,
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
                              const SizedBox(height: 4),
                              Text('${product.category} • ${product.unit}'),
                              const SizedBox(height: 4),
                              Text(
                                '₹${product.price.toStringAsFixed(2)} • Stock: ${product.stock}',
                                style: const TextStyle(
                                  color: AppColors.primaryMaroon,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    product.preOrderEnabled
                                        ? Icons.check_circle_outline
                                        : Icons.cancel_outlined,
                                    size: 17,
                                    color: product.preOrderEnabled
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    product.preOrderEnabled
                                        ? 'Pre-order ON'
                                        : 'Pre-order OFF',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: product.preOrderEnabled
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                _editProduct(product);
                                break;

                              case 'toggle':
                                _togglePreOrder(product);
                                break;

                              case 'delete':
                                _deleteProduct(product);
                                break;
                            }
                          },
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit Product'),
                            ),
                            PopupMenuItem(
                              value: 'toggle',
                              child: Text(
                                product.preOrderEnabled
                                    ? 'Disable Pre-order'
                                    : 'Enable Pre-order',
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete Product'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}

class SellerProductFormScreen extends StatefulWidget {
  final SellerProduct? product;

  const SellerProductFormScreen({super.key, this.product});

  @override
  State<SellerProductFormScreen> createState() =>
      _SellerProductFormScreenState();
}

class _SellerProductFormScreenState extends State<SellerProductFormScreen> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController priceController;
  late final TextEditingController unitController;
  late final TextEditingController stockController;

  late String category;
  late bool preOrderEnabled;

  bool get editing => widget.product != null;

  final categories = const [
    'Dairy',
    'Bakery',
    'Groceries',
    'Vegetables',
    'Snacks',
    'Beverages',
    'Meals',
    'Drinks',
  ];

  @override
  void initState() {
    super.initState();

    final product = widget.product;

    nameController = TextEditingController(text: product?.name ?? '');

    priceController = TextEditingController(
      text: product?.price.toString() ?? '',
    );

    unitController = TextEditingController(text: product?.unit ?? '');

    stockController = TextEditingController(
      text: product?.stock.toString() ?? '',
    );

    category = product?.category ?? 'Dairy';

    if (!categories.contains(category)) {
      category = 'Groceries';
    }

    preOrderEnabled = product?.preOrderEnabled ?? true;
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    unitController.dispose();
    stockController.dispose();

    super.dispose();
  }

  void _save() {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    final price = double.tryParse(priceController.text.trim());

    final stock = int.tryParse(stockController.text.trim());

    if (price == null || price < 0) {
      return;
    }

    if (stock == null || stock < 0) {
      return;
    }

    if (editing) {
      final product = widget.product!;

      product.name = nameController.text.trim();
      product.category = category;
      product.price = price;
      product.unit = unitController.text.trim();
      product.stock = stock;
      product.preOrderEnabled = preOrderEnabled;

      Navigator.of(context).pop(true);

      return;
    }

    final product = SellerProduct(
      id: 'SP${DateTime.now().millisecondsSinceEpoch}',
      name: nameController.text.trim(),
      category: category,
      price: price,
      unit: unitController.text.trim(),
      stock: stock,
      preOrderEnabled: preOrderEnabled,
    );

    Navigator.of(context).pop(product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(editing ? 'Edit Product' : 'Add Product')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter product name';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: categories
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        category = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      prefixText: '₹ ',
                    ),
                    validator: (value) {
                      final price = double.tryParse(value ?? '');

                      if (price == null || price < 0) {
                        return 'Enter a valid price';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: unitController,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      hintText: '1 L, 500 g, piece...',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter unit';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Available Stock',
                      prefixIcon: Icon(Icons.inventory_outlined),
                    ),
                    validator: (value) {
                      final stock = int.tryParse(value ?? '');

                      if (stock == null || stock < 0) {
                        return 'Enter valid stock';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: preOrderEnabled,
                    activeThumbColor: AppColors.primaryMaroon,
                    title: const Text('Available for Pre-order'),
                    subtitle: Text(
                      preOrderEnabled
                          ? 'Customers can pre-order this product.'
                          : 'This product will not accept pre-orders.',
                    ),
                    onChanged: (value) {
                      setState(() {
                        preOrderEnabled = value;
                      });
                    },
                  ),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save_outlined),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryMaroon,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(54),
                    ),
                    label: Text(editing ? 'Save Changes' : 'Add Product'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
