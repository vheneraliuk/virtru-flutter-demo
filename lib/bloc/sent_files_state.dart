part of 'sent_files_cubit.dart';

class SentFilesState extends Equatable {
  final List<ApiPolicy>? policies;
  final int? bookmark;
  final VirtruError? error;

  const SentFilesState._({
    this.policies,
    this.bookmark,
    this.error,
  });

  const SentFilesState.initial() : this._(bookmark: 0);

  const SentFilesState.page(List<ApiPolicy> policies, int? bookmark)
      : this._(
          policies: policies,
          bookmark: bookmark,
        );

  const SentFilesState.error(
      List<ApiPolicy>? policies, int? bookmark, dynamic error)
      : this._(
          policies: policies,
          bookmark: bookmark,
          error: error,
        );

  @override
  List<Object?> get props => [policies, bookmark, error];
}
