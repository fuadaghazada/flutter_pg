import 'package:bloc/bloc.dart';
import 'package:flutter_pg/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:flutter_pg/features/number_trivia/presentation/bloc/number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  @override
  // TODO: implement initialState
  NumberTriviaState get initialState => throw UnimplementedError();

  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}
