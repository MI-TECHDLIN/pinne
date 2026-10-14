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
import '../collections/collection.dart' as _i6vkr3zi;

/// What a collection card shows: the collection, how many saves it holds,
/// the tags used most on them and the titles of the newest ones.
abstract class CollectionSummary
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CollectionSummary._({
    required this.collection,
    required this.itemCount,
    required this.topTags,
    required this.recentTitles,
  });

  factory CollectionSummary({
    required _i6vkr3zi.Collection collection,
    required int itemCount,
    required List<String> topTags,
    required List<String> recentTitles,
  }) = _CollectionSummaryImpl;

  factory CollectionSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return CollectionSummary(
      collection: _iub9zyhg.Protocol().deserialize<_i6vkr3zi.Collection>(
        jsonSerialization['collection'],
      ),
      itemCount: jsonSerialization['itemCount'] as int,
      topTags: _iub9zyhg.Protocol().deserialize<List<String>>(
        jsonSerialization['topTags'],
      ),
      recentTitles: _iub9zyhg.Protocol().deserialize<List<String>>(
        jsonSerialization['recentTitles'],
      ),
    );
  }

  _i6vkr3zi.Collection collection;

  int itemCount;

  List<String> topTags;

  List<String> recentTitles;

  /// Returns a shallow copy of this [CollectionSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CollectionSummary copyWith({
    _i6vkr3zi.Collection? collection,
    int? itemCount,
    List<String>? topTags,
    List<String>? recentTitles,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CollectionSummary',
      'collection': collection.toJson(),
      'itemCount': itemCount,
      'topTags': topTags.toJson(),
      'recentTitles': recentTitles.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CollectionSummary',
      'collection': collection.toJsonForProtocol(),
      'itemCount': itemCount,
      'topTags': topTags.toJson(),
      'recentTitles': recentTitles.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _CollectionSummaryImpl extends CollectionSummary {
  _CollectionSummaryImpl({
    required _i6vkr3zi.Collection collection,
    required int itemCount,
    required List<String> topTags,
    required List<String> recentTitles,
  }) : super._(
         collection: collection,
         itemCount: itemCount,
         topTags: topTags,
         recentTitles: recentTitles,
       );

  /// Returns a shallow copy of this [CollectionSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CollectionSummary copyWith({
    _i6vkr3zi.Collection? collection,
    int? itemCount,
    List<String>? topTags,
    List<String>? recentTitles,
  }) {
    return CollectionSummary(
      collection: collection ?? this.collection.copyWith(),
      itemCount: itemCount ?? this.itemCount,
      topTags: topTags ?? this.topTags.map((e0) => e0).toList(),
      recentTitles: recentTitles ?? this.recentTitles.map((e0) => e0).toList(),
    );
  }
}
