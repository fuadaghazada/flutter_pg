import 'package:dartz/dartz.dart';
import 'package:flutter_pg/core/util/input_converter.dart';
import 'package:flutter_pg/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_pg/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_pg/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_pg/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initialState should be empty', () {
    // assert
    expect(bloc.initialState, Empty());
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumber = 1;
    final tNumberTrivia = NumberTrivia(text: 'Test', number: tNumber);

    test('''
        should call the InputConverter to validate and 
        convert the string to an unsigned integer
        ''', () async {
      // arrange
      when(mockInputConverter.stringToUInteger(any)).thenReturn(Right(tNumber));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUInteger(any));

      // assert
      verify(mockInputConverter.stringToUInteger(tNumberString));
    });

    test('''
        should emit Error when the input is invalid
        ''', () async {
      // arrange
      when(mockInputConverter.stringToUInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      // assert
      final expected = [Empty(), Error(message: INVALID_INPUT_FAILURE_MESSAGE)];
      expectLater(bloc, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
  });
}
