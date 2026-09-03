import 'package:flutter/material.dart';

import '../customer/customer_session.dart';

class JoinCommunityScreen extends StatefulWidget {
  const JoinCommunityScreen({super.key});

  static const String routeName = '/join-community';

  @override
  State<JoinCommunityScreen> createState() => _JoinCommunityScreenState();
}

class _JoinCommunityScreenState extends State<JoinCommunityScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    await CustomerSession.instance.load();

    if (!mounted) return;

    if (CustomerSession.instance.hasCommunity) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        Navigator.of(context)
            .pushNamedAndRemoveUntil('/customer-home', (route) => false);
      });

      return;
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF800020)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFC),
      appBar: AppBar(
        title: const Text('Join Your Community'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),

                  const Text(
                    'Choose where you want to order from',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, color: Colors.black54),
                  ),

                  const SizedBox(height: 36),

                  _CommunityChoiceCard(
                    icon: Icons.storefront_rounded,
                    title: 'Supermarket',
                    description: 'Pre-order groceries and everyday essentials',
                    buttonText: 'Join Supermarket',
                    onTap: () {
                      Navigator.pushNamed(context, '/join-supermarket');
                    },
                  ),

                  const SizedBox(height: 22),

                  _CommunityChoiceCard(
                    icon: Icons.school_rounded,
                    title: 'College',
                    description: 'Pre-order meals from your college canteen',
                    buttonText: 'Join College',
                    onTap: () {
                      Navigator.pushNamed(context, '/join-college');
                    },
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

class _CommunityChoiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;

  const _CommunityChoiceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFF5E1E5)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 18,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5E1E5),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Icon(icon, size: 38, color: const Color(0xFF800020)),
              ),

              const SizedBox(height: 20),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF292323),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, height: 1.4),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: onTap,
                  icon: Icon(icon),
                  label: Text(buttonText),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF800020),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
