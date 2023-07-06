import 'package:dio/dio.dart';
import 'package:virtru_demo_flutter/repo/repo.dart';

import '../model/user.dart';

class AuthInterceptor extends Interceptor {
  final UserRepository userRepo = UserRepository();

  AuthInterceptor();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var user = await userRepo.getUser() ?? User.empty;
    if (user.appId.isNotEmpty && user.userId.isNotEmpty) {
      options.headers['Authorization'] =
          'Virtru [["${user.appId}","${user.userId}"]]';
    }
    super.onRequest(options, handler);
  }
}
