import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/community.dart';

class CommunityRegistry {
  CommunityRegistry._();

  static final CommunityRegistry instance = CommunityRegistry._();

  static const _storageKey = 'martigo_seller_communities';

  final List<Community> _communities = [];

  bool _loaded = false;

  List<Community> get communities => List.unmodifiable(_communities);

  Future<void> load() async {
    if (_loaded) return;

    final prefs = await SharedPreferences.getInstance();

    final stored = prefs.getString(_storageKey);

    if (stored != null && stored.isNotEmpty) {
      try {
        final decoded = jsonDecode(stored) as List<dynamic>;

        _communities
          ..clear()
          ..addAll(
            decoded.map(
              (item) =>
                  Community.fromJson(Map<String, dynamic>.from(item as Map)),
            ),
          );
      } catch (_) {
        await prefs.remove(_storageKey);
      }
    }

    _loaded = true;
  }

  Future<Community> createCommunity({
    required String communityName,
    required String businessName,
    required CommunityType type,
  }) async {
    await load();

    final community = Community(
      id: 'COM${DateTime.now().millisecondsSinceEpoch}',
      name: communityName.trim(),
      code: _generateCode(communityName),
      type: type,
      businessName: businessName.trim(),
      businessType: type == CommunityType.apartment
          ? BusinessType.supermarket
          : BusinessType.canteen,
    );

    _communities.add(community);

    await _save();

    return community;
  }

  Community? findByCode(String code) {
    final normalized = code.trim().toUpperCase();

    for (final community in _communities) {
      if (community.code.toUpperCase() == normalized) {
        return community;
      }
    }

    return null;
  }

  String _generateCode(String name) {
    final cleaned = name.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

    final prefix = cleaned.isEmpty
        ? 'MARTIGO'
        : cleaned.substring(0, cleaned.length > 6 ? 6 : cleaned.length);

    final random = Random();

    while (true) {
      final number = 1000 + random.nextInt(9000);

      final code = '$prefix-$number';

      final alreadyExists = _communities.any(
        (community) => community.code.toUpperCase() == code.toUpperCase(),
      );

      if (!alreadyExists) {
        return code;
      }
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _storageKey,
      jsonEncode(_communities.map((community) => community.toJson()).toList()),
    );
  }
}
