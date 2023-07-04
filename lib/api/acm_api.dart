import 'package:dio/dio.dart' hide Headers;
import 'package:json_annotation/json_annotation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';
import 'package:virtru_demo_flutter/api/auth_interceptor.dart';
import 'package:virtru_demo_flutter/model/model.dart';

part 'acm_api.g.dart';

@RestApi(baseUrl: "https://api.virtru.com/acm")
abstract class AcmClient {
  final User user;

  factory AcmClient.forUser(User user, {String? baseUrl}) {
    var dio = Dio()
      ..interceptors.addAll([
        AuthInterceptor(user),
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
      ]);
    return _AcmClient(dio, user, baseUrl: baseUrl);
  }

  AcmClient(this.user);

  Future<PoliciesSearchResponse> getSentEmails({int bookmark = 0}) {
    var query = 'type:email AND from:(${user.userId})';
    return _getPolicies(query, bookmark);
  }

  Future<PoliciesSearchResponse> getSentFiles({int bookmark = 0}) {
    var query = 'type:(file OR cse) AND from:(${user.userId})';
    return _getPolicies(query, bookmark);
  }

  Future<PoliciesSearchResponse> getReceivedEmails({int bookmark = 0}) {
    var query = 'type:email AND to:(${user.userId})';
    return _getPolicies(query, bookmark);
  }

  Future<PoliciesSearchResponse> getReceivedFiles({int bookmark = 0}) {
    var query = 'type:(file OR cse) AND to:(${user.userId})';
    return _getPolicies(query, bookmark);
  }

  @GET("/api/policies/search")
  Future<PoliciesSearchResponse> _getPolicies(
    @Query('q') String query,
    @Query('bookmark') int bookmark, {
    @Query('sort') String sort = '["-dateSent.raw<string>"]',
  });
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
