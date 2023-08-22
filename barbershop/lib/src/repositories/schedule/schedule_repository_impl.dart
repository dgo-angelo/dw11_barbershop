import 'dart:developer';

import 'package:barbershop/src/core/exceptions/repository_exception.dart';
import 'package:barbershop/src/core/fp/either.dart';
import 'package:barbershop/src/core/fp/nil.dart';
import 'package:barbershop/src/core/restClient/rest_client.dart';
import 'package:barbershop/src/models/schedule_model.dart';
import 'package:dio/dio.dart';

import './schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final RestClient restClient;
  ScheduleRepositoryImpl({
    required this.restClient,
  });

  @override
  Future<Either<RepositoryException, Nil>> scheduleCustomer(
      ({
        int barbershopId,
        String customerName,
        DateTime date,
        int hour,
        int userId
      }) scheduleData) async {
    try {
      await restClient.auth.post('/schedules', data: {
        'barbershop_id': scheduleData.barbershopId,
        'user_id': scheduleData.userId,
        'client_name': scheduleData.customerName,
        'date': scheduleData.date.toIso8601String(),
        'time': scheduleData.hour,
      });

      return Success(nil);
    } on DioException catch (e, s) {
      log('Falha ao registrar horario', error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: 'Erro ao agendar horário'),
      );
    }
  }

  @override
  Future<Either<RepositoryException, List<ScheduleModel>>> findScheduleByDate(
      ({
        DateTime date,
        int userId,
      }) filter) async {
    try {
      final Response(:List data) =
          await restClient.auth.get('/schedules', queryParameters: {
        'user_id': filter.userId,
        'date': filter.date.toIso8601String(),
      });

      final List<ScheduleModel> schedules =
          data.map((schedule) => ScheduleModel.fromMap(schedule)).toList();
      return Success(schedules);
    } on DioException catch (e, s) {
      log('Erro ao buscar agendamentos', error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: 'Erro ao buscar agendamentos'),
      );
    } on ArgumentError catch (e, s) {
      log('Erro ao converter agendamentos ( Json invalido )',
          error: e, stackTrace: s);
      return Failure(RepositoryException(
          message: 'Erro ao converter agendamentos ( Json invalido '));
    }
  }
}
