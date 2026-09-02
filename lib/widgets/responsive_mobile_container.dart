import 'package:flutter/material.dart';

/// Wraps mobile-first content so it doesn't stretch full-width on large
/// desktop windows (e.g. `flutter run -d linux`), while still using the
/// full available width on actual phone-sized screens.
class ResponsiveMobileContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveMobileContainer({
    super.key,
    required this.child,
    this.maxWidth = 560,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
