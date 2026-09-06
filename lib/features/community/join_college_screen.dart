import 'package:flutter/material.dart';

import '../../models/community.dart';
import 'join_by_code_screen.dart';

class JoinCollegeScreen extends StatelessWidget {
  const JoinCollegeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const JoinByCodeScreen(requiredType: CommunityType.college);
  }
}
