part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  final bool isLogin;
  const ProfileState(this.isLogin);

  @override
  List<Object> get props => [isLogin];
}

final class ProfileInitialState extends ProfileState {
  const ProfileInitialState(super.isLogin);
}

final class ProfileSuccessState extends ProfileState {
  const ProfileSuccessState(super.isLogin);
}

final class ProfileIErrorState extends ProfileState {
  final AppException exception;
  const ProfileIErrorState(super.isLogin, this.exception);
  @override
  List<Object> get props => [exception];
}
