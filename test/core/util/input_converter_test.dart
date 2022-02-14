import 'package:dartz/dartz.dart';
import 'package:flutter_pg/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUInteger', () {
    test('should return a uint when string can be', () async {
      // arrange
      final str = '123';

      // act
      final result = inputConverter.stringToUInteger(str);

      // assert
      expect(result, Right(123));
    });

    test('should return a failure when string does not represent', () async {
      // arrange
      final str = 'abc';

      // act
      final result = inputConverter.stringToUInteger(str);

      // assert
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a failure when string is negative', () async {
      // arrange
      final str = '-123';

      // act
      final result = inputConverter.stringToUInteger(str);

      // assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
