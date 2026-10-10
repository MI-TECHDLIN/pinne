import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../core/server_client.dart';
import '../../router.dart';
import '../../theme/pinne_theme.dart';
import '../../theme/pinne_tokens.dart';

/// Guest-first sign-in, with email and optional Google for durable accounts.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  bool _guestLoading = false;

  Future<void> _signInAsGuest() async {
    setState(() => _guestLoading = true);
    try {
      await ref.read(guestSignInActionProvider)();
      if (mounted) _closeAfterAuthentication();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Guest sign-in failed: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _guestLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailDelivery = ref.watch(emailDeliveryAvailableProvider);
    final emailAvailable = emailDelivery.asData?.value ?? false;
    final client = ref.watch(clientProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(PinneSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Start saving in one tap',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: PinneSpacing.sm),
                  const Text(
                    'You can try every core feature without setting up an '
                    'account.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: PinneColors.muted),
                  ),
                  const SizedBox(height: PinneSpacing.xl),
                  FilledButton(
                    key: const ValueKey('guest-sign-in-button'),
                    style: pinnePrimaryActionStyle(),
                    onPressed: _guestLoading ? null : _signInAsGuest,
                    child: Text(
                      _guestLoading ? 'Starting…' : 'Try without an account',
                    ),
                  ),
                  if (!emailAvailable) ...[
                    const SizedBox(height: PinneSpacing.md),
                    const Text(
                      'New-account email codes are not available on this '
                      'server. Use guest access now, or sign in with the demo '
                      'account from the testing instructions.',
                      key: ValueKey('email-delivery-unavailable'),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: PinneColors.muted),
                    ),
                  ],
                  const SizedBox(height: PinneSpacing.xl),
                  SignInLocalizationProvider(
                    email: EmailSignInTexts.defaults.copyWith(
                      dontHaveAnAccount: 'New to Pinne?',
                      alreadyHaveAnAccount: 'Have an account?',
                    ),
                    child: SignInWidget(
                      client: client,
                      disableAnonymousSignInWidget: true,
                      disableGoogleSignInWidget: !googleSignInConfigured,
                      emailSignInWidget: EmailSignInWidget(
                        client: client,
                        startScreen: EmailFlowScreen.login,
                        onAuthenticated: _closeAfterAuthentication,
                        onError: _showSignInError,
                      ),
                      onAuthenticated: _closeAfterAuthentication,
                      onError: _showSignInError,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _closeAfterAuthentication() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.today);
    }
  }

  void _showSignInError(Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sign-in failed: $error')),
    );
  }
}
