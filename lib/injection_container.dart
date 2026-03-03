import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wsports_cup_premium/features/world_cup/data/datasources/world_cup_firebase_datasource.dart';
import 'package:wsports_cup_premium/features/world_cup/data/repositories/world_cup_repository_impl.dart';
import 'package:wsports_cup_premium/features/world_cup/domain/repositories/world_cup_repository.dart';
import 'package:wsports_cup_premium/features/world_cup/domain/usecases/get_matches_usecase.dart';
import 'package:wsports_cup_premium/features/world_cup/presentation/bloc/world_cup_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ===========================================================================
  // 1. EXTERNAL (Bancos de Dados e APIs)
  // ===========================================================================

  // A. Memória Local (Placares das simulações)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // B. Firebase (Estrutura da Copa: Grupos, Seleções, Datas)
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // ===========================================================================
  // 2. DATASOURCES
  // ===========================================================================

  // Registra a fonte de dados que vai na nuvem ler os JSONs
  sl.registerLazySingleton<WorldCupFirebaseDatasource>(
    () => WorldCupFirebaseDatasource(firestore: sl()),
  );

  // ===========================================================================
  // 3. REPOSITORIES
  // ===========================================================================

  // O Repositório agora recebe OS DOIS: o Firebase (pra ler a tabela) e o SharedPrefs (pra ler/salvar placares)
  sl.registerLazySingleton<WorldCupRepository>(
    () =>
        WorldCupRepositoryImpl(remoteDatasource: sl(), sharedPreferences: sl()),
  );

  // ===========================================================================
  // 4. USE CASES
  // ===========================================================================
  sl.registerLazySingleton(() => GetMatchesUseCase(sl()));

  // ===========================================================================
  // 5. BLOC
  // ===========================================================================
  sl.registerFactory(
    () => WorldCupBloc(getMatchesUseCase: sl(), repository: sl()),
  );
}
