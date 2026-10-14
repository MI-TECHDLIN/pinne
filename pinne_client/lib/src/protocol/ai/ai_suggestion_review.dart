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
import 'package:pinne_client/src/protocol/protocol.dart' as _iub9zyhg;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../ai/ai_suggestion.dart' as _ibt9rc7b;

/// What the Saved card shows for one item: its pending suggestions, and
/// whether a newer organizing pass (for example after the link preview
/// arrives) is still on its way and will replace them.
abstract class AiSuggestionReview
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AiSuggestionReview._({
    required this.suggestions,
    required this.organizing,
  });

  factory AiSuggestionReview({
    required List<_ibt9rc7b.AiSuggestion> suggestions,
    required bool organizing,
  }) = _AiSuggestionReviewImpl;

  factory AiSuggestionReview.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiSuggestionReview(
      suggestions: _iub9zyhg.Protocol()
          .deserialize<List<_ibt9rc7b.AiSuggestion>>(
            jsonSerialization['suggestions'],
          ),
      organizing: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['organizing'],
      ),
    );
  }

  List<_ibt9rc7b.AiSuggestion> suggestions;

  bool organizing;

  /// Returns a shallow copy of this [AiSuggestionReview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AiSuggestionReview copyWith({
    List<_ibt9rc7b.AiSuggestion>? suggestions,
    bool? organizing,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiSuggestionReview',
      'suggestions': suggestions.toJson(valueToJson: (v) => v.toJson()),
      'organizing': organizing,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AiSuggestionReview',
      'suggestions': suggestions.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'organizing': organizing,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _AiSuggestionReviewImpl extends AiSuggestionReview {
  _AiSuggestionReviewImpl({
    required List<_ibt9rc7b.AiSuggestion> suggestions,
    required bool organizing,
  }) : super._(
         suggestions: suggestions,
         organizing: organizing,
       );

  /// Returns a shallow copy of this [AiSuggestionReview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AiSuggestionReview copyWith({
    List<_ibt9rc7b.AiSuggestion>? suggestions,
    bool? organizing,
  }) {
    return AiSuggestionReview(
      suggestions:
          suggestions ?? this.suggestions.map((e0) => e0.copyWith()).toList(),
      organizing: organizing ?? this.organizing,
    );
  }
}
