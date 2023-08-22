import 'dart:developer';

import 'package:barbershop/src/core/ui/constants.dart';
import 'package:barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:barbershop/src/features/employee/schedule/appointment_ds.dart';
import 'package:barbershop/src/features/employee/schedule/employee_schedule_vm.dart';
import 'package:barbershop/src/features/schedule/schedule_vm.dart';
import 'package:barbershop/src/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EmployeeSchedulePage extends ConsumerStatefulWidget {
  const EmployeeSchedulePage({super.key});

  @override
  ConsumerState<EmployeeSchedulePage> createState() =>
      _EmployeeSchedulePageState();
}

class _EmployeeSchedulePageState extends ConsumerState<EmployeeSchedulePage> {
  late DateTime selectedDate;
  var ignoreFirstLoad = true;

  @override
  void initState() {
    final DateTime(:year, :month, :day) = DateTime.now();
    selectedDate = DateTime(year, month, day, 0, 0, 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel(:id, :name) =
        ModalRoute.of(context)?.settings.arguments! as UserModel;

    final scheduleAsync =
        ref.watch(employeeScheduleVmProvider(id, selectedDate));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 44,
            ),
            scheduleAsync.when(
              loading: () => const BarbershopLoader(),
              error: (error, stackTrace) {
                log('Erro ao carregar agendamentos',
                    error: error, stackTrace: stackTrace);
                return const Center(
                  child: Text('Erro ao carregar agendamentos'),
                );
              },
              data: (schedules) {
                return Expanded(
                  child: SfCalendar(
                    onViewChanged: (viewChangedDetails) {
                      if (ignoreFirstLoad) {
                        ignoreFirstLoad = false;
                        return;
                      }

                      ref
                          .read(employeeScheduleVmProvider(id, selectedDate)
                              .notifier)
                          .changeDate(
                            id,
                            viewChangedDetails.visibleDates.first,
                          );
                    },
                    allowViewNavigation: true,
                    view: CalendarView.day,
                    showNavigationArrow: true,
                    todayHighlightColor: ColorsConstants.brown,
                    showDatePickerButton: true,
                    showTodayButton: true,
                    dataSource: AppointmentDs(schedules: schedules),
                    onTap: (calendarTapDetails) {
                      if (calendarTapDetails.appointments != null &&
                          calendarTapDetails.appointments!.isNotEmpty) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            final dateFormat =
                                DateFormat('dd/MM/yyyy : HH:mm:ss');
                            return SizedBox(
                              height: 200,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Cliente: ${calendarTapDetails.appointments!.first.subject}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Horário: ${dateFormat.format(
                                        calendarTapDetails.date ??
                                            DateTime.now(),
                                      )}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
