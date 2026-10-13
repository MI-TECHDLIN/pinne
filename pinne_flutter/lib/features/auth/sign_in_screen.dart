import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../core/server_client.dart';
import '../../router.dart';
import '../../theme/pinne_theme.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/feedback/friendly_error.dart';
import '../../ui/feedback/toast.dart';
import '../../ui/pinne_loading.dart';

/// Guest-first sign-in, with email and optional Google for durable accounts.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key, this.createAccount = false});

  final bool createAccount;

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  bool _guestLoading = false;
  late final EmailAuthController _loginOnlyController;

  @override
  void initState() {
    super.initState();
    _loginOnlyController = EmailAuthController(
      client: ref.read(clientProvider),
      startScreen: EmailFlowScreen.login,
      onAuthenticated: _closeAfterAuthentication,
      onError: _showSignInError,
    );
  }

  @override
  void dispose() {
    _loginOnlyController.dispose();
    super.dispose();
  }

  Future<void> _signInAsGuest() async {
    setState(() => _guestLoading = true);
    try {
      await ref.read(guestSignInActionProvider)();
      if (mounted) _closeAfterAuthentication();
    } catch (error) {
      if (mounted) _showSignInError(error);
    } finally {
      if (mounted) setState(() => _guestLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailDelivery = ref.watch(emailDeliveryAvailableProvider);
    final emailAvailable = emailDelivery.asData?.value ?? false;
    final client = ref.watch(clientProvider);
    final alreadySignedIn = ref.watch(signedInProvider);
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
                    alreadySignedIn
                        ? 'Choose an account'
                        : 'Start saving in one tap',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: PinneSpacing.sm),
                  Text(
                    alreadySignedIn
                        ? 'Signing in or creating an account switches away '
                              'from your guest account. Guest saves do not '
                              'transfer.'
                        : 'You can try every core feature without setting up '
                              'an account.',
                    key: alreadySignedIn
                        ? const ValueKey('guest-account-switch-notice')
                        : null,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: PinneColors.muted),
                  ),
                  const SizedBox(height: PinneSpacing.xl),
                  if (!alreadySignedIn)
                    FilledButton(
                      key: const ValueKey('guest-sign-in-button'),
                      style: pinnePrimaryActionStyle(),
                      onPressed: _guestLoading ? null : _signInAsGuest,
                      child: _guestLoading
                          ? const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                PinneBrandedLoader(
                                  size: 20,
                                  label: 'Starting guest session',
                                ),
                                SizedBox(width: PinneSpacing.sm),
                                Text('Starting…'),
                              ],
                            )
                          : const Text('Try without an account'),
                    ),
                  if (!emailAvailable) ...[
                    const SizedBox(height: PinneSpacing.md),
                    const Text(
                      'Email sign-up opens soon - try Pinne as a guest.',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (emailAvailable)
                          EmailSignInWidget(
                            client: client,
                            startScreen: widget.createAccount
                                ? EmailFlowScreen.startRegistration
                                : EmailFlowScreen.login,
                            onAuthenticated: _closeAfterAuthentication,
                            onError: _showSignInError,
                          )
                        else
                          _EmailLoginOnly(controller: _loginOnlyController),
                        if (googleSignInConfigured) ...[
                          const SizedBox(height: PinneSpacing.lg),
                          SignInWidget(
                            client: client,
                            disableAnonymousSignInWidget: true,
                            disableEmailSignInWidget: true,
                            onAuthenticated: _closeAfterAuthentication,
                            onError: _showSignInError,
                          ),
                        ],
                      ],
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
    if (!mounted) return;
    final friendly = FriendlyError.from(error);
    showPinneToast(
      context,
      '${friendly.title}. ${friendly.hint}',
      kind: ToastKind.error,
    );
  }
}

class _EmailLoginOnly extends StatelessWidget {
  const _EmailLoginOnly({required this.controller});

  final EmailAuthController controller;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, child) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: const ValueKey('email-login-only-email'),
          controller: controller.emailController,
          enabled: !controller.isLoading,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: PinneSpacing.sm),
        TextField(
          key: const ValueKey('email-login-only-password'),
          controller: controller.passwordController,
          enabled: !controller.isLoading,
          obscureText: true,
          autofillHints: const [AutofillHints.password],
          onSubmitted: (_) => _canSubmit ? controller.login() : null,
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        const SizedBox(height: PinneSpacing.md),
        FilledButton(
          key: const ValueKey('email-login-only-submit'),
          onPressed: _canSubmit ? controller.login : null,
          child: controller.isLoading
              ? const PinneBrandedLoader(size: 20, label: 'Signing in')
              : const Text('Sign in'),
        ),
      ],
    ),
  );

  bool get _canSubmit =>
      !controller.isLoading &&
      controller.emailController.text.isNotEmpty &&
      controller.passwordController.text.isNotEmpty;
}
