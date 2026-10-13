import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class SearchHistoryStore {
  List<String> read();

  Future<void> write(List<String> searches);

  Future<void> clear();
}

class SharedPreferencesSearchHistoryStore implements SearchHistoryStore {
  SharedPreferencesSearchHistoryStore(this._preferences);

  static const key = 'search.recent.v1';
  final SharedPreferences _preferences;

  @override
  List<String> read() => _preferences.getStringList(key) ?? const [];

  @override
  Future<void> write(List<String> searches) =>
      _preferences.setStringList(key, searches);

  @override
  Future<void> clear() => _preferences.remove(key);
}

class MemorySearchHistoryStore implements SearchHistoryStore {
  MemorySearchHistoryStore([Iterable<String> initial = const []])
    : searches = List.of(initial);

  List<String> searches;

  @override
  List<String> read() => List.of(searches);

  @override
  Future<void> write(List<String> searches) async {
    this.searches = List.of(searches);
  }

  @override
  Future<void> clear() async => searches = [];
}

final searchHistoryStoreProvider = Provider<SearchHistoryStore>(
  (ref) => MemorySearchHistoryStore(),
);

final searchHistoryProvider = NotifierProvider<SearchHistory, List<String>>(
  SearchHistory.new,
);

class SearchHistory extends Notifier<List<String>> {
  static const limit = 20;

  @override
  List<String> build() {
    final unique = <String>[];
    final seen = <String>{};
    for (final value in ref.watch(searchHistoryStoreProvider).read()) {
      final search = value.trim();
      if (search.isEmpty || !seen.add(search.toLowerCase())) continue;
      unique.add(search);
      if (unique.length == limit) break;
    }
    return List.unmodifiable(unique);
  }

  void add(String value) {
    final search = value.trim();
    if (search.isEmpty) return;
    final normalized = search.toLowerCase();
    state = List.unmodifiable(
      [
        search,
        for (final saved in state)
          if (saved.toLowerCase() != normalized) saved,
      ].take(limit),
    );
    unawaited(ref.read(searchHistoryStoreProvider).write(state));
  }

  void remove(String value) {
    final normalized = value.trim().toLowerCase();
    state = List.unmodifiable(
      state.where((saved) => saved.toLowerCase() != normalized),
    );
    unawaited(ref.read(searchHistoryStoreProvider).write(state));
  }

  Future<void> clear() async {
    state = const [];
    await ref.read(searchHistoryStoreProvider).clear();
  }
}
