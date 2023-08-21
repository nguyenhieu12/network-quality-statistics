part of 'landing_bloc.dart';

sealed class LandingState extends Equatable {
  // final int tabIndex;

  // LandingState({required this.tabIndex});

  @override
  List<Object> get props => [];
}

sealed class LandingActionState extends LandingState {
  // LandingActionState({required super.tabIndex});
}

final class LandingInitial extends LandingState {
  // LandingInitial({required super.tabIndex});
}

class LineTabSelectedState extends LandingState {}

class SettingTabSelectedState extends LandingState {}
