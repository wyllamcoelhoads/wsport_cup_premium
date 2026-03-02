import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wsports_cup_premium/features/world_cup/data/repositories/world_cup_repository_impl.dart';
import 'package:wsports_cup_premium/features/world_cup/domain/repositories/world_cup_repository.dart';
import 'package:wsports_cup_premium/features/world_cup/domain/usecases/get_matches_usecase.dart';
import 'package:wsports_cup_premium/features/world_cup/presentation/bloc/world_cup_bloc.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // --- Features - World Cup ---
  
  // 1. Bloc
  sl.registerFactory(
    () => WorldCupBloc(
      getMatchesUseCase: sl(),
      repository: sl(),
    ),
  );

  // 2. Use Cases
  sl.registerLazySingleton(() => GetMatchesUseCase(sl()));

  // 3. Repository
  sl.registerLazySingleton<WorldCupRepository>(
    () => WorldCupRepositoryImpl(sharedPreferences: sl()),
  );

  // --- External ---
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}