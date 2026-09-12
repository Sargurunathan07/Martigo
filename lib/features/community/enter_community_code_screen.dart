import 'package:flutter/material.dart';

class EnterCommunityCodeScreen extends StatefulWidget {
  const EnterCommunityCodeScreen({super.key});

  @override
  State<EnterCommunityCodeScreen> createState() =>
      _EnterCommunityCodeScreenState();
}

class _EnterCommunityCodeScreenState extends State<EnterCommunityCodeScreen> {
  final TextEditingController _controller = TextEditingController();

  String? _errorMessage;

  void _findCommunity() {
    final code = _controller.text.trim().toUpperCase();

    if (code.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your community code.';
      });
      return;
    }

    if (code == 'SUNRISE-A72') {
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
      return;
    }

    if (code == 'ABC-COLLEGE') {
      Navigator.pushNamed(
        context,
        '/community-confirmation',
        arguments: {
          'name': 'ABC Engineering College',
          'type': 'College',
          'business': 'ABC College Canteen',
          'code': 'ABC-COLLEGE',
        },
      );
      return;
    }

    setState(() {
      _errorMessage = 'Community not found. Check the code and try again.';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Code')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.pin_rounded,
                    size: 64,
                    color: Color(0xFF7A1736),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Enter community code',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF292323),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Enter the code provided by your apartment or college.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'Community Code',
                      hintText: 'SUNRISE-A72',
                      prefixIcon: const Icon(Icons.tag_rounded),
                      errorText: _errorMessage,
                      filled: true,
                      fillColor: const Color(0xFFF5DCE4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onChanged: (_) {
                      if (_errorMessage != null) {
                        setState(() {
                          _errorMessage = null;
                        });
                      }
                    },
                    onSubmitted: (_) => _findCommunity(),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Demo: SUNRISE-A72 or ABC-COLLEGE',
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _findCommunity,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A1736),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Find Community',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
