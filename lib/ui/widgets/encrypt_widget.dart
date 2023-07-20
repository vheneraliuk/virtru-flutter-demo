import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' show basename;
import 'package:share_plus/share_plus.dart';
import 'package:virtru_demo_flutter/bloc/bloc.dart';
import 'package:virtru_demo_flutter/ui/widgets/widgets.dart';

class EncryptWidget extends StatefulWidget {
  const EncryptWidget({super.key});

  @override
  State<EncryptWidget> createState() => _EncryptWidgetState();
}

class _EncryptWidgetState extends State<EncryptWidget> {
  final _encryptFormKey = GlobalKey<FormState>();
  final _messageTextController = TextEditingController();

  @override
  void dispose() {
    _messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EncryptCubit, EncryptState>(
      listener: (context, state) {
        if (state.encryptedFile != null) {
          _shareFile(state.encryptedFile!);
        }
        if (state.rcaLink != null) {
          _shareLink(state.rcaLink!);
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
      child: BlocBuilder<EncryptCubit, EncryptState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                state.inputFile == null
                    ? Column(
                        children: [
                          Form(
                            key: _encryptFormKey,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, top: 24, bottom: 8),
                              child: TextFormField(
                                textInputAction: TextInputAction.newline,
                                controller: _messageTextController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                minLines: 5,
                                maxLines: 15,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'You need some text to encrypt';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Message to encrypt',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          const Text("OR"),
                          OutlinedButton.icon(
                              onPressed: _addFile,
                              icon: const Icon(Icons.file_open_outlined),
                              label: const Text("Encrypt file")),
                        ],
                      )
                    : Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 24, bottom: 8),
                            child: Text("File to encrypt:"),
                          ),
                          Chip(
                            avatar: const Icon(Icons.file_present_outlined),
                            label: Text(basename(state.inputFile!.path)),
                            onDeleted: _bloc.removeInputFile,
                          ),
                        ],
                      ),
                state.shareWith.isNotEmpty
                    ? Column(
                        children: [
                          const Divider(),
                          const Text("Shared with:"),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 8,
                              children: state.shareWith
                                  .map((user) => Chip(
                                        avatar: const Icon(Icons
                                            .supervised_user_circle_outlined),
                                        label: Text(user),
                                        onDeleted: () => _bloc.removeUser(user),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                const Divider(),
                CheckboxListTile(
                    title: const Text("Result as RCA Link"),
                    value: state.encryptToRca,
                    onChanged: (value) => _bloc.setRcaLinkAsResult(value!)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 24.0),
                      child: OutlinedButton.icon(
                          onPressed: _shareWith,
                          icon: const Icon(Icons.add_reaction_outlined),
                          label: const Text("Share with")),
                    ),
                    OutlinedButton.icon(
                        onPressed: _validateAndEncrypt,
                        icon: const Icon(Icons.lock_outline),
                        label: const Text("Encrypt")),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _validateAndEncrypt() async {
    final bloc = _bloc;
    final encryptText = bloc.state.inputFile == null;
    if (encryptText) {
      if (!_encryptFormKey.currentState!.validate()) return;
      FocusManager.instance.primaryFocus?.unfocus();
    }
    if (bloc.state.shareWith.isEmpty) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Warning'),
          content: const Text(
              'Probably you forgot to add some users to share this message with. Do you want to encrypt it anyway?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop("No"),
                child: const Text("No")),
            TextButton(
                onPressed: () {
                  _encrypt(encryptText);
                  Navigator.of(context).pop("Yes");
                },
                child: const Text("Yes"))
          ],
        ),
      );
    } else {
      _encrypt(encryptText);
    }
  }

  void _encrypt(bool encryptText) {
    if (encryptText) {
      _bloc.encryptMessage(_messageTextController.text);
    } else {
      _bloc.encryptFile();
      // _bloc.encryptFileToRCA();
    }
  }

  void _shareFile(File encryptedFile) async {
    await Share.shareXFiles(
      [
        XFile(
          encryptedFile.path,
          mimeType: ContentType.html.mimeType,
        )
      ],
    );
    _clear();
  }
  void _shareLink(String rcaLink) async {
    await Share.share(
      rcaLink,
      subject: "Virtru RCA Link"
    );
    _clear();
  }

  _clear() {
    _messageTextController.clear();
    _bloc.clear();
  }

  _shareWith() async {
    FocusManager.instance.primaryFocus?.unfocus();

    await showDialog(
      context: context,
      builder: (_) => AddUserDialog(_bloc),
    );
  }

  _addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) return;
    final inputFile = File(result.files.single.path!);
    _bloc.setInputFile(inputFile);
  }

  EncryptCubit get _bloc => BlocProvider.of<EncryptCubit>(context);
}
