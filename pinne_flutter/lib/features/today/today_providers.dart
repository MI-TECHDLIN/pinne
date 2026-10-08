import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/server_client.dart';
import '../progress/progress_providers.dart';

final reviewQueueEndpointProvider = Provider<EndpointReviewQueue>(
  (ref) => ref.watch(clientProvider).reviewQueue,
);

final reviewEndpointProvider = Provider<EndpointReview>(
  (ref) => ref.watch(clientProvider).review,
);

final reviewBudgetProvider = NotifierProvider<ReviewBudget, int>(
  ReviewBudget.new,
);

class ReviewBudget extends Notifier<int> {
  @override
  int build() => 10;

  void select(int minutes) => state = minutes;
}

final todayQueueProvider = FutureProvider.autoDispose<ReviewQueueResult>((
  ref,
) async {
  final budget = ref.watch(reviewBudgetProvider);
  if (!ref.watch(signedInProvider)) {
    return ReviewQueueResult(entries: [], timeBudgetMinutes: budget);
  }
  return ref
      .watch(reviewQueueEndpointProvider)
      .get(
        timeBudgetMinutes: budget,
      );
});

typedef OpenExternalUrl = Future<bool> Function(Uri uri);

final openExternalUrlProvider = Provider<OpenExternalUrl>(
  (ref) =>
      (uri) => launchUrl(uri, mode: LaunchMode.externalApplication),
);

abstract interface class TodayActionGateway {
  Future<ReviewEventReceipt> reviewed(Item item);
  Future<ReviewEventReceipt> undo(Item item, UuidValue eventId);
  Future<void> remindLater(Item item);
  Future<void> archive(Item item);
  Future<void> open(Item item);
}

final todayActionGatewayProvider = Provider<TodayActionGateway>(
  TodayServerActions.new,
);

class TodayServerActions implements TodayActionGateway {
  TodayServerActions(this.ref);

  final Ref ref;

  @override
  Future<ReviewEventReceipt> reviewed(Item item) async {
    final receipt = await _record(item, ReviewEventType.reviewed);
    ref
      ..invalidate(todayQueueProvider)
      ..invalidate(progressReportProvider);
    return receipt;
  }

  @override
  Future<ReviewEventReceipt> undo(Item item, UuidValue eventId) async {
    final receipt = await _record(
      item,
      ReviewEventType.undo,
      compensatesEventId: eventId,
    );
    ref
      ..invalidate(todayQueueProvider)
      ..invalidate(progressReportProvider);
    return receipt;
  }

  @override
  Future<void> remindLater(Item item) async {
    await ref
        .read(reviewQueueEndpointProvider)
        .snooze(item.id!, DateTime.now().toUtc().add(const Duration(days: 1)));
    ref.invalidate(todayQueueProvider);
  }

  @override
  Future<void> archive(Item item) async {
    await ref.read(reviewQueueEndpointProvider).archive(item.id!);
    ref.invalidate(todayQueueProvider);
  }

  @override
  Future<void> open(Item item) async {
    final uri = item.url == null ? null : Uri.tryParse(item.url!);
    if (uri == null) return;
    await _record(item, ReviewEventType.opened);
    await ref.read(openExternalUrlProvider)(uri);
    ref.invalidate(todayQueueProvider);
  }

  Future<ReviewEventReceipt> _record(
    Item item,
    ReviewEventType type, {
    UuidValue? compensatesEventId,
  }) {
    final local = DateTime.now();
    return ref
        .read(reviewEndpointProvider)
        .record(
          ReviewEventDraft(
            clientEventId:
                '${type.name}-${item.id}-${local.microsecondsSinceEpoch}',
            itemId: item.id!,
            eventType: type,
            occurredAt: local.toUtc(),
            timezone: local.timeZoneName,
            timezoneOffsetMinutes: local.timeZoneOffset.inMinutes,
            compensatesEventId: compensatesEventId,
          ),
        );
  }
}
