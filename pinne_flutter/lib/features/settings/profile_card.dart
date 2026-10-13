import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../router.dart';
import '../../shell/pinne_page.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/ribbon_spirit/ribbon_spirit.dart';
import '../../ui/pinne_loading.dart';
import 'profile_provider.dart';
import '../../ui/feedback/friendly_error.dart';

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
                if (profile.isLoading)
                  const PinneSkeleton(
                    label: 'Loading profile settings',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Bone.text(width: 178, fontSize: 18),
                        SizedBox(height: PinneSpacing.sm),
                        Bone.text(width: 146, fontSize: 14),
                        SizedBox(height: PinneSpacing.md),
                        Bone.button(width: 142, height: 34),
                      ],
                    ),
                  )
                else ...[
                  Text(
                    profile.asData?.value?.displayName ??
                        'Your little companion',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    userId == null
                        ? 'Sign in to keep your spirit.'
                        : 'A ribbon, all your own.',
                    style: TextStyle(color: context.pinne.muted),
                  ),
                  if (profile.hasError)
                    TextButton.icon(
                      key: const ValueKey('profile-retry'),
                      onPressed: () => ref.invalidate(profileProvider),
                      icon: Icon(
                        FriendlyError.from(profile.error).icon,
                        size: 16,
                      ),
                      label: Text(
                        '${FriendlyError.from(profile.error).title} · Try again',
                      ),
                    ),
                  if (userId != null)
                    TextButton(
                      onPressed: profile.hasError
                          ? null
                          : () => showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: context.pinne.midnightRaised,
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
                TextButton(
                  key: const ValueKey('settings-profile-link'),
                  onPressed: () => context.push(Routes.profile),
                  child: const Text('View profile'),
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
          Text(
            'Same little soul. A different twist.',
            style: TextStyle(color: context.pinne.muted),
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
                              ? context.pinne.cardRaised
                              : context.pinne.card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: _seed == _seeds[index]
                                ? context.pinne.violet
                                : context.pinne.line,
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
                              Positioned(
                                right: 4,
                                bottom: 4,
                                child: Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: context.pinne.lilac,
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
                  selectedColor: context.pinne.violet,
                  backgroundColor: context.pinne.card,
                  checkmarkColor: context.pinne.onViolet,
                  // Only the selected chip sits on violet; the rest sit on
                  // the card and use body text.
                  labelStyle: TextStyle(
                    color: _palette == index
                        ? context.pinne.onViolet
                        : context.pinne.text,
                  ),
                  side: BorderSide(color: context.pinne.line),
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
                style: TextStyle(color: context.pinne.error),
              ),
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PinneBrandedLoader(
                          size: 20,
                          label: 'Saving your spirit',
                        ),
                        SizedBox(width: PinneSpacing.sm),
                        Text('Saving…'),
                      ],
                    )
                  : const Text('Keep this spirit'),
            ),
          ),
        ],
      ),
    ),
  );
}
