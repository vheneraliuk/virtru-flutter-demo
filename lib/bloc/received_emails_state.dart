part of 'received_emails_cubit.dart';

class ReceivedEmailsState extends Equatable {
  final List<Policy>? policies;
  final int? bookmark;
  final VirtruError? error;

  const ReceivedEmailsState._({
    this.policies,
    this.bookmark,
    this.error,
  });

  const ReceivedEmailsState.initial() : this._(bookmark: 0);

  const ReceivedEmailsState.page(List<Policy> policies, int? bookmark)
      : this._(
          policies: policies,
          bookmark: bookmark,
        );

  const ReceivedEmailsState.error(
      List<Policy>? policies, int? bookmark, VirtruError error)
      : this._(
          policies: policies,
          bookmark: bookmark,
          error: error,
        );

  @override
  List<Object?> get props => [policies, bookmark, error];
}
