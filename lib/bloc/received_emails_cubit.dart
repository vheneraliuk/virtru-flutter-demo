import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virtru_demo_flutter/model/model.dart';
import 'package:virtru_demo_flutter/repo/repo.dart';

part 'received_emails_state.dart';

class ReceivedEmailsCubit extends Cubit<ReceivedEmailsState> {
  final AcmRepository acmRepo;

  ReceivedEmailsCubit({required this.acmRepo})
      : super(const ReceivedEmailsState.initial());

  void loadPolicies(int bookmark) async {
    try {
      var result = await acmRepo.getReceivedEmails(bookmark: bookmark);
      emit(ReceivedEmailsState.page(
        result.rows.map((e) => e.fields).toList(),
        result.bookmark,
      ));
    } catch (error) {
      emit(ReceivedEmailsState.error(
        state.policies,
        state.bookmark,
        VirtruError.fromError(error),
      ));
    }
  }
}
