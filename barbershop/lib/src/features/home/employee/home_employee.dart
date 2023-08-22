import 'package:barbershop/src/core/providers/application_providers.dart';
import 'package:barbershop/src/core/ui/constants.dart';
import 'package:barbershop/src/core/ui/widgets/avatar.dart';
import 'package:barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:barbershop/src/features/home/employee/home_employee_provider.dart';
import 'package:barbershop/src/features/home/widgets/home_header.dart';
import 'package:barbershop/src/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeEmployee extends ConsumerWidget {
  const HomeEmployee({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModelAsync = ref.watch(getMeProvider);
    return Scaffold(
      body: userModelAsync.when(
        error: (error, stackTrace) {
          return const Center(
            child: Text('Erro ao carregar pagina'),
          );
        },
        loading: () => const BarbershopLoader(),
        data: (user) {
          final UserModel(:id, :name) = user;
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: HomeHeader(
                  hideFilter: true,
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Avatar(
                        hideUploadButton: true,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * .7,
                        height: 90,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorsConstants.grey,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Consumer(
                              builder: (context, ref, child) {
                                final totalAsync = ref
                                    .watch(getTotalSchedulesTodayProvider(id));
                                return totalAsync.when(
                                  error: (error, stackTrace) => const Center(
                                    child: Text(
                                        'Erro ao carregar todal de agendamentos'),
                                  ),
                                  loading: () => const BarbershopLoader(),
                                  skipLoadingOnRefresh: false,
                                  data: (totalSchedules) {
                                    return Text(
                                      '$totalSchedules',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 32,
                                        color: ColorsConstants.brown,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const Text(
                              'Hoje',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                        ),
                        onPressed: () async {
                          await Navigator.of(context).pushNamed(
                            '/schedule',
                            arguments: user,
                          );
                          ref.invalidate(getTotalSchedulesTodayProvider);
                        },
                        child: const Text('AGENDAR CLIENTE'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            '/employee/schedule',
                            arguments: user,
                          );
                        },
                        child: const Text('VER AGENDA'),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
