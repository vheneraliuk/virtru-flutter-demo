import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:virtru_demo_flutter/repo/user_repository.dart';

import '../model/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository userRepo;

  AuthCubit({required this.userRepo}) : super(const AuthState.unknown()) {
    reloadCurrentState();
  }

  void reloadCurrentState() async {
    var currentUser = await userRepo.getUser();
    if (currentUser == null) {
      emit(const AuthState.unauthenticated());
    } else {
      emit(AuthState.authenticated(currentUser));
    }
  }
}
