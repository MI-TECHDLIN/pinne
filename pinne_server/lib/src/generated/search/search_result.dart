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
import 'package:pinne_server/src/generated/protocol.dart' as _i2yoimhd;
import 'package:serverpod/serverpod.dart' as _is;
import '../items/item.dart' as _ieep4ee2;
import '../search/search_evidence.dart' as _ir15z3en;

abstract class SearchResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SearchResult._({
    required this.item,
    required this.evidence,
    required this.score,
  });

  factory SearchResult({
    required _ieep4ee2.Item item,
    required List<_ir15z3en.SearchEvidence> evidence,
    required double score,
  }) = _SearchResultImpl;

  factory SearchResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return SearchResult(
      item: _i2yoimhd.Protocol().deserialize<_ieep4ee2.Item>(
        jsonSerialization['item'],
      ),
      evidence: _i2yoimhd.Protocol()
          .deserialize<List<_ir15z3en.SearchEvidence>>(
            jsonSerialization['evidence'],
          ),
      score: (jsonSerialization['score'] as num).toDouble(),
    );
  }

  _ieep4ee2.Item item;

  List<_ir15z3en.SearchEvidence> evidence;

  double score;

  /// Returns a shallow copy of this [SearchResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SearchResult copyWith({
    _ieep4ee2.Item? item,
    List<_ir15z3en.SearchEvidence>? evidence,
    double? score,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SearchResult',
      'item': item.toJson(),
      'evidence': evidence.toJson(valueToJson: (v) => v.toJson()),
      'score': score,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SearchResult',
      'item': item.toJsonForProtocol(),
      'evidence': evidence.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'score': score,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SearchResultImpl extends SearchResult {
  _SearchResultImpl({
    required _ieep4ee2.Item item,
    required List<_ir15z3en.SearchEvidence> evidence,
    required double score,
  }) : super._(
         item: item,
         evidence: evidence,
         score: score,
       );

  /// Returns a shallow copy of this [SearchResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SearchResult copyWith({
    _ieep4ee2.Item? item,
    List<_ir15z3en.SearchEvidence>? evidence,
    double? score,
  }) {
    return SearchResult(
      item: item ?? this.item.copyWith(),
      evidence: evidence ?? this.evidence.map((e0) => e0.copyWith()).toList(),
      score: score ?? this.score,
    );
  }
}
