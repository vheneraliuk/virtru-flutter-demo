import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:virtru_demo_flutter/bloc/bloc.dart';
import 'package:virtru_demo_flutter/helpers/helpers.dart';
import 'package:virtru_demo_flutter/model/model.dart';
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Encrypting...",
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

  Widget _buildWidget(EncryptState state) {
    if (state.encryptedFile != null) {
      return _EncryptFileResult(
        encryptedFileName: state.encryptedFile!.name,
        clear: _clear,
        shareFile: _saveOrShareFile,
      );
    } else if (state.rcaLink != null) {
      return _EncryptRCALinkResult(
          rcaLink: state.rcaLink!,
          copyToClipboard: _copyRcaToClipboard,
          clear: _clear,
          shareLink: _shareLink);
    }
    return Column(
      children: [
        state.inputFile == null
            ? _EncryptText(
                encryptFormKey: _encryptFormKey,
                messageTextController: _messageTextController,
                addFile: _addFile,
              )
            : _EncryptFile(
                filename: state.inputFile!.name,
                removeInputFile: _bloc.removeInputFile,
              ),
        state.shareWith.isNotEmpty
            ? _EncryptShareWith(
                shareWith: state.shareWith,
                removeUser: _bloc.removeUser,
              )
            : Container(),
        const Divider(),
        _EncryptSecuritySettings(
            settings: state.securitySettings, showDatePicker: _showDatePicker),
        const Divider(),
        SwitchListTile(
            activeColor: Theme.of(context).colorScheme.primary,
            selected: state.encryptToRca,
            secondary: const Icon(
              Icons.link_outlined,
            ),
            title: const Text("Result as RCA Link"),
            value: state.encryptToRca,
            onChanged: _bloc.setRcaLinkAsResult),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
                onPressed: _shareWith,
                icon: const Icon(Icons.add_reaction_outlined),
                label: const Text("Share with")),
            const SizedBox(width: 24),
            OutlinedButton.icon(
                onPressed: _validateAndEncrypt,
                icon: const Icon(Icons.lock_outline),
                label: const Text("Encrypt")),
          ],
        ),
        const SizedBox(height: 24),
      ],
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

  _saveOrShareFile(Rect? shareBounds) async {
    final encryptedFile = _bloc.state.encryptedFile!;
    if (isDesktop()) {
      final selectedFilePath = await FilePicker.platform.saveFile(
        fileName: encryptedFile.name,
      );
      if (selectedFilePath != null) {
        await encryptedFile.saveTo(selectedFilePath);
      }
      return;
    }
    await Share.shareXFiles(
      [encryptedFile],
      sharePositionOrigin: shareBounds,
    );
  }

  void _shareLink(Rect? shareBounds) async {
    final rcaLink = _bloc.state.rcaLink!;
    await Share.share(rcaLink, sharePositionOrigin: shareBounds);
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

  _showDatePicker() async {
    final expirationDate = _bloc.state.securitySettings.expirationDate;
    final result = await showDatePicker(
      context: context,
      initialDate: expirationDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: "Select expiration date",
      cancelText: "Remove",
      confirmText: "Set",
    );

    _bloc.setExpirationDate(result);
  }

  _addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) return;
    _bloc.setInputFile(result.files.first.toXFile());
  }

  void _copyRcaToClipboard() async {
    final rcaLink = _bloc.state.rcaLink!;
    await Clipboard.setData(ClipboardData(text: rcaLink));
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

  EncryptCubit get _bloc => BlocProvider.of<EncryptCubit>(context);
}

class _EncryptText extends StatelessWidget {
  final GlobalKey<FormState> _encryptFormKey;
  final TextEditingController _messageTextController;
  final void Function() _addFile;

  const _EncryptText(
      {required dynamic encryptFormKey,
      required dynamic messageTextController,
      required void Function() addFile})
      : _addFile = addFile,
        _messageTextController = messageTextController,
        _encryptFormKey = encryptFormKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Form(
          key: _encryptFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextFormField(
              textInputAction: TextInputAction.newline,
              controller: _messageTextController,
              textCapitalization: TextCapitalization.sentences,
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

class _EncryptFile extends StatelessWidget {
  final String _filename;
  final void Function() _removeInputFile;

  const _EncryptFile(
      {required String filename, required void Function() removeInputFile})
      : _removeInputFile = removeInputFile,
        _filename = filename;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        const Text("File to encrypt:"),
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

class _EncryptShareWith extends StatelessWidget {
  final List<String> _shareWith;
  final void Function(String user) _removeUser;

  const _EncryptShareWith(
      {required List<String> shareWith,
      required void Function(String) removeUser})
      : _removeUser = removeUser,
        _shareWith = shareWith;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 8),
        const Text("Shared with:"),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: _shareWith
                .map(
                  (user) => Chip(
                    avatar: const Icon(Icons.supervised_user_circle_outlined),
                    label: Text(user, overflow: TextOverflow.ellipsis),
                    onDeleted: () => _removeUser(user),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _EncryptSecuritySettings extends StatelessWidget {
  final SecuritySettings _settings;
  final void Function() _showDatePicker;

  const _EncryptSecuritySettings(
      {required SecuritySettings settings,
      required void Function() showDatePicker})
      : _showDatePicker = showDatePicker,
        _settings = settings;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EncryptCubit>(context);
    return Column(
      children: [
        const SizedBox(height: 8),
        const Text("Security settings:"),
        const SizedBox(height: 8),
        SwitchListTile(
          onChanged: bloc.setPersistentProtection,
          activeColor: Theme.of(context).colorScheme.primary,
          selected: _settings.persistentProtectionEnabled,
          value: _settings.persistentProtectionEnabled,
          title: const Text("Persistent protection"),
          secondary: const Icon(
            Icons.file_present_outlined,
          ),
        ),
        SwitchListTile(
          onChanged: bloc.setWatermarkEnable,
          activeColor: Theme.of(context).colorScheme.primary,
          selected: _settings.watermarkEnabled,
          value: _settings.watermarkEnabled,
          title: const Text("Enable watermarks"),
          secondary: const Icon(
            Icons.water_drop_outlined,
          ),
        ),
        ListTile(
          onTap: _showDatePicker,
          leading: const Icon(
            Icons.calendar_month,
          ),
          trailing: Text(
            _settings.expirationDate == null
                ? ""
                : DateFormat.yMMMd().format(
                    _settings.expirationDate!,
                  ),
            style: const TextStyle(fontSize: 15),
          ),
          title: Text(
            _settings.expirationDate == null ? "Expiration" : "Expires on",
          ),
          selectedColor: Theme.of(context).colorScheme.primary,
          selected: _settings.expirationDate != null,
        ),
      ],
    );
  }
}

class _EncryptFileResult extends StatelessWidget {
  final String _encryptedFileName;
  final void Function() _clear;
  final void Function(Rect? shareBounds) _shareFile;

  const _EncryptFileResult(
      {required String encryptedFileName,
      required void Function() clear,
      required void Function(Rect? shareBounds) shareFile})
      : _shareFile = shareFile,
        _clear = clear,
        _encryptedFileName = encryptedFileName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        const Text("Encrypted file:"),
        const SizedBox(height: 8),
        Chip(
          avatar: const Icon(Icons.file_present_outlined),
          label: Text(_encryptedFileName, overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
                onPressed: _clear,
                icon: const Icon(Icons.lock_outline),
                label: const Text("Encrypt more")),
            const SizedBox(width: 24),
            Builder(builder: (context) {
              return OutlinedButton.icon(
                  onPressed: () => _shareFile(context.globalPaintBounds),
                  icon: Icon(
                      isDesktop() ? Icons.save_outlined : Icons.share_outlined),
                  label: Text(isDesktop() ? "Save file" : "Share file"));
            }),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _EncryptRCALinkResult extends StatelessWidget {
  final String _rcaLink;
  final void Function() _clear;
  final void Function() _copyToClipboard;
  final void Function(Rect? shareBounds) _shareLink;

  const _EncryptRCALinkResult(
      {required String rcaLink,
      required void Function() clear,
      required void Function(Rect? shareBounds) shareLink,
      required void Function() copyToClipboard})
      : _copyToClipboard = copyToClipboard,
        _shareLink = shareLink,
        _clear = clear,
        _rcaLink = rcaLink;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        const Text("RCA Link:"),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 24),
            Expanded(
              child: Chip(
                  label: Text(_rcaLink, overflow: TextOverflow.ellipsis),
                  avatar: const Icon(Icons.link_outlined)),
            ),
            IconButton(
              tooltip: "Copy",
              onPressed: _copyToClipboard,
              icon: const Icon(Icons.copy_outlined),
            ),
            const SizedBox(width: 24),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
                onPressed: _clear,
                icon: const Icon(Icons.lock_outline),
                label: const Text("Encrypt more")),
            const SizedBox(width: 24),
            Builder(builder: (context) {
              return OutlinedButton.icon(
                onPressed: () => _shareLink(context.globalPaintBounds),
                icon: const Icon(Icons.share_outlined),
                label: const Text("Share link"),
              );
            }),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
