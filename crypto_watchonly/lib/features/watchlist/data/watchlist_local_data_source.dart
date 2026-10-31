import 'package:shared_preferences/shared_preferences.dart';

class WatchlistLocalDataSource {
  static const _key = 'watchlist_coin_ids';

  Future<Set<String>> getIds() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getStringList(_key)?.toSet() ?? <String>{};
  }

  Future<void> toggle(String coinId) async {
    final preferences = await SharedPreferences.getInstance();
    final ids = preferences.getStringList(_key)?.toSet() ?? <String>{};
    if (!ids.add(coinId)) ids.remove(coinId);
    await preferences.setStringList(_key, ids.toList());
  }
}
