part of 'landing_bloc.dart';

sealed class LandingState {}

sealed class LandingActionState extends LandingState {}

final class LandingInitial extends LandingState {}

class LineTabSelectedState extends LandingState {}

class DashboardTabSelectedState extends LandingState {}

class SettingTabSelectedState extends LandingState {}
