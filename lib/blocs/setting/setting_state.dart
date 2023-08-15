part of 'setting_bloc.dart';

sealed class SettingState extends Equatable {
  const SettingState();
  
  @override
  List<Object> get props => [];
}

sealed class SettingActionState extends SettingState {}

final class SettingInitial extends SettingState {
  
  SettingInitial(SwitchOffState switchOffState);

}

class SwitchOnState extends SettingState {}

class SwitchOffState extends SettingState {}

class NavigateToAccountInfoState extends SettingActionState {}

class NavigateToUpdateAccountState extends SettingActionState {}