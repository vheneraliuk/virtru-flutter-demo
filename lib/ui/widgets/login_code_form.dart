import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtru_demo_flutter/bloc/bloc.dart';

class LoginCodeForm extends StatefulWidget {
  const LoginCodeForm({super.key});

  @override
  State<LoginCodeForm> createState() => _LoginCodeFormState();
}

class _LoginCodeFormState extends State<LoginCodeForm> {
  final _codeFormKey = GlobalKey<FormState>();
  final codeTextController = TextEditingController();

  @override
  void dispose() {
    codeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Form(
          key: _codeFormKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextFormField(
                  onFieldSubmitted: (value) => _validateAndSendCode(),
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
                  OutlinedButton.icon(
                      onPressed: () => BlocProvider.of<LoginCubit>(context)
                          .backToSendCode(),
                      icon: const Icon(Icons.arrow_back_outlined),
                      label: const Text("Back")),
                  const SizedBox(width: 24),
                  OutlinedButton(
                      onPressed: _validateAndSendCode,
                      child: const Text("Activate")),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _validateAndSendCode() {
    if (_codeFormKey.currentState!.validate()) {
      BlocProvider.of<LoginCubit>(context).activate(codeTextController.text);
    }
  }
}
