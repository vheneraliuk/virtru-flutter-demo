import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String userId;
  final String appId;

  const User({required this.userId, required this.appId});

  @override
  List<Object?> get props => [userId, appId];

  static const empty = User(userId: '', appId: '');
}