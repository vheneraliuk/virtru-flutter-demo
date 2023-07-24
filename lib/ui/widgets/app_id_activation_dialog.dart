import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
  final _dashboardUrl =
      Uri.parse("https://secure.virtru.com/dashboard-v2/settings");

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
            const SizedBox(height: 8),
            RichText(
                textAlign: TextAlign.start,
                text: TextSpan(children: [
                  TextSpan(
                      text: "You can generate AppId on your ",
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer)),
                  TextSpan(
                    text: "Virtru Dashboard",
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        if (!await launchUrl(_dashboardUrl,
                            mode: LaunchMode.externalApplication)) {
                          debugPrint("Can't launch Dashboard url");
                        }
                      },
                  ),
                  TextSpan(
                      text: " settings page.\nGo to ",
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer)),
                  TextSpan(
                      text: "Developers",
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: " tab and switch on ",
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer)),
                  TextSpan(
                      text: "Developer Mode",
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold)),
                ])),
            const SizedBox(height: 16),
            TextFormField(
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
            const SizedBox(height: 16),
            TextFormField(
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
