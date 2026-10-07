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
import '../reviews/item_progress.dart' as _iwt5wocm;
import '../reviews/review_event.dart' as _ilom1qr3;

abstract class ReviewEventReceipt
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ReviewEventReceipt._({
    required this.event,
    required this.progress,
  });

  factory ReviewEventReceipt({
    required _ilom1qr3.ReviewEvent event,
    required _iwt5wocm.ItemProgress progress,
  }) = _ReviewEventReceiptImpl;

  factory ReviewEventReceipt.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReviewEventReceipt(
      event: _i2yoimhd.Protocol().deserialize<_ilom1qr3.ReviewEvent>(
        jsonSerialization['event'],
      ),
      progress: _i2yoimhd.Protocol().deserialize<_iwt5wocm.ItemProgress>(
        jsonSerialization['progress'],
      ),
    );
  }

  _ilom1qr3.ReviewEvent event;

  _iwt5wocm.ItemProgress progress;

  /// Returns a shallow copy of this [ReviewEventReceipt]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReviewEventReceipt copyWith({
    _ilom1qr3.ReviewEvent? event,
    _iwt5wocm.ItemProgress? progress,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReviewEventReceipt',
      'event': event.toJson(),
      'progress': progress.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReviewEventReceipt',
      'event': event.toJsonForProtocol(),
      'progress': progress.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ReviewEventReceiptImpl extends ReviewEventReceipt {
  _ReviewEventReceiptImpl({
    required _ilom1qr3.ReviewEvent event,
    required _iwt5wocm.ItemProgress progress,
  }) : super._(
         event: event,
         progress: progress,
       );

  /// Returns a shallow copy of this [ReviewEventReceipt]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReviewEventReceipt copyWith({
    _ilom1qr3.ReviewEvent? event,
    _iwt5wocm.ItemProgress? progress,
  }) {
    return ReviewEventReceipt(
      event: event ?? this.event.copyWith(),
      progress: progress ?? this.progress.copyWith(),
    );
  }
}
