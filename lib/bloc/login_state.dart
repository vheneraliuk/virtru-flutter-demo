part of 'login_cubit.dart';

@immutable
class LoginState extends Equatable {
  final LoginStatus status;
  final AppIdBundle? appIdBundle;
  final String? userId;
  final String? sessionId;

  const LoginState._({
    this.status = LoginStatus.initial,
    this.appIdBundle,
    this.userId,
    this.sessionId,
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

  @override
  List<Object?> get props => [status, appIdBundle, sessionId];
}

enum LoginStatus { initial, pendingCode, authenticated }
