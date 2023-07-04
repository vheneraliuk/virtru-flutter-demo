import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virtru_demo_flutter/api/api.dart';

part 'received_files_state.dart';

class ReceivedFilesCubit extends Cubit<ReceivedFilesState> {
  final AcmClient acmClient;

  ReceivedFilesCubit({required this.acmClient})
      : super(const ReceivedFilesState.initial());

  void loadPolicies(int bookmark) async {
    try {
      var result = await acmClient.getReceivedFiles(bookmark: bookmark);
      emit(ReceivedFilesState.page(
        result.rows.map((e) => e.fields).toList(),
        result.bookmark,
      ));
    } catch (error) {
      emit(ReceivedFilesState.error(state.policies, state.bookmark, error));
    }
  }
}
