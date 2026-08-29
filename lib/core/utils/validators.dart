import '../constants/app_constants.dart';

/// Reusable form-field validators used across Martigo screens.
class Validators {
  Validators._();

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least '
          '${AppConstants.minPasswordLength} characters';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    final nameRegex = RegExp(r"^[a-zA-Z\s.'-]+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return 'Enter a valid name';
    }
    return null;
  }

  static String? validateMobileNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    final digitsOnly = value.trim().replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length != AppConstants.mobileNumberLength) {
      return 'Enter a valid ${AppConstants.mobileNumberLength}-digit '
          'mobile number';
    }
    return null;
  }

  static String? validateCommunityCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Community code is required';
    }
    if (value.trim().length != AppConstants.communityCodeLength) {
      return 'Community code must be '
          '${AppConstants.communityCodeLength} characters';
    }
    return null;
  }

  static String? validateRequired(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}