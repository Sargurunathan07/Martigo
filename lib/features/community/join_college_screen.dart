import 'package:flutter/material.dart';

import '../customer/customer_session.dart';
import 'community_mock_data.dart';

class JoinCollegeScreen extends StatefulWidget {
  const JoinCollegeScreen({super.key});

  @override
  State<JoinCollegeScreen> createState() => _JoinCollegeScreenState();
}

class _JoinCollegeScreenState extends State<JoinCollegeScreen> {
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

  Future<void> _join() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _loading = true);

    await Future.delayed(const Duration(milliseconds: 500));

    final community = CommunityMockData.findCollege(
      name: _nameController.text,
      code: _codeController.text,
    );

    if (!mounted) return;

    if (community == null) {
      setState(() => _loading = false);

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
      const SnackBar(content: Text('College joined successfully!')),
    );

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/customer-home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Your College')),
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
                    const Icon(
                      Icons.school_rounded,
                      size: 70,
                      color: Color(0xFF800020),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Join Your College',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Enter your college details to continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),

                    const SizedBox(height: 32),

                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'College Name',
                        hintText: 'Enter college name',
                        prefixIcon: Icon(Icons.school_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter college name';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    TextFormField(
                      controller: _codeController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'College Code',
                        hintText: 'Enter college code',
                        prefixIcon: Icon(Icons.key_rounded),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter college code';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Demo: ABC Engineering College / ABC-COLLEGE',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),

                    const SizedBox(height: 28),

                    FilledButton(
                      onPressed: _loading ? null : _join,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF800020),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(54),
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
                          : const Text('Join College'),
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
