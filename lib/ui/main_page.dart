import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:virtru_demo_flutter/bloc/bloc.dart';
import 'package:virtru_demo_flutter/helpers/helpers.dart';
import 'package:virtru_demo_flutter/model/model.dart';
import 'package:virtru_demo_flutter/ui/ui.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PagingController<int, Policy> _sentEmailsPagingController =
      PagingController(firstPageKey: 0);
  final PagingController<int, Policy> _receivedEmailsPagingController =
      PagingController(firstPageKey: 0);
  final PagingController<int, Policy> _sentFilesPagingController =
      PagingController(firstPageKey: 0);
  final PagingController<int, Policy> _receivedFilesPagingController =
      PagingController(firstPageKey: 0);
  static final _titles = [
    "Sent Emails",
    "Received Emails",
    "Sent Files",
    "Received Files"
  ];

  int _selectedIndex = 0;

  @override
  void initState() {
    _sentEmailsPagingController.addPageRequestListener((pageKey) {
      BlocProvider.of<SentEmailsCubit>(context).loadPolicies(pageKey);
    });
    _receivedEmailsPagingController.addPageRequestListener((pageKey) {
      BlocProvider.of<ReceivedEmailsCubit>(context).loadPolicies(pageKey);
    });
    _sentFilesPagingController.addPageRequestListener((pageKey) {
      BlocProvider.of<SentFilesCubit>(context).loadPolicies(pageKey);
    });
    _receivedFilesPagingController.addPageRequestListener((pageKey) {
      BlocProvider.of<ReceivedFilesCubit>(context).loadPolicies(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _sentEmailsPagingController.dispose();
    _receivedEmailsPagingController.dispose();
    _sentFilesPagingController.dispose();
    _receivedFilesPagingController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop();
  }

  Future<void> _onLogOutTapped() async {
    Navigator.of(context).pop();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logging out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop("No"),
              child: const Text("No")),
          TextButton(
              onPressed: () {
                BlocProvider.of<LoginCubit>(this.context).logOut();
                Navigator.of(context).pop("Yes");
              },
              child: const Text("Yes"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var iconColor = Theme.of(context).colorScheme.primary;
    final List<Widget> widgetOptions = <Widget>[
      SentEmails(pagingController: _sentEmailsPagingController),
      ReceivedEmails(pagingController: _receivedEmailsPagingController),
      SentFiles(pagingController: _sentFilesPagingController),
      ReceivedFiles(pagingController: _receivedFilesPagingController),
    ];
    return MultiBlocListener(
      listeners: [
        BlocListener<SentEmailsCubit, SentEmailsState>(
          listener: (context, state) {
            if (state.error != null) {
              _sentEmailsPagingController.error = state.error!.message;
            } else if (state.policies != null) {
              _sentEmailsPagingController.appendPage(
                  state.policies!, state.bookmark);
            }
          },
        ),
        BlocListener<ReceivedEmailsCubit, ReceivedEmailsState>(
          listener: (context, state) {
            if (state.error != null) {
              _receivedEmailsPagingController.error = state.error!.message;
            } else if (state.policies != null) {
              _receivedEmailsPagingController.appendPage(
                  state.policies!, state.bookmark);
            }
          },
        ),
        BlocListener<SentFilesCubit, SentFilesState>(
          listener: (context, state) {
            if (state.error != null) {
              _sentFilesPagingController.error = state.error!.message;
            } else if (state.policies != null) {
              _sentFilesPagingController.appendPage(
                  state.policies!, state.bookmark);
            }
          },
        ),
        BlocListener<ReceivedFilesCubit, ReceivedFilesState>(
          listener: (context, state) {
            if (state.error != null) {
              _receivedFilesPagingController.error = state.error!.message;
            } else if (state.policies != null) {
              _receivedFilesPagingController.appendPage(
                  state.policies!, state.bookmark);
            }
          },
        ),
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.initial) {
              BlocProvider.of<AuthCubit>(context).reloadCurrentState();
            }
          },
        ),
      ],
      child: VirtruAppBar(
        drawer: SafeArea(
          child: Drawer(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return UserAccountsDrawerHeader(
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                            accountName: Text('Virtru Demo',
                                style: Theme.of(context).textTheme.bodyLarge),
                            accountEmail: Text(
                              state is AuthStateAuthenticated
                                  ? state.user.userId
                                  : 'unknown',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            currentAccountPicture:
                                Image.asset('assets/virtru_icon.png'),
                          );
                        },
                      ),
                      ListTile(
                          onTap: () => _onItemTapped(0),
                          selected: _selectedIndex == 0,
                          leading: Icon(
                            Icons.outbox,
                            color: iconColor,
                          ),
                          title: Text(_titles[0])),
                      ListTile(
                          onTap: () => _onItemTapped(1),
                          selected: _selectedIndex == 1,
                          leading: Icon(
                            Icons.inbox,
                            color: iconColor,
                          ),
                          title: Text(_titles[1])),
                      ListTile(
                          onTap: () => _onItemTapped(2),
                          selected: _selectedIndex == 2,
                          leading: Icon(
                            Icons.drive_file_move_sharp,
                            color: iconColor,
                          ),
                          title: Text(_titles[2])),
                      ListTile(
                          onTap: () => _onItemTapped(3),
                          selected: _selectedIndex == 3,
                          leading: Icon(
                            Icons.drive_file_move_rtl_sharp,
                            color: iconColor,
                          ),
                          title: Text(_titles[3])),
                    ],
                  ),
                ),
                const Spacer(),
                ListTile(
                  onTap: () => _onLogOutTapped(),
                  title: const Text('Log out'),
                  leading: Icon(
                    Icons.logout,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        title: _titles[_selectedIndex],
        body: widgetOptions[_selectedIndex],
      ),
    );
  }
}

class SentEmails extends StatelessWidget {
  const SentEmails({super.key, required this.pagingController});

  final PagingController<int, Policy> pagingController;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => pagingController.refresh()),
      child: PagedListView<int, Policy>(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<Policy>(
            itemBuilder: (context, item, index) => ListTile(
                  // onTap: () => EmailPage.goHere(context, policyId: item.id),
                  leading: Icon(
                    Icons.mail_lock,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    item.subject ?? '(No subject)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(_getRecipientsText(item.to)),
                  trailing: Text(getDateString(item.dateSent)),
                )),
      ),
    );
  }
}

class ReceivedEmails extends StatelessWidget {
  const ReceivedEmails({super.key, required this.pagingController});

  final PagingController<int, Policy> pagingController;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => pagingController.refresh()),
      child: PagedListView<int, Policy>(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<Policy>(
            itemBuilder: (context, item, index) => ListTile(
                  // onTap: () => EmailPage.goHere(context, policyId: item.id),
                  leading: Icon(
                    Icons.mail_lock,
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
    );
  }
}

class SentFiles extends StatelessWidget {
  const SentFiles({super.key, required this.pagingController});

  final PagingController<int, Policy> pagingController;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => pagingController.refresh()),
      child: PagedListView<int, Policy>(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<Policy>(
            itemBuilder: (context, item, index) => ListTile(
                  leading: Icon(
                    Icons.file_present_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    item.filename ?? '(No filename)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(_getRecipientsText(item.to)),
                  trailing: Text(getDateString(item.dateSent)),
                )),
      ),
    );
  }
}

class ReceivedFiles extends StatelessWidget {
  const ReceivedFiles({super.key, required this.pagingController});

  final PagingController<int, Policy> pagingController;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => pagingController.refresh()),
      child: PagedListView<int, Policy>(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<Policy>(
            itemBuilder: (context, item, index) => ListTile(
                  leading: Icon(
                    Icons.file_present_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    item.filename ?? '(No filename)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(item.from),
                  trailing: Text(getDateString(item.dateSent)),
                )),
      ),
    );
  }
}

String _getRecipientsText(List<String> to) {
  if (to.isEmpty) return '(No Recipients)';
  return '${to.first}${to.length > 1 ? ' (+${to.length - 1})' : ''}';
}
