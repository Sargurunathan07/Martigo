import 'package:flutter/material.dart';

/// Reusable rounded card with consistent styling, used throughout Martigo.
///
/// Rounded corners and elevation come from the app's [CardThemeData];
/// this widget only adds padding and optional tap behavior on top.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardTheme = Theme.of(context).cardTheme;
    final shape = cardTheme.shape is RoundedRectangleBorder
        ? cardTheme.shape as RoundedRectangleBorder
        : RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));

    final content = Padding(padding: padding, child: child);

    return Card(
      margin: EdgeInsets.zero,
      child: onTap == null
          ? content
          : InkWell(
              onTap: onTap,
              borderRadius: shape.borderRadius.resolve(Directionality.of(context)),
              child: content,
            ),
    );
  }
}