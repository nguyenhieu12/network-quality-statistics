import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonClickedEvent>(loginButtonClickedEvent);
  }

  FutureOr<void> loginButtonClickedEvent(
    LoginButtonClickedEvent event, Emitter<LoginState> emit) async {
      if((event.email != '1') || (event.password != '1') || (event.email == '') || (event.password == '')) {
        emit(ShowLoginFailedState());
        debugPrint('FAILED !!!!');
        return;
      } else {
        emit(LoginValidatingState());
        debugPrint('LOADING !!!!');
        await Future.delayed(const Duration(seconds: 3));
        emit(NavigateToHomeScreenState());
        debugPrint('NAVIGATED !!!!');
      }
  } 
} 
