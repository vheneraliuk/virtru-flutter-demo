import 'package:virtru_demo_flutter/api/api.dart';
import 'package:virtru_demo_flutter/model/model.dart';

class AcmRepository {
  final AcmClient acmClient;

  AcmRepository._(this.acmClient);

  factory AcmRepository.forUser(User user) {
    var acmClient = AcmClient.forUser(user);
    return AcmRepository._(acmClient);
  }

  Future<PoliciesSearchResponse> getSentEmails({int bookmark = 0}) {
    return acmClient.getSentEmails(bookmark: bookmark);
  }

  Future<PoliciesSearchResponse> getReceivedEmails({int bookmark = 0}) {
    return acmClient.getReceivedEmails(bookmark: bookmark);
  }

  Future<PoliciesSearchResponse> getSentFiles({int bookmark = 0}) {
    return acmClient.getSentFiles(bookmark: bookmark);
  }

  Future<PoliciesSearchResponse> getReceivedFiles({int bookmark = 0}) {
    return acmClient.getReceivedFiles(bookmark: bookmark);
  }
}
