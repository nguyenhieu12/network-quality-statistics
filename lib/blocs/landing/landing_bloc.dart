import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'landing_event.dart';
part 'landing_state.dart';

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  LandingBloc() : super(LandingInitial()) {
    on<TabChangeEvent>(tabChangeEvent);
  }

  FutureOr<void> tabChangeEvent(TabChangeEvent event, Emitter<LandingState> emit) {
    switch (event.tabIndex) {
      case 0:
        emit(LandingInitial());
      case 1:
        emit(LineTabSelectedState());
      case 2:
        emit(SettingTabSelectedState());
      default:
        break;
    }
  }
}
