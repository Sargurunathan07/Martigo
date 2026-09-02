/// Role a user holds within the Martigo platform.
enum UserRole { customer, seller, admin }

/// A registered Martigo user.
class User {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final UserRole role;

  /// ID of the [Community] this user belongs to.
  /// Null for users who have not joined/created a community yet.
  final String? communityId;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.role,
    this.communityId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      mobile: json['mobile'] as String,
      role: UserRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => UserRole.customer,
      ),
      communityId: json['communityId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'role': role.name,
      'communityId': communityId,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? mobile,
    UserRole? role,
    String? communityId,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      role: role ?? this.role,
      communityId: communityId ?? this.communityId,
    );
  }
}
