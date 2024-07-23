import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/repo/auth_repo.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  bool isLogin;
  final AuthRepository authRepository;
  ProfileBloc({required this.authRepository, required this.isLogin})
      : super(ProfileInitialState(isLogin)) {
    on<ProfileEvent>((event, emit) {
      if (event is ProfileLogoutButtonClickedEvent) {
        try {
          emit(ProfileInitialState(isLogin));
          authRepository.signOut();
          isLogin = false;
          emit(ProfileSuccessState(isLogin));
        } catch (e) {
          emit(
              ProfileIErrorState(isLogin, AppException(message: e.toString())));
        }
      }
    });
  }
}
