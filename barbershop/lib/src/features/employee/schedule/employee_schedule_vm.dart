import 'package:barbershop/src/core/exceptions/repository_exception.dart';
import 'package:barbershop/src/core/fp/either.dart';
import 'package:barbershop/src/core/providers/application_providers.dart';
import 'package:barbershop/src/models/schedule_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee_schedule_vm.g.dart';

@riverpod
class EmployeeScheduleVm extends _$EmployeeScheduleVm {
  Future<Either<RepositoryException, List<ScheduleModel>>> _getSchedules(
      int userId, DateTime date) {
    final repository = ref.read(scheduleRepositoryProvider);
    final dto = (
      userId: userId,
      date: date,
    );
    return repository.findScheduleByDate(dto);
  }

  @override
  Future<List<ScheduleModel>> build(int userId, DateTime date) async {
    final schedulesListResult = await _getSchedules(userId, date);
    return switch (schedulesListResult) {
      Success(value: final schedules) => schedules,
      Failure(:final exception) => throw Exception(exception)
    };
  }

  Future<void> changeDate(int userId, DateTime date) async {
    final schedulesListResult = await _getSchedules(userId, date);
    state = switch (schedulesListResult) {
      Success(value: final schedules) => AsyncData(schedules),
      Failure(:final exception) =>
        AsyncError(Exception(exception), StackTrace.current),
    };
  }
}
