import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../theme/pinne_tokens.dart';
import '../../ui/pinne_loading.dart';

/// Pinne's email sign-in, sign-up and password-reset forms.
///
/// The flow and server calls stay in the package's [EmailAuthController];
/// only the screens are Pinne's, so every busy state shows the branded loader
/// instead of the package's circular spinner. With [allowSignUp] false only
/// the sign-in form is offered (email delivery is down, so no codes can be
/// sent).
class PinneEmailAuthFlow extends StatelessWidget {
  const PinneEmailAuthFlow({
    super.key,
    required this.controller,
    this.allowSignUp = true,
  });

  final EmailAuthController controller;
  final bool allowSignUp;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final texts = context.emailSignInTexts;
      return switch (allowSignUp
          ? controller.currentScreen
          : EmailFlowScreen.login) {
        EmailFlowScreen.login => _LoginForm(
          controller: controller,
          allowSignUp: allowSignUp,
        ),
        EmailFlowScreen.startRegistration => _StartRegistrationForm(
          controller: controller,
        ),
        EmailFlowScreen.verifyRegistration => _VerificationForm(
          key: const ValueKey('verify-registration'),
          controller: controller,
          title: texts.verifyAccountTitle,
          onCompleted: controller.verifyRegistrationCode,
        ),
        EmailFlowScreen.completeRegistration => _SetPasswordForm(
          controller: controller,
          title: texts.setAccountPasswordTitle,
          label: texts.passwordLabel,
          actionLabel: texts.signUp,
          busyLabel: 'Creating your account',
          onAction: controller.finishRegistration,
          back: _LinkButton(
            label: texts.backToSignUp,
            onPressed: () =>
                controller.navigateTo(EmailFlowScreen.startRegistration),
          ),
        ),
        EmailFlowScreen.requestPasswordReset => _RequestPasswordResetForm(
          controller: controller,
        ),
        EmailFlowScreen.verifyPasswordReset => _VerificationForm(
          key: const ValueKey('verify-password-reset'),
          controller: controller,
          title: texts.verifyResetCodeTitle,
          onCompleted: controller.verifyPasswordResetCode,
        ),
        EmailFlowScreen.completePasswordReset => _SetPasswordForm(
          controller: controller,
          title: texts.setNewPasswordTitle,
          label: texts.newPasswordLabel,
          actionLabel: texts.resetPassword,
          busyLabel: 'Saving your new password',
          onAction: controller.finishPasswordReset,
          back: _BackToSignIn(controller: controller),
        ),
      };
    },
  );
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({required this.controller, required this.allowSignUp});

  final EmailAuthController controller;
  final bool allowSignUp;

  bool get _canSubmit =>
      controller.state == EmailAuthState.idle &&
      controller.emailController.text.isNotEmpty &&
      controller.passwordController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final texts = context.emailSignInTexts;
    return _FormLayout(
      title: texts.title,
      children: [
        _EmailField(controller: controller),
        const SizedBox(height: PinneSpacing.sm),
        _PasswordField(
          fieldKey: const ValueKey('email-login-password'),
          controller: controller,
          label: texts.passwordLabel,
          autofill: AutofillHints.password,
          onSubmitted: _canSubmit ? controller.login : null,
        ),
        if (allowSignUp)
          Align(
            alignment: Alignment.centerRight,
            child: _LinkButton(
              label: texts.forgotPassword,
              onPressed: () =>
                  controller.navigateTo(EmailFlowScreen.requestPasswordReset),
            ),
          ),
        const SizedBox(height: PinneSpacing.md),
        _BusyButton(
          buttonKey: const ValueKey('email-login-submit'),
          label: texts.signIn,
          busyLabel: 'Signing in',
          isLoading: controller.isLoading,
          onPressed: _canSubmit ? controller.login : null,
        ),
        if (allowSignUp)
          _SwitchPrompt(
            prompt: texts.dontHaveAnAccount,
            label: texts.signUp,
            onPressed: () =>
                controller.navigateTo(EmailFlowScreen.startRegistration),
          ),
      ],
    );
  }
}

class _StartRegistrationForm extends StatelessWidget {
  const _StartRegistrationForm({required this.controller});

  final EmailAuthController controller;

  @override
  Widget build(BuildContext context) {
    final texts = context.emailSignInTexts;
    return _FormLayout(
      title: texts.signUpTitle,
      children: [
        _EmailField(controller: controller),
        const SizedBox(height: PinneSpacing.md),
        _BusyButton(
          buttonKey: const ValueKey('email-sign-up-submit'),
          label: texts.continueAction,
          busyLabel: 'Sending your code',
          isLoading: controller.isLoading,
          onPressed:
              controller.emailController.text.isNotEmpty &&
                  controller.state == EmailAuthState.idle
              ? () => unawaited(controller.startRegistration())
              : null,
        ),
        _SwitchPrompt(
          prompt: texts.alreadyHaveAnAccount,
          label: texts.signIn,
          onPressed: () => controller.navigateTo(EmailFlowScreen.login),
        ),
      ],
    );
  }
}

class _RequestPasswordResetForm extends StatelessWidget {
  const _RequestPasswordResetForm({required this.controller});

  final EmailAuthController controller;

  @override
  Widget build(BuildContext context) {
    final texts = context.emailSignInTexts;
    return _FormLayout(
      title: texts.resetPasswordTitle,
      children: [
        Text(
          texts.resetPasswordDescription,
          style: TextStyle(color: context.pinne.muted),
        ),
        const SizedBox(height: PinneSpacing.md),
        _EmailField(controller: controller),
        const SizedBox(height: PinneSpacing.md),
        _BusyButton(
          buttonKey: const ValueKey('email-reset-submit'),
          label: texts.requestPasswordReset,
          busyLabel: 'Sending your code',
          isLoading: controller.isLoading,
          onPressed:
              controller.emailController.text.isNotEmpty &&
                  controller.state == EmailAuthState.idle
              ? () => unawaited(controller.startPasswordReset())
              : null,
        ),
        _BackToSignIn(controller: controller),
      ],
    );
  }
}

/// Codes from the server use the digits 1-9, as in the package's form.
class _VerificationForm extends StatefulWidget {
  const _VerificationForm({
    super.key,
    required this.controller,
    required this.title,
    required this.onCompleted,
  });

  final EmailAuthController controller;
  final String title;
  final Future<void> Function() onCompleted;

  static const codeLength = 8;
  static const resendAfter = Duration(minutes: 1);

  @override
  State<_VerificationForm> createState() => _VerificationFormState();
}

class _VerificationFormState extends State<_VerificationForm> {
  final _focus = FocusNode();
  Timer? _timer;
  int _wait = 0;
  bool _resending = false;

  EmailAuthController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    _timer?.cancel();
    _focus.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted && controller.state == EmailAuthState.error) {
      _focus.requestFocus();
    }
  }

  void _startCountdown() {
    _wait = _VerificationForm.resendAfter.inSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      setState(() => _wait--);
      if (_wait <= 0) timer.cancel();
    });
  }

  Future<void> _resend() async {
    setState(() => _resending = true);
    try {
      await controller.resendVerificationCode();
      _startCountdown();
    } catch (_) {
      // The controller reports the failure through onError.
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  void _submit() {
    if (controller.isLoading) return;
    unawaited(widget.onCompleted());
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.emailSignInTexts;
    final busy = controller.isLoading;
    return _FormLayout(
      title: widget.title,
      children: [
        Text(
          texts.verificationMessage,
          style: TextStyle(color: context.pinne.muted),
        ),
        const SizedBox(height: PinneSpacing.md),
        TextField(
          key: const ValueKey('email-verification-code'),
          controller: controller.verificationCodeController,
          focusNode: _focus,
          enabled: !busy,
          autofocus: true,
          keyboardType: TextInputType.number,
          autofillHints: const [AutofillHints.oneTimeCode],
          maxLength: _VerificationForm.codeLength,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[1-9]'))],
          style: const TextStyle(letterSpacing: 6, fontSize: 20),
          decoration: const InputDecoration(labelText: 'Code'),
          onChanged: (code) {
            if (code.length == _VerificationForm.codeLength) _submit();
          },
          onSubmitted: (_) => _submit(),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: _resending
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: PinneSpacing.md),
                  child: PinneBrandedLoader(
                    size: 20,
                    label: 'Sending a new code',
                  ),
                )
              : _LinkButton(
                  key: const ValueKey('email-resend-code'),
                  label: _wait > 0
                      ? 'Send a new code in ${_wait}s'
                      : "Didn't receive it? Send a new code",
                  onPressed: _wait > 0 || busy ? null : _resend,
                ),
        ),
        const SizedBox(height: PinneSpacing.sm),
        _BusyButton(
          buttonKey: const ValueKey('email-verify-submit'),
          label: texts.verify,
          busyLabel: 'Checking your code',
          isLoading: busy,
          onPressed: busy ? null : _submit,
        ),
        _BackToSignIn(controller: controller),
      ],
    );
  }
}

class _SetPasswordForm extends StatelessWidget {
  const _SetPasswordForm({
    required this.controller,
    required this.title,
    required this.label,
    required this.actionLabel,
    required this.busyLabel,
    required this.onAction,
    required this.back,
  });

  final EmailAuthController controller;
  final String title;
  final String label;
  final String actionLabel;
  final String busyLabel;
  final Future<void> Function() onAction;
  final Widget back;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller.passwordController,
    builder: (context, _) {
      final password = controller.passwordController.text;
      final requirements = controller.passwordRequirements;
      final valid = requirements.every((rule) => rule.validate(password));
      return _FormLayout(
        title: title,
        children: [
          _PasswordField(
            fieldKey: const ValueKey('email-new-password'),
            controller: controller,
            label: label,
            autofill: AutofillHints.newPassword,
          ),
          const SizedBox(height: PinneSpacing.sm),
          for (final rule in requirements)
            _Requirement(
              text: rule.description,
              met: rule.validate(password),
            ),
          const SizedBox(height: PinneSpacing.md),
          _BusyButton(
            buttonKey: const ValueKey('email-password-submit'),
            label: actionLabel,
            busyLabel: busyLabel,
            isLoading: controller.isLoading,
            onPressed: valid && !controller.isLoading
                ? () => unawaited(onAction())
                : null,
          ),
          back,
        ],
      );
    },
  );
}

class _Requirement extends StatelessWidget {
  const _Requirement({required this.text, required this.met});

  final String text;
  final bool met;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Icon(
          met ? Icons.check_circle_rounded : Icons.circle_outlined,
          size: 16,
          color: met ? context.pinne.success : context.pinne.muted,
        ),
        const SizedBox(width: PinneSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: met ? context.pinne.text : context.pinne.muted,
            ),
          ),
        ),
      ],
    ),
  );
}

class _FormLayout extends StatelessWidget {
  const _FormLayout({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => AutofillGroup(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: PinneSpacing.lg),
        ...children,
      ],
    ),
  );
}

class _EmailField extends StatelessWidget {
  const _EmailField({required this.controller});

  final EmailAuthController controller;

  @override
  Widget build(BuildContext context) => TextField(
    key: const ValueKey('email-auth-email'),
    controller: controller.emailController,
    enabled: !controller.isLoading,
    keyboardType: TextInputType.emailAddress,
    autofillHints: const [AutofillHints.email],
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'[\s()<>[\]\\,;:]')),
      TextInputFormatter.withFunction(
        (_, value) => value.copyWith(text: value.text.toLowerCase()),
      ),
    ],
    decoration: InputDecoration(
      labelText: context.emailSignInTexts.emailLabel,
      errorText: controller.error is InvalidEmailException
          ? controller.errorMessage
          : null,
    ),
  );
}

class _PasswordField extends StatefulWidget {
  const _PasswordField({
    required this.fieldKey,
    required this.controller,
    required this.label,
    required this.autofill,
    this.onSubmitted,
  });

  final Key fieldKey;
  final EmailAuthController controller;
  final String label;
  final String autofill;
  final VoidCallback? onSubmitted;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) => TextField(
    key: widget.fieldKey,
    controller: widget.controller.passwordController,
    enabled: !widget.controller.isLoading,
    obscureText: _hidden,
    autofillHints: [widget.autofill],
    onSubmitted: widget.onSubmitted == null
        ? null
        : (_) => widget.onSubmitted!(),
    decoration: InputDecoration(
      labelText: widget.label,
      suffixIcon: IconButton(
        tooltip: _hidden ? 'Show password' : 'Hide password',
        color: context.pinne.muted,
        onPressed: () => setState(() => _hidden = !_hidden),
        icon: Icon(
          _hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
      ),
    ),
  );
}

/// A full-width button that swaps its label for the branded loader.
class _BusyButton extends StatelessWidget {
  const _BusyButton({
    required this.buttonKey,
    required this.label,
    required this.busyLabel,
    required this.isLoading,
    required this.onPressed,
  });

  final Key buttonKey;
  final String label;
  final String busyLabel;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => FilledButton(
    key: buttonKey,
    onPressed: isLoading ? null : onPressed,
    child: isLoading
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PinneBrandedLoader(size: 20, label: busyLabel),
              const SizedBox(width: PinneSpacing.sm),
              Flexible(child: Text('$busyLabel…')),
            ],
          )
        : Text(label),
  );
}

class _SwitchPrompt extends StatelessWidget {
  const _SwitchPrompt({
    required this.prompt,
    required this.label,
    required this.onPressed,
  });

  final String prompt;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: PinneSpacing.sm),
    child: Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(prompt, style: TextStyle(color: context.pinne.muted)),
        _LinkButton(label: label, onPressed: onPressed),
      ],
    ),
  );
}

class _BackToSignIn extends StatelessWidget {
  const _BackToSignIn({required this.controller});

  final EmailAuthController controller;

  @override
  Widget build(BuildContext context) => Center(
    child: _LinkButton(
      label: context.emailSignInTexts.backToSignIn,
      onPressed: controller.isLoading
          ? null
          : () => controller.navigateTo(EmailFlowScreen.login),
    ),
  );
}

class _LinkButton extends StatelessWidget {
  const _LinkButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) =>
      TextButton(onPressed: onPressed, child: Text(label));
}
