import '../../models/community.dart';

/// Mock community directory used for the join-community flow.
/// Simulates a lookup that would normally come from a backend.
class CommunityMockData {
  CommunityMockData._();

  static const List<Community> communities = [
    Community(
      id: 'com001',
      name: 'Sunrise Apartments',
      code: 'SUNRISE-A72',
      type: CommunityType.apartment,
      businessName: 'Sunrise Supermarket',
      businessType: BusinessType.supermarket,
    ),
    Community(
      id: 'com002',
      name: 'ABC Engineering College',
      code: 'ABCENGG-C14',
      type: CommunityType.college,
      businessName: 'ABC Campus Canteen',
      businessType: BusinessType.canteen,
    ),
  ];

  /// Mock lookup by community code. Returns null if no match is found.
  static Community? findByCode(String code) {
    final normalized = code.trim().toUpperCase();
    for (final community in communities) {
      if (community.code.toUpperCase() == normalized) {
        return community;
      }
    }
    return null;
  }

  /// Mock "scan result" — simulates a QR code resolving to a community,
  /// since real camera scanning is not implemented yet.
  static Community simulateScanResult() {
    return communities.first;
  }
}