part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class AuthButtonClickedEvent extends AuthEvent {
  final String username;
  final String password;

  const AuthButtonClickedEvent(
      {required this.username, required this.password});
}

final class AuthCtrlLoginMode extends AuthEvent {}
