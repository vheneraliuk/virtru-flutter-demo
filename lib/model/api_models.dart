import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'api_models.g.dart';

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

@JsonSerializable()
class PoliciesSearchResponse {
  @JsonKey(name: 'total_rows')
  final int totalRows;
  final int? bookmark;
  final List<PolicyResponse> rows;

  PoliciesSearchResponse({
    required this.totalRows,
    required this.bookmark,
    required this.rows,
  });

  factory PoliciesSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$PoliciesSearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PoliciesSearchResponseToJson(this);
}

@JsonSerializable()
class PolicyResponse {
  final String id;
  final Policy fields;

  PolicyResponse({
    required this.id,
    required this.fields,
  });

  factory PolicyResponse.fromJson(Map<String, dynamic> json) =>
      _$PolicyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PolicyResponseToJson(this);
}

@JsonSerializable()
class Policy {
  final String id;
  final DateTime dateSent;
  final String? creator;
  final String owner;
  final String from;
  final String? name;
  final String? filename;
  final String? fileExtension;
  final String? subject;
  final int attachmentCount;
  final String orgId;
  final bool wasForwarded;
  final List<String> to;
  final String status;
  final String type;
  final int forwardCount;
  final int recipientCount;
  final String accessPercent;
  @JsonKey(name: "is")
  final List<String> statuses;
  final List<String> was;
  final List<String> has;

  Policy(
      this.id,
      this.dateSent,
      this.creator,
      this.owner,
      this.from,
      this.name,
      this.filename,
      this.fileExtension,
      this.subject,
      this.attachmentCount,
      this.orgId,
      this.wasForwarded,
      this.to,
      this.status,
      this.type,
      this.forwardCount,
      this.recipientCount,
      this.accessPercent,
      this.statuses,
      this.was,
      this.has);

  factory Policy.fromJson(Map<String, dynamic> json) => _$PolicyFromJson(json);

  Map<String, dynamic> toJson() => _$PolicyToJson(this);
}
