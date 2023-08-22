import 'dart:developer';

import 'package:barbershop/src/core/providers/application_providers.dart';
import 'package:barbershop/src/core/ui/constants.dart';
import 'package:barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:barbershop/src/core/ui/helpers/messages.dart';
import 'package:barbershop/src/core/ui/widgets/avatar.dart';
import 'package:barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:barbershop/src/core/ui/widgets/hours_panel.dart';
import 'package:barbershop/src/core/ui/widgets/weekdays_panel.dart';
import 'package:barbershop/src/features/employee/register/employee_register_state.dart';
import 'package:barbershop/src/features/employee/register/employee_register_vm.dart';
import 'package:barbershop/src/models/barbershop_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

class EmployeeRegisterPage extends ConsumerStatefulWidget {
  const EmployeeRegisterPage({super.key});

  @override
  ConsumerState<EmployeeRegisterPage> createState() =>
      _EmployeeRegisterPageState();
}

class _EmployeeRegisterPageState extends ConsumerState<EmployeeRegisterPage> {
  var _registerAdm = false;

  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  void dispose() {
    _nameEC.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeeRegisterVm = ref.watch(employeeRegisterVmProvider.notifier);
    final barbershopAsyncValue = ref.watch(getMyBarbershopProvider);

    ref.listen(
      employeeRegisterVmProvider.select((state) => state.status),
      (_, status) {
        switch (status) {
          case EmployeeRegisterStateStatus.initial:
            break;
          case EmployeeRegisterStateStatus.success:
            Messages.showSuccess('Colaborador cadastrado com sucesso', context);
            Navigator.of(context).pop();
          case EmployeeRegisterStateStatus.error:
            Messages.showError('Erro ao registrar colaborador', context);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Colaborador'),
      ),
      body: barbershopAsyncValue.when(
        error: (error, stackTrace) {
          log('Erro ao carregar a pagina',
              error: error, stackTrace: stackTrace);
          return const Center(
            child: Text('Erro ao carregar a pagina'),
          );
        },
        loading: () => const BarbershopLoader(),
        data: (barbershopModel) {
          final BarbershopModel(:openingDays, :openingHours) = barbershopModel;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Column(
                  children: [
                    const Avatar(),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      children: [
                        Checkbox.adaptive(
                            activeColor: ColorsConstants.brown,
                            value: _registerAdm,
                            onChanged: (value) {
                              setState(() {
                                _registerAdm = !_registerAdm;
                                employeeRegisterVm.setRegisterAdm(_registerAdm);
                              });
                            }),
                        const Expanded(
                          child: Text(
                            'Sou um administrador e quero me cadastrar como um colaborador',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    Offstage(
                      offstage: _registerAdm,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameEC,
                              validator: _registerAdm
                                  ? null
                                  : Validatorless.required(
                                      'Nome é obrigatório'),
                              onTapOutside: (_) => context.unfocus(),
                              decoration: const InputDecoration(
                                label: Text('Nome'),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              controller: _emailEC,
                              validator: _registerAdm
                                  ? null
                                  : Validatorless.multiple(
                                      [
                                        Validatorless.email('E-mail inválido'),
                                        Validatorless.required(
                                            'E-mail é obrigatório')
                                      ],
                                    ),
                              onTapOutside: (_) => context.unfocus(),
                              decoration: const InputDecoration(
                                label: Text('E-mail'),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: _passwordEC,
                              validator: _registerAdm
                                  ? null
                                  : Validatorless.multiple(
                                      [
                                        Validatorless.required(
                                            'Senha é obrigatório'),
                                        Validatorless.min(6,
                                            'Senha deve ter no minimo 6 caracteres'),
                                      ],
                                    ),
                              onTapOutside: (_) => context.unfocus(),
                              decoration: const InputDecoration(
                                label: Text('Senha'),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    WeekdaysPanel(
                      enableDays: openingDays,
                      onDayPressed: employeeRegisterVm.addOrRemoveWorkDays,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    HoursPanel(
                      enableHours: openingHours,
                      startTime: 6,
                      endTime: 23,
                      onHourPressed: employeeRegisterVm.addOrRemoveWorkHours,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                      ),
                      onPressed: () {
                        switch (_formKey.currentState?.validate()) {
                          case null || false:
                            Messages.showError('Formulário inválido', context);
                          case true:
                            final EmployeeRegisterState(
                              workDays: List(isNotEmpty: hasWorkDays),
                              workHours: List(isNotEmpty: hasWorkHours)
                            ) = ref.watch(employeeRegisterVmProvider);

                            if (!hasWorkDays || !hasWorkHours) {
                              Messages.showError(
                                'Por favor, selecione os dias da semana e horário de atendimento',
                                context,
                              );
                            }
                            final name = _nameEC.text;
                            final email = _emailEC.text;
                            final password = _passwordEC.text;
                            employeeRegisterVm.register(
                              name: name,
                              email: email,
                              password: password,
                            );
                        }
                      },
                      child: const Text('CADASTRAR COLABORADOR'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
