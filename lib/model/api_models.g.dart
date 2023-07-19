// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      userId: json['userId'] as String,
      platform: json['platform'] as String,
      activationMethod: json['activationMethod'] as String,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'platform': instance.platform,
      'activationMethod': instance.activationMethod,
    };

RevokeAppIdRequest _$RevokeAppIdRequestFromJson(Map<String, dynamic> json) =>
    RevokeAppIdRequest(
      appIds:
          (json['appIds'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$RevokeAppIdRequestToJson(RevokeAppIdRequest instance) =>
    <String, dynamic>{
      'appIds': instance.appIds,
    };

CodeRequest _$CodeRequestFromJson(Map<String, dynamic> json) => CodeRequest(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$CodeRequestToJson(CodeRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };

SendCodeRequest _$SendCodeRequestFromJson(Map<String, dynamic> json) =>
    SendCodeRequest(
      userId: json['userId'] as String,
      code: json['code'] as String,
      sessionId: json['sessionId'] as String,
    );

Map<String, dynamic> _$SendCodeRequestToJson(SendCodeRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'code': instance.code,
      'sessionId': instance.sessionId,
    };

SessionId _$SessionIdFromJson(Map<String, dynamic> json) => SessionId(
      sessionId: json['sessionId'] as String,
    );

Map<String, dynamic> _$SessionIdToJson(SessionId instance) => <String, dynamic>{
      'sessionId': instance.sessionId,
    };

EmailLoginRequest _$EmailLoginRequestFromJson(Map<String, dynamic> json) =>
    EmailLoginRequest(
      emailAddress: json['emailAddress'] as String,
      stayLoggedIn: json['stayLoggedIn'] as bool,
    );

Map<String, dynamic> _$EmailLoginRequestToJson(EmailLoginRequest instance) =>
    <String, dynamic>{
      'emailAddress': instance.emailAddress,
      'stayLoggedIn': instance.stayLoggedIn,
    };

AppIdBundle _$AppIdBundleFromJson(Map<String, dynamic> json) => AppIdBundle(
      userId: json['userId'] as String,
      appId: json['appId'] as String,
      state: json['state'] as String,
      platform: json['platform'] as String,
    );

Map<String, dynamic> _$AppIdBundleToJson(AppIdBundle instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'appId': instance.appId,
      'state': instance.state,
      'platform': instance.platform,
    };

AppIdBundleResponse _$AppIdBundleResponseFromJson(Map<String, dynamic> json) =>
    AppIdBundleResponse(
      userId: json['userId'] as String?,
      appId: json['appId'] as String?,
      state: json['state'] as String?,
      platform: json['platform'] as String?,
      error: json['error'] == null
          ? null
          : VirtruError.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppIdBundleResponseToJson(
        AppIdBundleResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'appId': instance.appId,
      'state': instance.state,
      'platform': instance.platform,
      'error': instance.error,
    };

Contract _$ContractFromJson(Map<String, dynamic> json) => Contract(
      json['policyId'] as String,
      json['authorizedUser'] as String,
      json['key'] as String,
      KeyAccess.fromJson(json['keyAccess'] as Map<String, dynamic>),
      json['type'] as String,
      json['displayName'] as String,
      json['state'] as String,
      json['activeEnd'] == null
          ? null
          : DateTime.parse(json['activeEnd'] as String),
      (json['authorizations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      json['isManaged'] as bool,
      json['isOwner'] as bool,
      json['isRecipient'] as bool,
      json['sentFrom'] as String,
      json['isInternal'] as bool,
      (json['attributes'] as List<dynamic>).map((e) => e as String).toList(),
      json['leaseTime'] as int,
    );

Map<String, dynamic> _$ContractToJson(Contract instance) => <String, dynamic>{
      'policyId': instance.policyId,
      'authorizedUser': instance.authorizedUser,
      'key': instance.key,
      'keyAccess': instance.keyAccess,
      'type': instance.type,
      'displayName': instance.displayName,
      'state': instance.state,
      'activeEnd': instance.activeEnd?.toIso8601String(),
      'authorizations': instance.authorizations,
      'isManaged': instance.isManaged,
      'isOwner': instance.isOwner,
      'isRecipient': instance.isRecipient,
      'sentFrom': instance.sentFrom,
      'isInternal': instance.isInternal,
      'attributes': instance.attributes,
      'leaseTime': instance.leaseTime,
    };

KeyAccess _$KeyAccessFromJson(Map<String, dynamic> json) => KeyAccess(
      json['type'] as String,
      json['version'] as String,
      json['keyId'] as String,
      KeyDetails.fromJson(json['details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$KeyAccessToJson(KeyAccess instance) => <String, dynamic>{
      'type': instance.type,
      'version': instance.version,
      'keyId': instance.keyId,
      'details': instance.details,
    };

KeyDetails _$KeyDetailsFromJson(Map<String, dynamic> json) => KeyDetails(
      json['encoding'] as String,
      json['body'] as String,
    );

Map<String, dynamic> _$KeyDetailsToJson(KeyDetails instance) =>
    <String, dynamic>{
      'encoding': instance.encoding,
      'body': instance.body,
    };

PoliciesSearchResponse _$PoliciesSearchResponseFromJson(
        Map<String, dynamic> json) =>
    PoliciesSearchResponse(
      totalRows: json['total_rows'] as int,
      bookmark: json['bookmark'] as int?,
      rows: (json['rows'] as List<dynamic>)
          .map((e) => PolicyResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PoliciesSearchResponseToJson(
        PoliciesSearchResponse instance) =>
    <String, dynamic>{
      'total_rows': instance.totalRows,
      'bookmark': instance.bookmark,
      'rows': instance.rows,
    };

PolicyResponse _$PolicyResponseFromJson(Map<String, dynamic> json) =>
    PolicyResponse(
      id: json['id'] as String,
      fields: Policy.fromJson(json['fields'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PolicyResponseToJson(PolicyResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fields': instance.fields,
    };

Policy _$PolicyFromJson(Map<String, dynamic> json) => Policy(
      json['id'] as String,
      DateTime.parse(json['dateSent'] as String),
      json['creator'] as String?,
      json['owner'] as String,
      json['from'] as String,
      json['name'] as String?,
      json['filename'] as String?,
      json['fileExtension'] as String?,
      json['subject'] as String?,
      json['attachmentCount'] as int,
      json['orgId'] as String,
      json['wasForwarded'] as bool,
      (json['to'] as List<dynamic>).map((e) => e as String).toList(),
      json['status'] as String,
      json['type'] as String,
      json['forwardCount'] as int,
      json['recipientCount'] as int,
      json['accessPercent'] as String,
      (json['is'] as List<dynamic>).map((e) => e as String).toList(),
      (json['was'] as List<dynamic>).map((e) => e as String).toList(),
      (json['has'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PolicyToJson(Policy instance) => <String, dynamic>{
      'id': instance.id,
      'dateSent': instance.dateSent.toIso8601String(),
      'creator': instance.creator,
      'owner': instance.owner,
      'from': instance.from,
      'name': instance.name,
      'filename': instance.filename,
      'fileExtension': instance.fileExtension,
      'subject': instance.subject,
      'attachmentCount': instance.attachmentCount,
      'orgId': instance.orgId,
      'wasForwarded': instance.wasForwarded,
      'to': instance.to,
      'status': instance.status,
      'type': instance.type,
      'forwardCount': instance.forwardCount,
      'recipientCount': instance.recipientCount,
      'accessPercent': instance.accessPercent,
      'is': instance.statuses,
      'was': instance.was,
      'has': instance.has,
    };

ExtendedPolicy _$ExtendedPolicyFromJson(Map<String, dynamic> json) =>
    ExtendedPolicy(
      json['uuid'] as String,
      json['orgId'] as String,
      json['sentFrom'] as String,
      (json['associatedAttachmentIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      (json['children'] as List<dynamic>).map((e) => e as String).toList(),
      DateTime.parse(json['created'] as String),
      json['displayName'] as String?,
      DateTime.parse(json['lastModified'] as String),
      DateTime.parse(json['secureEmailSentAt'] as String),
      SimplePolicy.fromJson(json['simplePolicy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExtendedPolicyToJson(ExtendedPolicy instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'orgId': instance.orgId,
      'sentFrom': instance.sentFrom,
      'associatedAttachmentIds': instance.associatedAttachmentIds,
      'children': instance.children,
      'created': instance.created.toIso8601String(),
      'displayName': instance.displayName,
      'lastModified': instance.lastModified.toIso8601String(),
      'secureEmailSentAt': instance.secureEmailSentAt.toIso8601String(),
      'simplePolicy': instance.simplePolicy,
    };

SimplePolicy _$SimplePolicyFromJson(Map<String, dynamic> json) => SimplePolicy(
      (json['emailUsers'] as List<dynamic>).map((e) => e as String).toList(),
      (json['authorizations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      json['state'] as String,
      json['isManaged'] as bool,
      json['activeEnd'] == null
          ? null
          : DateTime.parse(json['activeEnd'] as String),
      (json['accessedBy'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SimplePolicyToJson(SimplePolicy instance) =>
    <String, dynamic>{
      'emailUsers': instance.emailUsers,
      'authorizations': instance.authorizations,
      'state': instance.state,
      'isManaged': instance.isManaged,
      'activeEnd': instance.activeEnd?.toIso8601String(),
      'accessedBy': instance.accessedBy,
    };
