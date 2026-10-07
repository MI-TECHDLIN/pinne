import 'package:flutter/material.dart';
import 'package:pinne_calendar/pinne_calendar.dart' show LocalDate;
import 'package:pinne_client/pinne_client.dart';

import '../../theme/pinne_tokens.dart';
import 'planner_format.dart';

/// A month grid with session markers. A day with a scheduled session has a
/// filled dot, a proposed one a dashed ring; both are also in the day's
/// screen-reader label, so colour is never the only cue.
class MonthCalendar extends StatefulWidget {
  const MonthCalendar({
    super.key,
    required this.zone,
    required this.today,
    required this.selected,
    required this.sessions,
    required this.onSelect,
  });

  final String zone;
  final LocalDate today;
  final LocalDate selected;
  final List<SessionView> sessions;
  final ValueChanged<LocalDate> onSelect;

  @override
  State<MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  late LocalDate _month = LocalDate(
    widget.selected.year,
    widget.selected.month,
    1,
  );

  static const _letters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  void _shift(int months) => setState(
    () => _month = LocalDate.of(_month.year, _month.month + months, 1),
  );

  @override
  Widget build(BuildContext context) {
    final first = _month;
    final lead = first.weekday - 1;
    final days = first.daysUntil(LocalDate.of(first.year, first.month + 1, 1));
    final cells = lead + days;
    final rows = (cells / 7).ceil();
    final label = '${monthName(first.month)} ${first.year}';

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: PinneColors.lilac),
                ),
              ),
            ),
            IconButton(
              tooltip: 'Previous month',
              onPressed: () => _shift(-1),
              icon: const Icon(Icons.chevron_left),
            ),
            IconButton(
              tooltip: 'Next month',
              onPressed: () => _shift(1),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        ExcludeSemantics(
          child: Row(
            children: [
              for (final letter in _letters)
                Expanded(
                  child: Center(
                    child: Text(
                      letter,
                      style: const TextStyle(
                        color: PinneColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: PinneSpacing.xs),
        for (var row = 0; row < rows; row++)
          Row(
            children: [
              for (var col = 0; col < 7; col++)
                Expanded(child: _cell(row * 7 + col - lead + 1, days)),
            ],
          ),
        const SizedBox(height: PinneSpacing.xs),
        const _Legend(),
      ],
    );
  }

  Widget _cell(int dayNumber, int daysInMonth) {
    if (dayNumber < 1 || dayNumber > daysInMonth) {
      return const SizedBox(height: 44);
    }
    final day = LocalDate(_month.year, _month.month, dayNumber);
    return _DayCell(
      day: day,
      isToday: day == widget.today,
      isSelected: day == widget.selected,
      scheduled: _count(day, SessionStatus.scheduled),
      proposed: _count(day, SessionStatus.proposed),
      onTap: () => widget.onSelect(day),
    );
  }

  int _count(LocalDate day, SessionStatus status) => widget.sessions
      .where(
        (v) =>
            v.session.status == status &&
            LocalDate.inZone(v.session.startAt, widget.zone) == day,
      )
      .length;
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.scheduled,
    required this.proposed,
    required this.onTap,
  });

  final LocalDate day;
  final bool isToday;
  final bool isSelected;
  final int scheduled;
  final int proposed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final parts = [
      longDate(day),
      if (isToday) 'today',
      if (scheduled > 0)
        scheduled == 1 ? '1 session planned' : '$scheduled sessions planned',
      if (proposed > 0)
        proposed == 1 ? '1 session proposed' : '$proposed sessions proposed',
    ];
    final text = isSelected ? PinneColors.ink : PinneColors.text;
    return Semantics(
      button: true,
      selected: isSelected,
      label: parts.join(', '),
      excludeSemantics: true,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: 44,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomPaint(
                painter: proposed > 0 && !isSelected ? _DashedRing() : null,
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? PinneColors.lilac : null,
                    border: isToday && !isSelected
                        ? Border.all(color: PinneColors.muted)
                        : null,
                  ),
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: text,
                      fontSize: 13,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheduled > 0 ? PinneColors.lilac : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedRing extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = PinneColors.lilac
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final rect = Offset.zero & size;
    const dashes = 14;
    const sweep = 2 * 3.141592653589793 / dashes;
    for (var i = 0; i < dashes; i++) {
      canvas.drawArc(rect.deflate(0.6), i * sweep, sweep * 0.55, false, paint);
    }
  }

  @override
  bool shouldRepaint(_DashedRing oldDelegate) => false;
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: PinneColors.muted, fontSize: 12);
    return ExcludeSemantics(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: PinneColors.lilac,
            ),
          ),
          const SizedBox(width: 4),
          const Text('Planned', style: style),
          const SizedBox(width: PinneSpacing.md),
          SizedBox(
            width: 10,
            height: 10,
            child: CustomPaint(painter: _DashedRing()),
          ),
          const SizedBox(width: 4),
          const Text('Proposed', style: style),
        ],
      ),
    );
  }
}
