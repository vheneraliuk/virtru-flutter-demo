import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' show basename;
import 'package:share_plus/share_plus.dart';
import 'package:virtru_demo_flutter/bloc/bloc.dart';
import 'package:virtru_demo_flutter/helpers/helpers.dart';

class DecryptWidget extends StatefulWidget {
  const DecryptWidget({super.key});

  @override
  State<DecryptWidget> createState() => _DecryptWidgetState();
}

class _DecryptWidgetState extends State<DecryptWidget> {
  final _rcaFormKey = GlobalKey<FormState>();
  final _rcaLinkTextController = TextEditingController();

  @override
  void dispose() {
    _rcaLinkTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DecryptCubit, DecryptState>(
      listener: (context, state) {
        if (state.decryptedFile != null) {
          _shareFile(state.decryptedFile!);
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
      child: BlocBuilder<DecryptCubit, DecryptState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.decryptedString != null) {
            return SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Decrypted text:"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state.decryptedString!,
                        style: const TextStyle(fontSize: 19),
                      ),
                    ),
                    OutlinedButton.icon(
                        onPressed: _clear,
                        icon: const Icon(Icons.lock_open_outlined),
                        label: const Text("Decrypt more")),
                  ],
                ),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                state.inputFile == null
                    ? Column(
                        children: [
                          Form(
                            key: _rcaFormKey,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, top: 24, bottom: 8),
                              child: TextFormField(
                                textInputAction: TextInputAction.newline,
                                controller: _rcaLinkTextController,
                                minLines: 3,
                                maxLines: 5,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'You have to provide RCA Link';
                                  }
                                  // } else if (!urlRegExp.hasMatch(value)) {
                                  //   return 'Please provide a valid RCA Link';
                                  // }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'RCA Link',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          const Text("OR"),
                          OutlinedButton.icon(
                              onPressed: _addFile,
                              icon: const Icon(Icons.file_open_outlined),
                              label: const Text("Select file")),
                        ],
                      )
                    : Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 24, bottom: 8),
                            child: Text("File to decrypt:"),
                          ),
                          Chip(
                            avatar: const Icon(Icons.file_present_outlined),
                            label: Text(basename(state.inputFile!.path)),
                            onDeleted: _bloc.removeInputFile,
                          ),
                        ],
                      ),
                const Divider(),
                OutlinedButton.icon(
                    onPressed: _validateAndDecrypt,
                    icon: const Icon(Icons.lock_open_outlined),
                    label: const Text("Decrypt")),
              ],
            ),
          );
        },
      ),
    );
  }

  _validateAndDecrypt() async {
    final inputFile = _bloc.state.inputFile;
    final decryptRca = inputFile == null;
    if (decryptRca) {
      if (!_rcaFormKey.currentState!.validate()) return;
      FocusManager.instance.primaryFocus?.unfocus();
      _bloc.decryptRca(_rcaLinkTextController.text);
    } else {
      if (!inputFile.path.contains(tdfExt)) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Warning'),
            content: const Text(
                'Probably you`re trying to decrypt regular file not encrypted one. Do you want to decrypt it anyway?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop("No"),
                  child: const Text("No")),
              TextButton(
                  onPressed: () {
                    _bloc.decryptFile();
                    Navigator.of(context).pop("Yes");
                  },
                  child: const Text("Yes"))
            ],
          ),
        );
      } else {
        _bloc.decryptFile();
      }
    }
  }

  void _shareFile(File encryptedFile) async {
    await Share.shareXFiles(
      [
        XFile(
          encryptedFile.path,
        )
      ],
    );
    _clear();
  }

  _clear() {
    _rcaLinkTextController.clear();
    _bloc.clear();
  }

  _addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) return;
    final inputFile = File(result.files.single.path!);
    _bloc.setInputFile(inputFile);
  }

  DecryptCubit get _bloc => BlocProvider.of<DecryptCubit>(context);
}
