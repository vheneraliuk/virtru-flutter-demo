import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cryptography/cryptography.dart';
import 'package:cryptography_flutter/cryptography_flutter.dart';
import 'package:virtru_demo_flutter/model/model.dart';
import 'package:virtru_demo_flutter/repo/repo.dart';
import 'package:xml/xml.dart';

part 'email_state.dart';

class EmailCubit extends Cubit<EmailState> {
  final AcmRepository acmRepo;
  final String policyId;
  final String metadataKeyBase64;

  EmailCubit({
    required this.acmRepo,
    required this.policyId,
    required this.metadataKeyBase64,
  }) : super(EmailStateInitial()) {
    decryptPayload();
  }

  void decryptPayload() async {
    try {
      final cipher = FlutterAesGcm.with256bits();

      final metadataBinary = await acmRepo.getMetadata(policyId: policyId);
      final secretBoxForMetadata = SecretBox.fromConcatenation(metadataBinary,
          nonceLength: 12, macLength: 16);
      final metadata = await cipher.decryptString(secretBoxForMetadata,
          secretKey: SecretKey(base64Decode(metadataKeyBase64)));

      final tdf = XmlDocument.parse(jsonDecode(metadata)["email"]);
      final keyValue = tdf.findAllElements("tdf:KeyValue").first;
      final payloadKeyEncoded = base64Decode(keyValue.innerText);
      final contract = await acmRepo.getContract(policyId: policyId);
      final secretBoxForWrappedKey = SecretBox.fromConcatenation(
          payloadKeyEncoded,
          nonceLength: 12,
          macLength: 16);
      final payloadKey = await cipher.decrypt(secretBoxForWrappedKey,
          secretKey: SecretKey(base64Decode(contract.keyAccess.details.body!)));

      final payloadBinary = await acmRepo.getPayload(policyId: policyId);
      final secretBoxForPayload = SecretBox.fromConcatenation(payloadBinary,
          nonceLength: 12, macLength: 16);
      final decrypted = await cipher.decryptString(secretBoxForPayload,
          secretKey: SecretKey(payloadKey));
      final policy = await acmRepo.getPolicy(policyId: policyId);
      emit(EmailStateSuccess(
        policy: policy,
        contract: contract,
        decryptedEmail: decrypted,
      ));
    } catch (error) {
      emit(EmailStateError(VirtruError.fromError(error)));
    }
  }
}
