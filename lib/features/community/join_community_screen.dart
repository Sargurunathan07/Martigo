import 'package:flutter/material.dart';

class JoinCommunityScreen extends StatelessWidget {
  const JoinCommunityScreen({super.key});

  static const String routeName = '/join-community';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Community'), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.groups_rounded,
                    size: 72,
                    color: Color(0xFF800020),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Join your community',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF292323),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Connect with your apartment or college community '
                    'to access its supermarket or canteen.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: Colors.black54, height: 1.5),
                  ),
                  const SizedBox(height: 40),
                  _CommunityOptionCard(
                    icon: Icons.qr_code_scanner_rounded,
                    title: 'Scan QR Code',
                    subtitle: 'Scan your community QR code',
                    onTap: () {
                      Navigator.pushNamed(context, '/scan-community-qr');
                    },
                  ),
                  const SizedBox(height: 18),
                  _CommunityOptionCard(
                    icon: Icons.pin_rounded,
                    title: 'Enter Community Code',
                    subtitle: 'Enter the code provided by your community',
                    onTap: () {
                      Navigator.pushNamed(context, '/enter-community-code');
                    },
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5E1E5),
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
                            'Your community connects you with the correct '
                            'supermarket or canteen in Martigo.',
                            style: TextStyle(
                              color: Color(0xFF292323),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
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

class _CommunityOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CommunityOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFF7F0),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF5E1E5)),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5E1E5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: const Color(0xFF800020), size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF292323),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Color(0xFF800020),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
