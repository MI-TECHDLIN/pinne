import 'package:pinne_calendar/pinne_calendar.dart';
import 'package:pinne_client/pinne_client.dart';

/// Carries out calendar work from the server on this phone and says what
/// happened, one result per write.
///
/// Every write looks for the session's event by its uid first, so a create
/// whose answer was lost (the event was made but the app never heard) is
/// found instead of made twice, and an event that no longer carries the
/// session's marker is never changed.
class CalendarWriteRunner {
  CalendarWriteRunner(this.adapter);

  final CalendarAdapter adapter;

  Future<List<CalendarWriteResult>> run(List<CalendarWrite> writes) async {
    final results = <CalendarWriteResult>[];
    for (final write in writes) {
      final result = await _runOne(write);
      if (result != null) results.add(result);
    }
    return results;
  }

  Future<CalendarWriteResult?> _runOne(CalendarWrite write) async {
    final draft = SessionEventDraft(
      uid: write.eventUid,
      calendarId: write.externalCalendarId,
      title: write.title,
      notes: write.notes,
      span: TimeInterval(write.startAt, write.endAt),
      timezone: write.timezone,
    );
    final known = write.externalEventId == null
        ? null
        : SessionEventRef(
            calendarId: write.externalCalendarId,
            eventId: write.externalEventId!,
          );
    CalendarWriteResult result(
      CalendarWriteOutcome outcome, {
      SessionEventRef? ref,
      TimeInterval? span,
      String? message,
    }) => CalendarWriteResult(
      linkId: write.linkId,
      action: write.action,
      outcome: outcome,
      sessionRevision: write.sessionRevision,
      externalEventId: ref?.eventId ?? write.externalEventId,
      providerRevision: ref?.revision,
      startAt: span?.start,
      endAt: span?.end,
      message: message,
    );

    try {
      final found = await adapter.reconcile(draft, known: known);
      switch (write.action) {
        case CalendarWriteAction.create:
          return switch (found.state) {
            ReconcileState.missing || ReconcileState.foreign => result(
              CalendarWriteOutcome.done,
              ref: await adapter.createSessionEvent(draft),
            ),
            ReconcileState.matches => result(
              CalendarWriteOutcome.done,
              ref: found.ref,
            ),
            // Made earlier for an older time: bring it in line.
            ReconcileState.moved => result(
              CalendarWriteOutcome.done,
              ref: await adapter.updateSessionEvent(found.ref!, draft),
            ),
          };
        case CalendarWriteAction.update:
          return switch (found.state) {
            ReconcileState.missing => result(CalendarWriteOutcome.missing),
            ReconcileState.foreign => result(CalendarWriteOutcome.notOurs),
            ReconcileState.matches => result(
              CalendarWriteOutcome.done,
              ref: found.ref,
            ),
            ReconcileState.moved => result(
              CalendarWriteOutcome.done,
              ref: await adapter.updateSessionEvent(found.ref!, draft),
            ),
          };
        case CalendarWriteAction.delete:
          switch (found.state) {
            case ReconcileState.missing:
              return result(CalendarWriteOutcome.alreadyGone);
            case ReconcileState.foreign:
              return result(CalendarWriteOutcome.notOurs);
            case ReconcileState.matches || ReconcileState.moved:
              await adapter.deleteSessionEvent(found.ref!, uid: draft.uid);
              return result(CalendarWriteOutcome.done, ref: found.ref);
          }
        case CalendarWriteAction.check:
          return switch (found.state) {
            // Nothing changed; nothing to report.
            ReconcileState.matches => null,
            ReconcileState.moved => result(
              CalendarWriteOutcome.moved,
              ref: found.ref,
              span: found.span,
            ),
            ReconcileState.missing => result(CalendarWriteOutcome.missing),
            ReconcileState.foreign => result(CalendarWriteOutcome.notOurs),
          };
      }
    } on CalendarCapabilityException catch (e) {
      return result(CalendarWriteOutcome.failed, message: e.message);
    } catch (e) {
      // Timeouts and platform errors: the next run reconciles by uid.
      return result(
        CalendarWriteOutcome.failed,
        message: 'The calendar did not answer. Pinne will try again.',
      );
    }
  }
}
