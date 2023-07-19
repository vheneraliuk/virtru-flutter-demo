import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:virtru_demo_flutter/bloc/bloc.dart';
import 'package:virtru_demo_flutter/helpers/helpers.dart';
import 'package:virtru_demo_flutter/model/model.dart';

class ReceivedEmails extends StatelessWidget {
  const ReceivedEmails({super.key, required this.pagingController});

  final PagingController<int, Policy> pagingController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReceivedEmailsCubit, ReceivedEmailsState>(
      listener: (context, state) {
        if (state.error != null) {
          pagingController.error = state.error!.message;
        } else if (state.policies != null) {
          pagingController.appendPage(state.policies!, state.bookmark);
        }
      },
      child: RefreshIndicator(
        onRefresh: () => Future.sync(() => pagingController.refresh()),
        child: PagedListView<int, Policy>(
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<Policy>(
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
                    subtitle: Text(item.from),
                    trailing: Text(getDateString(item.dateSent)),
                  )),
        ),
      ),
    );
  }
}
