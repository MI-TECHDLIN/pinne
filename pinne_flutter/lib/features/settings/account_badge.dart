import 'package:flutter/material.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../theme/pinne_tokens.dart';

/// The account kind as a small violet pill: GUEST, EMAIL or DEMO.
class AccountBadge extends StatelessWidget {
  const AccountBadge({super.key, required this.type});

  final ProfileAccountType? type;

  @override
  Widget build(BuildContext context) {
    final label = switch (type) {
      ProfileAccountType.email => 'EMAIL',
      ProfileAccountType.demo => 'DEMO',
      ProfileAccountType.guest || null => 'GUEST',
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.pinne.violet,
        borderRadius: BorderRadius.circular(PinneRadii.chip),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: context.pinne.onViolet,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
