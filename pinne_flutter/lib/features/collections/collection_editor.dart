import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';

import '../../core/library_revision.dart';
import '../../theme/pinne_tokens.dart';
import '../../ui/feedback/friendly_error.dart';
import '../../ui/motion.dart';
import '../../ui/pinne_loading.dart';
import 'collection_cover.dart';
import 'collections_providers.dart';

/// Opens the sheet that creates a collection, or edits [editing]. Resolves
/// to the saved collection, or null when the sheet is dismissed.
Future<Collection?> showCollectionEditor(
  BuildContext context, {
  CollectionTileData? editing,
  int defaultPalette = 0,
}) => showModalBottomSheet<Collection>(
  context: context,
  isScrollControlled: true,
  backgroundColor: context.pinne.card,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(PinneRadii.sheet)),
  ),
  builder: (context) =>
      CollectionEditorSheet(editing: editing, defaultPalette: defaultPalette),
);

/// Name (required, unique), colour and an optional description. A new
/// collection starts with the palette its neighbours use least; its mesh
/// cover is generated from that one base colour.
class CollectionEditorSheet extends ConsumerStatefulWidget {
  const CollectionEditorSheet({
    super.key,
    this.editing,
    this.defaultPalette = 0,
  });

  final CollectionTileData? editing;
  final int defaultPalette;

  @override
  ConsumerState<CollectionEditorSheet> createState() =>
      _CollectionEditorSheetState();
}

class _CollectionEditorSheetState extends ConsumerState<CollectionEditorSheet> {
  late final _name = TextEditingController(text: widget.editing?.name);
  late final _description = TextEditingController(
    text: widget.editing?.description,
  );
  late int _palette = widget.editing?.paletteIndex ?? widget.defaultPalette;
  late final int _seed =
      widget.editing?.coverSeed ?? ref.read(coverSeedProvider)();
  String? _error;
  var _busy = false;

  bool get _editing => widget.editing != null;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Give the collection a name.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final description = _description.text.trim();
    final api = ref.read(collectionsApiProvider);
    try {
      final existing = widget.editing?.collection;
      final saved = existing == null
          ? await api.create(
              CollectionDraft(
                name: name,
                description: description.isEmpty ? null : description,
                coverSeed: _seed,
                paletteIndex: _palette,
              ),
            )
          : await api.update(
              existing.copyWith(
                name: name,
                description: description.isEmpty ? null : description,
                paletteIndex: _palette,
              ),
            );
      ref.read(libraryRevisionProvider.notifier).bump();
      if (mounted) Navigator.of(context).pop(saved);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _busy = false;
          // The server's own words for a taken or invalid name.
          _error = error is ValidationException
              ? error.message
              : FriendlyError.from(
                  error,
                ).toast('Could not save the collection');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: PinneSpacing.gutter,
        right: PinneSpacing.gutter,
        top: PinneSpacing.lg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + PinneSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(
                _editing ? 'Edit collection' : 'New collection',
                style: theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: PinneSpacing.md),
            SizedBox(
              height: 96,
              child: CollectionCover(
                seed: _seed,
                paletteIndex: _palette,
                borderRadius: PinneRadii.card,
              ),
            ),
            const SizedBox(height: PinneSpacing.md),
            TextField(
              key: const ValueKey('collection-name-field'),
              controller: _name,
              autofocus: !_editing,
              maxLength: 60,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Such as UI inspiration',
                errorText: _error,
                errorMaxLines: 3,
              ),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: PinneSpacing.sm),
            TextField(
              key: const ValueKey('collection-description-field'),
              controller: _description,
              maxLength: 200,
              maxLines: 2,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'What goes in here?',
              ),
            ),
            const SizedBox(height: PinneSpacing.sm),
            Text(
              'Colour',
              style: theme.textTheme.labelLarge?.copyWith(
                color: context.pinne.muted,
              ),
            ),
            const SizedBox(height: PinneSpacing.sm),
            Wrap(
              spacing: PinneSpacing.md,
              runSpacing: PinneSpacing.sm,
              children: [
                for (var index = 0; index < collectionPaletteCount; index++)
                  _Swatch(
                    index: index,
                    selected: index == _palette,
                    onTap: () => setState(() => _palette = index),
                  ),
              ],
            ),
            const SizedBox(height: PinneSpacing.lg),
            FilledButton(
              key: const ValueKey('save-collection'),
              onPressed: _busy ? null : _save,
              child: _busy
                  ? const PinneBrandedLoader(
                      size: 18,
                      label: 'Saving the collection',
                    )
                  : Text(_editing ? 'Save changes' : 'Create collection'),
            ),
          ],
        ),
      ),
    );
  }
}

/// One base colour to pick. The cover's mesh is generated from it.
class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.index,
    required this.selected,
    required this.onTap,
  });

  static const names = ['Lavender', 'Apricot', 'Mint', 'Rose', 'Sky'];

  final int index;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '${names[index]} colour',
      child: InkResponse(
        key: ValueKey('collection-colour-$index'),
        onTap: onTap,
        radius: 26,
        child: AnimatedContainer(
          duration: motionDurationOf(context, PinneMotionDurations.quick),
          width: 44,
          height: 44,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? context.pinne.violet : Colors.transparent,
              width: 2.5,
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: collectionAccent(index),
            ),
            child: selected
                ? Icon(Icons.check_rounded, size: 20, color: context.pinne.ink)
                : null,
          ),
        ),
      ),
    );
  }
}
