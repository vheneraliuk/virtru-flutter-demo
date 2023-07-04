import 'package:dio/dio.dart' hide Headers;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';
import 'package:virtru_demo_flutter/api/auth_interceptor.dart';
import 'package:virtru_demo_flutter/model/model.dart';

part 'acm_api.g.dart';

@RestApi(baseUrl: "https://api.virtru.com/acm")
abstract class AcmClient {
  final User user;

  AcmClient._(this.user);

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
    return _AcmClient._(dio, user, baseUrl: baseUrl);
  }

  Future<PoliciesSearchResponse> getSentEmails({int bookmark = 0}) {
    var query = 'type:email AND from:(${user.userId})';
    return _getPolicies(query, bookmark);
  }

  Future<PoliciesSearchResponse> getReceivedEmails({int bookmark = 0}) {
    var query = 'type:email AND to:(${user.userId})';
    return _getPolicies(query, bookmark);
  }

  Future<PoliciesSearchResponse> getSentFiles({int bookmark = 0}) {
    var query = 'type:(file OR cse) AND from:(${user.userId})';
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
