import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';
import 'package:virtru_demo_flutter/model/model.dart';

part 'accounts_api.g.dart';

@RestApi(baseUrl: "https://api.virtru.com/accounts")
abstract class AccountsClient {
  AccountsClient._();

  factory AccountsClient({String? baseUrl}) {
    var dio = Dio()..interceptors.addAll(_getInterceptors());
    return _AccountsClient._(dio, baseUrl: baseUrl);
  }

  Future<SessionId> requestCode({required String userId}) {
    return _requestCode(CodeRequest.forUser(userId: userId));
  }

  Future<AppIdBundle> sendCode(
      {required String userId,
      required String code,
      required String sessionId}) {
    return _sendCode(SendCodeRequest(
      userId: userId,
      code: code,
      sessionId: sessionId,
    ));
  }

  Future<void> revokeAppId({required String appId, required String userId}) {
    return _revokeAppId(
      'Virtru [["$appId","$userId"]]',
      RevokeAppIdRequest.forAppId(appId),
    );
  }

  @POST("/api/code-login")
  @Headers({
    'Origin': 'https://sdk.virtru.com',
  })
  Future<SessionId> _requestCode(@Body() CodeRequest request);

  @POST("/api/code-activation")
  @Headers({
    'Origin': 'https://sdk.virtru.com',
  })
  Future<AppIdBundle> _sendCode(@Body() SendCodeRequest request);

  @POST("/api/appIdBundle/revoke")
  Future<void> _revokeAppId(
    @Header("Authorization") String authHeader,
    @Body() RevokeAppIdRequest request,
  );

  static List<Interceptor> _getInterceptors() {
    if (kDebugMode) {
      return [
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
      ];
    }
    return [];
  }
}
