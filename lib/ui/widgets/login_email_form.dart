import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtru_demo_flutter/bloc/bloc.dart';
import 'package:virtru_demo_flutter/helpers/helpers.dart';
import 'package:virtru_demo_flutter/ui/widgets/app_id_activation_dialog.dart';

class LoginEmailForm extends StatefulWidget {
  const LoginEmailForm({super.key});

  @override
  State<LoginEmailForm> createState() => _LoginEmailFormState();
}

class _LoginEmailFormState extends State<LoginEmailForm> {
  final _emailFormKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();

  @override
  void dispose() {
    emailTextController.dispose();
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
          key: _emailFormKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextFormField(
                  enabled: !kIsWeb,
                  onFieldSubmitted: (value) => _validateAndRequestCode(),
                  textInputAction: TextInputAction.send,
                  controller: emailTextController,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    } else if (!emailRegExp.hasMatch(value)) {
                      return 'Please enter valid email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    helperText: 'Email to send code to',
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: _activateWithAppId,
                      child: const Text("Activate with AppId")),
                  const SizedBox(width: 24),
                  OutlinedButton(
                      onPressed:
                      (!kIsWeb ? _validateAndRequestCode : null),
                      child: const Text("Send Code")),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _validateAndRequestCode() {
    if (_emailFormKey.currentState!.validate()) {
      BlocProvider.of<LoginCubit>(context).sendCode(emailTextController.text);
    }
  }

  _activateWithAppId() async {
    FocusManager.instance.primaryFocus?.unfocus();

    await showDialog(
      context: context,
      builder: (_) =>
          AppIdActivationDialog(BlocProvider.of<LoginCubit>(context)),
    );
  }
}
