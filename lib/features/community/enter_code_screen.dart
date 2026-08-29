import 'package:flutter/material.dart';
import '../../core/utils/validators.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import 'community_confirmation_screen.dart';
import 'community_mock_data.dart';

/// Lets the user manually enter a community code (e.g. SUNRISE-A72)
/// instead of scanning a QR code. Uses mock lookup data only.
class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _notFoundMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _onContinuePressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _notFoundMessage = null;
    });

    // Mock lookup delay — no backend involved.
    await Future.delayed(const Duration(milliseconds: 600));

    final community = CommunityMockData.findByCode(_codeController.text);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (community == null) {
      setState(() {
        _notFoundMessage =
            'No community found for this code. Please check and try again.';
      });
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            CommunityConfirmationScreen(community: community),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Enter Community Code')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enter your code', style: textTheme.headlineMedium),
                const SizedBox(height: 4),
                Text(
                  'Ask your community admin for your unique code, '
                  'e.g. SUNRISE-A72.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                AppTextField(
                  controller: _codeController,
                  label: 'Community Code',
                  hint: 'e.g. SUNRISE-A72',
                  prefixIcon: Icons.confirmation_number_outlined,
                  validator: Validators.validateCommunityCode,
                ),
                if (_notFoundMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _notFoundMessage!,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.redAccent,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                AppButton(
                  label: 'Continue',
                  isLoading: _isLoading,
                  onPressed: _onContinuePressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}