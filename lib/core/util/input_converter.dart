import 'package:dartz/dartz.dart';
import 'package:flutter_pg/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUInteger(String str) {
    try {
      final parsed = int.parse(str);
      if (parsed < 0) {
        throw FormatException();
      }
      return Right(parsed);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
