/// Reusable, non-sensitive global constants for the Martigo application.
class AppConstants {
  AppConstants._();

  static const String appName = 'Martigo';
  static const String appTagline = 'Smart Demand. Better Supply.';

  /// Example community names used for onboarding / join-community flows
  /// before real community data is available.
  static const List<String> defaultCommunityExamples = [
    'Green Valley Apartments',
    'Sunrise Residency',
    'Lakeview Society',
    'Maple Heights',
    'Silver Oak Community',
  ];

  static const int defaultPageSize = 20;
  static const int communityCodeLength = 6;
  static const int minPasswordLength = 6;
  static const int mobileNumberLength = 10;

  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration networkTimeout = Duration(seconds: 15);
}