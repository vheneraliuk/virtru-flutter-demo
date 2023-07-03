import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:virtru_demo_flutter/model/user.dart';
import 'package:virtru_demo_flutter/repo/user_repository.dart';

import '../api/accounts_api.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserRepository userRepo;
  final _accountClient = AccountsClient(Dio()
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
    )));

  LoginCubit({required this.userRepo}) : super(const LoginState.initial());

  void sendCode(String email) async {
    var sessionId =
        await _accountClient.requestCode(CodeRequest.forUser(userId: email));
    emit(LoginState.codePending(email, sessionId.sessionId));
  }

  void activate(String code) async {
    var currentState = state;
    if (currentState.status != LoginStatus.pendingCode) return;
    var appIdBundle = await _accountClient.sendCode(SendCodeRequest(
        userId: currentState.userId!,
        sessionId: currentState.sessionId!,
        code: code));
    userRepo
        .saveUser(User(userId: appIdBundle.userId, appId: appIdBundle.appId));
    emit(LoginState.authenticated(appIdBundle));
  }

  void emailLogin() async {
    _accountClient.emailLogin(EmailLoginRequest.forUser(
        emailAddress: 'vladyslav.heneraliuk@gmail.com'));
  }
}
