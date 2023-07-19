import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtru_demo_flutter/bloc/bloc.dart';
import 'package:virtru_demo_flutter/ui/ui.dart';
import 'package:virtru_demo_flutter/ui/widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return VirtruAppBar(
      title: 'Activation',
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.authenticated) {
            var snackBar = const SnackBar(
              content: Text('Activation completed!'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            BlocProvider.of<AuthCubit>(context).reloadCurrentState();
          }
          if (state.error != null) {
            var snackBar = SnackBar(
              backgroundColor: Theme.of(context).colorScheme.error,
              content: Text(
                state.error?.message ?? 'Unknown error',
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          if (state.status == LoginStatus.initial) {
            return const LoginEmailForm();
          } else {
            return const LoginCodeForm();
          }
        },
      ),
    );
  }
}
