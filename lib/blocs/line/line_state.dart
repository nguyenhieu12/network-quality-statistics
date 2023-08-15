part of 'line_bloc.dart';

sealed class LineState extends Equatable {
  const LineState();
  
  @override
  List<Object> get props => [];
}

final class LineInitial extends LineState {}
