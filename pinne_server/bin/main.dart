import 'package:pinne_server/server.dart';

/// This is the starting point for your Serverpod server. Typically, there is
/// no need to modify this file.
Future<void> main(List<String> args) async {
  final seedDemo = args.contains('--seed-demo');
  final serverpodArgs = args.where((arg) => arg != '--seed-demo').toList();
  await run(serverpodArgs, seedDemo: seedDemo);
}
