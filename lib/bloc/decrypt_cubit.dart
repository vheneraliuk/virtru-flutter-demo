import 'package:bloc/bloc.dart';
import 'package:cross_file/cross_file.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
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
      final inputFilePath = inputFile.name;
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
      final outputFile = XFile(outputFilePath);
      final decryptedFile = await client.decryptFile(inputFile, outputFile);
      emit(state.copyWith(decryptedFile: decryptedFile));
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

    try {
      final contract = await _acmRepo.getContract(policyId: policyId);

      if (contract.type == "file") {
        _decryptRcaToFile(rcaLink, contract.displayName, client);
      } else {
        _decryptRcaToString(rcaLink, client);
      }
    } catch (error) {
      _emitError(VirtruError.fromError(error));
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

  void setInputFile(XFile inputFile) async {
    if (kIsWeb) {
      emit(state.copyWith(inputFile: inputFile));
    } else {
      final inputFileName = inputFile.name;
      final tempInputFilePath = await getTempFilePath(inputFileName);
      await inputFile.saveTo(tempInputFilePath);
      emit(state.copyWith(inputFile: XFile(tempInputFilePath)));
    }
  }

  void _decryptRcaToString(String rcaLink, virtru.Client client) async {
    try {
      final result = await client.decryptRcaToString(rcaLink);
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
      final outputFile = XFile(await getTempFilePath(fileName));
      final decryptedFile = await client.decryptRcaToFile(rcaLink, outputFile);
      emit(state.copyWith(decryptedFile: decryptedFile));
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
