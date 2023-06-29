import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtru_demo_flutter/bloc/auth_cubit.dart';
import 'package:virtru_demo_flutter/ui/login_page.dart';
import 'package:virtru_demo_flutter/ui/main_page.dart';
import 'package:virtru_demo_flutter/ui/virtru_app_bar.dart';

import '../repo/user_repository.dart';

class VirtruHomePage extends StatelessWidget {
  const VirtruHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => UserRepository(),
      child: BlocProvider<AuthCubit>(
        create: (context) =>
            AuthCubit(userRepo: RepositoryProvider.of(context)),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return switch (state.status) {
              AuthenticationStatus.authenticated =>
                const VirtruAppBar(title: 'Flutter Demo', body: MainPage()),
              AuthenticationStatus.unauthenticated =>
                const VirtruAppBar(title: 'Activation', body: LoginPage()),
              AuthenticationStatus.unknown => const VirtruAppBar(
                  title: 'Flutter Demo',
                  body: Center(
                    child: CircularProgressIndicator(),
                  )),
            };
          },
        ),
      ),
    );
  }
}
