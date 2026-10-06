import 'package:flutter/material.dart';

import '../../shell/pinne_page.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PinnePage(
      headline: 'Honest',
      headlineBold: 'progress',
      subtitle: 'What you saved, and what you actually came back to.',
      children: [
        ComingSoonCard(
          title: 'No reviews yet',
          body: 'Progress counts unique items reviewed, never guilt.',
        ),
      ],
    );
  }
}
