import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:virtru_demo_flutter/model/model.dart';
import 'package:virtru_demo_flutter/repo/repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserRepository userRepo;
  final AccountsRepository accountRepo;

  LoginCubit({required this.userRepo, required this.accountRepo})
      : super(const LoginState.initial());

  void sendCode(String email) async {
    try {
      var sessionId = await accountRepo.requestCode(userId: email);
      emit(LoginState.codePending(email, sessionId.sessionId));
    } on DioException catch (error) {
      _emitError(error);
    }
  }

  void activate(String code) async {
    var currentState = state;
    if (currentState.status != LoginStatus.pendingCode) return;
    try {
      var appIdBundle = await accountRepo.sendCode(
        userId: currentState.userId!,
        code: code,
        sessionId: currentState.sessionId!,
      );
      userRepo.saveUser(User(
        userId: appIdBundle.userId,
        appId: appIdBundle.appId,
      ));
      emit(LoginState.authenticated(appIdBundle));
    } on DioException catch (error) {
      _emitError(error);
    }
  }

  void logOut() async {
    var user = await userRepo.getUser();
    if (user == null) return;
    try {
      accountRepo.revokeAppId(userId: user.appId, appId: user.userId);
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
