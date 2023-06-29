import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtru_demo_flutter/bloc/dark_mode_cubit.dart';

class VirtruAppBar extends StatelessWidget {
  final String title;
  final Widget body;

  const VirtruAppBar({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(title),
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_4_outlined),
              tooltip: "Toggle Dark Mode",
              onPressed: () {
                BlocProvider.of<DarkModeCubit>(context).toggleDarkMode();
              },
            )
          ],
        ),
        body: body);
  }
}
