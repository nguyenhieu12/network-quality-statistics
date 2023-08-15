part of 'setting_bloc.dart';

sealed class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class NotificationSwitchClickedEvent extends SettingEvent {}

class UpdateAccountClickedEvent extends SettingEvent {}

class AccountInfoClickedEvent extends SettingEvent {}
