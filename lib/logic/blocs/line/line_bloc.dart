import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'line_event.dart';
part 'line_state.dart';

class LineBloc extends Bloc<LineEvent, LineState> {
  LineBloc() : super(LineInitial()) {
    on<LineEvent>((event, emit) {
      
    });
  }
}
