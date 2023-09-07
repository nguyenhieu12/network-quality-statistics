part of 'login_bloc.dart';

sealed class LoginState {}

sealed class LoginActionState extends LoginState {}

final class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginActionState {
  int id;
  String fullName;
  String email;
  String phoneNumber;
  String imageUrl;

  LoginSuccessState(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.phoneNumber,
      required this.imageUrl});
}

class ShowLoginFailedState extends LoginActionState {
  String message;

  ShowLoginFailedState({required this.message});
}
