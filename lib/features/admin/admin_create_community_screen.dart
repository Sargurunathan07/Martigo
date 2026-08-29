import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminCreateCommunityScreen extends StatefulWidget {
  const AdminCreateCommunityScreen({super.key});

  @override
  State<AdminCreateCommunityScreen> createState() =>
      _AdminCreateCommunityScreenState();
}

class _AdminCreateCommunityScreenState
    extends State<AdminCreateCommunityScreen> {
  final _formKey = GlobalKey<FormState>();

  final _communityNameController = TextEditingController();
  final _businessNameController = TextEditingController();

  String _communityType = 'Apartment';
  String? _generatedCode;

  String get _businessType =>
      _communityType == 'Apartment' ? 'Supermarket' : 'Canteen';

  String _generateCommunityCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();

    final cleanName = _communityNameController.text
        .trim()
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z0-9]'), '');

    String prefix;

    if (cleanName.length >= 6) {
      prefix = cleanName.substring(0, 6);
    } else if (cleanName.isNotEmpty) {
      prefix = cleanName;
    } else {
      prefix = 'MARTIGO';
    }

    final suffix = List.generate(
      3,
      (_) => chars[random.nextInt(chars.length)],
    ).join();

    return '$prefix-$suffix';
  }

  void _generateCode() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _generatedCode = _generateCommunityCode();
    });
  }

  void _copyCode() {
    if (_generatedCode == null) return;

    Clipboard.setData(ClipboardData(text: _generatedCode!));

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Community code copied')));
  }

  void _saveCommunity() {
    if (!_formKey.currentState!.validate()) return;

    if (_generatedCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Generate a community code first')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_communityNameController.text.trim()} created successfully',
        ),
      ),
    );

    // Backend/database saving will be added later.
  }

  @override
  void dispose() {
    _communityNameController.dispose();
    _businessNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Community')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Create a new community',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF292323),
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create an apartment or college community and generate '
                      'a unique code for users to join.',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Community name
                    TextFormField(
                      controller: _communityNameController,
                      decoration: InputDecoration(
                        labelText: 'Community Name',
                        hintText: 'Sunrise Apartments',
                        prefixIcon: const Icon(Icons.groups_rounded),
                        filled: true,
                        fillColor: const Color(0xFFFFF7F0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter community name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Community type
                    DropdownButtonFormField<String>(
                      initialValue: _communityType,
                      decoration: InputDecoration(
                        labelText: 'Community Type',
                        prefixIcon: const Icon(Icons.category_outlined),
                        filled: true,
                        fillColor: const Color(0xFFFFF7F0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Apartment',
                          child: Text('Apartment'),
                        ),
                        DropdownMenuItem(
                          value: 'College',
                          child: Text('College'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          _communityType = value;
                          _generatedCode = null;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // Business name
                    TextFormField(
                      controller: _businessNameController,
                      decoration: InputDecoration(
                        labelText: _businessType == 'Supermarket'
                            ? 'Supermarket Name'
                            : 'Canteen Name',
                        hintText: _businessType == 'Supermarket'
                            ? 'Sunrise Supermarket'
                            : 'ABC College Canteen',
                        prefixIcon: Icon(
                          _businessType == 'Supermarket'
                              ? Icons.storefront_rounded
                              : Icons.restaurant_rounded,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFFF7F0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter business name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Business type display
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5E1E5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.business_center_outlined,
                            color: Color(0xFF800020),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Business Type',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                _businessType,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF292323),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    OutlinedButton.icon(
                      onPressed: _generateCode,
                      icon: const Icon(Icons.auto_awesome_rounded),
                      label: const Text('Generate Community Code'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                        foregroundColor: const Color(0xFF800020),
                        side: const BorderSide(color: Color(0xFF800020)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),

                    if (_generatedCode != null) ...[
                      const SizedBox(height: 28),

                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5E1E5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF800020)
                                .withValues(alpha: 0.20),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.verified_rounded,
                              size: 44,
                              color: Color(0xFF800020),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Community Code',
                              style: TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 8),
                            SelectableText(
                              _generatedCode!,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: Color(0xFF5A0015),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              onPressed: _copyCode,
                              icon: const Icon(Icons.copy_rounded),
                              label: const Text('Copy Code'),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF800020),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7F0),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: Color(0xFF800020),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Residents or students can use this code to '
                                'join the community in Martigo.',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    ElevatedButton.icon(
                      onPressed: _saveCommunity,
                      icon: const Icon(Icons.add_business_rounded),
                      label: const Text(
                        'Create Community',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        backgroundColor: const Color(0xFF800020),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
