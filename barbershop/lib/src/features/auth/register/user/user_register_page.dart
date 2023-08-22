import 'package:barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:barbershop/src/features/auth/register/user/user_register_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/ui/helpers/messages.dart';

class UserRegisterPage extends ConsumerStatefulWidget {
  const UserRegisterPage({super.key});

  @override
  ConsumerState<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends ConsumerState<UserRegisterPage> {
  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _nameEC.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userRegisterVm = ref.watch(userRegisterVmProvider.notifier);

    ref.listen(
      userRegisterVmProvider,
      (_, state) {
        switch (state) {
          case UserRegisterStateStatus.initial:
            break;
          case UserRegisterStateStatus.success:
            Navigator.of(context).pushNamed('/auth/register/barbershop');
          case UserRegisterStateStatus.error:
            Messages.showError(
                'Erro ao registrar usuário administrador', context);
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Criar Conta',
          style: TextStyle(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onTapOutside: (_) => context.unfocus(),
                  controller: _nameEC,
                  validator: Validatorless.required('Nome é obrigatório'),
                  decoration: const InputDecoration(
                    label: Text('Nome'),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  onTapOutside: (_) => context.unfocus(),
                  controller: _emailEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('E-mail é obrigatório'),
                    Validatorless.email('E-mail inválido'),
                  ]),
                  decoration: const InputDecoration(
                    label: Text('E-mail'),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  onTapOutside: (_) => context.unfocus(),
                  controller: _passwordEC,
                  obscureText: true,
                  validator: Validatorless.multiple([
                    Validatorless.required('Senha é obrigatório'),
                    Validatorless.min(
                        6, 'Senha deve ter no minimo 6 caracteres'),
                  ]),
                  decoration: const InputDecoration(
                    label: Text('Senha'),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  onTapOutside: (_) => context.unfocus(),
                  obscureText: true,
                  validator: Validatorless.multiple(
                    [
                      Validatorless.required(
                          'Confirmação da senha é obrigatória'),
                      Validatorless.compare(
                          _passwordEC, 'As senhas digitadas não conferem'),
                    ],
                  ),
                  decoration: const InputDecoration(
                    label: Text('Confirmar Senha'),
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
                    switch (_formKey.currentState?.validate()) {
                      case (false || null):
                        Messages.showError('Formulário inválido', context);
                        //Mostrar erro
                        break;
                      case true:
                        userRegisterVm.register(
                          name: _nameEC.text,
                          email: _emailEC.text,
                          password: _passwordEC.text,
                        );
                    }
                  },
                  child: const Text('CRIAR CONTA'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
