import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtru_demo_flutter/bloc/bloc.dart';
import 'package:virtru_demo_flutter/ui/ui.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return VirtruAppBar(
      title: 'Activation',
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.authenticated) {
            BlocProvider.of<AuthCubit>(context).reloadCurrentState();
          }
        },
        builder: (context, state) {
          if (state.status == LoginStatus.initial) {
            return const EmailForm();
          } else {
            return const CodeForm();
          }
        },
      ),
    );
  }
}

class EmailForm extends StatefulWidget {
  const EmailForm({super.key});

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _emailFormKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();

  @override
  void dispose() {
    emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _emailFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: emailTextController,
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                } else if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
                  return 'Please enter valid email';
                }
                return null;
              },
              decoration: const InputDecoration(
                helperText: 'Email to send code to',
                labelText: 'Email',
                // prefix: Text('V-'),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          OutlinedButton(
              onPressed: () => {
                    if (_emailFormKey.currentState!.validate())
                      {
                        BlocProvider.of<LoginCubit>(context)
                            .sendCode(emailTextController.text)
                      }
                  },
              child: const Text("Send Code")),
        ],
      ),
    );
  }
}

class CodeForm extends StatefulWidget {
  const CodeForm({super.key});

  @override
  State<CodeForm> createState() => _CodeFormState();
}

class _CodeFormState extends State<CodeForm> {
  final _codeFormKey = GlobalKey<FormState>();
  final codeTextController = TextEditingController();

  @override
  void dispose() {
    codeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _codeFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              maxLength: 7,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              controller: codeTextController,
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter code';
                } else if (value.length != 7) {
                  return 'Code should be 7 characters long';
                }
                return null;
              },
              decoration: const InputDecoration(
                helperText: 'Code from email',
                labelText: 'Code',
                prefix: Text('V-'),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          OutlinedButton(
              onPressed: () => {
                    if (_codeFormKey.currentState!.validate())
                      {
                        BlocProvider.of<LoginCubit>(context)
                            .activate(codeTextController.text)
                      }
                  },
              child: const Text("Activate")),
        ],
      ),
    );
  }
}
