import 'package:flutter/material.dart';

import '../../models/community.dart';
import 'join_by_code_screen.dart';

class JoinSupermarketScreen extends StatelessWidget {
  const JoinSupermarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const JoinByCodeScreen(requiredType: CommunityType.apartment);
  }
}
