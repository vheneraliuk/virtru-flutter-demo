import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virtru_demo_flutter/model/model.dart';
import 'package:virtru_demo_flutter/repo/repo.dart';

part 'sent_emails_state.dart';

class SentEmailsCubit extends Cubit<SentEmailsState> {
  final AcmRepository acmRepo;

  SentEmailsCubit({required this.acmRepo})
      : super(const SentEmailsState.initial());

  void loadPolicies(int bookmark) async {
    try {
      var result = await acmRepo.getSentEmails(bookmark: bookmark);
      emit(SentEmailsState.page(
        result.rows.map((e) => e.fields).toList(),
        result.bookmark,
      ));
    } catch (error) {
      emit(SentEmailsState.error(
        state.policies,
        state.bookmark,
        VirtruError.fromError(error),
      ));
    }
  }
}
