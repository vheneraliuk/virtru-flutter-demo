import 'package:flutter/material.dart';
import 'package:virtru_demo_flutter/bloc/bloc.dart';
import 'package:virtru_demo_flutter/helpers/helpers.dart';

class AppIdActivationDialog extends StatefulWidget {
  final LoginCubit _bloc;

  const AppIdActivationDialog(this._bloc, {super.key});

  @override
  State<AppIdActivationDialog> createState() => _AppIdActivationDialogState();
}

class _AppIdActivationDialogState extends State<AppIdActivationDialog> {
  final _emailTextController = TextEditingController();
  final _appIdTextController = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailTextController.dispose();
    _appIdTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _emailFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _emailTextController,
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
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _appIdTextController,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter AppId';
                  } else if (!appIdRegExp.hasMatch(value)) {
                    return 'Please enter valid AppId';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'AppId',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop("Discard"),
            child: const Text("Discard")),
        TextButton(
            onPressed: () {
              if (!_emailFormKey.currentState!.validate()) return;
              widget._bloc.activateWithAppId(
                  _emailTextController.text, _appIdTextController.text);
              Navigator.of(context).pop("Activate");
            },
            child: const Text("Activate"))
      ],
    );
  }
}
