import 'package:asyncstate/asyncstate.dart';
import 'package:barbershop/src/core/exceptions/repository_exception.dart';
import 'package:barbershop/src/core/fp/either.dart';
import 'package:barbershop/src/core/fp/nil.dart';
import 'package:barbershop/src/core/providers/application_providers.dart';
import 'package:barbershop/src/features/employee/register/employee_register_state.dart';
import 'package:barbershop/src/models/barbershop_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../repositories/user/user_repository.dart';

part 'employee_register_vm.g.dart';

@riverpod
class EmployeeRegisterVm extends _$EmployeeRegisterVm {
  @override
  EmployeeRegisterState build() => EmployeeRegisterState.initial();

  void setRegisterAdm(bool isRegisterAdm) {
    state = state.copyWith(registerAdm: isRegisterAdm);
  }

  void addOrRemoveWorkDays(String weekDay) {
    final EmployeeRegisterState(:workDays) = state;

    if (workDays.contains(weekDay)) {
      workDays.remove(weekDay);
    } else {
      workDays.add(weekDay);
    }

    state = state.copyWith(workDays: workDays);
  }

  void addOrRemoveWorkHours(int hour) {
    final EmployeeRegisterState(:workHours) = state;

    if (workHours.contains(hour)) {
      workHours.remove(hour);
    } else {
      workHours.add(hour);
    }

    state = state.copyWith(workHours: workHours);
  }

  Future<void> register({
    String? name,
    String? email,
    String? password,
  }) async {
    final EmployeeRegisterState(:registerAdm, :workDays, :workHours) = state;
    final asyncLoaderHandler = AsyncLoaderHandler()..start();

    final UserRepository(:registerAdmAsEmployee, :registerEmployee) =
        ref.read(userRepositoryProvider);

    final Either<RepositoryException, Nil> registerResult;

    if (registerAdm) {
      final dto = (
        workDays: workDays,
        workHours: workHours,
      );
      registerResult = await registerAdmAsEmployee(dto);
    } else {
      final BarbershopModel(:id) =
          await ref.read(getMyBarbershopProvider.future);
      final dto = (
        barbershopId: id,
        name: name!,
        email: email!,
        password: password!,
        workDays: workDays,
        workHours: workHours,
      );
      registerResult = await registerEmployee(dto);
    }

    switch (registerResult) {
      case Success():
        state = state.copyWith(status: EmployeeRegisterStateStatus.success);
      case Failure():
        state = state.copyWith(status: EmployeeRegisterStateStatus.error);
    }

    asyncLoaderHandler.close();
  }
}
