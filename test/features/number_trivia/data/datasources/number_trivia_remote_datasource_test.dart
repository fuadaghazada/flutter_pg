import 'dart:convert';

import 'package:flutter_pg/core/error/exceptions.dart';
import 'package:flutter_pg/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:flutter_pg/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailed() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 500));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''
     should perform a GET request on a URL with
     number being the endpoint
        ''', () async {
      // arrange
      setUpMockHttpClientSuccess();

      // act
      dataSource.getConcreteNumberTrivia(tNumber);

      // assert
      verify(mockHttpClient.get('$NUMBER_TRIVIA_API_URL/$tNumber',
          headers: {'Content-Type': 'application/json'}));
    });

    test('''
     should return number trivia when the response code is 200
        ''', () async {
      // arrange
      setUpMockHttpClientSuccess();

      // act
      final response = await dataSource.getConcreteNumberTrivia(tNumber);

      // assert
      verify(mockHttpClient.get('$NUMBER_TRIVIA_API_URL/$tNumber',
          headers: {'Content-Type': 'application/json'}));
      expect(response, tNumberTriviaModel);
    });

    test('''
     should throw a server exception when the status code is other than 200
        ''', () async {
      // arrange
      setUpMockHttpClientFailed();

      // act
      final call = dataSource.getConcreteNumberTrivia;

      // assert
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''
     should perform a GET request on a URL with
     number being the endpoint
        ''', () async {
      // arrange
      setUpMockHttpClientSuccess();

      // act
      dataSource.getRandomNumberTrivia();

      // assert
      verify(mockHttpClient.get('$NUMBER_TRIVIA_API_URL/random',
          headers: {'Content-Type': 'application/json'}));
    });

    test('''
     should return number trivia when the response code is 200
        ''', () async {
      // arrange
      setUpMockHttpClientSuccess();

      // act
      final response = await dataSource.getRandomNumberTrivia();

      // assert
      verify(mockHttpClient.get('$NUMBER_TRIVIA_API_URL/random',
          headers: {'Content-Type': 'application/json'}));
      expect(response, tNumberTriviaModel);
    });

    test('''
     should throw a server exception when the status code is other than 200
        ''', () async {
      // arrange
      setUpMockHttpClientFailed();

      // act
      final call = dataSource.getRandomNumberTrivia;

      // assert
      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
