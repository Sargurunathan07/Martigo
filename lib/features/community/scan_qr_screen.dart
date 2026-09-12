import 'package:flutter/material.dart';

class ScanQrScreen extends StatelessWidget {
  const ScanQrScreen({super.key});

  void _useDemoQr(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/community-confirmation',
      arguments: {
        'name': 'Sunrise Apartments',
        'type': 'Apartment',
        'business': 'Sunrise Supermarket',
        'code': 'SUNRISE-A72',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Scan your community QR',
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Position your community QR code inside the frame.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5DCE4),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: const Color(0xFF7A1736),
                        width: 3,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 120,
                        color: Color(0xFF7A1736),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'QR camera support will be added later.',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () => _useDemoQr(context),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Use Demo QR'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A1736),
                        foregroundColor: Colors.white,
                      ),
                    ),
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
