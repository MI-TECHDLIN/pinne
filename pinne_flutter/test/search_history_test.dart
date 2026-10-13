import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinne_flutter/features/search/search_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('recent searches dedupe, cap, remove, and persist', () async {
    final store = MemorySearchHistoryStore();
    final container = ProviderContainer(
      overrides: [searchHistoryStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);
    final history = container.read(searchHistoryProvider.notifier);

    history.add('  Flutter tips  ');
    history.add('flutter TIPS');
    history.add('   ');
    for (var index = 0; index < 25; index++) {
      history.add('search $index');
    }
    await Future<void>.delayed(Duration.zero);

    expect(container.read(searchHistoryProvider), hasLength(20));
    expect(container.read(searchHistoryProvider).first, 'search 24');
    expect(
      container
          .read(searchHistoryProvider)
          .where((value) => value.toLowerCase() == 'flutter tips'),
      isEmpty,
    );

    history.add('SEARCH 10');
    await Future<void>.delayed(Duration.zero);
    expect(container.read(searchHistoryProvider).first, 'SEARCH 10');
    expect(
      container
          .read(searchHistoryProvider)
          .where((value) => value.toLowerCase() == 'search 10'),
      hasLength(1),
    );

    history.remove('search 10');
    await Future<void>.delayed(Duration.zero);
    expect(store.searches, isNot(contains('SEARCH 10')));

    await history.clear();
    expect(store.searches, isEmpty);
  });

  test('loads sanitized history from the device store', () {
    final container = ProviderContainer(
      overrides: [
        searchHistoryStoreProvider.overrideWithValue(
          MemorySearchHistoryStore([' First ', '', 'FIRST', 'Second']),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(searchHistoryProvider), ['First', 'Second']);
  });

  test('shared preferences store survives a new store instance', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    await SharedPreferencesSearchHistoryStore(
      preferences,
    ).write(['first', 'second']);

    final reopened = SharedPreferencesSearchHistoryStore(
      await SharedPreferences.getInstance(),
    );
    expect(reopened.read(), ['first', 'second']);

    await reopened.clear();
    expect(reopened.read(), isEmpty);
  });
}
