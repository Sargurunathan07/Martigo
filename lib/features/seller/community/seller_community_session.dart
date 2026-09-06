import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/community.dart';
import '../../community/community_registry.dart';

class SellerCommunitySession {
  SellerCommunitySession._();

  static final SellerCommunitySession instance = SellerCommunitySession._();

  static const String _activeCommunityCodeKey =
      'martigo_seller_active_community_code';

  final ValueNotifier<Community?> activeCommunity = ValueNotifier<Community?>(
    null,
  );

  bool _loaded = false;

  Community? get current => activeCommunity.value;

  bool get isCanteen => current?.businessType == BusinessType.canteen;

  Future<void> load() async {
    await CommunityRegistry.instance.load();

    if (_loaded) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    final savedCode = prefs.getString(_activeCommunityCodeKey);

    Community? selected;

    if (savedCode != null && savedCode.isNotEmpty) {
      selected = CommunityRegistry.instance.findByCode(savedCode);
    }

    if (selected == null && CommunityRegistry.instance.communities.isNotEmpty) {
      selected = CommunityRegistry.instance.communities.first;
    }

    activeCommunity.value = selected;

    _loaded = true;
  }

  Future<void> setActiveCommunity(Community community) async {
    activeCommunity.value = community;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_activeCommunityCodeKey, community.code);

    _loaded = true;
  }
}
