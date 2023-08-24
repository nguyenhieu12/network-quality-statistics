import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'account_info_event.dart';
part 'account_info_state.dart';

class AccountInfoBloc extends Bloc<AccountInfoEvent, AccountInfoState> {
  AccountInfoBloc() : super(AccountInfoInitial()) {
    on<ReturnIconClickEvent>(returnIconClickEvent);
  }

  FutureOr<void> returnIconClickEvent(ReturnIconClickEvent event, Emitter<AccountInfoState> emit) {
    emit(ReturnToSettingScreen());
  }
}
