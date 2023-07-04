part of 'auth_cubit.dart';

sealed class AuthState {}

class AuthStateUnknown extends AuthState {}

class AuthStateUnauthenticated extends AuthState {}

class AuthStateAuthenticated extends AuthState {
  final User user;

  AuthStateAuthenticated({required this.user});
}
