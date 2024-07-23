 import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/repo/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  bool isLoginMode;
  AuthBloc({this.isLoginMode = true}) : super(AuthInitial(isLoginMode)) {
    on<AuthEvent>((event, emit) {
      if (event is AuthButtonClickedEvent) {
        try {
          emit(AuthLoadingState(isLoginMode));
          if (isLoginMode) {
            authRepository.login(event.username, event.password);
          } else {
            authRepository.register(event.username, event.password);
          }
          emit(AuthSuccessState(isLoginMode));
        } catch (e) {
          emit(AuthErrorState(isLoginMode,
              exception: AppException(message: e.toString())));
        }
      } else if (event is AuthCtrlLoginMode) {
        isLoginMode = !isLoginMode;
        debugPrint("is login ----->$isLoginMode");
        emit(AuthChangedPageModeState(isLoginMode));
      } else {
        throw Exception("!!! Unknown event recieved !!!");
      }
    });
  }
}
