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
import 'package:serverpod/serverpod.dart' as _is;

/// A short, human-readable explanation of why a result matched.
abstract class SearchEvidence
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SearchEvidence._({
    required this.field,
    required this.snippet,
  });

  factory SearchEvidence({
    required String field,
    required String snippet,
  }) = _SearchEvidenceImpl;

  factory SearchEvidence.fromJson(Map<String, dynamic> jsonSerialization) {
    return SearchEvidence(
      field: jsonSerialization['field'] as String,
      snippet: jsonSerialization['snippet'] as String,
    );
  }

  String field;

  String snippet;

  /// Returns a shallow copy of this [SearchEvidence]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SearchEvidence copyWith({
    String? field,
    String? snippet,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SearchEvidence',
      'field': field,
      'snippet': snippet,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SearchEvidence',
      'field': field,
      'snippet': snippet,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SearchEvidenceImpl extends SearchEvidence {
  _SearchEvidenceImpl({
    required String field,
    required String snippet,
  }) : super._(
         field: field,
         snippet: snippet,
       );

  /// Returns a shallow copy of this [SearchEvidence]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SearchEvidence copyWith({
    String? field,
    String? snippet,
  }) {
    return SearchEvidence(
      field: field ?? this.field,
      snippet: snippet ?? this.snippet,
    );
  }
}
