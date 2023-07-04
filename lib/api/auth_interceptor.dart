import 'package:dio/dio.dart';

import '../model/user.dart';

class AuthInterceptor extends Interceptor {
  final User user;

  AuthInterceptor(this.user);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] =
        'Virtru [["${user.appId}","${user.userId}"]]';
    super.onRequest(options, handler);
  }
}
