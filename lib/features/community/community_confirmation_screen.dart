import 'package:flutter/material.dart';

class CommunityConfirmationScreen extends StatelessWidget {
  final String name;
  final String type;
  final String business;
  final String code;

  const CommunityConfirmationScreen({
    super.key,
    required this.name,
    required this.type,
    required this.business,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    final isCollege = type.toLowerCase() == 'college';

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Community')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    isCollege ? Icons.school_rounded : Icons.apartment_rounded,
                    size: 80,
                    color: const Color(0xFF800020),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Is this your community?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  _InfoTile(
                    label: 'Community',
                    value: name,
                    icon: Icons.groups_rounded,
                  ),
                  _InfoTile(
                    label: 'Type',
                    value: type,
                    icon: Icons.category_outlined,
                  ),
                  _InfoTile(
                    label: 'Connected business',
                    value: business,
                    icon: isCollege
                        ? Icons.restaurant_rounded
                        : Icons.storefront_rounded,
                  ),
                  _InfoTile(
                    label: 'Community code',
                    value: code,
                    icon: Icons.tag_rounded,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/customer-home',
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF800020),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Join Community',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Not your community? Go back',
                      style: TextStyle(color: Color(0xFF800020)),
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

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF5E1E5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF800020)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
