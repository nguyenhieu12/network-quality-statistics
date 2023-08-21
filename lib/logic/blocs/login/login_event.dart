part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  List<Object> get pros => [];
}

class LoginButtonClickedEvent extends LoginEvent {
  final String email;
  final String password;

  LoginButtonClickedEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
