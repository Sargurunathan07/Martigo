import 'package:flutter/material.dart';

import '../seller_portal.dart';

/// Compatibility shell used by the existing Martigo routing system.
///
/// The actual seller dashboard implementation is SellerDashboardShell
/// inside seller_portal.dart.
class SellerHomeShell extends StatelessWidget {
  const SellerHomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const SellerDashboardShell();
  }
}
