import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtru_demo_flutter/api/api.dart';
import 'package:virtru_demo_flutter/bloc/bloc.dart';
import 'package:virtru_demo_flutter/repo/repo.dart';
import 'package:virtru_demo_flutter/ui/ui.dart';

class VirtruHomePage extends StatelessWidget {
  const VirtruHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => UserRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) =>
                AuthCubit(userRepo: RepositoryProvider.of(context)),
          ),
          BlocProvider<LoginCubit>(
            create: (context) =>
                LoginCubit(userRepo: RepositoryProvider.of(context)),
          ),
        ],
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return switch (state) {
              AuthStateAuthenticated _ => RepositoryProvider(
                  create: (context) => AcmClient.forUser(state.user),
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => SentEmailsCubit(
                            acmClient: RepositoryProvider.of(context)),
                      ),
                      BlocProvider(
                        create: (context) => ReceivedEmailsCubit(
                            acmClient: RepositoryProvider.of(context)),
                      ),
                      BlocProvider(
                        create: (context) => SentFilesCubit(
                            acmClient: RepositoryProvider.of(context)),
                      ),
                      BlocProvider(
                        create: (context) => ReceivedFilesCubit(
                            acmClient: RepositoryProvider.of(context)),
                      ),
                    ],
                    child: const MainPage(),
                  ),
                ),
              AuthStateUnauthenticated _ => const LoginPage(),
              AuthStateUnknown _ => const VirtruAppBar(
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
