import 'dart:convert';

import 'package:flutter_pg/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pg/features/number_trivia/data/models/number_trivia_model.dart';

const NUMBER_TRIVIA_API_URL = 'http://numbersapi.com';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    return await _getNumberTrivia('$NUMBER_TRIVIA_API_URL/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return await _getNumberTrivia('$NUMBER_TRIVIA_API_URL/random');
  }

  Future<NumberTriviaModel> _getNumberTrivia(String url) async {
    final response =
        await client.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }
    return throw ServerException();
  }
}
