import 'package:flutter/material.dart';

import '../../shell/pinne_page.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PinnePage(
      headline: 'Today,',
      headlineBold: 'a few good saves',
      subtitle: 'A small queue of what is worth revisiting now.',
      children: [
        ComingSoonCard(
          title: 'Nothing due yet',
          body:
              'Items you save show up here about a day later, '
              'with the note you left on why you saved them.',
        ),
      ],
    );
  }
}
