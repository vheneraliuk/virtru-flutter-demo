part of 'sent_emails_cubit.dart';

class SentEmailsState extends Equatable {
  final List<ApiPolicy>? policies;
  final int? bookmark;
  final VirtruError? error;

  const SentEmailsState._({
    this.policies,
    this.bookmark,
    this.error,
  });

  const SentEmailsState.initial() : this._(bookmark: 0);

  const SentEmailsState.page(List<ApiPolicy> policies, int? bookmark)
      : this._(
          policies: policies,
          bookmark: bookmark,
        );

  const SentEmailsState.error(
      List<ApiPolicy>? policies, int? bookmark, dynamic error)
      : this._(
          policies: policies,
          bookmark: bookmark,
          error: error,
        );

  @override
  List<Object?> get props => [policies, bookmark, error];
}
