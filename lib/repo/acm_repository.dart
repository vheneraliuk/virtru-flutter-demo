import 'package:virtru_demo_flutter/api/api.dart';
import 'package:virtru_demo_flutter/model/model.dart';
import 'package:virtru_demo_flutter/repo/repo.dart';

class AcmRepository {
  final AcmClient _acmClient;

  AcmRepository._(this._acmClient);

  factory AcmRepository({required UserRepository userRepo}) {
    var acmClient = AcmClient(userRepo);
    return AcmRepository._(acmClient);
  }

  Future<PoliciesSearchResponse> getSentEmails({int bookmark = 0}) {
    return _acmClient.getSentEmails(bookmark: bookmark);
  }

  Future<PoliciesSearchResponse> getReceivedEmails({int bookmark = 0}) {
    return _acmClient.getReceivedEmails(bookmark: bookmark);
  }

  Future<PoliciesSearchResponse> getSentFiles({int bookmark = 0}) {
    return _acmClient.getSentFiles(bookmark: bookmark);
  }

  Future<PoliciesSearchResponse> getReceivedFiles({int bookmark = 0}) {
    return _acmClient.getReceivedFiles(bookmark: bookmark);
  }

  Future<Contract> getContract({required String policyId}) {
    return _acmClient.getContract(policyId);
  }

  Future<ExtendedPolicy> getPolicy({required String policyId}) {
    return _acmClient.getPolicy(policyId);
  }

  Future<List<int>> getPayload({required String policyId}) {
    return _acmClient.getPayload(policyId);
  }

  Future<List<int>> getMetadata({required String policyId}) {
    return _acmClient.getMetadata(policyId);
  }
}
