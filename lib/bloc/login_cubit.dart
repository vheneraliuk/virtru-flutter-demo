import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:virtru_demo_flutter/api/api.dart';
import 'package:virtru_demo_flutter/model/model.dart';
import 'package:virtru_demo_flutter/repo/repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserRepository userRepo;
  final _accountClient = AccountsClient();

  LoginCubit({required this.userRepo}) : super(const LoginState.initial());

  void sendCode(String email) async {
    try {
      var sessionId =
          await _accountClient.requestCode(CodeRequest.forUser(userId: email));
      emit(LoginState.codePending(email, sessionId.sessionId));
    } on DioException catch (error) {
      _emitError(error);
    }
  }

  void activate(String code) async {
    var currentState = state;
    if (currentState.status != LoginStatus.pendingCode) return;
    try {
      var appIdBundle = await _accountClient.sendCode(SendCodeRequest(
          userId: currentState.userId!,
          sessionId: currentState.sessionId!,
          code: code));
      userRepo
          .saveUser(User(userId: appIdBundle.userId, appId: appIdBundle.appId));
      emit(LoginState.authenticated(appIdBundle));
    } on DioException catch (error) {
      _emitError(error);
    }
  }

  void logOut() async {
    var user = await userRepo.getUser();
    if (user == null) return;
    try {
      _accountClient.revokeAppId('Virtru [["${user.appId}","${user.userId}"]]',
          RevokeAppIdRequest.forAppId(user.appId));
      userRepo.removeCurrentUser();
      emit(const LoginState.initial());
    } on DioException catch (error) {
      _emitError(error);
    }
  }

  void backToSendCode() {
    emit(const LoginState.initial());
  }

  void _emitError(DioException error) {
    var data = error.response?.data;
    if (data == null) return;
    var virtruError = VirtruErrorResponse.fromJson(data);
    emit(state.copyWith(error: virtruError.error));
  }
}
