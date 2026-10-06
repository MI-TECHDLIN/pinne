/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Where a saved item came from. Detected from the link by the shared
/// `pinne_capture` package, whose `CaptureSource` maps to this by name.
/// `unknown` is explicit: an ambiguous link, such as a generic short link,
/// is never guessed. `other` is kept for rows written before detection.
enum SourcePlatform implements _isc.SerializableModel {
  x,
  youtube,
  web,
  note,
  other,
  instagram,
  tiktok,
  reddit,
  github,
  unknown;

  static SourcePlatform fromJson(String name) {
    switch (name) {
      case 'x':
        return SourcePlatform.x;
      case 'youtube':
        return SourcePlatform.youtube;
      case 'web':
        return SourcePlatform.web;
      case 'note':
        return SourcePlatform.note;
      case 'other':
        return SourcePlatform.other;
      case 'instagram':
        return SourcePlatform.instagram;
      case 'tiktok':
        return SourcePlatform.tiktok;
      case 'reddit':
        return SourcePlatform.reddit;
      case 'github':
        return SourcePlatform.github;
      case 'unknown':
        return SourcePlatform.unknown;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "SourcePlatform"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
