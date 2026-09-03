import '../../models/community.dart';

class CommunityMockData {
  CommunityMockData._();

  static const Community sunriseSupermarket = Community(
    id: 'com001',
    name: 'Sunrise Apartments',
    code: 'SUNRISE-A72',
    type: CommunityType.apartment,
    businessName: 'Sunrise Supermarket',
    businessType: BusinessType.supermarket,
  );

  static const Community abcCollege = Community(
    id: 'com002',
    name: 'ABC Engineering College',
    code: 'ABC-COLLEGE',
    type: CommunityType.college,
    businessName: 'ABC College Canteen',
    businessType: BusinessType.canteen,
  );

  static const List<Community> communities = [sunriseSupermarket, abcCollege];

  static Community? findSupermarket({
    required String name,
    required String code,
  }) {
    final normalizedName = name.trim().toLowerCase();
    final normalizedCode = code.trim().toUpperCase();

    for (final community in communities) {
      if (community.businessType != BusinessType.supermarket) {
        continue;
      }

      final businessMatches =
          community.businessName?.toLowerCase() == normalizedName;

      final communityMatches = community.name.toLowerCase() == normalizedName;

      final codeMatches = community.code.toUpperCase() == normalizedCode;

      if ((businessMatches || communityMatches) && codeMatches) {
        return community;
      }
    }

    return null;
  }

  static Community? findCollege({required String name, required String code}) {
    final normalizedName = name.trim().toLowerCase();
    final normalizedCode = code.trim().toUpperCase();

    for (final community in communities) {
      if (community.type != CommunityType.college) {
        continue;
      }

      final collegeMatches = community.name.toLowerCase() == normalizedName;

      final businessMatches =
          community.businessName?.toLowerCase() == normalizedName;

      final codeMatches = community.code.toUpperCase() == normalizedCode;

      if ((collegeMatches || businessMatches) && codeMatches) {
        return community;
      }
    }

    return null;
  }

  static Community? findByCode(String code) {
    final normalizedCode = code.trim().toUpperCase();

    for (final community in communities) {
      if (community.code.toUpperCase() == normalizedCode) {
        return community;
      }
    }

    return null;
  }

  static Community simulateScanResult() {
    return sunriseSupermarket;
  }
}
