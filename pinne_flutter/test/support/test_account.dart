import 'package:pinne_flutter/core/server_client.dart';

class TestAccountId extends AccountIdNotifier {
  TestAccountId({this.id = 'test-account'});

  final String? id;

  @override
  String? build() => id;
}
