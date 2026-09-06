import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/constants/app_colors.dart';
import '../../models/community.dart';
import '../customer/customer_cart_store.dart';
import '../customer/customer_session.dart';
import 'community_registry.dart';

class JoinByCodeScreen extends StatefulWidget {
  final CommunityType requiredType;

  const JoinByCodeScreen({super.key, required this.requiredType});

  @override
  State<JoinByCodeScreen> createState() => _JoinByCodeScreenState();
}

class _JoinByCodeScreenState extends State<JoinByCodeScreen> {
  final formKey = GlobalKey<FormState>();

  final codeController = TextEditingController();

  bool loading = false;

  bool get isCollege => widget.requiredType == CommunityType.college;

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  Future<void> _join() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      loading = true;
    });

    await CommunityRegistry.instance.load();

    final community = CommunityRegistry.instance.findByCode(
      codeController.text,
    );

    if (!mounted) return;

    if (community == null || community.type != widget.requiredType) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isCollege
                ? 'College community not found. Check the code.'
                : 'Apartment community not found. Check the code.',
          ),
        ),
      );

      return;
    }

    // Only clear the old cart after the new code
    // has been successfully validated.
    CustomerCartStore.instance.clear();

    await CustomerSession.instance.selectCommunity(community);

    if (!mounted) return;

    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.customerHome, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(isCollege ? 'Join College' : 'Join Apartment'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      isCollege
                          ? Icons.school_rounded
                          : Icons.apartment_rounded,
                      size: 72,
                      color: AppColors.primaryMaroon,
                    ),

                    const SizedBox(height: 22),

                    Text(
                      isCollege ? 'Join Your College' : 'Join Your Apartment',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      isCollege
                          ? 'Enter the code provided by your canteen seller.'
                          : 'Enter the code provided by your supermarket seller.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black54),
                    ),

                    const SizedBox(height: 30),

                    TextFormField(
                      controller: codeController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'Community Code',
                        hintText: 'Enter community code',
                        prefixIcon: Icon(Icons.key_rounded),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter community code';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 26),

                    FilledButton(
                      onPressed: loading ? null : _join,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryMaroon,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(54),
                      ),
                      child: loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Join Community'),
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
