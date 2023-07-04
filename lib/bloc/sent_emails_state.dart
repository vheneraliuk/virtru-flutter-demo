part of 'sent_emails_cubit.dart';

class SentEmailsState extends Equatable {
  final List<Policy>? policies;
  final int? bookmark;
  final dynamic error;

  const SentEmailsState._({
    this.policies,
    this.bookmark,
    this.error,
  });

  const SentEmailsState.initial() : this._(bookmark: 0);

  const SentEmailsState.page(List<Policy> policies, int? bookmark)
      : this._(
          policies: policies,
          bookmark: bookmark,
        );

  const SentEmailsState.error(
      List<Policy>? policies, int? bookmark, dynamic error)
      : this._(
          policies: policies,
          bookmark: bookmark,
          error: error,
        );

  @override
  List<Object?> get props => [policies, bookmark, error];
}
