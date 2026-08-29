/// Type of community Martigo serves.
enum CommunityType { apartment, college }

/// Type of business operating within a community (e.g. the seller side).
enum BusinessType { supermarket, canteen }

/// A community (apartment/college) that customers join and sellers serve.
class Community {
  final String id;
  final String name;

  /// Short shareable code used by customers to join this community.
  final String code;
  final CommunityType type;

  /// Name of the business (supermarket/canteen) operating in this
  /// community, if any.
  final String? businessName;
  final BusinessType? businessType;

  const Community({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    this.businessName,
    this.businessType,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      type: CommunityType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => CommunityType.apartment,
      ),
      businessName: json['businessName'] as String?,
      businessType: json['businessType'] != null
          ? BusinessType.values.firstWhere(
              (b) => b.name == json['businessType'],
              orElse: () => BusinessType.supermarket,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'type': type.name,
      'businessName': businessName,
      'businessType': businessType?.name,
    };
  }

  Community copyWith({
    String? id,
    String? name,
    String? code,
    CommunityType? type,
    String? businessName,
    BusinessType? businessType,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      type: type ?? this.type,
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
    );
  }
}