import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../widgets/app_card.dart';
import '../seller_mock_data.dart';
import '../seller_models.dart';

class ConnectedSellerProductsPage extends StatefulWidget {
  final bool isCanteen;

  const ConnectedSellerProductsPage({super.key, this.isCanteen = false});

  @override
  State<ConnectedSellerProductsPage> createState() =>
      _ConnectedSellerProductsPageState();
}

class _ConnectedSellerProductsPageState
    extends State<ConnectedSellerProductsPage> {
  final store = SellerDataStore.instance;

  String search = '';

  List<SellerProduct> get modeProducts =>
      store.productsForMode(widget.isCanteen);

  List<SellerProduct> get filteredProducts {
    final query = search.trim().toLowerCase();

    if (query.isEmpty) {
      return modeProducts;
    }

    return modeProducts.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
    }).toList();
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
      modeProducts.add(product);
    });

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

    if (updated == true) {
      setState(() {});
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
      modeProducts.removeWhere((item) => item.id == product.id);
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

    final title = widget.isCanteen ? 'Menu' : 'Products';

    final addLabel = widget.isCanteen ? 'Add Food Item' : 'Add Product';

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addProduct,
        backgroundColor: AppColors.primaryMaroon,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(addLabel),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              widget.isCanteen
                  ? 'Manage breakfast, lunch, snacks, drinks and pre-order availability.'
                  : 'Manage products, prices, stock and pre-order availability.',
              style: const TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 20),

            TextField(
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
              decoration: InputDecoration(
                hintText: widget.isCanteen ? 'Search menu' : 'Search products',
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
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
                              const SizedBox(height: 4),
                              Text('${product.category} • ${product.unit}'),
                              const SizedBox(height: 4),
                              Text(
                                widget.isCanteen
                                    ? '₹${product.price.toStringAsFixed(2)} • Available: ${product.stock}'
                                    : '₹${product.price.toStringAsFixed(2)} • Stock: ${product.stock}',
                                style: const TextStyle(
                                  color: AppColors.primaryMaroon,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                product.preOrderEnabled
                                    ? 'Pre-order ON'
                                    : 'Pre-order OFF',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: product.preOrderEnabled
                                      ? AppColors.primaryMaroon
                                      : Colors.grey,
                                  fontWeight: FontWeight.w600,
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

            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}

class SellerProductFormScreen extends StatefulWidget {
  final SellerProduct? product;
  final bool isCanteen;

  const SellerProductFormScreen({
    super.key,
    this.product,
    this.isCanteen = false,
  });

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

  List<String> get categories {
    if (widget.isCanteen) {
      return const ['Breakfast', 'Lunch', 'Evening Snacks', 'Drinks'];
    }

    return const [
      'Dairy',
      'Bakery',
      'Groceries',
      'Vegetables',
      'Snacks',
      'Beverages',
    ];
  }

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

    category = product?.category ?? (widget.isCanteen ? 'Breakfast' : 'Dairy');

    if (!categories.contains(category)) {
      category = categories.first;
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

    final quantity = int.tryParse(stockController.text.trim());

    if (price == null || price < 0) {
      return;
    }

    if (quantity == null || quantity < 0) {
      return;
    }

    if (editing) {
      final product = widget.product!;

      product.name = nameController.text.trim();
      product.category = category;
      product.price = price;
      product.unit = unitController.text.trim();
      product.stock = quantity;
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
      stock: quantity,
      preOrderEnabled: preOrderEnabled,
    );

    Navigator.of(context).pop(product);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.isCanteen ? 'Food Item' : 'Product';

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(editing ? 'Edit $item' : 'Add $item'),
      ),
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
                    decoration: InputDecoration(
                      labelText: widget.isCanteen
                          ? 'Food Name'
                          : 'Product Name',
                      prefixIcon: Icon(
                        widget.isCanteen
                            ? Icons.restaurant_outlined
                            : Icons.inventory_2_outlined,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return widget.isCanteen
                            ? 'Please enter food name'
                            : 'Please enter product name';
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
                    decoration: InputDecoration(
                      labelText: 'Unit',
                      hintText: widget.isCanteen
                          ? 'plate, cup, piece...'
                          : '1 L, 500 g, piece...',
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
                    decoration: InputDecoration(
                      labelText: widget.isCanteen
                          ? 'Available Quantity'
                          : 'Available Stock',
                      prefixIcon: Icon(
                        widget.isCanteen
                            ? Icons.room_service_outlined
                            : Icons.inventory_outlined,
                      ),
                    ),
                    validator: (value) {
                      final quantity = int.tryParse(value ?? '');

                      if (quantity == null || quantity < 0) {
                        return 'Enter a valid quantity';
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
                          ? 'Customers can pre-order this item.'
                          : 'Pre-orders are disabled for this item.',
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
                    label: Text(editing ? 'Save Changes' : 'Add $item'),
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
