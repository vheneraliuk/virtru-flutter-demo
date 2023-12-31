part of 'received_files_cubit.dart';

class ReceivedFilesState extends Equatable {
  final List<ApiPolicy>? policies;
  final int? bookmark;
  final VirtruError? error;

  const ReceivedFilesState._({
    this.policies,
    this.bookmark,
    this.error,
  });

  const ReceivedFilesState.initial() : this._(bookmark: 0);

  const ReceivedFilesState.page(List<ApiPolicy> policies, int? bookmark)
      : this._(
          policies: policies,
          bookmark: bookmark,
        );

  const ReceivedFilesState.error(
      List<ApiPolicy>? policies, int? bookmark, dynamic error)
      : this._(
          policies: policies,
          bookmark: bookmark,
          error: error,
        );

  @override
  List<Object?> get props => [policies, bookmark, error];
}
