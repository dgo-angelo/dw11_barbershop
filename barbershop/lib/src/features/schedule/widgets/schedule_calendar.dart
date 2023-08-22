import 'package:barbershop/src/core/ui/constants.dart';
import 'package:barbershop/src/core/ui/helpers/messages.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleCalendar extends StatefulWidget {
  final List<String> workDays;
  final VoidCallback onCancelPressed;
  final ValueChanged<DateTime> onOkPressed;
  const ScheduleCalendar({
    super.key,
    required this.onCancelPressed,
    required this.onOkPressed,
    required this.workDays,
  });

  @override
  State<ScheduleCalendar> createState() => _ScheduleCalendarState();
}

class _ScheduleCalendarState extends State<ScheduleCalendar> {
  DateTime? selectedDay;
  late final List<int> weekDaysEnable;

  int convertWeekDay(String weekday) {
    return switch (weekday.toLowerCase()) {
      'seg' => DateTime.monday,
      'ter' => DateTime.tuesday,
      'qua' => DateTime.wednesday,
      'qui' => DateTime.thursday,
      'sex' => DateTime.friday,
      'sab' => DateTime.saturday,
      'dom' => DateTime.sunday,
      _ => 0
    };
  }

  @override
  void initState() {
    weekDaysEnable =
        widget.workDays.map((weekday) => convertWeekDay(weekday)).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xffe6e2e9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          TableCalendar(
            enabledDayPredicate: (day) {
              return weekDaysEnable.contains(day.weekday);
            },
            availableGestures: AvailableGestures.none,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            focusedDay: DateTime.now(),
            firstDay: DateTime.utc(2010, 01, 01),
            lastDay: DateTime.now().add(
              const Duration(days: 365 * 10),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
              });
            },
            calendarFormat: CalendarFormat.month,
            locale: 'pt_BR',
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay, day);
            },
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: ColorsConstants.brown,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: ColorsConstants.brown.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onCancelPressed,
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: ColorsConstants.brown,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (selectedDay == null) {
                    Messages.showError('Por favor, selecione um dia.', context);
                    return;
                  }
                  widget.onOkPressed(selectedDay!);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: ColorsConstants.brown,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
