import 'package:bloc/bloc.dart';
import 'package:virtru_demo_flutter/model/model.dart';
import 'package:virtru_demo_flutter/repo/repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository userRepo;

  AuthCubit({required this.userRepo}) : super(AuthStateUnknown()) {
    reloadCurrentState();
  }

  void reloadCurrentState() async {
    var currentUser = await userRepo.getUser();
    if (currentUser == null) {
      emit(AuthStateUnauthenticated());
    } else {
      emit(AuthStateAuthenticated(user: currentUser));
    }
  }
}
