import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virtru_demo_flutter/api/api.dart';

part 'sent_files_state.dart';

class SentFilesCubit extends Cubit<SentFilesState> {
  final AcmClient acmClient;

  SentFilesCubit({required this.acmClient})
      : super(const SentFilesState.initial());

  void loadPolicies(int bookmark) async {
    try {
      var result = await acmClient.getSentFiles(bookmark: bookmark);
      emit(SentFilesState.page(
        result.rows.map((e) => e.fields).toList(),
        result.bookmark,
      ));
    } catch (error) {
      emit(SentFilesState.error(state.policies, state.bookmark, error));
    }
  }
}
