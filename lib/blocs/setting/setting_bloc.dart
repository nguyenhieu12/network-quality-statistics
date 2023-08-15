import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingInitial(SwitchOffState())) {
    on<NotificationSwitchClickedEvent>(notificationSwitchClickedEvent);
    on<AccountInfoClickedEvent>(accountInfoClickedEvent);
    on<UpdateAccountClickedEvent>(updateAccountClickedEvent);
  }
  
  FutureOr<void> notificationSwitchClickedEvent(NotificationSwitchClickedEvent event, Emitter<SettingState> emit) {
    emit(state is SwitchOffState ? SwitchOnState() : SwitchOffState());
  }

  FutureOr<void> accountInfoClickedEvent(AccountInfoClickedEvent event, Emitter<SettingState> emit) {
    emit(NavigateToAccountInfoState());
  }

  FutureOr<void> updateAccountClickedEvent(UpdateAccountClickedEvent event, Emitter<SettingState> emit) {
    emit(NavigateToUpdateAccountState());
  }
}
