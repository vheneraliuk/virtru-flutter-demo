import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtru_demo_flutter/bloc/dark_mode_cubit.dart';
import 'package:virtru_demo_flutter/repo/dark_mode_repository.dart';
import 'package:virtru_demo_flutter/ui/virtru_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => DarkModeRepository(),
      child: BlocProvider(
        create: (context) =>
            DarkModeCubit(darkModeRepo: RepositoryProvider.of(context)),
        child: BlocBuilder<DarkModeCubit, DarkModeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Virtru Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.blue,
                    brightness:
                        state.darkMode ? Brightness.dark : Brightness.light),
                useMaterial3: true,
              ),
              // home: const LoginPage(),
              home: const VirtruHomePage(),
            );
          },
        ),
      ),
    );
  }
}
