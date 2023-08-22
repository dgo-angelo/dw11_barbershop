import 'package:barbershop/src/core/ui/constants.dart';
import 'package:barbershop/src/core/ui/helpers/messages.dart';
import 'package:barbershop/src/features/auth/login/login_state.dart';
import 'package:barbershop/src/features/auth/login/login_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:validatorless/validatorless.dart';

import '../../../core/ui/helpers/form_helper.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LoginVm(:login) = ref.watch(loginVmProvider.notifier);
    ref.listen(
      loginVmProvider,
      (_, state) {
        switch (state) {
          case LoginState(status: LoginStateStatus.initial):
            break;
          case LoginState(
              status: LoginStateStatus.error,
              errorMessage: final errorMessage?
            ):
            Messages.showError(errorMessage, context);
            break;
          case LoginState(
              status: LoginStateStatus.error,
            ):
            Messages.showError('Erro ao realizar login', context);
            break;
          case LoginState(status: LoginStateStatus.admLogin):
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/home/adm', (route) => false);
            break;
          case LoginState(status: LoginStateStatus.employeeLogin):
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/home/employee', (route) => false);
            break;
        }
      },
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: formKey,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImagesConstants.backgroundChair),
              fit: BoxFit.cover,
              opacity: 0.2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            ImagesConstants.imageLogo,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            controller: emailEC,
                            validator: Validatorless.multiple([
                              Validatorless.required('E-mail é obrigatório'),
                              Validatorless.email('E-mail inválido'),
                            ]),
                            onTapOutside: (_) => context.unfocus(),
                            decoration: const InputDecoration(
                              label: Text('E-mail'),
                              hintText: 'E-mail',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            controller: passwordEC,
                            validator: Validatorless.multiple([
                              Validatorless.required('Senha é obrigatória'),
                            ]),
                            onTapOutside: (_) => context.unfocus(),
                            obscureText: true,
                            decoration: const InputDecoration(
                              label: Text('Senha'),
                              hintText: 'Senha',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Esqueceu sua senha?',
                                    style: TextStyle(
                                      color: ColorsConstants.brown,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => Navigator.of(context)
                                      .pushNamed('/auth/register/user'),
                                  child: const Text(
                                    'Criar conta',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                            ),
                            onPressed: () {
                              final email = emailEC.text;
                              final password = passwordEC.text;

                              switch (formKey.currentState?.validate()) {
                                case (false || null):
                                  Messages.showError(
                                      'Formulário inválido', context);
                                  //Mostrar erro
                                  break;
                                case true:
                                  login(email, password);
                              }
                            },
                            child: const Text('ACESSAR'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
