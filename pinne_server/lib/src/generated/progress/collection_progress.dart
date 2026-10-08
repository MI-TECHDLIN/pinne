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

/// Review rate of the cohort items filed in one collection.
abstract class CollectionProgress
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CollectionProgress._({
    required this.collectionId,
    required this.name,
    required this.paletteIndex,
    required this.cohortCount,
    required this.reviewedCount,
    this.reviewRate,
  });

  factory CollectionProgress({
    required _is.UuidValue collectionId,
    required String name,
    required int paletteIndex,
    required int cohortCount,
    required int reviewedCount,
    double? reviewRate,
  }) = _CollectionProgressImpl;

  factory CollectionProgress.fromJson(Map<String, dynamic> jsonSerialization) {
    return CollectionProgress(
      collectionId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['collectionId'],
      ),
      name: jsonSerialization['name'] as String,
      paletteIndex: jsonSerialization['paletteIndex'] as int,
      cohortCount: jsonSerialization['cohortCount'] as int,
      reviewedCount: jsonSerialization['reviewedCount'] as int,
      reviewRate: (jsonSerialization['reviewRate'] as num?)?.toDouble(),
    );
  }

  _is.UuidValue collectionId;

  String name;

  int paletteIndex;

  int cohortCount;

  int reviewedCount;

  /// Null when no cohort item is in this collection.
  double? reviewRate;

  /// Returns a shallow copy of this [CollectionProgress]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CollectionProgress copyWith({
    _is.UuidValue? collectionId,
    String? name,
    int? paletteIndex,
    int? cohortCount,
    int? reviewedCount,
    double? reviewRate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CollectionProgress',
      'collectionId': collectionId.toJson(),
      'name': name,
      'paletteIndex': paletteIndex,
      'cohortCount': cohortCount,
      'reviewedCount': reviewedCount,
      if (reviewRate != null) 'reviewRate': reviewRate,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CollectionProgress',
      'collectionId': collectionId.toJson(),
      'name': name,
      'paletteIndex': paletteIndex,
      'cohortCount': cohortCount,
      'reviewedCount': reviewedCount,
      if (reviewRate != null) 'reviewRate': reviewRate,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CollectionProgressImpl extends CollectionProgress {
  _CollectionProgressImpl({
    required _is.UuidValue collectionId,
    required String name,
    required int paletteIndex,
    required int cohortCount,
    required int reviewedCount,
    double? reviewRate,
  }) : super._(
         collectionId: collectionId,
         name: name,
         paletteIndex: paletteIndex,
         cohortCount: cohortCount,
         reviewedCount: reviewedCount,
         reviewRate: reviewRate,
       );

  /// Returns a shallow copy of this [CollectionProgress]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CollectionProgress copyWith({
    _is.UuidValue? collectionId,
    String? name,
    int? paletteIndex,
    int? cohortCount,
    int? reviewedCount,
    Object? reviewRate = _Undefined,
  }) {
    return CollectionProgress(
      collectionId: collectionId ?? this.collectionId,
      name: name ?? this.name,
      paletteIndex: paletteIndex ?? this.paletteIndex,
      cohortCount: cohortCount ?? this.cohortCount,
      reviewedCount: reviewedCount ?? this.reviewedCount,
      reviewRate: reviewRate is double? ? reviewRate : this.reviewRate,
    );
  }
}
