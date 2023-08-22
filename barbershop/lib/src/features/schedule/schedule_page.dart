import 'package:barbershop/src/core/fp/either.dart';
import 'package:barbershop/src/core/ui/barbershop_icons.dart';
import 'package:barbershop/src/core/ui/constants.dart';
import 'package:barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:barbershop/src/core/ui/helpers/messages.dart';
import 'package:barbershop/src/core/ui/widgets/avatar.dart';
import 'package:barbershop/src/core/ui/widgets/hours_panel.dart';
import 'package:barbershop/src/features/schedule/schedule_state.dart';
import 'package:barbershop/src/features/schedule/schedule_vm.dart';
import 'package:barbershop/src/features/schedule/widgets/schedule_calendar.dart';
import 'package:barbershop/src/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  var dateFormat = DateFormat('dd/MM/yyyy');
  var _showCalendar = false;
  final _formKey = GlobalKey<FormState>();
  final _customerEC = TextEditingController();
  final _dateEC = TextEditingController();

  @override
  void dispose() {
    _customerEC.dispose();
    _dateEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = ModalRoute.of(context)?.settings.arguments! as UserModel;
    final scheduleVm = ref.watch(scheduleVmProvider.notifier);

    final employeeData = switch (userModel) {
      UserModelADM(:final workDays, :final workHours) => (
          workDays: workDays!,
          workHours: workHours!,
        ),
      UserModelEmployee(:final workDays, :final workHours) => (
          workDays: workDays!,
          workHours: workHours!,
        ),
    };

    ref.listen(scheduleVmProvider.select((state) => state.status), (_, status) {
      switch (status) {
        case ScheduleStateStatus.initial:
          break;
        case ScheduleStateStatus.success:
          Messages.showSuccess('Cliente agendado com sucesso.', context);
          Navigator.of(context).pop();
        case ScheduleStateStatus.error:
          Messages.showError('Erro ao realizar agendamento.', context);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar cliente'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Avatar(hideUploadButton: true),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    userModel.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 37,
                  ),
                  TextFormField(
                    controller: _customerEC,
                    validator: Validatorless.required('Cliente é obrigatório'),
                    onTapOutside: (_) => context.unfocus(),
                    decoration: const InputDecoration(
                      label: Text('Cliente'),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  TextFormField(
                    onTap: () {
                      setState(() {
                        _showCalendar = true;
                      });
                      context.unfocus();
                    },
                    readOnly: true,
                    controller: _dateEC,
                    validator: Validatorless.required(
                        'Selecione a data do agendamento.'),
                    decoration: const InputDecoration(
                      label: Text('Selecione uma data'),
                      hintText: 'Selecione uma data',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      suffixIcon: Icon(
                        BarbershopIcons.calendar,
                        color: ColorsConstants.brown,
                        size: 18,
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: !_showCalendar,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        ScheduleCalendar(
                          workDays: employeeData.workDays,
                          onCancelPressed: () {
                            setState(() {
                              _showCalendar = false;
                            });
                          },
                          onOkPressed: (DateTime date) {
                            setState(() {
                              _showCalendar = false;
                              scheduleVm.selectDate(date);
                              _dateEC.text = dateFormat.format(date);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  HoursPanel.singleSelection(
                    startTime: 6,
                    endTime: 23,
                    onHourPressed: scheduleVm.selectHour,
                    enableHours: employeeData.workHours,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      switch (_formKey.currentState?.validate()) {
                        case false || null:
                          Messages.showError('Formulário inválido', context);
                        case true:
                          final isHourSelected = ref.watch(scheduleVmProvider
                              .select((state) => state.scheduleHour != null));
                          if (isHourSelected) {
                            scheduleVm.register(
                              userModel: userModel,
                              customerName: _customerEC.text,
                            );
                          } else {
                            Messages.showError(
                                'Por favor, selecione um horário de atendimento.',
                                context);
                          }
                      }
                    },
                    child: const Text('AGENDAR'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
