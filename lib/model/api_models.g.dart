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
