import 'package:flutter/material.dart';

import '../../shell/pinne_page.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PinnePage(
      headline: 'Find it by',
      headlineBold: 'what you remember',
      subtitle: 'Describe it the way you would to a friend.',
      children: [
        ComingSoonCard(
          title: 'Search is on its way',
          body:
              'Exact words and remembered meaning, with the reason each '
              'result matched.',
        ),
      ],
    );
  }
}
