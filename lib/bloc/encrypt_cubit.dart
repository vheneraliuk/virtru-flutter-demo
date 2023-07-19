import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:virtru_demo_flutter/helpers/helpers.dart';
import 'package:virtru_demo_flutter/model/model.dart';
import 'package:virtru_demo_flutter/repo/repo.dart';
import 'package:virtru_sdk_flutter/virtru_sdk_flutter.dart' as virtru;

part 'encrypt_state.dart';

class EncryptCubit extends Cubit<EncryptState> {
  final UserRepository _userRepo;

  EncryptCubit(this._userRepo) : super(EncryptState.initial());

  void encryptMessage(String message) async {
    emit(state.copyWith(loading: true));
    final client = await _getClient();
    if (client == null) {
      return;
    }
    try {
      if (state.encryptToRca) {
        await _encryptStringToRca(message, client);
      } else {
        await _encryptStringToFile(message, client);
      }
    } on StateError catch (error) {
      _emitError(VirtruError(name: "State error", message: error.message));
    } catch (error) {
      _emitError(VirtruError(
          name: "Unknown error", message: "Oops, something went wrong"));
    }
    client.dispose();
  }

  void encryptFile() async {
    final inputFile = state.inputFile;
    if (inputFile == null) {
      _emitError(VirtruError(
        name: "There is no input File",
        message: "You need to select file to encrypt first",
      ));
      return;
    }
    emit(state.copyWith(loading: true));
    final client = await _getClient();
    if (client == null) {
      return;
    }
    try {
      if (state.encryptToRca) {
        await _encryptFileToRca(inputFile, client);
      } else {
        await _encryptFileToFile(inputFile, client);
      }
    } on StateError catch (error) {
      _emitError(VirtruError(name: "State error", message: error.message));
    } catch (error) {
      _emitError(VirtruError(
          name: "Unknown error", message: "Oops, something went wrong"));
    }

    client.dispose();
  }

  _encryptStringToFile(String message, virtru.Client client) async {
    final sourceFileName =
        "Flutter_Demo_${DateTime.now().millisecondsSinceEpoch}.txt";
    final encryptParams = virtru.EncryptStringParams(message)
      ..setDisplayName(sourceFileName)
      ..setDisplayMessage("This message was encrypted with Flutter App")
      ..setMimeType(ContentType.text.mimeType)
      ..shareWithUsers(state.shareWith);
    final encryptedString = await client.encryptString(encryptParams);
    final encryptedFileName = '$sourceFileName$tdfHtmlExt';
    final tempEncryptedFilePath =
        "${(await getTemporaryDirectory()).path}/$encryptedFileName";
    final encryptedFile = File(tempEncryptedFilePath);
    await encryptedFile.writeAsString(encryptedString);
    emit(state.copyWith(encryptedFile: encryptedFile));
  }

  _encryptStringToRca(String message, virtru.Client client) async {
    final sourceFileName =
        "Flutter_Demo_${DateTime.now().millisecondsSinceEpoch}.txt";
    final encryptParams = virtru.EncryptStringParams(message)
      ..setDisplayName(sourceFileName)
      ..setDisplayMessage("This message was encrypted with Flutter App")
      ..setMimeType(ContentType.text.mimeType)
      ..shareWithUsers(state.shareWith);
    final rcaLink = await client.encryptStringToRCA(encryptParams);
    emit(state.copyWith(rcaLink: rcaLink));
  }

  _encryptFileToFile(File inputFile, virtru.Client client) async {
    final fileSize = await inputFile.length();
    final inputFileName = basename(inputFile.path);
    final outputFile = switch (fileSize) {
      < mb100 => File("${inputFile.path}$tdfHtmlExt"),
      _ => File("${inputFile.path}$tdfExt")
    };
    final encryptParams =
        virtru.EncryptFileParams.fromFiles(inputFile, outputFile)
          ..setDisplayName(inputFileName)
          ..setDisplayMessage("This file was encrypted with Flutter App")
          ..shareWithUsers(state.shareWith);
    final mimeType = lookupMimeType(inputFile.path);
    if (mimeType != null) {
      encryptParams.setMimeType(mimeType);
    }
    if (fileSize >= mb100) {
      client.setZipProtocol(true);
    }
    await client.encryptFile(encryptParams);
    emit(state.copyWith(encryptedFile: outputFile));
  }

  _encryptFileToRca(File inputFile, virtru.Client client) async {
    final inputFileName = basename(inputFile.path);
    final encryptParams = virtru.EncryptFileParams.fromFile(inputFile)
        .setDisplayName(inputFileName)
        .setDisplayMessage("This file was encrypted with Flutter App")
        .shareWithUsers(state.shareWith);
    final mimeType = lookupMimeType(inputFile.path);
    if (mimeType != null) {
      encryptParams.setMimeType(mimeType);
    }
    final rcaLink = await client.encryptFileToRCA(encryptParams);
    emit(state.copyWith(rcaLink: rcaLink));
  }

  void setRcaLinkAsResult(bool enable) {
    emit(state.copyWith(encryptToRca: enable));
  }

  void encryptFileToRCA() async {
    final inputFile = state.inputFile;
    if (inputFile == null) {
      _emitError(VirtruError(
        name: "There is no input File",
        message: "You need to select file to encrypt first",
      ));
      return;
    }
    emit(state.copyWith(loading: true));
    final client = await _getClient();
    if (client == null) {
      return;
    }
    try {
      final inputFileName = basename(inputFile.path);
      final encryptParams = virtru.EncryptFileParams.fromFile(inputFile)
          .setDisplayName(inputFileName)
          .setDisplayMessage("This file was encrypted with Flutter App")
          .shareWithUsers(state.shareWith);
      final mimeType = lookupMimeType(inputFile.path);
      if (mimeType != null) {
        encryptParams.setMimeType(mimeType);
      }
      final rcaLink = await client.encryptFileToRCA(encryptParams);
      debugPrint("New RCA Link: '$rcaLink'");
      emit(state.copyWith(loading: false));
    } on StateError catch (error) {
      _emitError(VirtruError(name: "State error", message: error.message));
    } catch (error) {
      _emitError(VirtruError(
          name: "Unknown error", message: "Oops, something went wrong"));
      rethrow;
    }

    client.dispose();
  }

  void shareWithUser(String user) {
    if (state.shareWith.contains(user)) return;
    emit(state.copyWith(newShareWith: user));
  }

  void clear() async {
    await state.encryptedFile?.delete();
    await state.inputFile?.delete();
    emit(EncryptState.initial());
  }

  void removeUser(String user) {
    emit(state.copyWith(removeShareWith: user));
  }

  void removeInputFile() async {
    await state.inputFile?.delete();
    emit(state.copyWith(removeInputFile: true));
  }

  void setInputFile(File inputFile) async {
    final inputFileName = basename(inputFile.path);
    final tempInputFilePath =
        "${(await getTemporaryDirectory()).path}/$inputFileName";
    final tempInputFile = await inputFile.copy(tempInputFilePath);
    emit(state.copyWith(inputFile: tempInputFile));
  }

  Future<virtru.Client?> _getClient() async {
    final user = await _userRepo.getUser();
    if (user == null) {
      _emitError(VirtruError(
        name: "User is null",
        message: "You need to activate Virtru first",
      ));
      return null;
    }
    return virtru.Client.withAppId(userId: user.userId, appId: user.appId);
  }

  void _emitError(VirtruError error) {
    emit(state.copyWith(error: error));
  }
}
