import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:virtru_demo_flutter/bloc/bloc.dart';
import 'package:virtru_demo_flutter/helpers/helpers.dart';
import 'package:virtru_demo_flutter/model/model.dart';

class SentEmails extends StatelessWidget {
  const SentEmails({required this.pagingController});

  final PagingController<int, ApiPolicy> pagingController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SentEmailsCubit, SentEmailsState>(
      listener: (context, state) {
        if (state.error != null) {
          pagingController.error = state.error!.message;
        } else if (state.policies != null) {
          pagingController.appendPage(state.policies!, state.bookmark);
        }
      },
      child: RefreshIndicator(
        onRefresh: () => Future.sync(() => pagingController.refresh()),
        child: PagedListView<int, ApiPolicy>(
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<ApiPolicy>(
              itemBuilder: (context, item, index) => ListTile(
                    // onTap: () => EmailPage.goHere(context, policyId: item.id),
                    leading: Icon(
                      Icons.mail_lock_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      item.subject ?? '(No subject)',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(getRecipientsText(item.to)),
                    trailing: Text(getDateString(item.dateSent)),
                  )),
        ),
      ),
    );
  }
}
