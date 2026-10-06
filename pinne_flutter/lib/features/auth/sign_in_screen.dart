import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../core/server_client.dart';

/// Serverpod's built-in sign-in: email always, Google when configured.
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Center(
        child: SignInWidget(
          client: ref.watch(clientProvider),
          disableGoogleSignInWidget: !googleSignInConfigured,
          onAuthenticated: () {
            if (context.canPop()) context.pop();
          },
          onError: (error) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-in failed: $error')),
          ),
        ),
      ),
    );
  }
}
