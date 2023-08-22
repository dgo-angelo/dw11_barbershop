class ScheduleModel {
  final int id;
  final int barbershopId;
  final int userId;
  final String customerName;
  final DateTime date;
  final int hour;
  ScheduleModel({
    required this.id,
    required this.barbershopId,
    required this.userId,
    required this.customerName,
    required this.date,
    required this.hour,
  });

  factory ScheduleModel.fromMap(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'barbershop_id': int barbershopId,
        'user_id': int email,
        'client_name': String customerName,
        'date': String scheduleDate,
        'time': int hour,
      } =>
        ScheduleModel(
          id: id,
          barbershopId: barbershopId,
          userId: email,
          customerName: customerName,
          date: DateTime.parse(scheduleDate),
          hour: hour,
        ),
      _ => throw ArgumentError('Invalid Json'),
    };
  }
}
