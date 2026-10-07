import 'package:pinne_calendar/pinne_calendar.dart' as cal;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'coverage.dart';
import 'session_item_source.dart';

/// Review-session planning for one owner.
///
/// Propose places sessions in free time and stores them uncommitted. Commit
/// checks availability again, then persists the sessions and one event link
/// per session (with its operation id) before any calendar is touched; the
/// device writes the event and reports the id back. Unknown or stale
/// availability never becomes free time: such plans cannot be committed as
/// checked, and the user may only keep them in Pinne, labelled unverified.
class Planner {
  Planner(
    this.session,
    this.owner, {
    this.items = const UnreviewedItemSource(),
  });

  final Session session;
  final UuidValue owner;
  final SessionItemSource items;

  /// A proposal older than this must be planned again.
  static const proposalLifetime = Duration(hours: 24);

  /// Estimated minutes per item until items carry real durations.
  static const minutesPerItem = 5;
  static const maxItemsPerSession = 5;

  /// Calendar titles never reveal what was saved.
  static const eventTitle = 'Pinne review';

  static PlannerPreferences defaults(UuidValue owner) => PlannerPreferences(
    ownerId: owner,
    horizon: PlanHorizon.week,
    weekdays: const [1, 2, 3, 4, 5, 6, 7],
    windowStartMinute: 18 * 60,
    windowEndMinute: 21 * 60,
    sessionMinutes: 15,
    maxSessions: 3,
    bufferMinutes: 10,
    minLeadMinutes: 60,
    timezone: 'UTC',
    approvalMode: ApprovalMode.confirm,
  );

  /// The stored preferences, or the defaults (with a null id) when the owner
  /// has not saved any.
  Future<PlannerPreferences> preferences({Transaction? transaction}) async =>
      await PlannerPreferences.db.findFirstRow(
        session,
        where: (t) => t.ownerId.equals(owner),
        transaction: transaction,
      ) ??
      defaults(owner);

  Future<PlannerPreferences> savePreferences(
    PlannerPreferencesDraft draft,
  ) async {
    final weekdays = {...draft.weekdays}.toList()..sort();
    final problem = _policyOf(
      draft.timezone,
      weekdays,
      draft.windowStartMinute,
      draft.windowEndMinute,
      draft.sessionMinutes,
      draft.maxSessions,
      draft.bufferMinutes,
      draft.minLeadMinutes,
    ).problem();
    if (problem != null) throw ValidationException(message: problem);
    final row = await PlannerPreferences.db.upsertRow(
      session,
      PlannerPreferences(
        ownerId: owner,
        horizon: draft.horizon,
        weekdays: weekdays,
        windowStartMinute: draft.windowStartMinute,
        windowEndMinute: draft.windowEndMinute,
        sessionMinutes: draft.sessionMinutes,
        maxSessions: draft.maxSessions,
        bufferMinutes: draft.bufferMinutes,
        minLeadMinutes: draft.minLeadMinutes,
        timezone: draft.timezone,
        approvalMode: draft.approvalMode,
      ),
      conflictColumns: (t) => [t.ownerId],
      updateWhere: (t) => t.ownerId.equals(owner),
    );
    return row!;
  }

  /// Plans sessions in the owner's horizon and stores them uncommitted,
  /// replacing any earlier uncommitted plan.
  Future<PlanProposal> propose(PlanRequest request) async {
    final prefs = await preferences();
    final policy = _policy(prefs);
    final problem = policy.problem();
    if (problem != null) throw ValidationException(message: problem);

    final now = DateTime.now().toUtc();
    final horizon = _horizon(prefs, now);
    final context = await _CalendarContext.load(session, owner);
    final assessment = assessCoverage(
      conflictCalendars: context.conflictCalendars,
      connections: context.connections,
      snapshots: request.availability,
      window: horizon,
      now: now,
    );
    final scheduled = await _scheduledSessions(horizon);
    final slots = cal.planSlots(
      policy: policy,
      horizon: horizon,
      now: now,
      busy: [
        for (final b in assessment.busy) b.span,
        for (final s in scheduled) _span(s),
      ],
    );

    final perSession = _itemsPerSession(prefs.sessionMinutes);
    final picked = await items.candidates(
      session,
      owner,
      limit: slots.slots.length * perSession,
      exclude: await _itemsInUpcomingSessions(now),
    );

    final plan = await session.db.transaction((tx) async {
      await _dropUncommittedPlans(tx);
      final plan = await ReviewPlan.db.insertRow(
        session,
        ReviewPlan(
          ownerId: owner,
          createdAt: now,
          horizonStart: horizon.start,
          horizonEnd: horizon.end,
          timezone: prefs.timezone,
          coverage: assessment.coverage,
          availabilityVerified: assessment.verified,
        ),
        transaction: tx,
      );
      final sessions = await ReviewSession.db.insert(session, [
        for (final slot in slots.slots)
          ReviewSession(
            ownerId: owner,
            planId: plan.id,
            startAt: slot.start,
            endAt: slot.end,
            timezone: prefs.timezone,
            status: SessionStatus.proposed,
            schedulingMode: prefs.approvalMode,
            availabilityVerified: assessment.verified,
          ),
      ], transaction: tx);
      final rows = <SessionItem>[];
      for (var s = 0; s < sessions.length; s++) {
        final share = picked.skip(s * perSession).take(perSession).toList();
        for (var p = 0; p < share.length; p++) {
          rows.add(
            SessionItem(
              ownerId: owner,
              sessionId: sessions[s].id!,
              itemId: share[p].id!,
              position: p,
              plannedMinutes: minutesPerItem,
              estimated: true,
            ),
          );
        }
      }
      if (rows.isNotEmpty) {
        await SessionItem.db.insert(session, rows, transaction: tx);
      }
      return plan;
    });

    return _proposal(
      plan,
      prefs,
      context,
      shortfall: _shortfall(slots, prefs),
    );
  }

  /// The latest uncommitted plan that can still be accepted, if any.
  Future<PlanProposal?> currentProposal() async {
    final plan = await ReviewPlan.db.findFirstRow(
      session,
      where: (t) =>
          t.ownerId.equals(owner) &
          t.commitOperationId.equals(null) &
          (t.createdAt > DateTime.now().toUtc().subtract(proposalLifetime)),
      orderByList: (t) => [t.createdAt.desc()],
    );
    if (plan == null) return null;
    return _proposal(
      plan,
      await preferences(),
      await _CalendarContext.load(session, owner),
    );
  }

  /// Accepts a plan. Retrying with the same operation id returns the same
  /// sessions and links without writing anything twice.
  Future<PlanCommitResult> commit(PlanCommitRequest request) async {
    try {
      return await _commit(request);
    } on DatabaseUniqueViolationException {
      // A concurrent retry of the same operation committed first.
      return _commit(request);
    }
  }

  Future<PlanCommitResult> _commit(PlanCommitRequest request) async {
    final now = DateTime.now().toUtc();
    final prefs = await preferences();
    final context = await _CalendarContext.load(session, owner);

    final outcome = await session.db.transaction((tx) async {
      final plan = await ReviewPlan.db.findFirstRow(
        session,
        where: (t) => t.id.equals(request.planId) & t.ownerId.equals(owner),
        transaction: tx,
        lockMode: LockMode.forUpdate,
      );
      if (plan == null) throw RecordNotFoundException(resource: 'plan');
      if (plan.commitOperationId != null) {
        if (plan.commitOperationId == request.operationId) return plan;
        throw PlanningException(
          code: PlanningErrorCode.planExpired,
          message: 'This plan was already accepted.',
        );
      }
      if (now.difference(plan.createdAt) > proposalLifetime) {
        throw PlanningException(
          code: PlanningErrorCode.planExpired,
          message: 'This plan is out of date. Plan again.',
        );
      }
      if (prefs.approvalMode == ApprovalMode.proposeOnly) {
        throw PlanningException(
          code: PlanningErrorCode.proposeOnly,
          message:
              'Your planner only suggests times. Switch it to "Ask me to '
              'accept" to schedule sessions.',
        );
      }
      final proposed = await ReviewSession.db.find(
        session,
        where: (t) =>
            t.ownerId.equals(owner) &
            t.planId.equals(plan.id!) &
            t.status.equals(SessionStatus.proposed),
        orderBy: (t) => t.startAt,
        transaction: tx,
      );
      if (proposed.isEmpty) {
        throw ValidationException(message: 'This plan has no sessions.');
      }

      final window = cal.TimeInterval(
        proposed.first.startAt,
        proposed.map((s) => s.endAt).reduce((a, b) => a.isAfter(b) ? a : b),
      );
      final assessment = assessCoverage(
        conflictCalendars: context.conflictCalendars,
        connections: context.connections,
        snapshots: request.availability,
        window: window,
        now: now,
      );
      if (!assessment.verified && !request.acceptUnverified) {
        throw PlanningException(
          code: PlanningErrorCode.availabilityUnverified,
          message:
              '${assessment.gap} Check your calendars again, or keep the '
              'sessions in Pinne without a calendar check.',
        );
      }
      final own = {for (final s in proposed) _eventUid(s.id!)};
      await _requireNoConflicts(
        proposed,
        busy: [
          for (final b in assessment.busy)
            if (!own.contains(b.sessionUid)) b.span,
        ],
        bufferMinutes: prefs.bufferMinutes,
        now: now,
        transaction: tx,
      );

      final target = assessment.verified ? context.writeTarget : null;
      await ReviewSession.db.update(session, [
        for (final s in proposed)
          s.copyWith(
            status: SessionStatus.scheduled,
            availabilityVerified: assessment.verified,
          ),
      ], transaction: tx);
      if (target != null) {
        await CalendarEventLink.db.insert(session, [
          for (final s in proposed)
            CalendarEventLink(
              ownerId: owner,
              sessionId: s.id!,
              selectionId: target.id!,
              deviceId: target.deviceId,
              eventUid: _eventUid(s.id!),
              syncState: EventSyncState.pendingCreate,
              operationId: request.operationId,
              updatedAt: now,
            ),
        ], transaction: tx);
      }
      // Other uncommitted plans are now out of date.
      await _dropUncommittedPlans(tx, keep: plan.id);
      return ReviewPlan.db.updateRow(
        session,
        plan.copyWith(
          commitOperationId: request.operationId,
          committedAt: now,
          coverage: assessment.coverage,
          availabilityVerified: assessment.verified,
        ),
        transaction: tx,
      );
    });

    final sessions = await ReviewSession.db.find(
      session,
      where: (t) =>
          t.ownerId.equals(owner) &
          t.planId.equals(outcome.id!) &
          t.status.notEquals(SessionStatus.proposed),
      orderBy: (t) => t.startAt,
    );
    return PlanCommitResult(
      sessions: await _views(sessions, context),
      writes: await _writesFor(
        request.deviceId,
        context,
        sessionIds: {for (final s in sessions) s.id!},
      ),
    );
  }

  /// Scheduled sessions overlapping [from, to), in time order.
  Future<List<SessionView>> sessions(DateTime from, DateTime to) async {
    if (!to.isAfter(from)) return const [];
    final rows = await ReviewSession.db.find(
      session,
      where: (t) =>
          t.ownerId.equals(owner) &
          t.status.equals(SessionStatus.scheduled) &
          (t.startAt < to.toUtc()) &
          (t.endAt > from.toUtc()),
      orderBy: (t) => t.startAt,
    );
    return _views(rows, await _CalendarContext.load(session, owner));
  }

  /// Moves a scheduled session after checking the new time against fresh
  /// availability, then queues the calendar update.
  Future<SessionChangeResult> move(SessionMoveRequest request) async {
    final now = DateTime.now().toUtc();
    final prefs = await preferences();
    final context = await _CalendarContext.load(session, owner);
    final moved = await session.db.transaction((tx) async {
      final current = await _scheduled(request.sessionId, tx);
      if (current.lastOperationId == request.operationId) return current;
      final span = cal.TimeInterval(
        request.startAt,
        request.startAt.add(_span(current).duration),
      );
      final assessment = assessCoverage(
        conflictCalendars: context.conflictCalendars,
        connections: context.connections,
        snapshots: request.availability,
        window: span,
        now: now,
      );
      if (!assessment.verified && !request.acceptUnverified) {
        throw PlanningException(
          code: PlanningErrorCode.availabilityUnverified,
          message: '${assessment.gap} Check your calendars again first.',
        );
      }
      final uid = _eventUid(current.id!);
      final next = current.copyWith(
        startAt: span.start,
        endAt: span.end,
        planRevision: current.planRevision + 1,
        lastOperationId: request.operationId,
        availabilityVerified: assessment.verified,
      );
      await _requireNoConflicts(
        [next],
        busy: [
          for (final b in assessment.busy)
            if (b.sessionUid != uid) b.span,
        ],
        bufferMinutes: prefs.bufferMinutes,
        now: now,
        transaction: tx,
      );
      await _queueLinks(
        current.id!,
        request.operationId,
        tx,
        (state) => switch (state) {
          EventSyncState.synced ||
          EventSyncState.pendingUpdate => EventSyncState.pendingUpdate,
          _ => state,
        },
      );
      return ReviewSession.db.updateRow(session, next, transaction: tx);
    });
    return _change(moved, request.deviceId, context);
  }

  /// Cancels a scheduled session and queues removal of its event. The event
  /// is only removed if it still carries this session's marker.
  Future<SessionChangeResult> cancel(
    UuidValue sessionId,
    UuidValue operationId,
    UuidValue? deviceId,
  ) async {
    final context = await _CalendarContext.load(session, owner);
    final cancelled = await session.db.transaction((tx) async {
      final current = await ReviewSession.db.findFirstRow(
        session,
        where: (t) => t.id.equals(sessionId) & t.ownerId.equals(owner),
        transaction: tx,
        lockMode: LockMode.forUpdate,
      );
      if (current == null) throw RecordNotFoundException(resource: 'session');
      if (current.status == SessionStatus.cancelled) return current;
      if (current.status != SessionStatus.scheduled) {
        throw ValidationException(message: 'Only scheduled sessions cancel.');
      }
      await _queueLinks(
        sessionId,
        operationId,
        tx,
        (state) => switch (state) {
          // A create that was never confirmed may still have happened, so
          // the device looks for it by uid before giving up.
          EventSyncState.pendingCreate ||
          EventSyncState.synced ||
          EventSyncState.pendingUpdate => EventSyncState.pendingDelete,
          _ => state,
        },
      );
      return ReviewSession.db.updateRow(
        session,
        current.copyWith(
          status: SessionStatus.cancelled,
          planRevision: current.planRevision + 1,
          lastOperationId: operationId,
        ),
        transaction: tx,
      );
    });
    return _change(cancelled, deviceId, context);
  }

  /// Calendar work waiting for [deviceId]: pending writes, and a check of
  /// every upcoming synced event so outside moves and removals are seen.
  Future<List<CalendarWrite>> deviceWork(UuidValue deviceId) async =>
      _writesFor(
        deviceId,
        await _CalendarContext.load(session, owner),
        includeChecks: true,
      );

  /// Records what the device did. Results for an older session revision
  /// keep newer work pending. Repeated results change nothing.
  Future<void> reportWrites(List<CalendarWriteResult> results) async {
    final now = DateTime.now().toUtc();
    await session.db.transaction((tx) async {
      for (final result in results) {
        final link = await CalendarEventLink.db.findFirstRow(
          session,
          where: (t) => t.id.equals(result.linkId) & t.ownerId.equals(owner),
          transaction: tx,
          lockMode: LockMode.forUpdate,
        );
        if (link == null) {
          throw RecordNotFoundException(resource: 'calendar event');
        }
        final current = await ReviewSession.db.findFirstRow(
          session,
          where: (t) => t.id.equals(link.sessionId) & t.ownerId.equals(owner),
          transaction: tx,
          lockMode: LockMode.forUpdate,
        );
        if (current == null) continue;
        await _applyResult(result, link, current, now, tx);
      }
    });
  }

  Future<void> _applyResult(
    CalendarWriteResult result,
    CalendarEventLink link,
    ReviewSession current,
    DateTime now,
    Transaction tx,
  ) async {
    final eventId = result.externalEventId ?? link.externalEventId;
    final upToDate = result.sessionRevision == current.planRevision;
    var state = link.syncState;
    var lastError = link.lastError;
    ReviewSession? adopted;

    switch (result.outcome) {
      case CalendarWriteOutcome.done:
        final settles = switch (result.action) {
          CalendarWriteAction.create => state == EventSyncState.pendingCreate,
          CalendarWriteAction.update => state == EventSyncState.pendingUpdate,
          CalendarWriteAction.delete => state == EventSyncState.pendingDelete,
          CalendarWriteAction.check => false,
        };
        if (settles && upToDate) {
          state = result.action == CalendarWriteAction.delete
              ? EventSyncState.deleted
              : EventSyncState.synced;
        } else if (result.action == CalendarWriteAction.create &&
            state == EventSyncState.pendingCreate) {
          // Created at an older time; the device must still move it.
          state = EventSyncState.pendingUpdate;
        }
        lastError = null;
      case CalendarWriteOutcome.alreadyGone:
        if (state == EventSyncState.pendingDelete) {
          state = EventSyncState.deleted;
        }
      case CalendarWriteOutcome.notOurs:
        // The id now names someone else's event: never touch it again.
        state = EventSyncState.foreign;
      case CalendarWriteOutcome.moved:
        // Declared rule: an edit the user makes in their calendar app wins.
        final start = result.startAt, end = result.endAt;
        if (start != null &&
            end != null &&
            end.isAfter(start) &&
            current.status == SessionStatus.scheduled &&
            (start.toUtc() != current.startAt ||
                end.toUtc() != current.endAt)) {
          adopted = current.copyWith(
            startAt: start.toUtc(),
            endAt: end.toUtc(),
            planRevision: current.planRevision + 1,
          );
        }
        if (state != EventSyncState.pendingDelete) {
          state = EventSyncState.synced;
        }
      case CalendarWriteOutcome.missing:
        // Removed in the calendar app: the session is cancelled with it.
        if (state == EventSyncState.pendingDelete) {
          state = EventSyncState.deleted;
        } else {
          state = EventSyncState.missing;
          if (current.status == SessionStatus.scheduled) {
            adopted = current.copyWith(
              status: SessionStatus.cancelled,
              planRevision: current.planRevision + 1,
            );
          }
        }
      case CalendarWriteOutcome.failed:
        lastError = result.message ?? 'The calendar did not accept the change.';
    }

    await CalendarEventLink.db.updateRow(
      session,
      link.copyWith(
        externalEventId: eventId,
        providerRevision: result.providerRevision ?? link.providerRevision,
        syncState: state,
        lastError: lastError,
        updatedAt: now,
      ),
      transaction: tx,
    );
    if (adopted != null) {
      await ReviewSession.db.updateRow(session, adopted, transaction: tx);
    }
  }

  /// An export-only iCalendar file of the owner's sessions.
  Future<String> exportIcs(List<UuidValue> sessionIds) async {
    final ids = sessionIds.toSet();
    if (ids.isEmpty) throw ValidationException(message: 'Nothing to export.');
    if (ids.length > 100) {
      throw ValidationException(message: 'Export at most 100 sessions.');
    }
    final rows = await ReviewSession.db.find(
      session,
      where: (t) => t.ownerId.equals(owner) & t.id.inSet(ids),
      orderBy: (t) => t.startAt,
    );
    if (rows.length != ids.length) {
      throw RecordNotFoundException(resource: 'session');
    }
    final counts = await _itemCounts(ids);
    return cal.encodeIcs([
      for (final s in rows)
        if (s.status != SessionStatus.cancelled)
          cal.IcsEvent(
            uid: '${_eventUid(s.id!)}@pinne',
            span: _span(s),
            summary: eventTitle,
            description: _notes(counts[s.id] ?? 0, s.availabilityVerified),
            tentative: s.status == SessionStatus.proposed,
          ),
    ], stamp: DateTime.now().toUtc());
  }

  // ---------------------------------------------------------------------

  static cal.PlanningPolicy _policy(PlannerPreferences p) => _policyOf(
    p.timezone,
    p.weekdays,
    p.windowStartMinute,
    p.windowEndMinute,
    p.sessionMinutes,
    p.maxSessions,
    p.bufferMinutes,
    p.minLeadMinutes,
  );

  static cal.PlanningPolicy _policyOf(
    String timezone,
    List<int> weekdays,
    int windowStart,
    int windowEnd,
    int sessionMinutes,
    int maxSessions,
    int buffer,
    int lead,
  ) => cal.PlanningPolicy(
    timezone: timezone,
    weekdays: weekdays.toSet(),
    windowStartMinute: windowStart,
    windowEndMinute: windowEnd,
    sessionMinutes: sessionMinutes,
    maxSessions: maxSessions,
    bufferMinutes: buffer,
    minLeadMinutes: lead,
  );

  /// From now to the end of the seventh local day, or to the same date next
  /// month.
  static cal.TimeInterval _horizon(PlannerPreferences prefs, DateTime now) {
    final today = cal.LocalDate.inZone(now, prefs.timezone);
    final last = switch (prefs.horizon) {
      PlanHorizon.week => today.addDays(7),
      PlanHorizon.month => cal.LocalDate.of(
        today.year,
        today.month + 1,
        today.day,
      ),
    };
    return cal.TimeInterval(now, last.at(prefs.timezone, 0));
  }

  static int _itemsPerSession(int sessionMinutes) =>
      (sessionMinutes ~/ minutesPerItem).clamp(1, maxItemsPerSession);

  static String? _shortfall(cal.SlotPlan slots, PlannerPreferences prefs) =>
      switch (slots.shortfall) {
        null => null,
        cal.ShortfallReason.noEligibleDays =>
          'None of your chosen days fall in this period. Add days or plan a '
              'longer period.',
        cal.ShortfallReason.noFreeWindow =>
          'No free ${prefs.sessionMinutes}-minute gap in your chosen times '
              'this period. Try a wider window or shorter sessions.',
      };

  static cal.TimeInterval _span(ReviewSession s) =>
      cal.TimeInterval(s.startAt, s.endAt);

  static String _eventUid(UuidValue sessionId) => 'pinne-${sessionId.uuid}';

  static String _notes(int itemCount, bool verified) {
    final items = itemCount == 1 ? '1 saved item' : '$itemCount saved items';
    final check = verified
        ? ''
        : '\nPinne did not check your calendar for this time.';
    return 'Review time planned by Pinne: $items. Open Pinne to see them.'
        '$check';
  }

  Future<List<ReviewSession>> _scheduledSessions(
    cal.TimeInterval window, {
    Transaction? transaction,
  }) => ReviewSession.db.find(
    session,
    where: (t) =>
        t.ownerId.equals(owner) &
        t.status.equals(SessionStatus.scheduled) &
        (t.startAt < window.end) &
        (t.endAt > window.start),
    transaction: transaction,
  );

  Future<Set<UuidValue>> _itemsInUpcomingSessions(DateTime now) async {
    final upcoming = await ReviewSession.db.find(
      session,
      where: (t) =>
          t.ownerId.equals(owner) &
          t.status.equals(SessionStatus.scheduled) &
          (t.endAt > now),
    );
    if (upcoming.isEmpty) return {};
    final rows = await SessionItem.db.find(
      session,
      where: (t) =>
          t.ownerId.equals(owner) &
          t.sessionId.inSet({for (final s in upcoming) s.id!}),
    );
    return {for (final r in rows) r.itemId};
  }

  Future<void> _dropUncommittedPlans(Transaction tx, {UuidValue? keep}) async {
    final stale = await ReviewPlan.db.find(
      session,
      where: (t) => t.ownerId.equals(owner) & t.commitOperationId.equals(null),
      transaction: tx,
    );
    final drop = {
      for (final p in stale)
        if (p.id != keep) p.id!,
    };
    if (drop.isEmpty) return;
    await ReviewSession.db.deleteWhere(
      session,
      where: (t) =>
          t.ownerId.equals(owner) &
          t.planId.inSet(drop) &
          t.status.equals(SessionStatus.proposed),
      transaction: tx,
    );
    await ReviewPlan.db.deleteWhere(
      session,
      where: (t) => t.ownerId.equals(owner) & t.id.inSet(drop),
      transaction: tx,
    );
  }

  /// Throws [PlanningException.conflict] when a session starts in the past
  /// or overlaps a busy time (padded by the buffer) or another scheduled
  /// session of the owner.
  Future<void> _requireNoConflicts(
    List<ReviewSession> candidates, {
    required List<cal.TimeInterval> busy,
    required int bufferMinutes,
    required DateTime now,
    required Transaction transaction,
  }) async {
    final buffer = Duration(minutes: bufferMinutes);
    final window = cal.TimeInterval(
      candidates.first.startAt.subtract(const Duration(days: 1)),
      candidates.last.endAt.add(const Duration(days: 1)),
    );
    final ids = {for (final c in candidates) c.id};
    final others = [
      for (final s in await _scheduledSessions(
        window,
        transaction: transaction,
      ))
        if (!ids.contains(s.id)) _span(s),
    ];
    final blocked = cal.mergeIntervals([
      for (final b in busy) b.padded(before: buffer, after: buffer),
      ...others,
    ]);
    final clashing = [
      for (final c in candidates)
        if (c.startAt.isBefore(now) || blocked.any(_span(c).overlaps)) c.id!,
    ];
    if (clashing.isEmpty) return;
    throw PlanningException(
      code: PlanningErrorCode.conflict,
      message:
          'Something new is in your calendar at ${clashing.length == 1 ? 'one of these times' : 'some of these times'}. '
          'Plan again to pick free times.',
      sessionIds: clashing,
    );
  }

  Future<ReviewSession> _scheduled(UuidValue id, Transaction tx) async {
    final current = await ReviewSession.db.findFirstRow(
      session,
      where: (t) => t.id.equals(id) & t.ownerId.equals(owner),
      transaction: tx,
      lockMode: LockMode.forUpdate,
    );
    if (current == null) throw RecordNotFoundException(resource: 'session');
    if (current.status != SessionStatus.scheduled) {
      throw ValidationException(message: 'Only scheduled sessions can move.');
    }
    return current;
  }

  Future<void> _queueLinks(
    UuidValue sessionId,
    UuidValue operationId,
    Transaction tx,
    EventSyncState Function(EventSyncState) next,
  ) async {
    final links = await CalendarEventLink.db.find(
      session,
      where: (t) => t.ownerId.equals(owner) & t.sessionId.equals(sessionId),
      transaction: tx,
    );
    final changed = [
      for (final link in links)
        if (next(link.syncState) != link.syncState)
          link.copyWith(
            syncState: next(link.syncState),
            operationId: operationId,
            updatedAt: DateTime.now().toUtc(),
          ),
    ];
    if (changed.isNotEmpty) {
      await CalendarEventLink.db.update(session, changed, transaction: tx);
    }
  }

  Future<SessionChangeResult> _change(
    ReviewSession changed,
    UuidValue? deviceId,
    _CalendarContext context,
  ) async => SessionChangeResult(
    session: (await _views([changed], context)).single,
    writes: await _writesFor(deviceId, context, sessionIds: {changed.id!}),
  );

  Future<Map<UuidValue, int>> _itemCounts(Set<UuidValue> sessionIds) async {
    final rows = await SessionItem.db.find(
      session,
      where: (t) => t.ownerId.equals(owner) & t.sessionId.inSet(sessionIds),
    );
    final counts = <UuidValue, int>{};
    for (final r in rows) {
      counts[r.sessionId] = (counts[r.sessionId] ?? 0) + 1;
    }
    return counts;
  }

  Future<PlanProposal> _proposal(
    ReviewPlan plan,
    PlannerPreferences prefs,
    _CalendarContext context, {
    String? shortfall,
  }) async {
    final sessions = await ReviewSession.db.find(
      session,
      where: (t) =>
          t.ownerId.equals(owner) &
          t.planId.equals(plan.id!) &
          t.status.equals(SessionStatus.proposed),
      orderBy: (t) => t.startAt,
    );
    final String? blocked;
    if (sessions.isEmpty) {
      blocked = 'There is nothing to accept.';
    } else if (prefs.approvalMode == ApprovalMode.proposeOnly) {
      blocked = 'Your planner only suggests times.';
    } else if (!plan.availabilityVerified) {
      blocked = CoverageAssessment(
        coverage: plan.coverage,
        busy: const [],
        verified: false,
      ).gap;
    } else {
      blocked = null;
    }
    return PlanProposal(
      plan: plan,
      sessions: await _views(sessions, context),
      approvalMode: prefs.approvalMode,
      canCommit: blocked == null,
      commitBlockedReason: blocked,
      shortfall: shortfall,
      writeCalendarName: context.writeTarget?.name,
    );
  }

  Future<List<SessionView>> _views(
    List<ReviewSession> rows,
    _CalendarContext context,
  ) async {
    if (rows.isEmpty) return const [];
    final ids = {for (final s in rows) s.id!};
    final members = await SessionItem.db.find(
      session,
      where: (t) => t.ownerId.equals(owner) & t.sessionId.inSet(ids),
      orderBy: (t) => t.position,
    );
    final titles = {
      for (final item in await Item.db.find(
        session,
        where: (t) =>
            t.ownerId.equals(owner) &
            t.id.inSet(<UuidValue>{for (final m in members) m.itemId}),
      ))
        item.id!: item.title,
    };
    final links = {
      for (final link in await CalendarEventLink.db.find(
        session,
        where: (t) => t.ownerId.equals(owner) & t.sessionId.inSet(ids),
      ))
        link.sessionId: link,
    };
    return [
      for (final s in rows)
        SessionView(
          session: s,
          items: [
            for (final m in members)
              if (m.sessionId == s.id && titles.containsKey(m.itemId))
                SessionItemView(
                  itemId: m.itemId,
                  title: titles[m.itemId]!,
                  plannedMinutes: m.plannedMinutes,
                  estimated: m.estimated,
                ),
          ],
          calendarName: context.selections[links[s.id]?.selectionId]?.name,
          syncState: links[s.id]?.syncState,
        ),
    ];
  }

  /// Device-scoped work: only links written by [deviceId] are returned, so
  /// another phone never acts on this phone's calendar ids.
  Future<List<CalendarWrite>> _writesFor(
    UuidValue? deviceId,
    _CalendarContext context, {
    Set<UuidValue>? sessionIds,
    bool includeChecks = false,
  }) async {
    if (deviceId == null) return const [];
    const pending = {
      EventSyncState.pendingCreate,
      EventSyncState.pendingUpdate,
      EventSyncState.pendingDelete,
    };
    final links = await CalendarEventLink.db.find(
      session,
      where: (t) {
        var where =
            t.ownerId.equals(owner) &
            t.deviceId.equals(deviceId) &
            t.syncState.inSet({
              ...pending,
              if (includeChecks) EventSyncState.synced,
            });
        if (sessionIds != null) where = where & t.sessionId.inSet(sessionIds);
        return where;
      },
    );
    if (links.isEmpty) return const [];
    final sessions = {
      for (final s in await ReviewSession.db.find(
        session,
        where: (t) =>
            t.ownerId.equals(owner) &
            t.id.inSet(<UuidValue>{for (final l in links) l.sessionId}),
      ))
        s.id!: s,
    };
    final counts = await _itemCounts(sessions.keys.toSet());
    final now = DateTime.now().toUtc();
    final writes = <CalendarWrite>[];
    for (final link in links) {
      final s = sessions[link.sessionId];
      final selection = context.selections[link.selectionId];
      if (s == null || selection == null) continue;
      final action = switch (link.syncState) {
        EventSyncState.pendingCreate => CalendarWriteAction.create,
        EventSyncState.pendingUpdate => CalendarWriteAction.update,
        EventSyncState.pendingDelete => CalendarWriteAction.delete,
        _ => CalendarWriteAction.check,
      };
      // Past events are left alone; only upcoming ones are watched.
      if (action == CalendarWriteAction.check &&
          (s.status != SessionStatus.scheduled || !s.endAt.isAfter(now))) {
        continue;
      }
      writes.add(
        CalendarWrite(
          linkId: link.id!,
          action: action,
          sessionId: s.id!,
          eventUid: link.eventUid,
          externalCalendarId: selection.externalCalendarId,
          externalEventId: link.externalEventId,
          startAt: s.startAt,
          endAt: s.endAt,
          timezone: s.timezone,
          title: eventTitle,
          notes:
              '${_notes(counts[s.id] ?? 0, s.availabilityVerified)}\n\n'
              '${cal.SessionMarker.line(link.eventUid)}',
          sessionRevision: s.planRevision,
        ),
      );
    }
    writes.sort((a, b) => a.startAt.compareTo(b.startAt));
    return writes;
  }
}

/// The owner's calendars, loaded once per request.
class _CalendarContext {
  _CalendarContext(this.connections, this.selections);

  static Future<_CalendarContext> load(
    Session session,
    UuidValue owner,
  ) async {
    final connections = await CalendarConnection.db.find(
      session,
      where: (t) => t.ownerId.equals(owner),
    );
    final selections = await CalendarSelection.db.find(
      session,
      where: (t) => t.ownerId.equals(owner),
      orderBy: (t) => t.name,
    );
    return _CalendarContext(
      {for (final c in connections) c.id!: c},
      {for (final s in selections) s.id!: s},
    );
  }

  final Map<UuidValue, CalendarConnection> connections;
  final Map<UuidValue, CalendarSelection> selections;

  List<CalendarSelection> get conflictCalendars => [
    for (final s in selections.values)
      if (s.useForConflicts) s,
  ];

  /// The calendar sessions are written to, when its route may write.
  CalendarSelection? get writeTarget {
    for (final s in selections.values) {
      if (!s.useForWrites || s.readOnly) continue;
      final permission = connections[s.connectionId]?.permission;
      if (permission == CalendarPermission.granted ||
          permission == CalendarPermission.writeOnly) {
        return s;
      }
    }
    return null;
  }
}
