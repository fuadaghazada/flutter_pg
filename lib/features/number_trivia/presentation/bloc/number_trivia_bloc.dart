import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_pg/core/error/failures.dart';
import 'package:flutter_pg/core/usecases/usecase.dart';
import 'package:flutter_pg/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:meta/meta.dart';
import 'package:flutter_pg/core/util/input_converter.dart';
import 'package:flutter_pg/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_pg/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_pg/features/number_trivia/presentation/bloc/bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server failure';
const String CACHE_FAILURE_MESSAGE = 'Cache failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid input - The number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {@required GetConcreteNumberTrivia concrete,
      @required GetRandomNumberTrivia random,
      @required this.inputConverter})
      : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither = inputConverter.stringToUInteger(event.numberText);

      yield* inputEither.fold((failure) async* {
        yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      }, (number) async* {
        yield Loading();
        final res = await getConcreteNumberTrivia(Params(number: number));
        yield* _eitherLoadedOrErrorState(res);
      });
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final res = await getRandomNumberTrivia(NoParams());
      yield* _eitherLoadedOrErrorState(res);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> res) async* {
    yield res.fold((failure) => Error(message: _mapFailureToMessage(failure)),
        (trivia) => Loaded(trivia: trivia));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
