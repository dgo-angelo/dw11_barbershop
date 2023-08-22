import 'package:asyncstate/asyncstate.dart';
import 'package:barbershop/src/core/exceptions/service_exception.dart';
import 'package:barbershop/src/core/fp/either.dart';
import 'package:barbershop/src/core/providers/application_providers.dart';
import 'package:barbershop/src/features/auth/login/login_state.dart';
import 'package:barbershop/src/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_vm.g.dart';

@riverpod
class LoginVm extends _$LoginVm {
  @override
  LoginState build() => LoginState.initial();

  Future<void> login(email, password) async {
    final loaderHandler = AsyncLoaderHandler()..start();

    final loginService = ref.watch(userLoginServiceProvider);
    final result = await loginService.execute(email, password);
    switch (result) {
      case Success():
        //! Invalidando os caches para evitar o login com usuario errado.
        ref.invalidate(getMeProvider);
        ref.invalidate(getMyBarbershopProvider);
        final userModel = await ref.watch(getMeProvider.future);
        switch (userModel) {
          case UserModelADM():
            state = state.copyWith(status: LoginStateStatus.admLogin);
          case UserModelEmployee():
            state = state.copyWith(status: LoginStateStatus.employeeLogin);
        }
        break;
      case Failure(exception: ServiceException(:final message)):
        state = state.copyWith(
          status: LoginStateStatus.error,
          errorMessage: () => message,
        );
    }
    loaderHandler.close();
  }
}
