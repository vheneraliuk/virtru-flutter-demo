import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:virtru_demo_flutter/model/model.dart';

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

@JsonSerializable()
class AppIdBundleResponse {
  String? userId;
  String? appId;
  String? state;
  String? platform;
  VirtruError? error;

  AppIdBundleResponse({
    required this.userId,
    required this.appId,
    required this.state,
    required this.platform,
    required this.error,
  });

  factory AppIdBundleResponse.fromJson(Map<String, dynamic> json) =>
      _$AppIdBundleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AppIdBundleResponseToJson(this);

  toAppIdBundle() => AppIdBundle(
      userId: userId!, appId: appId!, state: state!, platform: platform!);
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
class Contract {
  final String policyId;
  final String authorizedUser;
  final String key;
  final KeyAccess keyAccess;
  final String type;
  final String displayName;
  final String state;
  final DateTime? activeEnd;
  final List<String> authorizations;
  final bool isManaged;
  final bool isOwner;
  final bool isRecipient;
  final String sentFrom;
  final bool isInternal;
  final List<String> attributes;
  final int leaseTime;

  Contract(
      this.policyId,
      this.authorizedUser,
      this.key,
      this.keyAccess,
      this.type,
      this.displayName,
      this.state,
      this.activeEnd,
      this.authorizations,
      this.isManaged,
      this.isOwner,
      this.isRecipient,
      this.sentFrom,
      this.isInternal,
      this.attributes,
      this.leaseTime);

  factory Contract.fromJson(Map<String, dynamic> json) =>
      _$ContractFromJson(json);

  Map<String, dynamic> toJson() => _$ContractToJson(this);
}

@JsonSerializable()
class KeyAccess {
  final String type;
  final String version;
  final String? keyId;
  final KeyDetails details;

  KeyAccess(this.type, this.version, this.keyId, this.details);

  factory KeyAccess.fromJson(Map<String, dynamic> json) =>
      _$KeyAccessFromJson(json);

  Map<String, dynamic> toJson() => _$KeyAccessToJson(this);
}

@JsonSerializable()
class KeyDetails {
  final String? encoding;
  final String? body;
  final EncryptionInformation? encryptionInformation;
  final String? publicKeyFingerprint;
  final Payload? payload;

  KeyDetails(this.encoding, this.body, this.encryptionInformation,
      this.publicKeyFingerprint, this.payload);

  factory KeyDetails.fromJson(Map<String, dynamic> json) =>
      _$KeyDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$KeyDetailsToJson(this);
}

@JsonSerializable()
class EncryptionInformation {
  final KeyAccess keyAccess;
  final EncryptionMethod encryptionMethod;

  EncryptionInformation(this.keyAccess, this.encryptionMethod);

  factory EncryptionInformation.fromJson(Map<String, dynamic> json) =>
      _$EncryptionInformationFromJson(json);

  Map<String, dynamic> toJson() => _$EncryptionInformationToJson(this);
}

@JsonSerializable()
class Payload {
  final String encoding;
  final String body;

  Payload(this.encoding, this.body);

  factory Payload.fromJson(Map<String, dynamic> json) =>
      _$PayloadFromJson(json);

  Map<String, dynamic> toJson() => _$PayloadToJson(this);
}

@JsonSerializable()
class EncryptionMethod {
  final String algorithm;

  EncryptionMethod(this.algorithm);

  factory EncryptionMethod.fromJson(Map<String, dynamic> json) =>
      _$EncryptionMethodFromJson(json);

  Map<String, dynamic> toJson() => _$EncryptionMethodToJson(this);
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
  final ApiPolicy fields;

  PolicyResponse({
    required this.id,
    required this.fields,
  });

  factory PolicyResponse.fromJson(Map<String, dynamic> json) =>
      _$PolicyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PolicyResponseToJson(this);
}

@JsonSerializable()
class ApiPolicy {
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

  ApiPolicy(
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

  factory ApiPolicy.fromJson(Map<String, dynamic> json) => _$ApiPolicyFromJson(json);

  Map<String, dynamic> toJson() => _$ApiPolicyToJson(this);
}

@JsonSerializable()
class ExtendedPolicy {
  final String uuid;
  final String orgId;
  final String sentFrom;
  final List<String> associatedAttachmentIds;
  final List<String> children;
  final DateTime created;
  final String? displayName;
  final DateTime lastModified;
  final DateTime secureEmailSentAt;
  final SimplePolicy simplePolicy;

  ExtendedPolicy(
    this.uuid,
    this.orgId,
    this.sentFrom,
    this.associatedAttachmentIds,
    this.children,
    this.created,
    this.displayName,
    this.lastModified,
    this.secureEmailSentAt,
    this.simplePolicy,
  );

  factory ExtendedPolicy.fromJson(Map<String, dynamic> json) =>
      _$ExtendedPolicyFromJson(json);

  Map<String, dynamic> toJson() => _$ExtendedPolicyToJson(this);
}

@JsonSerializable()
class SimplePolicy {
  final List<String> emailUsers;
  final List<String> authorizations;
  final String state;
  final bool isManaged;
  final DateTime? activeEnd;
  final List<String> accessedBy;

  SimplePolicy(this.emailUsers, this.authorizations, this.state, this.isManaged,
      this.activeEnd, this.accessedBy);

  factory SimplePolicy.fromJson(Map<String, dynamic> json) =>
      _$SimplePolicyFromJson(json);

  Map<String, dynamic> toJson() => _$SimplePolicyToJson(this);
}
