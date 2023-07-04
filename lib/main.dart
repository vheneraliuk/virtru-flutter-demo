import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtru_demo_flutter/bloc/bloc.dart';
import 'package:virtru_demo_flutter/repo/repo.dart';
import 'package:virtru_demo_flutter/ui/ui.dart';

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
