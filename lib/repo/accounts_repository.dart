import 'package:virtru_demo_flutter/api/api.dart';
import 'package:virtru_demo_flutter/model/model.dart';

class AccountsRepository {
  final AccountsClient _accountsClient = AccountsClient();

  AccountsRepository();

  Future<void> revokeAppId({required String appId, required String userId}) {
    return _accountsClient.revokeAppId(appId: appId, userId: userId);
  }

  Future<SessionId> requestCode({required String userId}) {
    return _accountsClient.requestCode(userId: userId);
  }

  Future<AppIdBundle> sendCode({
    required String userId,
    required String code,
    required String sessionId,
  }) {
    return _accountsClient.sendCode(userId: userId, code: code, sessionId: sessionId);
  }
}
