part of 'setting_bloc.dart';

sealed class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

sealed class SettingActionState extends SettingState {}

final class SettingInitial extends SettingState {
  // SharedPreferences prefs;

  // SettingInitial({required this.prefs});
  // SettingInitial(SwitchOffState switchOffState);
}

class SwitchOnState extends SettingState {}

class SwitchOffState extends SettingState {}

class NavigateToAccountInfoState extends SettingActionState {
  String fullName;
  String email;
  String phoneNumber;
  String imageUrl;

  NavigateToAccountInfoState(
      {required this.fullName,
      required this.email,
      required this.phoneNumber,
      required this.imageUrl});

  String get getFullName => fullName;
}

class NavigateToUpdateAccountState extends SettingActionState {}

class LogoutLoadingState extends SettingState {}

class LogoutSuccessState extends SettingActionState {}
