import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';
import 'package:virtru_demo_flutter/api/auth_interceptor.dart';
import 'package:virtru_demo_flutter/model/model.dart';
import 'package:virtru_demo_flutter/repo/repo.dart';

part 'acm_api.g.dart';

@RestApi(baseUrl: "https://api.virtru.com/acm")
abstract class AcmClient {
  final UserRepository userRepo;

  AcmClient._(this.userRepo);

  factory AcmClient(UserRepository userRepo, {String? baseUrl}) {
    var dio = Dio()..interceptors.addAll(_getInterceptors());
    return _AcmClient._(dio, userRepo, baseUrl: baseUrl);
  }

  Future<PoliciesSearchResponse> getSentEmails({int bookmark = 0}) async {
    var user = await _getUser();
    var query = 'type:email AND from:(${user.userId})';
    return _getPolicies(query, bookmark);
  }

  Future<PoliciesSearchResponse> getReceivedEmails({int bookmark = 0}) async {
    var user = await _getUser();
    var query = 'type:email AND to:(${user.userId})';
    return _getPolicies(query, bookmark);
  }

  Future<PoliciesSearchResponse> getSentFiles({int bookmark = 0}) async {
    var user = await _getUser();
    var query = 'type:(file OR cse) AND from:(${user.userId})';
    return _getPolicies(query, bookmark);
  }

  Future<PoliciesSearchResponse> getReceivedFiles({int bookmark = 0}) async {
    var user = await _getUser();
    var query = 'type:(file OR cse) AND to:(${user.userId})';
    return _getPolicies(query, bookmark);
  }

  @GET("/api/policies/search")
  Future<PoliciesSearchResponse> _getPolicies(
    @Query('q') String query,
    @Query('bookmark') int bookmark, {
    @Query('sort') String sort = '["-dateSent.raw<string>"]',
  });

  @GET("/api/policies/{policyId}/contract")
  Future<Contract> getContract(@Path() String policyId);

  @GET("/api/policies/{policyId}")
  Future<ExtendedPolicy> getPolicy(@Path() String policyId);

  @GET("/api/policies/{policyId}/data/payload")
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getPayload(@Path() String policyId);

  @GET("/api/policies/{policyId}/data/metadata")
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getMetadata(@Path() String policyId);

  static List<Interceptor> _getInterceptors() {
    final interceptors = <Interceptor>[AuthInterceptor()];
    if (kDebugMode) {
      interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
      );
    }
    return interceptors;
  }

  Future<User> _getUser() async {
    return await userRepo.getUser() ?? User.empty;
  }
}
