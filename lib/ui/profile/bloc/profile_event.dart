part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class ProfileLogoutButtonClickedEvent extends ProfileEvent {}

final class ProfileLoginButtonClickedEvent extends ProfileEvent {}
