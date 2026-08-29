import 'package:flutter/material.dart';

/// Visual style of an [AppButton].
enum AppButtonType { primary, secondary }

/// Reusable Martigo button.
///
/// Supports a primary (filled) style and a secondary (outlined) style,
/// loading and disabled states, custom child content, and a
/// touch-friendly minimum height. Colors and shapes come from the
/// app's [ThemeData] (elevatedButtonTheme / outlinedButtonTheme) rather
/// than being hardcoded here.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double minHeight;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.minHeight = 52,
  });

  bool get _isDisabled => onPressed == null || isLoading;

  @override
  Widget build(BuildContext context) {
    final child = _buildChild(context);

    if (type == AppButtonType.secondary) {
      return SizedBox(
        width: double.infinity,
        height: minHeight,
        child: OutlinedButton(
          onPressed: _isDisabled ? null : onPressed,
          child: child,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: minHeight,
      child: ElevatedButton(
        onPressed: _isDisabled ? null : onPressed,
        child: child,
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      final indicatorColor = type == AppButtonType.primary
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.primary;
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    }

    return Text(label);
  }
}