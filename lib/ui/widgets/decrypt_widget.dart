import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Decrypting...",
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            child: _buildWidget(state),
          );
        },
      ),
    );
  }

  Widget _buildWidget(DecryptState state) {
    if (state.decryptedString != null) {
      return _DecryptStringResult(
        decryptedResult: state.decryptedString!,
        clear: _clear,
        shareText: _shareStringResult,
        copyToClipboard: _copyResultToClipboard,
      );
    } else if (state.decryptedFile != null) {
      return _DecryptFileResult(
        decryptedFileName: basename(state.decryptedFile!.path),
        clear: _clear,
        shareFile: _saveOrShareFile,
      );
    }
    return Column(
      children: [
        state.inputFile == null
            ? _DecryptRcaLink(
                rcaFormKey: _rcaFormKey,
                rcaTextController: _rcaLinkTextController,
                addFile: _addFile,
              )
            : _DecryptFile(
                filename: basename(state.inputFile!.path),
                removeInputFile: _bloc.removeInputFile),
        const Divider(),
        const SizedBox(height: 8),
        OutlinedButton.icon(
            onPressed: _validateAndDecrypt,
            icon: const Icon(Icons.lock_open_outlined),
            label: const Text("Decrypt")),
        const SizedBox(height: 24)
      ],
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

  _saveOrShareFile() async {
    final decryptedFile = _bloc.state.decryptedFile!;
    if (isDesktop()) {
      final selectedFilePath = await FilePicker.platform.saveFile(
        fileName: basename(decryptedFile.path),
      );
      if (selectedFilePath != null) {
        await decryptedFile.copy(selectedFilePath);
      }
      return;
    }
    await Share.shareXFiles(
      [
        XFile(
          decryptedFile.path,
          mimeType: ContentType.html.mimeType,
        )
      ],
    );
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

  void _shareStringResult(Rect? bounds) async {
    final decryptedString = _bloc.state.decryptedString!;
    await Share.share(decryptedString, sharePositionOrigin: bounds);
  }

  void _copyResultToClipboard() async {
    final decryptedString = _bloc.state.decryptedString!;
    await Clipboard.setData(ClipboardData(text: decryptedString));
    _showClipboardSnackBar();
  }

  void _showClipboardSnackBar() {
    var snackBar = const SnackBar(
      content: Text(
        "Copied to clipboard",
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  DecryptCubit get _bloc => BlocProvider.of<DecryptCubit>(context);
}

class _DecryptRcaLink extends StatelessWidget {
  final GlobalKey<FormState> _rcaFormKey;
  final TextEditingController _rcaTextController;
  final void Function() _addFile;

  const _DecryptRcaLink(
      {required dynamic rcaFormKey,
      required dynamic rcaTextController,
      required void Function() addFile})
      : _addFile = addFile,
        _rcaTextController = rcaTextController,
        _rcaFormKey = rcaFormKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Form(
          key: _rcaFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextFormField(
              textInputAction: TextInputAction.newline,
              controller: _rcaTextController,
              minLines: 3,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'You have to provide RCA Link';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'RCA Link',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text("OR"),
        const SizedBox(height: 8),
        OutlinedButton.icon(
            onPressed: _addFile,
            icon: const Icon(Icons.file_open_outlined),
            label: const Text("Select file")),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _DecryptFile extends StatelessWidget {
  final String _filename;
  final void Function() _removeInputFile;

  const _DecryptFile(
      {required String filename, required void Function() removeInputFile})
      : _removeInputFile = removeInputFile,
        _filename = filename;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        const Text("File to decrypt:"),
        const SizedBox(height: 8),
        Chip(
          avatar: const Icon(Icons.file_present_outlined),
          label: Text(_filename, overflow: TextOverflow.ellipsis),
          onDeleted: _removeInputFile,
        ),
      ],
    );
  }
}

class _DecryptStringResult extends StatelessWidget {
  final String _decryptedResult;
  final void Function() _clear;
  final void Function(Rect? bounds) _shareText;
  final void Function() _copyToClipboard;

  const _DecryptStringResult(
      {required String decryptedResult,
      required void Function() clear,
      required void Function(Rect? bounds) shareText,
      required void Function() copyToClipboard})
      : _copyToClipboard = copyToClipboard,
        _shareText = shareText,
        _clear = clear,
        _decryptedResult = decryptedResult;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            const Text("Decrypted text:"),
            const SizedBox(height: 16),
            Text(
              _decryptedResult,
              style: const TextStyle(fontSize: 19),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
                onPressed: _copyToClipboard,
                icon: const Icon(Icons.lock_open_outlined),
                label: const Text("Copy to clipboard")),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                    onPressed: _clear,
                    icon: const Icon(Icons.lock_open_outlined),
                    label: const Text("Decrypt more")),
                const SizedBox(width: 24),
                OutlinedButton.icon(
                    onPressed: () => _shareText(context.globalPaintBounds),
                    icon: const Icon(Icons.share_outlined),
                    label: const Text("Share text")),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _DecryptFileResult extends StatelessWidget {
  final String _decryptedFileName;
  final void Function() _clear;
  final void Function() _shareFile;

  const _DecryptFileResult(
      {required String decryptedFileName,
      required void Function() clear,
      required void Function() shareFile})
      : _shareFile = shareFile,
        _clear = clear,
        _decryptedFileName = decryptedFileName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        const Text("Decrypted file:"),
        const SizedBox(height: 8),
        Chip(
          avatar: const Icon(Icons.file_present_outlined),
          label: Text(_decryptedFileName, overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
                onPressed: _clear,
                icon: const Icon(Icons.lock_open_outlined),
                label: const Text("Decrypt more")),
            const SizedBox(width: 24),
            OutlinedButton.icon(
                onPressed: _shareFile,
                icon: Icon(
                    isDesktop() ? Icons.save_outlined : Icons.share_outlined),
                label: Text(isDesktop() ? "Save file" : "Share file")),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
