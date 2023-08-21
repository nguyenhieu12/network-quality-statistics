import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingInitial()) {
    on<NotificationSwitchClickedEvent>(notificationSwitchClickedEvent);
    on<AccountInfoClickedEvent>(accountInfoClickedEvent);
    on<UpdateAccountClickedEvent>(updateAccountClickedEvent);
    on<LogoutClickedEvent>(logoutClickedEvent);
  }

  FutureOr<void> notificationSwitchClickedEvent(
      NotificationSwitchClickedEvent event, Emitter<SettingState> emit) {
    emit(state is SwitchOffState ? SwitchOnState() : SwitchOffState());
  }

  FutureOr<void> accountInfoClickedEvent(
      AccountInfoClickedEvent event, Emitter<SettingState> emit) {
    emit(NavigateToAccountInfoState(
        fullName: event.fullName,
        email: event.email,
        phoneNumber: event.phoneNumber,
        imageUrl: event.imageUrl));
  }

  FutureOr<void> updateAccountClickedEvent(
      UpdateAccountClickedEvent event, Emitter<SettingState> emit) {
    emit(NavigateToUpdateAccountState());
  }

  FutureOr<void> logoutClickedEvent(
      LogoutClickedEvent event, Emitter<SettingState> emit) async {
    emit(LogoutLoadingState());
    await Future.delayed(const Duration(seconds: 2));
    emit(LogoutSuccessState());
  }
}
