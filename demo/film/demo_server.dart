import 'dart:async';

import 'package:pinne_calendar/pinne_calendar.dart';
import 'package:pinne_capture/pinne_capture.dart';
import 'package:pinne_client/pinne_client.dart';
import 'package:pinne_flutter/features/capture/outbox_sync.dart';
import 'package:pinne_flutter/features/planner/device_calendar_adapter.dart';
import 'package:pinne_flutter/features/planner/planner_api.dart';
import 'package:pinne_flutter/features/progress/progress_providers.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

/// Clearly sample data standing in for the Serverpod server while the real
/// app is filmed. Every screen, provider and widget is the app's own code;
/// only the answers the server would give are canned here. Domains use the
/// reserved `.example` TLD so nothing points at a real site.
abstract final class Sample {
  static final owner = UuidValue.fromString(
    '00000000-0000-4000-8000-00000000a001',
  );
  static const ownerName = 'Ada';

  /// The avatar the whole film uses, as stored in `pinne_profile`.
  static const avatarSeed = 2026;
  static const avatarPalette = 0;

  static UuidValue id(int n) => UuidValue.fromString(
    '00000000-0000-4000-8000-${n.toRadixString(16).padLeft(12, '0')}',
  );

  /// The link shared into Pinne in the capture scene.
  static const sharedUrl =
      'https://fieldnotes.example/2026/calm-onboarding-patterns';
  static const sharedTitle = 'Calm onboarding: 7 patterns that don’t nag';
  static const sharedWhy = 'Ideas for our app’s first-run screens';

  static DateTime get now => DateTime.now().toUtc();

  /// The phone's clock in the film: Thursday of the current week at 10:24,
  /// the time the drawn status bar shows, so the progress week has a few
  /// days behind it whatever day the film is rendered.
  static final DateTime filmNow = () {
    final real = DateTime.now();
    final monday = DateTime(
      real.year,
      real.month,
      real.day,
    ).subtract(Duration(days: real.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day + 3, 10, 24);
  }();

  /// Thumbnails are served from demo/assets/thumbs by file name.
  static String thumb(String name) => 'https://thumbs.pinne.example/$name.png';

  static final collections = [
    Collection(
      id: id(0xc1),
      ownerId: owner,
      name: 'App ideas',
      description: '14 saved · 9 reviewed',
      coverSeed: 1847,
      paletteIndex: 0,
    ),
    Collection(
      id: id(0xc2),
      ownerId: owner,
      name: 'Weeknight cooking',
      description: '11 saved · 6 reviewed',
      coverSeed: 90210,
      paletteIndex: 1,
    ),
    Collection(
      id: id(0xc3),
      ownerId: owner,
      name: 'Design reading',
      description: '9 saved · 7 reviewed',
      coverSeed: 7331,
      paletteIndex: 2,
    ),
    Collection(
      id: id(0xc4),
      ownerId: owner,
      name: 'Garden plans',
      description: '5 saved · 2 reviewed',
      coverSeed: 24680,
      paletteIndex: 3,
    ),
  ];

  /// Saved items. Preview fields are added per branch by the scene files.
  static List<Item> items() => [
    Item(
      id: id(1),
      ownerId: owner,
      url: sharedUrl,
      canonicalUrl: sharedUrl,
      sourcePlatform: SourcePlatform.web,
      title: sharedTitle,
      contentType: ContentType.article,
      intention: sharedWhy,
      enrichmentState: EnrichmentState.ready,
      accessState: AccessState.available,
      previewSiteName: 'Field Notes',
      previewAuthor: 'M. Okafor · Field Notes',
      thumbnailUrl: thumb('onboarding'),
      savedAt: now.subtract(const Duration(hours: 26)),
    ),
    Item(
      id: id(2),
      ownerId: owner,
      url: 'https://kitchenlab.example/videos/knife-skills-12-minutes',
      sourcePlatform: SourcePlatform.web,
      title: 'Knife skills in 12 minutes',
      contentType: ContentType.video,
      intention: 'Practice before Sunday dinner with the family',
      enrichmentState: EnrichmentState.ready,
      accessState: AccessState.available,
      previewAuthor: 'Kitchen Lab',
      thumbnailUrl: thumb('knife'),
      durationSeconds: 724,
      savedAt: now.subtract(const Duration(days: 9)),
    ),
    Item(
      id: id(3),
      ownerId: owner,
      url: 'https://kitchenlab.example/videos/slow-roast-tomato-pasta',
      sourcePlatform: SourcePlatform.web,
      title: 'Slow-roast tomato pasta',
      contentType: ContentType.video,
      intention: 'Maybe for Sunday dinner, looks easy',
      enrichmentState: EnrichmentState.ready,
      accessState: AccessState.available,
      previewAuthor: 'Kitchen Lab',
      thumbnailUrl: thumb('pasta'),
      durationSeconds: 1135,
      savedAt: now.subtract(const Duration(days: 16)),
    ),
    Item(
      id: id(4),
      ownerId: owner,
      url: 'https://uipatterns.example/navigation/pill-bars',
      sourcePlatform: SourcePlatform.web,
      title: 'Designing a floating pill nav',
      contentType: ContentType.article,
      intention: 'Compare with our bottom nav',
      enrichmentState: EnrichmentState.ready,
      accessState: AccessState.available,
      previewSiteName: 'UI Patterns',
      thumbnailUrl: thumb('navbar'),
      savedAt: now.subtract(const Duration(days: 4)),
    ),
  ];
}

/// The in-memory `item.capture` side of the server: idempotent by operation
/// id like the real endpoint. Starts offline when asked, to show that a save
/// never waits for the network.
class DemoCaptureApi implements CaptureApi {
  DemoCaptureApi({this.offline = false});

  bool offline;
  final _byOperation = <String, UuidValue>{};
  final _listeners = <VoidCallback>[];

  /// Called with the server id for each accepted capture.
  void Function(UuidValue itemId, CaptureDraft draft)? onCaptured;

  @override
  Future<CaptureResult> capture(CaptureDraft draft) async {
    if (offline) {
      throw const ServerpodClientNetworkException('No connection');
    }
    final known = _byOperation[draft.operationId.uuid];
    final itemId = known ?? Sample.id(1);
    _byOperation[draft.operationId.uuid] = itemId;
    if (known == null) onCaptured?.call(itemId, draft);
    final input = parseCaptureInput(draft.url ?? draft.text ?? '');
    return CaptureResult(
      itemId: itemId,
      clientItemId: draft.clientItemId,
      revision: 1,
      title: draft.title ?? input.suggestedTitle,
      sourcePlatform: SourcePlatform.values.byName(input.source.name),
      sourceItemId: input.link?.sourceItemId,
      canonicalUrl: input.link?.canonicalUrl,
      duplicate: false,
      enrichmentState: EnrichmentState.pending,
      savedAt: draft.capturedAt,
    );
  }

  void comeOnline() {
    offline = false;
    for (final listener in [..._listeners]) {
      listener();
    }
  }

  @override
  VoidCallback watchConnectivity(VoidCallback onOnline) {
    _listeners.add(onOnline);
    return () => _listeners.remove(onOnline);
  }
}

/// The generated client with its endpoints answered from [Sample].
class DemoClient extends Client {
  DemoClient({
    List<Item> Function()? items,
    ReviewQueueResult Function()? queue,
    this.displayName = Sample.ownerName,
    this.onReviewed,
    this.onSnoozed,
  }) : itemsSource = items ?? Sample.items,
       queueSource = queue,
       super('http://pinne.example/') {
    // The sign-in screen's widgets read the client's auth session.
    authSessionManager = FlutterAuthSessionManager();
  }

  List<Item> Function() itemsSource;
  ReviewQueueResult Function()? queueSource;

  /// The profile name; empty for a fresh guest, who is greeted as "Guest".
  final String displayName;

  /// Called when a review event is recorded or an item is snoozed.
  final void Function(ReviewEventDraft draft)? onReviewed;
  final void Function(UuidValue itemId)? onSnoozed;

  @override
  late final EndpointItem item = _DemoItems(this);
  @override
  late final EndpointCollection collection = _DemoCollections(this);
  @override
  late final EndpointSearch search = _DemoSearch(this);
  @override
  late final EndpointReviewQueue reviewQueue = _DemoQueue(this);
  @override
  late final EndpointReview review = _DemoReview(this);
  @override
  late final EndpointProfile profile = _DemoProfile(this);
  @override
  late final EndpointAiOrganizing aiOrganizing = _DemoAi(this);
  @override
  late final EndpointAccount account = _DemoAccount(this);
  @override
  late final EndpointHealth health = _DemoHealth(this);
}

class _DemoItems extends EndpointItem {
  _DemoItems(this.client) : super(client);
  final DemoClient client;

  @override
  Future<List<Item>> list({int? limit, DateTime? before}) async =>
      client.itemsSource();
}

class _DemoCollections extends EndpointCollection {
  _DemoCollections(super.caller);

  @override
  Future<List<Collection>> list() async => Sample.collections;
}

/// Mirrors the server's keyword search: every query term must appear in the
/// item's title, notes, URL, source or type, and evidence lists the fields
/// that matched in the server's order.
class _DemoSearch extends EndpointSearch {
  _DemoSearch(this.client) : super(client);
  final DemoClient client;

  @override
  Future<SearchPage> keyword({
    required String query,
    SourcePlatform? source,
    ContentType? contentType,
    UuidValue? collectionId,
    ReviewStatusFilter? reviewStatus,
    String? cursor,
    int? limit,
  }) async {
    final terms = RegExp(
      r'[\p{L}\p{N}]+',
      unicode: true,
    ).allMatches(query.toLowerCase()).map((m) => m.group(0)!).toSet();
    final results = <SearchResult>[];
    for (final item in client.itemsSource()) {
      final haystack = [
        item.title,
        item.intention ?? '',
        item.url ?? '',
        item.sourcePlatform.name,
        item.contentType.name,
      ].join(' ').toLowerCase();
      if (!terms.every(haystack.contains)) continue;
      final evidence = <SearchEvidence>[];
      void add(String field, String? value) {
        if (value == null) return;
        if (terms.any(value.toLowerCase().contains)) {
          evidence.add(SearchEvidence(field: field, snippet: value));
        }
      }

      add('title', item.title);
      add('saved note', item.intention);
      add('content type', item.contentType.name);
      results.add(
        SearchResult(
          item: item,
          evidence: evidence.take(3).toList(),
          score: evidence.length.toDouble(),
        ),
      );
    }
    return SearchPage(results: results);
  }
}

class _DemoQueue extends EndpointReviewQueue {
  _DemoQueue(this.client) : super(client);
  final DemoClient client;

  @override
  Future<ReviewQueueResult> get({required int timeBudgetMinutes}) async =>
      client.queueSource?.call() ??
      ReviewQueueResult(entries: [], timeBudgetMinutes: timeBudgetMinutes);

  @override
  Future<ItemReviewControl> snooze(UuidValue itemId, DateTime until) async {
    client.onSnoozed?.call(itemId);
    return ItemReviewControl(
      ownerId: Sample.owner,
      itemId: itemId,
      snoozedUntil: until,
    );
  }
}

class _DemoReview extends EndpointReview {
  _DemoReview(this.client) : super(client);
  final DemoClient client;

  @override
  Future<ReviewEventReceipt> record(ReviewEventDraft draft) async {
    client.onReviewed?.call(draft);
    return ReviewEventReceipt(
      event: ReviewEvent(
        id: const Uuid().v4obj(),
        ownerId: Sample.owner,
        itemId: draft.itemId,
        clientEventId: draft.clientEventId,
        eventType: draft.eventType,
        occurredAt: draft.occurredAt,
        timezone: draft.timezone,
        effectiveLocalDate: draft.occurredAt.toIso8601String().substring(0, 10),
      ),
      progress: ItemProgress(
        ownerId: Sample.owner,
        itemId: draft.itemId,
        firstReviewedAt: draft.occurredAt,
        lastReviewedAt: draft.occurredAt,
      ),
    );
  }
}

class _DemoProfile extends EndpointProfile {
  _DemoProfile(this.client) : super(client);
  final DemoClient client;

  @override
  Future<PinneProfile?> get() async => PinneProfile(
    ownerId: Sample.owner,
    displayName: client.displayName,
    avatarSeed: Sample.avatarSeed,
    avatarPalette: Sample.avatarPalette,
  );
}

class _DemoAi extends EndpointAiOrganizing {
  _DemoAi(super.caller);

  @override
  Future<AiSettings> getSettings() async =>
      AiSettings(enabled: true, disclosure: _disclosure);

  @override
  Future<AiSettings> setEnabled(bool enabled) async =>
      AiSettings(enabled: enabled, disclosure: _disclosure);

  // The server's AiOrganizingEndpoint.disclosure.
  static const _disclosure =
      "When AI organizing is on, Pinne sends the saved item's title, URL, "
      'source platform, your intention and notes, plus the names and IDs of '
      "your collections, to Google's Gemini API. It does not fetch the page. "
      "On Gemini's unpaid tier, Google may use prompts and responses to "
      'improve its products, and human reviewers may process them. Google '
      'says not to send sensitive, confidential or personal information. '
      'Different data terms apply in the EEA, Switzerland and UK. Turn this '
      'off to keep organizing on this server with simple rules only.';
}

class _DemoAccount extends EndpointAccount {
  _DemoAccount(super.caller);

  @override
  Future<bool> isGuest() async => false;
}

class _DemoHealth extends EndpointHealth {
  _DemoHealth(super.caller);

  @override
  Future<bool> emailDeliveryAvailable() async => true;

  @override
  Future<ServerHealth> check() async => ServerHealth(
    ok: true,
    databaseOk: true,
    serverTime: DateTime.now().toUtc(),
    version: '1.0.0',
  );
}

/// A progress server answering with one lively week ending today. Every
/// number obeys the server's rules: rates come from cohorts, empty cohorts
/// are null.
class DemoProgressApi implements ProgressApi {
  DemoProgressApi({this.milestones = const []});

  List<ProgressMilestone> milestones;
  var _extraReviews = 0;

  /// One more review counted on the server. The 25th reaches the
  /// "25 saves revisited" milestone, not yet celebrated.
  void reviewRecorded() {
    _extraReviews++;
    if (24 + _extraReviews == 25) {
      milestones = [
        ...milestones,
        ProgressMilestone(
          key: 'reviews-25',
          kind: MilestoneKind.reviewCount,
          value: 25,
          celebrated: false,
        ),
      ];
    }
  }

  @override
  Future<ProgressReport> report(ProgressQuery query) async =>
      demoWeek(milestones: milestones, extraReviews: _extraReviews);

  @override
  Future<void> markCelebrated(List<String> keys) async {
    milestones = [
      for (final m in milestones)
        keys.contains(m.key) ? m.copyWith(celebrated: true) : m,
    ];
  }

  @override
  Future<ProgressSettings> settings() async =>
      ProgressSettings(ownerId: Sample.owner, streakEnabled: true);

  @override
  Future<ProgressSettings> updateSettings(ProgressSettingsDraft draft) async =>
      ProgressSettings(
        ownerId: Sample.owner,
        streakEnabled: draft.streakEnabled,
        weeklyGoalDays: draft.weeklyGoalDays,
      );
}

String _key(DateTime day) =>
    '${day.year}-${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';

/// This week, Monday to Sunday, around [Sample.filmNow]. 24 reviews so far,
/// plus any recorded while filming.
ProgressReport demoWeek({
  List<ProgressMilestone> milestones = const [],
  int extraReviews = 0,
}) {
  final now = Sample.filmNow;
  final today = DateTime(now.year, now.month, now.day);
  final monday = today.subtract(Duration(days: today.weekday - 1));
  const counts = [2, 3, 1, 2, 3, 2, 1];
  const rates = [0.25, 0.5, 0.5, 7 / 12, 0.6, 0.62, 0.65];
  final days = [
    for (var i = 0; i < 7; i++)
      () {
        final day = monday.add(Duration(days: i));
        final future = day.isAfter(today);
        return ProgressDay(
          date: _key(day),
          reviewedCount: future
              ? 0
              : counts[i] + (day == today ? extraReviews : 0),
          cohortRate: future ? null : rates[i],
          isToday: day == today,
          isFuture: future,
        );
      }(),
  ];
  final reviewed = days.fold<int>(0, (sum, d) => sum + d.reviewedCount);
  final reviewDays = days.where((d) => d.reviewedCount > 0).length;
  return ProgressReport(
    period: ProgressPeriod.thisWeek,
    startDate: _key(monday),
    endDate: _key(monday.add(const Duration(days: 7))),
    today: _key(today),
    savedCount: 14,
    reviewedCount: 9 + extraReviews,
    firstReviewedTodayCount: 2 + extraReviews,
    remainingCount: 5 - extraReviews,
    appliedCount: 3,
    reviewRate: (9 + extraReviews) / 14,
    reviewedInPeriodCount: reviewed,
    totalReviewedCount: 24 + extraReviews,
    days: days,
    bestDayDate: _key(monday.add(const Duration(days: 1))),
    collections: [
      for (final (i, c) in Sample.collections.take(3).indexed)
        CollectionProgress(
          collectionId: c.id!,
          name: c.name,
          paletteIndex: c.paletteIndex,
          cohortCount: const [5, 4, 3][i],
          reviewedCount: const [4, 2, 2][i],
          reviewRate: const [4 / 5, 2 / 4, 2 / 3][i],
        ),
    ],
    weeklyGoal: WeeklyGoalProgress(
      weekStartDate: _key(monday),
      goalDays: 5,
      reviewDayCount: reviewDays,
      reached: reviewDays >= 5,
      days: days,
    ),
    streakEnabled: true,
    currentStreakDays: today.weekday,
    milestones: milestones,
  );
}

/// The phone's calendars with a realistic busy week, read through the app's
/// real Android adapter.
class DemoDeviceCalendar implements DeviceCalendarApi {
  DemoDeviceCalendar() {
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    var n = 0;
    void busy(String calendar, int day, int startMinute, int minutes) {
      final start = today.add(Duration(days: day, minutes: startMinute));
      final id = 'e${n++}';
      stored.add(
        DeviceEvent(
          eventId: id,
          instanceId: id,
          calendarId: calendar,
          start: start,
          end: start.add(Duration(minutes: minutes)),
        ),
      );
    }

    for (var day = 0; day < 8; day++) {
      busy('1', day, 9 * 60, 8 * 60);
    }
    // Evenings are not empty either.
    busy('2', 0, 18 * 60, 75); // School run and dinner.
    busy('2', 1, 18 * 60 + 30, 90); // Football practice.
    busy('2', 2, 19 * 60, 120); // Friends over.
    busy('2', 4, 18 * 60, 60);
    busy('2', 5, 20 * 60, 60);
  }

  final stored = <DeviceEvent>[];
  var _next = 100;

  @override
  bool get supported => true;

  @override
  Future<DeviceCalendarAccess> access() async => DeviceCalendarAccess.granted;

  @override
  Future<DeviceCalendarAccess> requestAccess() async =>
      DeviceCalendarAccess.granted;

  @override
  Future<List<AdapterCalendar>> calendars() async => const [
    AdapterCalendar(id: '1', name: 'Work', readOnly: false),
    AdapterCalendar(id: '2', name: 'Family', readOnly: false),
  ];

  @override
  Future<List<DeviceEvent>> events(
    DateTime start,
    DateTime end, {
    List<String>? calendarIds,
  }) async => [
    for (final e in stored)
      if ((calendarIds == null || calendarIds.contains(e.calendarId)) &&
          e.start.isBefore(end) &&
          e.end.isAfter(start))
        e,
  ];

  @override
  Future<DeviceEvent?> event(String id) async {
    for (final e in stored) {
      if (e.instanceId == id) return e;
    }
    return null;
  }

  @override
  Future<String> create({
    required String calendarId,
    required String title,
    required String notes,
    required DateTime start,
    required DateTime end,
    required String timezone,
  }) async {
    final id = '${_next++}';
    stored.add(
      DeviceEvent(
        eventId: id,
        instanceId: id,
        calendarId: calendarId,
        start: start,
        end: end,
        description: notes,
      ),
    );
    return id;
  }

  @override
  Future<void> update(
    String instanceId, {
    required String title,
    required String notes,
    required DateTime start,
    required DateTime end,
  }) async {}

  @override
  Future<void> delete(String instanceId) async =>
      stored.removeWhere((e) => e.instanceId == instanceId);
}

/// The planner server: places sessions with the shared `planSlots` rules
/// over the busy times the phone actually sent, and verifies a plan only
/// when every conflict calendar arrived readable, like the real one.
class DemoPlannerApi implements PlannerApi {
  final _sessions = <SessionView>[];
  PlanProposal? _current;
  CalendarConnectionView? _phone;

  PlannerPreferences prefs = PlannerPreferences(
    id: Sample.id(0xa2),
    ownerId: Sample.owner,
    horizon: PlanHorizon.week,
    weekdays: const [1, 2, 3, 4, 5, 6, 7],
    windowStartMinute: 18 * 60,
    windowEndMinute: 21 * 60 + 30,
    sessionMinutes: 15,
    maxSessions: 3,
    bufferMinutes: 10,
    minLeadMinutes: 60,
    timezone: 'UTC',
    approvalMode: ApprovalMode.confirm,
  );

  static const _queued = [
    ('Calm onboarding: 7 patterns', 5),
    ('Designing a floating pill nav', 5),
    ('Knife skills in 12 minutes', 12),
    ('Slow-roast tomato pasta', 8),
  ];

  @override
  Future<List<CalendarRouteStatus>> routes() async => [
    CalendarRouteStatus(
      route: CalendarRoute.androidDevice,
      label: 'Calendars on this phone',
      available: true,
      liveSync: true,
      canReadBusy: true,
      canWrite: true,
    ),
  ];

  @override
  Future<List<CalendarConnectionView>> connections() async => [?_phone];

  @override
  Future<CalendarConnectionView> syncDeviceCalendars(
    DeviceCalendarReport report,
  ) async {
    final connection = CalendarConnection(
      id: _phone?.connection.id ?? Sample.id(0xa3),
      ownerId: Sample.owner,
      route: report.route,
      accountKey: report.deviceId.uuid,
      label: report.label,
      deviceId: report.deviceId,
      permission: report.permission,
      lastCheckedAt: report.checkedAt,
    );
    _phone = CalendarConnectionView(
      connection: connection,
      selections: [
        for (final (i, c) in report.calendars.indexed)
          CalendarSelection(
            id: Sample.id(0xb0 + i),
            ownerId: Sample.owner,
            connectionId: connection.id!,
            externalCalendarId: c.externalCalendarId,
            deviceId: report.deviceId,
            name: c.name,
            readOnly: c.readOnly,
            useForConflicts: true,
            useForWrites: c.name == 'Family',
          ),
      ],
    );
    return _phone!;
  }

  @override
  Future<List<CalendarConnectionView>> setSelections(
    UuidValue connectionId,
    List<CalendarSelectionChoice> choices,
  ) async => [?_phone];

  @override
  Future<PlannerPreferences> preferences() async => prefs;

  @override
  Future<PlannerPreferences> savePreferences(
    PlannerPreferencesDraft draft,
  ) async => prefs;

  @override
  Future<PlanProposal> propose(PlanRequest request) async {
    final now = DateTime.now().toUtc();
    final conflicts = [
      for (final s in _phone?.selections ?? const <CalendarSelection>[])
        if (s.useForConflicts) s,
    ];
    final coverage = [
      for (final s in conflicts)
        CalendarCoverage(
          selectionId: s.id!,
          calendarName: s.name,
          route: CalendarRoute.androidDevice,
          state:
              request.availability.any(
                (a) => a.selectionId == s.id && a.readable,
              )
              ? CoverageState.checked
              : CoverageState.unreadable,
          checkedAt: now,
        ),
    ];
    final verified =
        coverage.isNotEmpty &&
        coverage.every((c) => c.state == CoverageState.checked);
    final horizon = TimeInterval(now, now.add(const Duration(days: 7)));
    final slots = planSlots(
      policy: PlanningPolicy(
        timezone: prefs.timezone,
        weekdays: prefs.weekdays.toSet(),
        windowStartMinute: prefs.windowStartMinute,
        windowEndMinute: prefs.windowEndMinute,
        sessionMinutes: prefs.sessionMinutes,
        maxSessions: prefs.maxSessions,
        bufferMinutes: prefs.bufferMinutes,
        minLeadMinutes: prefs.minLeadMinutes,
      ),
      horizon: horizon,
      now: now,
      busy: [
        for (final a in request.availability)
          for (final b in a.intervals) TimeInterval(b.startAt, b.endAt),
      ],
    ).slots;
    final plan = ReviewPlan(
      id: Sample.id(0xa4),
      ownerId: Sample.owner,
      horizonStart: horizon.start,
      horizonEnd: horizon.end,
      timezone: prefs.timezone,
      coverage: coverage,
      availabilityVerified: verified,
    );
    _current = PlanProposal(
      plan: plan,
      approvalMode: prefs.approvalMode,
      canCommit: verified,
      commitBlockedReason: verified
          ? null
          : 'Busy times could not be confirmed.',
      writeCalendarName: verified ? 'Family' : null,
      sessions: [
        for (final (i, slot) in slots.indexed)
          SessionView(
            session: ReviewSession(
              id: Sample.id(0xd0 + i),
              ownerId: Sample.owner,
              planId: plan.id,
              startAt: slot.start,
              endAt: slot.end,
              timezone: prefs.timezone,
              status: SessionStatus.proposed,
              schedulingMode: ApprovalMode.confirm,
              availabilityVerified: verified,
            ),
            items: [
              for (final (title, minutes) in [
                _queued[i % _queued.length],
                _queued[(i + 1) % _queued.length],
              ])
                SessionItemView(
                  itemId: Sample.id(0xe0 + i),
                  title: title,
                  plannedMinutes: minutes,
                  estimated: true,
                ),
            ],
          ),
      ],
    );
    return _current!;
  }

  @override
  Future<PlanProposal?> currentProposal() async => _current;

  @override
  Future<PlanCommitResult> commit(PlanCommitRequest request) async {
    final views = [
      for (final v in _current!.sessions)
        v.copyWith(
          session: v.session.copyWith(status: SessionStatus.scheduled),
          calendarName: 'Family',
          syncState: EventSyncState.pendingCreate,
        ),
    ];
    _sessions.addAll(views);
    _current = null;
    return PlanCommitResult(sessions: views, writes: const []);
  }

  @override
  Future<List<SessionView>> sessions(DateTime from, DateTime to) async =>
      _sessions;

  @override
  Future<SessionChangeResult> moveSession(SessionMoveRequest request) =>
      throw UnimplementedError();

  @override
  Future<SessionChangeResult> cancelSession(
    UuidValue sessionId,
    UuidValue operationId,
    UuidValue? deviceId,
  ) => throw UnimplementedError();

  @override
  Future<List<CalendarWrite>> deviceWork(UuidValue deviceId) async => const [];

  @override
  Future<void> reportWrites(List<CalendarWriteResult> results) async {}

  @override
  Future<String> exportIcs(List<UuidValue> sessionIds) async => '';
}
