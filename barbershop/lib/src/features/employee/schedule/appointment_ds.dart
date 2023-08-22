import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:barbershop/src/core/ui/constants.dart';
import 'package:barbershop/src/models/schedule_model.dart';

class AppointmentDs extends CalendarDataSource {
  final List<ScheduleModel> schedules;
  AppointmentDs({
    required this.schedules,
  });
  @override
  List<dynamic>? get appointments {
    return schedules.map((schedule) {
      final ScheduleModel(
        date: DateTime(:year, :month, :day),
        :hour,
        :customerName,
      ) = schedule;

      final startTime = DateTime(year, month, day, hour, 0, 0);
      final endTime = DateTime(year, month, day, hour + 1, 0, 0);
      return Appointment(
        color: ColorsConstants.brown,
        startTime: startTime,
        endTime: endTime,
        subject: customerName,
      );
    }).toList();
  }
}
