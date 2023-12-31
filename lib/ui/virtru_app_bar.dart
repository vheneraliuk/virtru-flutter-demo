import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtru_demo_flutter/bloc/bloc.dart';

class VirtruAppBar extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? drawer;

  const VirtruAppBar(
      {super.key, required this.title, required this.body, this.drawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
          actions: [
            BlocBuilder<DarkModeCubit, DarkModeState>(
              builder: (context, state) {
                return IconButton(
                  icon: Icon(
                    state.darkMode
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                  ),
                  tooltip: "Toggle Dark Mode",
                  onPressed:
                      BlocProvider.of<DarkModeCubit>(context).toggleDarkMode,
                );
              },
            )
          ],
        ),
        drawer: drawer,
        body: body);
  }
}
