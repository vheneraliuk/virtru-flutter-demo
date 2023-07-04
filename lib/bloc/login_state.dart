part of 'login_cubit.dart';

class LoginState extends Equatable {
  final LoginStatus status;
  final AppIdBundle? appIdBundle;
  final String? userId;
  final String? sessionId;
  final VirtruError? error;

  const LoginState._({
    this.status = LoginStatus.initial,
    this.appIdBundle,
    this.userId,
    this.sessionId,
    this.error,
  });

  const LoginState.initial() : this._();

  const LoginState.codePending(String userId, String sessionId)
      : this._(
          status: LoginStatus.pendingCode,
          userId: userId,
          sessionId: sessionId,
        );

  const LoginState.authenticated(AppIdBundle appIdBundle)
      : this._(
          status: LoginStatus.authenticated,
          appIdBundle: appIdBundle,
        );

  LoginState copyWith({
    LoginStatus? status,
    AppIdBundle? appIdBundle,
    String? userId,
    String? sessionId,
    VirtruError? error,
  }) =>
      LoginState._(
        status: status ?? this.status,
        appIdBundle: appIdBundle ?? this.appIdBundle,
        userId: userId ?? this.userId,
        sessionId: sessionId ?? this.sessionId,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [status, appIdBundle, sessionId, error];
}

enum LoginStatus { initial, pendingCode, authenticated }
