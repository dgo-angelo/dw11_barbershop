import 'package:asyncstate/widget/async_state_builder.dart';
import 'package:barbershop/src/core/ui/barbershop_nav_global_key.dart';
import 'package:barbershop/src/core/ui/barbershop_theme.dart';
import 'package:barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:barbershop/src/features/auth/login/login_page.dart';
import 'package:barbershop/src/features/auth/register/barbershop/barbershop_register_page.dart';
import 'package:barbershop/src/features/auth/register/user/user_register_page.dart';
import 'package:barbershop/src/features/employee/register/employee_register_page.dart';
import 'package:barbershop/src/features/employee/schedule/employee_schedule_page.dart';
import 'package:barbershop/src/features/home/adm/home_adm_page.dart';
import 'package:barbershop/src/features/home/employee/home_employee.dart';
import 'package:barbershop/src/features/schedule/schedule_page.dart';
import 'package:barbershop/src/features/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class BarbershopApp extends StatelessWidget {
  const BarbershopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncStateBuilder(
      customLoader: const BarbershopLoader(),
      builder: (asyncNavigatorObserver) => MaterialApp(
        theme: BarbershopTheme.themeData,
        debugShowCheckedModeBanner: false,
        title: "DW Barbershop",
        navigatorObservers: [asyncNavigatorObserver],
        navigatorKey: BarbershopNavGlobalKey.instance.navKey,
        routes: {
          '/': (context) => const SplashPage(),
          '/auth/login': (context) => const LoginPage(),
          '/auth/register/user': (context) => const UserRegisterPage(),
          '/auth/register/barbershop': (context) =>
              const BarbershopRegisterPage(),
          '/home/adm': (context) => const HomeAdmPage(),
          '/home/employee': (context) => const HomeEmployee(),
          '/employee/register': (context) => const EmployeeRegisterPage(),
          '/employee/schedule': (context) => const EmployeeSchedulePage(),
          '/schedule': (context) => const SchedulePage(),
        },
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('pt', 'BR'),
        ],
        locale: const Locale('pt', 'BR'),
      ),
    );
  }
}
