import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virtru_demo_flutter/api/api.dart';

part 'sent_emails_state.dart';

class SentEmailsCubit extends Cubit<SentEmailsState> {
  final AcmClient acmClient;

  SentEmailsCubit({required this.acmClient})
      : super(const SentEmailsState.initial());

  void loadPolicies(int bookmark) async {
    try {
      var result = await acmClient.getSentEmails(bookmark: bookmark);
      emit(SentEmailsState.page(
        result.rows.map((e) => e.fields).toList(),
        result.bookmark,
      ));
    } catch (error) {
      emit(SentEmailsState.error(state.policies, state.bookmark, error));
    }
  }
}
