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

/// The owner's choice for one calendar.
abstract class CalendarSelectionChoice
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CalendarSelectionChoice._({
    required this.selectionId,
    required this.useForConflicts,
    required this.useForWrites,
  });

  factory CalendarSelectionChoice({
    required _isc.UuidValue selectionId,
    required bool useForConflicts,
    required bool useForWrites,
  }) = _CalendarSelectionChoiceImpl;

  factory CalendarSelectionChoice.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CalendarSelectionChoice(
      selectionId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['selectionId'],
      ),
      useForConflicts: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['useForConflicts'],
      ),
      useForWrites: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['useForWrites'],
      ),
    );
  }

  _isc.UuidValue selectionId;

  bool useForConflicts;

  bool useForWrites;

  /// Returns a shallow copy of this [CalendarSelectionChoice]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CalendarSelectionChoice copyWith({
    _isc.UuidValue? selectionId,
    bool? useForConflicts,
    bool? useForWrites,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CalendarSelectionChoice',
      'selectionId': selectionId.toJson(),
      'useForConflicts': useForConflicts,
      'useForWrites': useForWrites,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CalendarSelectionChoice',
      'selectionId': selectionId.toJson(),
      'useForConflicts': useForConflicts,
      'useForWrites': useForWrites,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _CalendarSelectionChoiceImpl extends CalendarSelectionChoice {
  _CalendarSelectionChoiceImpl({
    required _isc.UuidValue selectionId,
    required bool useForConflicts,
    required bool useForWrites,
  }) : super._(
         selectionId: selectionId,
         useForConflicts: useForConflicts,
         useForWrites: useForWrites,
       );

  /// Returns a shallow copy of this [CalendarSelectionChoice]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CalendarSelectionChoice copyWith({
    _isc.UuidValue? selectionId,
    bool? useForConflicts,
    bool? useForWrites,
  }) {
    return CalendarSelectionChoice(
      selectionId: selectionId ?? this.selectionId,
      useForConflicts: useForConflicts ?? this.useForConflicts,
      useForWrites: useForWrites ?? this.useForWrites,
    );
  }
}
