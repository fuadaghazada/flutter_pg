import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pg/core/network/network_info.dart';
import 'package:flutter_pg/core/util/input_converter.dart';
import 'package:flutter_pg/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_pg/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:flutter_pg/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_pg/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_pg/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_pg/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Features
  initNumberTrivia();

  // ! Core - InputConverter, NetworkInfo
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // ! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}

void initNumberTrivia() {
  // BLoC
  sl.registerFactory(
    () => NumberTriviaBloc(
      concrete: sl(),
      random: sl(),
      inputConverter: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  );
}
