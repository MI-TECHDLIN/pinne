import 'package:pinne_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart' show Uuid, UuidValue;
import 'package:test/test.dart';

import 'calendar_fixtures.dart';
import 'owner_fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

Matcher _planning(PlanningErrorCode code) =>
    throwsA(isA<PlanningException>().having((e) => e.code, 'code', code));

UuidValue _op() => const Uuid().v4obj();

void main() {
  withServerpod('Given the planner', (sessionBuilder, endpoints) {
    late TestSessionBuilder alice;
    late TestSessionBuilder bob;
    late PhoneCalendars phone;

    setUp(() async {
      alice = await signedInAs(sessionBuilder);
      bob = await signedInAs(sessionBuilder);
      await endpoints.planner.savePreferences(alice, anyTimePreferences());
      phone = await PhoneCalendars.connect(endpoints, alice);
    });

    Future<PlanProposal> propose({
      List<BusyInterval> work = const [],
      List<BusyInterval> family = const [],
      List<AvailabilitySnapshot>? availability,
    }) => endpoints.planner.propose(
      alice,
      PlanRequest(
        availability:
            availability ?? phone.readings(work: work, family: family),
      ),
    );

    Future<PlanCommitResult> commit(
      PlanProposal proposal, {
      UuidValue? operationId,
      List<AvailabilitySnapshot>? availability,
      bool acceptUnverified = false,
      UuidValue? deviceId,
    }) => endpoints.planner.commit(
      alice,
      PlanCommitRequest(
        planId: proposal.plan.id!,
        operationId: operationId ?? _op(),
        availability: availability ?? phone.readings(),
        acceptUnverified: acceptUnverified,
        deviceId: deviceId ?? phone.deviceId,
      ),
    );

    group('when proposing', () {
      test(
        'then sessions are not committed and coverage is disclosed',
        () async {
          final proposal = await propose();
          expect(proposal.sessions, hasLength(3));
          for (final view in proposal.sessions) {
            expect(view.session.status, SessionStatus.proposed);
            expect(view.syncState, isNull);
          }
          expect(proposal.plan.availabilityVerified, isTrue);
          expect(proposal.canCommit, isTrue);
          expect(proposal.writeCalendarName, 'Family');
          expect(
            proposal.plan.coverage.map((c) => (c.calendarName, c.state)),
            unorderedEquals([
              ('Work', CoverageState.checked),
              ('Family', CoverageState.checked),
            ]),
          );
          // Holidays is not a conflict calendar, so it is not claimed.
          expect(
            proposal.plan.coverage.map((c) => c.calendarName),
            isNot(contains('Holidays')),
          );
        },
      );

      test(
        'then overlapping busy times merge and no session overlaps them',
        () async {
          final now = DateTime.now().toUtc();
          final work = [busy(now, const Duration(hours: 5))];
          final family = [
            busy(now.add(const Duration(hours: 4)), const Duration(hours: 4)),
          ];
          final proposal = await propose(work: work, family: family);
          final first = proposal.sessions.first.session;
          expect(
            first.startAt.isBefore(now.add(const Duration(hours: 8))),
            isFalse,
          );
          for (final view in proposal.sessions) {
            for (final block in [...work, ...family]) {
              final overlaps =
                  view.session.startAt.isBefore(block.endAt) &&
                  block.startAt.isBefore(view.session.endAt);
              expect(overlaps, isFalse);
            }
          }
        },
      );

      test('then unknown availability is never treated as free', () async {
        final proposal = await propose(availability: []);
        expect(proposal.sessions, isNotEmpty);
        expect(proposal.plan.availabilityVerified, isFalse);
        expect(proposal.canCommit, isFalse);
        expect(proposal.commitBlockedReason, contains('Work'));
        expect(
          proposal.plan.coverage.map((c) => c.state),
          everyElement(CoverageState.notChecked),
        );
      });

      test(
        'then a stale or unreadable reading leaves the plan unverified',
        () async {
          final stale = await propose(
            availability: phone.readings(
              checkedAt: DateTime.now().toUtc().subtract(
                const Duration(hours: 1),
              ),
            ),
          );
          expect(stale.canCommit, isFalse);
          expect(
            stale.plan.coverage.map((c) => c.state),
            everyElement(CoverageState.stale),
          );

          final unreadable = await propose(
            availability: [
              snapshot(phone.work.id!, [], readable: false),
              snapshot(phone.family.id!, []),
            ],
          );
          expect(unreadable.canCommit, isFalse);
          expect(unreadable.commitBlockedReason, contains('could not be read'));
        },
      );

      test(
        'then with no conflict calendar chosen nothing is verified',
        () async {
          await endpoints.calendar.setSelections(alice, phone.connection.id!, [
            for (final s in [phone.work, phone.family])
              CalendarSelectionChoice(
                selectionId: s.id!,
                useForConflicts: false,
                useForWrites: false,
              ),
          ]);
          final proposal = await propose();
          expect(proposal.plan.coverage, isEmpty);
          expect(proposal.canCommit, isFalse);
          expect(
            proposal.commitBlockedReason,
            contains('No calendar is chosen'),
          );
        },
      );

      test('then a newer proposal replaces the older one', () async {
        final first = await propose();
        final second = await propose();
        final current = await endpoints.planner.currentProposal(alice);
        expect(current!.plan.id, second.plan.id);
        await expectLater(
          commit(first),
          throwsA(isA<RecordNotFoundException>()),
        );
      });

      test('then sessions hold unreviewed active items only', () async {
        final keep = await endpoints.item.create(
          alice,
          ItemDraft(title: 'Keep'),
        );
        final archived = await endpoints.item.create(
          alice,
          ItemDraft(title: 'Archived'),
        );
        await endpoints.item.update(
          alice,
          archived.copyWith(lifecycle: ItemLifecycle.archived),
        );
        final reviewed = await endpoints.item.create(
          alice,
          ItemDraft(title: 'Reviewed'),
        );
        final undone = await endpoints.item.create(
          alice,
          ItemDraft(title: 'Undone'),
        );
        final opened = await endpoints.item.create(
          alice,
          ItemDraft(title: 'Opened only'),
        );
        final session = alice.build();
        ReviewEvent event(
          Item item,
          ReviewEventType type, {
          UuidValue? undoes,
        }) => ReviewEvent(
          ownerId: item.ownerId,
          itemId: item.id!,
          eventType: type,
          occurredAt: DateTime.now().toUtc(),
          timezone: 'UTC',
          effectiveLocalDate: '2026-10-06',
          compensatesEventId: undoes,
        );
        await ReviewEvent.db.insertRow(
          session,
          event(reviewed, ReviewEventType.reviewed),
        );
        final mistaken = await ReviewEvent.db.insertRow(
          session,
          event(undone, ReviewEventType.completed),
        );
        await ReviewEvent.db.insertRow(
          session,
          event(undone, ReviewEventType.undo, undoes: mistaken.id),
        );
        await ReviewEvent.db.insertRow(
          session,
          event(opened, ReviewEventType.opened),
        );

        final proposal = await propose();
        final titles = [
          for (final view in proposal.sessions)
            for (final item in view.items) item.title,
        ];
        expect(titles, unorderedEquals(['Keep', 'Undone', 'Opened only']));
        expect(
          proposal.sessions.expand((v) => v.items).every((i) => i.estimated),
          isTrue,
        );
        expect(keep.id, isNotNull);
      });
    });

    group('when committing', () {
      test('then unknown availability blocks commit (BR04)', () async {
        final proposal = await propose(availability: []);
        await expectLater(
          commit(proposal, availability: []),
          _planning(PlanningErrorCode.availabilityUnverified),
        );
        // A fresh reading of only one calendar is still not enough.
        await expectLater(
          commit(proposal, availability: [snapshot(phone.work.id!, [])]),
          _planning(PlanningErrorCode.availabilityUnverified),
        );
        final upcoming = await endpoints.planner.sessions(
          alice,
          DateTime.now(),
          DateTime.now().add(const Duration(days: 40)),
        );
        expect(upcoming, isEmpty);
      });

      test('then a stale reading at commit time blocks it', () async {
        final proposal = await propose();
        await expectLater(
          commit(
            proposal,
            availability: phone.readings(
              checkedAt: DateTime.now().toUtc().subtract(
                const Duration(minutes: 30),
              ),
            ),
          ),
          _planning(PlanningErrorCode.availabilityUnverified),
        );
      });

      test(
        'then keeping unverified sessions saves them in Pinne only',
        () async {
          final proposal = await propose(availability: []);
          final result = await commit(
            proposal,
            availability: [],
            acceptUnverified: true,
          );
          expect(result.writes, isEmpty);
          for (final view in result.sessions) {
            expect(view.session.status, SessionStatus.scheduled);
            expect(view.session.availabilityVerified, isFalse);
            expect(view.syncState, isNull);
          }
        },
      );

      test(
        'then the session and its operation are stored before any write',
        () async {
          final proposal = await propose();
          final operationId = _op();
          final result = await commit(proposal, operationId: operationId);
          expect(result.sessions, hasLength(3));
          expect(result.writes, hasLength(3));
          for (final write in result.writes) {
            expect(write.action, CalendarWriteAction.create);
            expect(write.externalCalendarId, '2');
            expect(write.externalEventId, isNull);
            expect(write.title, 'Pinne review');
            expect(write.notes, contains('pinne-session:${write.eventUid}'));
          }
          final links = await CalendarEventLink.db.find(
            alice.build(),
            where: (t) => t.operationId.equals(operationId),
          );
          expect(links, hasLength(3));
          expect(
            links.map((l) => l.syncState),
            everyElement(EventSyncState.pendingCreate),
          );
        },
      );

      test(
        'then a retry after an ambiguous timeout duplicates nothing',
        () async {
          final proposal = await propose();
          final operationId = _op();
          final first = await commit(proposal, operationId: operationId);
          // The response was lost; the app retries with the same operation,
          // even with availability that would now clash.
          final now = DateTime.now().toUtc();
          final retry = await commit(
            proposal,
            operationId: operationId,
            availability: phone.readings(
              work: [busy(now, const Duration(days: 30))],
            ),
          );
          expect(
            retry.sessions.map((v) => v.session.id),
            first.sessions.map((v) => v.session.id),
          );
          expect(
            retry.writes.map((w) => (w.linkId, w.eventUid)),
            first.writes.map((w) => (w.linkId, w.eventUid)),
          );
          final links = await CalendarEventLink.db.count(alice.build());
          expect(links, 3);

          // The device confirms twice (the first confirmation also timed out).
          final results = [
            for (final w in first.writes)
              CalendarWriteResult(
                linkId: w.linkId,
                action: w.action,
                outcome: CalendarWriteOutcome.done,
                sessionRevision: w.sessionRevision,
                externalEventId: 'evt-${w.eventUid}',
              ),
          ];
          await endpoints.planner.reportWrites(alice, results);
          await endpoints.planner.reportWrites(alice, results);
          final work = await endpoints.planner.deviceWork(
            alice,
            phone.deviceId,
          );
          expect(
            work.map((w) => w.action),
            everyElement(CalendarWriteAction.check),
          );
          expect(
            work.map((w) => w.externalEventId),
            everyElement(startsWith('evt-')),
          );
        },
      );

      test('then a different operation cannot accept the plan again', () async {
        final proposal = await propose();
        await commit(proposal);
        await expectLater(
          commit(proposal),
          _planning(PlanningErrorCode.planExpired),
        );
      });

      test(
        'then a new busy time found at commit revises nothing and says so',
        () async {
          final proposal = await propose();
          final clash = proposal.sessions[1].session;
          await expectLater(
            commit(
              proposal,
              availability: phone.readings(
                family: [busy(clash.startAt, const Duration(minutes: 5))],
              ),
            ),
            throwsA(
              isA<PlanningException>()
                  .having((e) => e.code, 'code', PlanningErrorCode.conflict)
                  .having((e) => e.sessionIds, 'sessionIds', [clash.id]),
            ),
          );
          final current = await endpoints.planner.currentProposal(alice);
          expect(current!.sessions.map((v) => v.session.status), [
            SessionStatus.proposed,
            SessionStatus.proposed,
            SessionStatus.proposed,
          ]);
        },
      );

      test('then the buffer counts at commit time', () async {
        await endpoints.planner.savePreferences(
          alice,
          anyTimePreferences(bufferMinutes: 30),
        );
        final proposal = await propose();
        final first = proposal.sessions.first.session;
        await expectLater(
          commit(
            proposal,
            availability: phone.readings(
              work: [
                busy(
                  first.endAt.add(const Duration(minutes: 10)),
                  const Duration(minutes: 30),
                ),
              ],
            ),
          ),
          _planning(PlanningErrorCode.conflict),
        );
      });

      test('then a propose-only planner cannot commit', () async {
        await endpoints.planner.savePreferences(
          alice,
          anyTimePreferences(approvalMode: ApprovalMode.proposeOnly),
        );
        final proposal = await propose();
        expect(proposal.canCommit, isFalse);
        await expectLater(
          commit(proposal),
          _planning(PlanningErrorCode.proposeOnly),
        );
      });

      test('then a write-only phone cannot verify availability', () async {
        await endpoints.calendar.syncDeviceCalendars(
          alice,
          PhoneCalendars.report(
            phone.deviceId,
            permission: CalendarPermission.writeOnly,
          ),
        );
        final proposal = await propose();
        expect(proposal.canCommit, isFalse);
        expect(
          proposal.plan.coverage.map((c) => c.state),
          everyElement(CoverageState.unreadable),
        );
      });
    });

    group('when a session is scheduled', () {
      late List<CalendarWrite> created;

      setUp(() async {
        final proposal = await propose();
        created = (await commit(proposal)).writes;
        await endpoints.planner.reportWrites(alice, [
          for (final w in created)
            CalendarWriteResult(
              linkId: w.linkId,
              action: w.action,
              outcome: CalendarWriteOutcome.done,
              sessionRevision: w.sessionRevision,
              externalEventId: 'evt-${w.eventUid}',
            ),
        ]);
      });

      test(
        'then moving it rechecks availability and queues an update',
        () async {
          final target = created.first;
          final newStart = target.startAt.add(const Duration(hours: 1));
          final moved = await endpoints.planner.moveSession(
            alice,
            SessionMoveRequest(
              sessionId: target.sessionId,
              operationId: _op(),
              startAt: newStart,
              // The session's own event is in the calendar; it must not block.
              availability: phone.readings(
                family: [
                  busy(
                    target.startAt,
                    const Duration(minutes: 30),
                    sessionUid: target.eventUid,
                  ),
                ],
              ),
              acceptUnverified: false,
              deviceId: phone.deviceId,
            ),
          );
          expect(moved.session.session.startAt, newStart);
          expect(moved.session.session.planRevision, 2);
          final update = moved.writes.single;
          expect(update.action, CalendarWriteAction.update);
          expect(update.externalEventId, 'evt-${target.eventUid}');

          // A result for the old revision does not settle the move.
          CalendarWriteResult done(int revision) => CalendarWriteResult(
            linkId: update.linkId,
            action: CalendarWriteAction.update,
            outcome: CalendarWriteOutcome.done,
            sessionRevision: revision,
          );
          await endpoints.planner.reportWrites(alice, [done(1)]);
          var work = await endpoints.planner.deviceWork(alice, phone.deviceId);
          expect(
            work.firstWhere((w) => w.linkId == update.linkId).action,
            CalendarWriteAction.update,
          );
          await endpoints.planner.reportWrites(alice, [done(2)]);
          work = await endpoints.planner.deviceWork(alice, phone.deviceId);
          expect(
            work.firstWhere((w) => w.linkId == update.linkId).action,
            CalendarWriteAction.check,
          );
        },
      );

      test('then moving it onto a busy time is refused', () async {
        final target = created.first;
        final newStart = target.startAt.add(const Duration(hours: 2));
        await expectLater(
          endpoints.planner.moveSession(
            alice,
            SessionMoveRequest(
              sessionId: target.sessionId,
              operationId: _op(),
              startAt: newStart,
              availability: phone.readings(
                work: [busy(newStart, const Duration(minutes: 10))],
              ),
              acceptUnverified: false,
              deviceId: phone.deviceId,
            ),
          ),
          _planning(PlanningErrorCode.conflict),
        );
      });

      test('then cancelling queues a marker-checked delete, once', () async {
        final target = created.first;
        final operationId = _op();
        final cancelled = await endpoints.planner.cancelSession(
          alice,
          target.sessionId,
          operationId,
          phone.deviceId,
        );
        expect(cancelled.session.session.status, SessionStatus.cancelled);
        final delete = cancelled.writes.single;
        expect(delete.action, CalendarWriteAction.delete);
        expect(delete.notes, contains('pinne-session:${target.eventUid}'));

        final again = await endpoints.planner.cancelSession(
          alice,
          target.sessionId,
          operationId,
          phone.deviceId,
        );
        expect(again.writes.single.linkId, delete.linkId);

        await endpoints.planner.reportWrites(alice, [
          CalendarWriteResult(
            linkId: delete.linkId,
            action: CalendarWriteAction.delete,
            outcome: CalendarWriteOutcome.done,
            sessionRevision: delete.sessionRevision,
          ),
        ]);
        final work = await endpoints.planner.deviceWork(alice, phone.deviceId);
        expect(work.map((w) => w.linkId), isNot(contains(delete.linkId)));
      });

      test(
        'then an event moved in the calendar app moves the session',
        () async {
          final target = created.first;
          final start = target.startAt.add(const Duration(days: 1));
          await endpoints.planner.reportWrites(alice, [
            CalendarWriteResult(
              linkId: target.linkId,
              action: CalendarWriteAction.check,
              outcome: CalendarWriteOutcome.moved,
              sessionRevision: target.sessionRevision,
              startAt: start,
              endAt: start.add(const Duration(minutes: 30)),
            ),
          ]);
          final sessions = await endpoints.planner.sessions(
            alice,
            DateTime.now(),
            DateTime.now().add(const Duration(days: 40)),
          );
          final view = sessions.firstWhere(
            (v) => v.session.id == target.sessionId,
          );
          expect(view.session.startAt, start);
          expect(view.session.planRevision, 2);
          expect(view.syncState, EventSyncState.synced);
        },
      );

      test(
        'then an event removed in the calendar app cancels the session',
        () async {
          final target = created.last;
          await endpoints.planner.reportWrites(alice, [
            CalendarWriteResult(
              linkId: target.linkId,
              action: CalendarWriteAction.check,
              outcome: CalendarWriteOutcome.missing,
              sessionRevision: target.sessionRevision,
            ),
          ]);
          final sessions = await endpoints.planner.sessions(
            alice,
            DateTime.now(),
            DateTime.now().add(const Duration(days: 40)),
          );
          expect(
            sessions.map((v) => v.session.id),
            isNot(contains(target.sessionId)),
          );
        },
      );

      test(
        'then an id that now names someone else\'s event is left alone',
        () async {
          final target = created.first;
          await endpoints.planner.reportWrites(alice, [
            CalendarWriteResult(
              linkId: target.linkId,
              action: CalendarWriteAction.check,
              outcome: CalendarWriteOutcome.notOurs,
              sessionRevision: target.sessionRevision,
            ),
          ]);
          await endpoints.planner.cancelSession(
            alice,
            target.sessionId,
            _op(),
            phone.deviceId,
          );
          final work = await endpoints.planner.deviceWork(
            alice,
            phone.deviceId,
          );
          expect(work.map((w) => w.linkId), isNot(contains(target.linkId)));
        },
      );

      test(
        'then another device never gets this phone\'s calendar work',
        () async {
          final other = const Uuid().v4obj();
          expect(await endpoints.planner.deviceWork(alice, other), isEmpty);
        },
      );

      test('then it exports as an export-only iCalendar file', () async {
        final ics = await endpoints.planner.exportIcs(alice, [
          for (final w in created) w.sessionId,
        ]);
        expect(ics, startsWith('BEGIN:VCALENDAR\r\n'));
        expect('BEGIN:VEVENT'.allMatches(ics), hasLength(3));
        expect(ics, contains('UID:${created.first.eventUid}@pinne'));
        expect(ics.replaceAll('\r\n ', ''), contains('does not sync'));
        expect(ics, isNot(contains('Keep')));
      });
    });

    group('when another user tries', () {
      test('then plans, sessions, links and readings stay private', () async {
        final proposal = await propose();
        final result = await commit(proposal);
        final write = result.writes.first;

        await expectLater(
          endpoints.planner.commit(
            bob,
            PlanCommitRequest(
              planId: proposal.plan.id!,
              operationId: _op(),
              availability: [],
              acceptUnverified: true,
            ),
          ),
          throwsA(isA<RecordNotFoundException>()),
        );
        await expectLater(
          endpoints.planner.cancelSession(bob, write.sessionId, _op(), null),
          throwsA(isA<RecordNotFoundException>()),
        );
        await expectLater(
          endpoints.planner.moveSession(
            bob,
            SessionMoveRequest(
              sessionId: write.sessionId,
              operationId: _op(),
              startAt: write.startAt,
              availability: [],
              acceptUnverified: true,
            ),
          ),
          throwsA(isA<RecordNotFoundException>()),
        );
        await expectLater(
          endpoints.planner.exportIcs(bob, [write.sessionId]),
          throwsA(isA<RecordNotFoundException>()),
        );
        await expectLater(
          endpoints.planner.reportWrites(bob, [
            CalendarWriteResult(
              linkId: write.linkId,
              action: write.action,
              outcome: CalendarWriteOutcome.missing,
              sessionRevision: write.sessionRevision,
            ),
          ]),
          throwsA(isA<RecordNotFoundException>()),
        );
        expect(
          await endpoints.planner.deviceWork(bob, phone.deviceId),
          isEmpty,
        );
        expect(
          await endpoints.planner.sessions(
            bob,
            DateTime.now(),
            DateTime.now().add(const Duration(days: 40)),
          ),
          isEmpty,
        );

        // Alice's calendar readings do not verify Bob's plan.
        await endpoints.planner.savePreferences(bob, anyTimePreferences());
        final bobs = await endpoints.planner.propose(
          bob,
          PlanRequest(availability: phone.readings()),
        );
        expect(bobs.plan.availabilityVerified, isFalse);
        expect(bobs.plan.coverage, isEmpty);
      });
    });

    group('when saving preferences', () {
      test('then invalid rules are refused', () async {
        final good = anyTimePreferences();
        for (final bad in [
          good.copyWith(timezone: 'Mars/Olympus'),
          good.copyWith(weekdays: []),
          good.copyWith(windowStartMinute: 600, windowEndMinute: 500),
          good.copyWith(sessionMinutes: 1),
          good.copyWith(maxSessions: 0),
          good.copyWith(bufferMinutes: -5),
        ]) {
          await expectLater(
            endpoints.planner.savePreferences(alice, bad),
            throwsA(isA<ValidationException>()),
          );
        }
      });

      test('then defaults have no id until saved', () async {
        final prefs = await endpoints.planner.preferences(bob);
        expect(prefs.id, isNull);
        expect(prefs.approvalMode, ApprovalMode.confirm);
      });
    });
  });
}
