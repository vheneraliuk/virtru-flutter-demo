import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:virtru_demo_flutter/repo/dark_mode_repository.dart';

part 'dark_mode_state.dart';

class DarkModeCubit extends Cubit<DarkModeState> {
  final DarkModeRepository darkModeRepo;

  DarkModeCubit({required this.darkModeRepo})
      : super(const DarkModeState.light()) {
    _initDarkMode();
  }

  void _initDarkMode() async {
    emit(DarkModeState.fromBool(darkMode: await darkModeRepo.isDarkMode()));
  }

  void toggleDarkMode() async {
    emit(DarkModeState.fromBool(darkMode: await darkModeRepo.toggleDarkMode()));
  }
}
