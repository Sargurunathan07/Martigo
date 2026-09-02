import 'package:flutter/material.dart';

/// Reusable Martigo text field.
///
/// Supports a label, hint, controller, validator, prefix/suffix icons,
/// password visibility toggling, and keyboard type selection. Visual
/// styling (fill color, borders, radius) comes from the app's
/// [InputDecorationTheme].
class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final bool obscureText;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final int maxLines;
  final bool enabled;

  const AppTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    final bool isPasswordField = widget.obscureText;

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: isPasswordField ? _obscure : false,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      maxLines: isPasswordField ? 1 : widget.maxLines,
      enabled: widget.enabled,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: _buildSuffixIcon(isPasswordField),
      ),
    );
  }

  Widget? _buildSuffixIcon(bool isPasswordField) {
    if (isPasswordField) {
      return IconButton(
        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
        onPressed: () => setState(() => _obscure = !_obscure),
      );
    }
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(widget.suffixIcon),
        onPressed: widget.onSuffixIconTap,
      );
    }
    return null;
  }
}
