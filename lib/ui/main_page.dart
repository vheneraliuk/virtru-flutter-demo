import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:virtru_demo_flutter/bloc/bloc.dart';
import 'package:virtru_demo_flutter/model/model.dart';
import 'package:virtru_demo_flutter/ui/ui.dart';
import 'package:virtru_demo_flutter/ui/widgets/widgets.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PagingController<int, ApiPolicy> _sentEmailsPagingController =
      PagingController(firstPageKey: 0);
  final PagingController<int, ApiPolicy> _receivedEmailsPagingController =
      PagingController(firstPageKey: 0);
  final PagingController<int, ApiPolicy> _sentFilesPagingController =
      PagingController(firstPageKey: 0);
  final PagingController<int, ApiPolicy> _receivedFilesPagingController =
      PagingController(firstPageKey: 0);

  static final _drawerItems = [
    _DrawerItem("encrypt", "Encrypt", Icons.lock_outline),
    _DrawerItem("decrypt", "Decrypt", Icons.lock_open_outlined),
    _DrawerItem("se", "Sent Emails", Icons.outbox_outlined),
    _DrawerItem("re", "Received Emails", Icons.inbox_outlined),
    _DrawerItem("sf", "Sent Files", Icons.drive_file_move_outline),
    _DrawerItem("rf", "Received Files", Icons.drive_file_move_rtl_outlined),
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
    final widgetOptions = <String, Widget>{
      "encrypt": const EncryptWidget(),
      "decrypt": const DecryptWidget(),
      "se": SentEmails(pagingController: _sentEmailsPagingController),
      "re": ReceivedEmails(pagingController: _receivedEmailsPagingController),
      "sf": SentFiles(pagingController: _sentFilesPagingController),
      "rf": ReceivedFiles(pagingController: _receivedFilesPagingController),
    };
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.initial) {
          BlocProvider.of<AuthCubit>(context).reloadCurrentState();
        }
      },
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
                      Column(
                        children: _drawerItems
                            .asMap()
                            .entries
                            .map((entry) => ListTile(
                                onTap: () => _onItemTapped(entry.key),
                                selected: _selectedIndex == entry.key,
                                leading: Icon(
                                  entry.value.icon,
                                  color: iconColor,
                                ),
                                title: Text(entry.value.title)))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () => _onLogOutTapped(),
                  title: const Text('Log out'),
                  leading: Icon(
                    Icons.logout_outlined,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        title: _drawerItems[_selectedIndex].title,
        body: widgetOptions[_drawerItems[_selectedIndex].key] ??
            const Placeholder(),
      ),
    );
  }
}

class _DrawerItem {
  final String key;
  final String title;
  final IconData icon;

  _DrawerItem(this.key, this.title, this.icon);
}
