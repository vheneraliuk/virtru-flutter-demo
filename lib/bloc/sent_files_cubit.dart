import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virtru_demo_flutter/model/model.dart';
import 'package:virtru_demo_flutter/repo/repo.dart';

part 'sent_files_state.dart';

class SentFilesCubit extends Cubit<SentFilesState> {
  final AcmRepository acmRepo;

  SentFilesCubit({required this.acmRepo})
      : super(const SentFilesState.initial());

  void loadPolicies(int bookmark) async {
    try {
      var result = await acmRepo.getSentFiles(bookmark: bookmark);
      emit(SentFilesState.page(
        result.rows.map((e) => e.fields).toList(),
        result.bookmark,
      ));
    } catch (error) {
      emit(SentFilesState.error(
        state.policies,
        state.bookmark,
        VirtruError.fromError(error),
      ));
    }
  }
}
