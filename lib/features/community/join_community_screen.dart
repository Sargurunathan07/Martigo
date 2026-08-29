import 'package:flutter/material.dart';
import '../../widgets/app_button.dart';
import 'enter_code_screen.dart';
import 'scan_qr_screen.dart';

/// Entry point for joining a community. Offers two paths: scanning a
/// QR code or manually entering a community code.
class JoinCommunityScreen extends StatelessWidget {
  const JoinCommunityScreen({super.key});

  void _onScanQrPressed(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ScanQrScreen()),
    );
  }

  void _onEnterCodePressed(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const EnterCodeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Join Community')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Find your community', style: textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(
                'Join an apartment or college community to start '
                'pre-ordering from your local supermarket or canteen.',
                style: textTheme.bodyMedium,
              ),
              const Spacer(),
              Icon(
                Icons.groups_outlined,
                size: 96,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'Scan QR Code',
                icon: Icons.qr_code_scanner_outlined,
                onPressed: () => _onScanQrPressed(context),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'Enter Community Code',
                type: AppButtonType.secondary,
                icon: Icons.keyboard_outlined,
                onPressed: () => _onEnterCodePressed(context),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}