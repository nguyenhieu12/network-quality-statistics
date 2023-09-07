import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:network_quality_statistic/data/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonClickedEvent>(loginButtonClickedEvent);
  }

  FutureOr<void> loginButtonClickedEvent(
      LoginButtonClickedEvent event, Emitter<LoginState> emit) async {
    Map<String, dynamic>? loginUser =
        await UserRepository.getUserByEmailAndPassword(
            event.email, event.password);

    if((event.email == '') || (event.password == '')) {
      emit(ShowLoginFailedState(message: 'Email và mật khẩu không được trống'));
    } else if(loginUser == null) {
      emit(ShowLoginFailedState(message: 'Email hoặc mật khẩu không đúng'));
    }
    else {
      emit(LoginLoadingState());
      await Future.delayed(const Duration(seconds: 2));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('id', loginUser['id']);
      prefs.setString('email', loginUser['email']);
      prefs.setString('password', loginUser['password']);
      prefs.setString('fullName', loginUser['fullName']);
      prefs.setString('phoneNumber', loginUser['phoneNumber']);
      prefs.setString('role', loginUser['role']);
      prefs.setString('province', loginUser['province']);
      prefs.setString('imageUrl', loginUser['imageUrl']);
      emit(LoginSuccessState(
          id: loginUser['id'],
          fullName: loginUser['fullName'],
          email: loginUser['email'],
          phoneNumber: loginUser['phoneNumber'],
          imageUrl: loginUser['imageUrl']));
    }
  }
}
