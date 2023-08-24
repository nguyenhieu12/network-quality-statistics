part of 'account_info_bloc.dart';

sealed class AccountInfoEvent extends Equatable {
  const AccountInfoEvent();

  @override
  List<Object> get props => [];
}

class ReturnIconClickEvent extends AccountInfoEvent {}
