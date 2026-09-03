import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/community.dart';

class CustomerSession {
  CustomerSession._();

  static final CustomerSession instance = CustomerSession._();

  static const String _communityKey = 'martigo_customer_community';

  Community? _selectedCommunity;

  Community? get selectedCommunity => _selectedCommunity;

  bool get hasCommunity => _selectedCommunity != null;

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final storedCommunity = preferences.getString(_communityKey);

    if (storedCommunity == null || storedCommunity.isEmpty) {
      _selectedCommunity = null;
      return;
    }

    try {
      final json = jsonDecode(storedCommunity) as Map<String, dynamic>;
      _selectedCommunity = Community.fromJson(json);
    } catch (_) {
      _selectedCommunity = null;
      await preferences.remove(_communityKey);
    }
  }

  Future<void> selectCommunity(Community community) async {
    _selectedCommunity = community;

    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_communityKey, jsonEncode(community.toJson()));
  }

  Future<void> clearCommunity() async {
    _selectedCommunity = null;

    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_communityKey);
  }
}
