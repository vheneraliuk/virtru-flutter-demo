part of 'dark_mode_cubit.dart';

@immutable
class DarkModeState extends Equatable {
  const DarkModeState.fromBool({required this.darkMode});

  const DarkModeState.light() : this.fromBool(darkMode: false);

  const DarkModeState.dark() : this.fromBool(darkMode: true);

  final bool darkMode;

  @override
  List<Object?> get props => [darkMode];
}
