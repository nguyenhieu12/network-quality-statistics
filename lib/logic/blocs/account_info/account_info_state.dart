part of 'account_info_bloc.dart';

sealed class AccountInfoState extends Equatable {
  const AccountInfoState();
  
  @override
  List<Object> get props => [];
}

sealed class AccountInfoActionState extends AccountInfoState {}

final class AccountInfoInitial extends AccountInfoState {}

class ReturnToSettingScreen extends AccountInfoActionState {}


