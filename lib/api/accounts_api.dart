import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:json_annotation/json_annotation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';

part 'accounts_api.g.dart';

@RestApi(baseUrl: "https://api.virtru.com/accounts")
abstract class AccountsClient {
  factory AccountsClient({String? baseUrl}) {
    var dio = Dio()
      ..interceptors.addAll([
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
      ]);
    return _AccountsClient(dio, baseUrl: baseUrl);
  }

  @POST("/api/register")
  Future<AppIdBundle> register(@Body() RegisterRequest request);

  @POST("/api/appIdBundle/revoke")
  Future<void> revokeAppId(
    @Header("Authorization") String authHeader,
    @Body() RevokeAppIdRequest request,
  );

  @POST("/api/code-login")
  @Headers({
    'Origin': 'https://sdk.virtru.com',
  })
  Future<SessionId> requestCode(@Body() CodeRequest request);

  @POST("/api/code-activation")
  @Headers({
    'Origin': 'https://sdk.virtru.com',
  })
  Future<AppIdBundle> sendCode(@Body() SendCodeRequest request);

  @POST("/api/email-login")
  Future<void> emailLogin(@Body() EmailLoginRequest request);
}

@JsonSerializable()
class RegisterRequest {
  final String userId;
  final String platform;
  final String activationMethod;

  RegisterRequest({
    required this.userId,
    required this.platform,
    required this.activationMethod,
  });

  RegisterRequest.forUser({required String userId})
      : this(
          userId: userId,
          platform: getPlatform(),
          activationMethod: "federated",
        );

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable()
class RevokeAppIdRequest {
  final List<String> appIds;

  RevokeAppIdRequest({
    required this.appIds,
  });

  RevokeAppIdRequest.forAppId(String appId) : this(appIds: [appId]);

  factory RevokeAppIdRequest.fromJson(Map<String, dynamic> json) =>
      _$RevokeAppIdRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RevokeAppIdRequestToJson(this);
}

@JsonSerializable()
class CodeRequest {
  final String userId;

  CodeRequest({
    required this.userId,
  });

  CodeRequest.forUser({required String userId})
      : this(
          userId: userId,
        );

  factory CodeRequest.fromJson(Map<String, dynamic> json) =>
      _$CodeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CodeRequestToJson(this);
}

@JsonSerializable()
class SendCodeRequest {
  final String userId;
  final String code;
  final String sessionId;

  SendCodeRequest({
    required this.userId,
    required this.code,
    required this.sessionId,
  });

  factory SendCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$SendCodeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SendCodeRequestToJson(this);
}

@JsonSerializable()
class SessionId {
  final String sessionId;

  SessionId({
    required this.sessionId,
  });

  factory SessionId.fromJson(Map<String, dynamic> json) =>
      _$SessionIdFromJson(json);

  Map<String, dynamic> toJson() => _$SessionIdToJson(this);
}

@JsonSerializable()
class EmailLoginRequest {
  final String emailAddress;
  final bool stayLoggedIn;

  EmailLoginRequest({
    required this.emailAddress,
    required this.stayLoggedIn,
  });

  EmailLoginRequest.forUser({required String emailAddress})
      : this(
          emailAddress: emailAddress,
          stayLoggedIn: true,
        );

  factory EmailLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$EmailLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EmailLoginRequestToJson(this);
}

@JsonSerializable()
class AppIdBundle {
  String userId;
  String appId;
  String state;
  String platform;

  AppIdBundle({
    required this.userId,
    required this.appId,
    required this.state,
    required this.platform,
  });

  factory AppIdBundle.fromJson(Map<String, dynamic> json) =>
      _$AppIdBundleFromJson(json);

  Map<String, dynamic> toJson() => _$AppIdBundleToJson(this);
}

String getPlatform() {
  if (Platform.isAndroid) {
    return "android";
  } else if (Platform.isIOS) {
    return "iphone";
  } else {
    return "browser_extension_chrome";
  }
}
