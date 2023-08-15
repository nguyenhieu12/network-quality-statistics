part of 'login_bloc.dart';

sealed class LoginState {}

sealed class LoginActionState extends LoginState{}

final class LoginInitial extends LoginState {}

class LoginValidatingState extends LoginState {

}

class LoginSuccessState extends LoginState {

}

class ShowLoginFailedState extends LoginActionState {

}

class NavigateToHomeScreenState extends LoginActionState {
  
}
