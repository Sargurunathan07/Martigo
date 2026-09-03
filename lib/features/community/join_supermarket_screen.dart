import 'package:flutter/material.dart';

import '../customer/customer_session.dart';
import 'community_mock_data.dart';

class JoinSupermarketScreen extends StatefulWidget {
  const JoinSupermarketScreen({super.key});

  @override
  State<JoinSupermarketScreen> createState() => _JoinSupermarketScreenState();
}

class _JoinSupermarketScreenState extends State<JoinSupermarketScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _joinSupermarket() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _loading = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    final community = CommunityMockData.findSupermarket(
      name: _nameController.text,
      code: _codeController.text,
    );

    if (!mounted) return;

    if (community == null) {
      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Community not found. Please check the name and code and try again.',
          ),
        ),
      );

      return;
    }

    await CustomerSession.instance.selectCommunity(community);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Supermarket joined successfully!')),
    );

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/customer-home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFC),
      appBar: AppBar(title: const Text('Join a Supermarket')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 82,
                        height: 82,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5E1E5),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(
                          Icons.storefront_rounded,
                          size: 42,
                          color: Color(0xFF800020),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Join a Supermarket',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF292323),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Enter your supermarket details to continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),

                    const SizedBox(height: 32),

                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Supermarket Name',
                        hintText: 'Enter supermarket name',
                        prefixIcon: const Icon(Icons.store_outlined),
                        filled: true,
                        fillColor: const Color(0xFFFFF7F0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter supermarket name';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    TextFormField(
                      controller: _codeController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        labelText: 'Community Code',
                        hintText: 'Enter community code',
                        prefixIcon: const Icon(Icons.key_rounded),
                        filled: true,
                        fillColor: const Color(0xFFFFF7F0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter community code';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Demo: Sunrise Supermarket / SUNRISE-A72',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),

                    const SizedBox(height: 28),

                    FilledButton(
                      onPressed: _loading ? null : _joinSupermarket,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF800020),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Join Supermarket',
                              style: TextStyle(fontWeight: FontWeight.w700),
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
