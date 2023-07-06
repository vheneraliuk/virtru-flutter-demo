import 'package:flutter/material.dart';
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
            var snackBar = const SnackBar(
              content: Text('Activation completed!'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            BlocProvider.of<AuthCubit>(context).reloadCurrentState();
          }
          if (state.error != null) {
            var snackBar = SnackBar(
              backgroundColor: Theme.of(context).colorScheme.error,
              content: Text(
                state.error?.message ?? 'Unknown error',
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
            padding: const EdgeInsets.all(24.0),
            child: TextFormField(
              onFieldSubmitted: (value) => validateAndRequestCode(),
              textInputAction: TextInputAction.send,
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
              onPressed: () => validateAndRequestCode(),
              child: const Text("Send Code")),
        ],
      ),
    );
  }

  void validateAndRequestCode() {
    if (_emailFormKey.currentState!.validate()) {
      BlocProvider.of<LoginCubit>(context).sendCode(emailTextController.text);
    }
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
            padding: const EdgeInsets.all(24.0),
            child: TextFormField(
              onFieldSubmitted: (value) => validateAndSendCode(),
              textInputAction: TextInputAction.done,
              maxLength: 7,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: OutlinedButton.icon(
                    onPressed: () =>
                        BlocProvider.of<LoginCubit>(context).backToSendCode(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Back")),
              ),
              OutlinedButton(
                  onPressed: () => validateAndSendCode(),
                  child: const Text("Activate")),
            ],
          ),
        ],
      ),
    );
  }

  void validateAndSendCode() {
    if (_codeFormKey.currentState!.validate()) {
      BlocProvider.of<LoginCubit>(context).activate(codeTextController.text);
    }
  }
}
