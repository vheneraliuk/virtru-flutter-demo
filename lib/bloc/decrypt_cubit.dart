import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:virtru_demo_flutter/helpers/helpers.dart';
import 'package:virtru_demo_flutter/model/model.dart';
import 'package:virtru_demo_flutter/repo/repo.dart';
import 'package:virtru_sdk_flutter/virtru_sdk_flutter.dart' as virtru;

part 'decrypt_state.dart';

class DecryptCubit extends Cubit<DecryptState> {
  final UserRepository _userRepo;
  final AcmRepository _acmRepo;

  DecryptCubit(this._userRepo, this._acmRepo) : super(DecryptState.initial());

  void decryptFile() async {
    final inputFile = state.inputFile;
    if (inputFile == null) {
      _emitError(VirtruError(
        name: "There is no input File",
        message: "You need to select file to decrypt first",
      ));
      return;
    }
    emit(state.copyWith(loading: true));
    final client = await _getClient();
    if (client == null) {
      return;
    }
    try {
      final inputFilePath = inputFile.path;
      final containsTdfInName = inputFilePath.contains(tdfExt);
      String outputFilePath;
      if (containsTdfInName) {
        outputFilePath = inputFilePath.replaceAll(tdfHtmlExt, "")
          ..replaceAll(tdfExt, "");
      } else {
        final ext = extension(inputFilePath);
        final clearName = basenameWithoutExtension(inputFilePath);
        outputFilePath = inputFilePath.replaceAll(
            "$clearName$ext", "${clearName}_decrypted$ext");
      }
      final outputFile = File(outputFilePath);
      await client.decryptFile(inputFile, outputFile);
      emit(state.copyWith(decryptedFile: outputFile));
    } on virtru.NativeError catch (error) {
      _emitError(VirtruError(name: "Native error", message: error.message));
    } catch (error) {
      _emitError(VirtruError(
          name: "Unknown error", message: "Oops, something went wrong"));
    }

    client.dispose();
  }

  void decryptRca(String rcaLink) async {
    emit(state.copyWith(loading: true));
    final client = await _getClient();
    if (client == null) {
      return;
    }
    final parsedRca = RcaLink.fromString(rcaLink);
    debugPrint("Parsed RCA: $parsedRca");
    final policyId = parsedRca?.getPolicyId();
    if (policyId == null) {
      _emitError(VirtruError(
          name: "Invalid RCA Link",
          message: "Invalid or unsupported RCA Link"));
      return;
    }

    final contract = await _acmRepo.getContract(policyId: policyId);

    if (contract.type == "file") {
      _decryptRcaToFile(rcaLink, contract.displayName, client);
    } else {
      _decryptRcaToString(rcaLink, client);
    }
  }

  void clear() async {
    await state.decryptedFile?.delete();
    await state.inputFile?.delete();
    emit(DecryptState.initial());
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

  void _decryptRcaToString(String rcaLink, virtru.Client client) async {
    try {
      final result = await client.decryptRcaToString(rcaLink);
      debugPrint("Result: '$result'");
      emit(state.copyWith(decryptedString: result));
    } on virtru.NativeError catch (error) {
      _emitError(VirtruError(name: "Native error", message: error.message));
    } catch (error) {
      _emitError(VirtruError(
          name: "Unknown error", message: "Oops, something went wrong"));
    }
  }

  void _decryptRcaToFile(
      String rcaLink, String fileName, virtru.Client client) async {
    try {
      File outputFile =
          File("${(await getTemporaryDirectory()).path}/$fileName");
      await client.decryptRcaToFile(rcaLink, outputFile.path);
      emit(state.copyWith(decryptedFile: outputFile));
    } on virtru.NativeError catch (error) {
      _emitError(VirtruError(name: "Native error", message: error.message));
    } catch (error) {
      _emitError(VirtruError(
          name: "Unknown error", message: "Oops, something went wrong"));
    }
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
