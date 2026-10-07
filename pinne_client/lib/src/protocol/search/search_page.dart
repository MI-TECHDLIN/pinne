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
import '../search/search_result.dart' as _i5odns5n;

abstract class SearchPage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SearchPage._({
    required this.results,
    this.nextCursor,
  });

  factory SearchPage({
    required List<_i5odns5n.SearchResult> results,
    String? nextCursor,
  }) = _SearchPageImpl;

  factory SearchPage.fromJson(Map<String, dynamic> jsonSerialization) {
    return SearchPage(
      results: _iub9zyhg.Protocol().deserialize<List<_i5odns5n.SearchResult>>(
        jsonSerialization['results'],
      ),
      nextCursor: jsonSerialization['nextCursor'] as String?,
    );
  }

  List<_i5odns5n.SearchResult> results;

  String? nextCursor;

  /// Returns a shallow copy of this [SearchPage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SearchPage copyWith({
    List<_i5odns5n.SearchResult>? results,
    String? nextCursor,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SearchPage',
      'results': results.toJson(valueToJson: (v) => v.toJson()),
      if (nextCursor != null) 'nextCursor': nextCursor,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SearchPage',
      'results': results.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (nextCursor != null) 'nextCursor': nextCursor,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SearchPageImpl extends SearchPage {
  _SearchPageImpl({
    required List<_i5odns5n.SearchResult> results,
    String? nextCursor,
  }) : super._(
         results: results,
         nextCursor: nextCursor,
       );

  /// Returns a shallow copy of this [SearchPage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SearchPage copyWith({
    List<_i5odns5n.SearchResult>? results,
    Object? nextCursor = _Undefined,
  }) {
    return SearchPage(
      results: results ?? this.results.map((e0) => e0.copyWith()).toList(),
      nextCursor: nextCursor is String? ? nextCursor : this.nextCursor,
    );
  }
}
