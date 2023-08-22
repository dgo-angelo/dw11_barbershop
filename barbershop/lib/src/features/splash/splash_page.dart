import 'dart:async';
import 'dart:developer';

import 'package:barbershop/src/core/ui/constants.dart';
import 'package:barbershop/src/core/ui/helpers/messages.dart';
import 'package:barbershop/src/features/splash/splash_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  var _scale = 10.0;
  var _animationOpacityLogo = 0.0;

  var endAnimation = false;
  double get _logoAnimationWidth => 100 * _scale;
  double get _logoAnimationHeight => 120 * _scale;
  Timer? redirectTimer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _animationOpacityLogo = 1.0;
        _scale = 1;
      });
    });
    super.initState();
  }

  void _redirect(String routeName) {
    if (!endAnimation) {
      redirectTimer?.cancel();
      redirectTimer = Timer(const Duration(milliseconds: 300), () {
        _redirect(routeName);
      });
    } else {
      redirectTimer?.cancel();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(routeName, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashVmProvider, (_, state) {
      state.whenOrNull(error: (error, stackTrace) {
        log('Error ao validar login', error: error, stackTrace: stackTrace);
        Messages.showError('Error ao validar login', context);

        _redirect('/auth/login');
      }, data: (status) {
        switch (status) {
          case SplashState.loggedAdm:
            _redirect('/home/adm');
          case SplashState.loggedEmployee:
            _redirect('/home/employee');
          case _:
            _redirect('/auth/login');
        }
      });
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagesConstants.backgroundChair),
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            duration: const Duration(seconds: 3),
            curve: Curves.easeIn,
            opacity: _animationOpacityLogo,
            child: AnimatedContainer(
              duration: const Duration(seconds: 3),
              width: _logoAnimationWidth,
              height: _logoAnimationHeight,
              curve: Curves.linearToEaseOut,
              child: Image.asset(
                ImagesConstants.imageLogo,
                fit: BoxFit.cover,
              ),
            ),
            onEnd: () {
              setState(() {
                endAnimation = true;
              });
            },
            //   Navigator.of(context).pushAndRemoveUntil(
            //     PageRouteBuilder(
            //       pageBuilder: (context, animation, secondaryAnimation) {
            //         return const LoginPage();
            //       },
            //       transitionsBuilder: (_, animation, __, child) {
            //         return FadeTransition(
            //           opacity: animation,
            //           child: child,
            //         );
            //       },
            //       settings: const RouteSettings(name: '/auth/login'),
            //     ),
            //     (route) => false,
            //   );
            // },
          ),
        ),
      ),
    );
  }
}
