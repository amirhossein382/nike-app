part of 'auth_bloc.dart';

sealed class AuthState{
  final bool isLoginMode;
  const AuthState(this.isLoginMode);

}

final class AuthInitial extends AuthState {
  const AuthInitial(super.isLoginMode);
}

final class AuthErrorState extends AuthState {
  final AppException exception;

  const AuthErrorState(super.isLoginMode, {required this.exception});


}

final class AuthSuccessState extends AuthState {
  const AuthSuccessState(super.isLoginMode);
}

final class AuthLoadingState extends AuthState {
  const AuthLoadingState(super.isLoginMode);
}

final class AuthChangedPageModeState extends AuthState {
  const AuthChangedPageModeState(super.isLoginMode);
}
