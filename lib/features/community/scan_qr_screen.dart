import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/app_button.dart';
import 'community_confirmation_screen.dart';
import 'community_mock_data.dart';

/// QR scanner UI placeholder only. Real camera scanning is not
/// implemented yet — this screen shows the intended layout and lets
/// the user simulate a successful scan using mock data.
class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  bool _isProcessing = false;

  Future<void> _onSimulateScanPressed() async {
    setState(() => _isProcessing = true);

    // Mock scan-processing delay — no real camera/QR decoding involved.
    await Future.delayed(const Duration(milliseconds: 700));

    final community = CommunityMockData.simulateScanResult();

    if (!mounted) return;
    setState(() => _isProcessing = false);

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
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                'Point your camera at your community QR code',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.text.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_scanner_outlined,
                            size: 80,
                            color: AppColors.cream.withValues(alpha: 0.6),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.cream,
                                  width: 2,
                                ),
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
              const SizedBox(height: 8),
              Text(
                'Camera scanning is not yet available in this preview.',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.text.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Simulate Scan',
                isLoading: _isProcessing,
                onPressed: _onSimulateScanPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}