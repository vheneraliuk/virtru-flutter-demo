import 'package:flutter/material.dart';
import 'package:virtru_demo_flutter/bloc/bloc.dart';
import 'package:virtru_demo_flutter/helpers/helpers.dart';

class AddUserDialog extends StatefulWidget {
  final EncryptCubit _bloc;

  const AddUserDialog(this._bloc, {super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _textController = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _emailFormKey,
        child: TextFormField(
          onFieldSubmitted: (value) => _verifyAndAddUser(),
          textInputAction: TextInputAction.done,
          controller: _textController,
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
            labelText: 'Share with',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop("Discard"),
            child: const Text("Discard")),
        TextButton(onPressed: _verifyAndAddUser, child: const Text("Add"))
      ],
    );
  }

  void _verifyAndAddUser() {
    if (!_emailFormKey.currentState!.validate()) return;
    widget._bloc.shareWithUser(_textController.text);
    Navigator.of(context).pop("Add");
  }
}
