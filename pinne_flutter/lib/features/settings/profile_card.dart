import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../shell/pinne_page.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/ribbon_spirit/ribbon_spirit.dart';
import 'profile_provider.dart';

class ProfileCard extends ConsumerWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatar = ref.watch(avatarRecipeProvider);
    final profile = ref.watch(profileProvider);
    final userId = ref.watch(profileUserIdProvider);
    return GlassCard(
      child: Row(
        children: [
          RibbonSpirit(seed: avatar.seed, palette: avatar.palette, size: 88),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.asData?.value?.displayName ?? 'Your little companion',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  userId == null
                      ? 'Sign in to keep your spirit.'
                      : 'A ribbon, all your own.',
                  style: const TextStyle(color: PinneColors.muted),
                ),
                if (profile.isLoading) const LinearProgressIndicator(),
                if (profile.hasError)
                  TextButton(
                    onPressed: () => ref.invalidate(profileProvider),
                    child: const Text('Could not load · Retry'),
                  ),
                if (userId != null)
                  TextButton(
                    onPressed: profile.isLoading || profile.hasError
                        ? null
                        : () => showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: PinneColors.midnightRaised,
                            builder: (_) => _AvatarPicker(
                              userId: userId,
                              profile: profile.asData?.value,
                              seed: avatar.seed,
                              palette: avatar.palette,
                            ),
                          ),
                    child: const Text('Choose your spirit'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarPicker extends ConsumerStatefulWidget {
  const _AvatarPicker({
    required this.userId,
    required this.profile,
    required this.seed,
    required this.palette,
  });
  final String userId;
  final PinneProfile? profile;
  final int seed;
  final int palette;

  @override
  ConsumerState<_AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends ConsumerState<_AvatarPicker> {
  late int _seed = widget.seed;
  late int _palette = widget.palette;
  late final _name = TextEditingController(
    text: widget.profile?.displayName ?? 'Reader',
  );
  late final _seeds = <int>[
    widget.seed,
    ...RibbonRecipe.choicesFor(
      widget.userId,
    ).where((seed) => seed != widget.seed),
  ].take(12).toList();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      setState(() => _error = 'Add a display name first.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      // A sheet opened for a previous account must never write to a new one.
      if (ref.read(profileUserIdProvider) != widget.userId) {
        setState(() => _error = 'Your account changed. Reopen the picker.');
        return;
      }
      await ref
          .read(profileEndpointProvider)
          .upsert(
            ProfileDraft(
              displayName: _name.text.trim(),
              avatarSeed: _seed,
              avatarPalette: _palette,
            ),
          );
      if (!mounted) return;
      ref.invalidate(profileProvider);
      Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Could not save your spirit. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Find your spirit',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Text(
            'Same little soul. A different twist.',
            style: TextStyle(color: PinneColors.muted),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            maxLength: 80,
            enabled: !_saving,
            decoration: const InputDecoration(labelText: 'Display name'),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var index = 0; index < _seeds.length; index++)
                  Semantics(
                    selected: _seed == _seeds[index],
                    button: true,
                    label: 'Spirit ${index + 1}',
                    excludeSemantics: true,
                    child: InkWell(
                      key: ValueKey('avatar-choice-$index'),
                      onTap: _saving
                          ? null
                          : () => setState(() => _seed = _seeds[index]),
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        width: (constraints.maxWidth - 24) / 4,
                        decoration: BoxDecoration(
                          color: _seed == _seeds[index]
                              ? PinneColors.cardRaised
                              : PinneColors.card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: _seed == _seeds[index]
                                ? PinneColors.violet
                                : PinneColors.line,
                            width: 2,
                          ),
                        ),
                        child: Stack(
                          children: [
                            RibbonSpirit(
                              seed: _seeds[index],
                              palette: _palette,
                              animate: false,
                              size: (constraints.maxWidth - 24) / 4,
                            ),
                            if (_seed == _seeds[index])
                              const Positioned(
                                right: 4,
                                bottom: 4,
                                child: Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: PinneColors.lilac,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (
                var index = 0;
                index < PinneSpiritPalettes.values.length;
                index++
              )
                ChoiceChip(
                  selectedColor: PinneColors.violet,
                  backgroundColor: PinneColors.card,
                  checkmarkColor: PinneColors.text,
                  labelStyle: const TextStyle(color: PinneColors.text),
                  side: const BorderSide(color: PinneColors.line),
                  label: Text(PinneSpiritPalettes.values[index].name),
                  avatar: CircleAvatar(
                    backgroundColor: PinneSpiritPalettes.values[index].body,
                    radius: 7,
                  ),
                  selected: _palette == index,
                  onSelected: _saving
                      ? null
                      : (_) => setState(() => _palette = index),
                ),
            ],
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                _error!,
                style: const TextStyle(color: PinneColors.pink),
              ),
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving ? 'Saving…' : 'Keep this spirit'),
            ),
          ),
        ],
      ),
    ),
  );
}
