import 'package:dartz/dartz.dart';
import 'package:flutter_pg/core/error/failures.dart';
import 'package:flutter_pg/core/usecases/usecase.dart';
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

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUInteger(any))
            .thenReturn(Right(tNumber));

    void setUpMockInputConverterFailed() =>
        when(mockInputConverter.stringToUInteger(any))
            .thenReturn(Left(InvalidInputFailure()));

    test('''
        should call the InputConverter to validate and 
        convert the string to an unsigned integer
        ''', () async {
      // arrange
      setUpMockInputConverterSuccess();

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
      setUpMockInputConverterFailed();

      // assert
      final expected = [Empty(), Error(message: INVALID_INPUT_FAILURE_MESSAGE)];
      expectLater(bloc, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('''
        should get data from the concrete use case
        ''', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia((any)))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));

      // assert
      verify(mockGetConcreteNumberTrivia(Params(number: tNumber)));
    });

    test('''
        should emit [Loading, Loaded] when data is got successfully
        ''', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia((any)))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // assert
      final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(bloc, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('''
        should emit [Loading, Error] when data got is failed
        ''', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia((any)))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('''
        should emit [Loading, Error] when data got is failed with proper msg
        ''', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia((any)))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'Test', number: 123);

    test('''
        should get data from the random use case
        ''', () async {
      // arrange
      when(mockGetRandomNumberTrivia((any)))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));

      // assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('''
        should emit [Loading, Loaded] when data is got successfully
        ''', () async {
      // arrange
      when(mockGetRandomNumberTrivia((any)))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // assert
      final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(bloc, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test('''
        should emit [Loading, Error] when data got is failed
        ''', () async {
      // arrange
      when(mockGetRandomNumberTrivia((any)))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test('''
        should emit [Loading, Error] when data got is failed with proper msg
        ''', () async {
      // arrange
      when(mockGetRandomNumberTrivia((any)))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
