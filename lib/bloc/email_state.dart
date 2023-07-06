part of 'email_cubit.dart';

sealed class EmailState {}

class EmailStateInitial extends EmailState {}

class EmailStateError extends EmailState {
  final VirtruError error;

  EmailStateError(this.error);
}

class EmailStateSuccess extends EmailState {
  final Contract contract;
  final ExtendedPolicy policy;
  final String decryptedEmail;

  EmailStateSuccess({
    required this.policy,
    required this.contract,
    required this.decryptedEmail,
  });
}
