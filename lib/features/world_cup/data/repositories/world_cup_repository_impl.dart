import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/match_entity.dart';
import '../../domain/repositories/world_cup_repository.dart';
// 1. Importe o seu novo datasource do Firebase (ajuste o caminho se necessário)
import '../datasources/world_cup_firebase_datasource.dart';

class WorldCupRepositoryImpl implements WorldCupRepository {
  // 2. Agora o repositório tem as duas fontes de dados!
  final WorldCupFirebaseDatasource remoteDatasource;
  final SharedPreferences sharedPreferences;

  // 3. O construtor pede os dois parâmetros obrigatórios, resolvendo o erro do Injection Container
  WorldCupRepositoryImpl({
    required this.remoteDatasource,
    required this.sharedPreferences,
  });

  @override
  Future<List<MatchEntity>> getMatches() async {
    // 4. A grande mudança: Pega os jogos DIRETO DA NUVEM (Firebase) em vez do arquivo Mock local!
    List<MatchEntity> matches = await remoteDatasource.getMatches();
    List<MatchEntity> updatedMatches = [];

    // 5. Verifica se o usuário já salvou algum palpite para esses jogos na memória local
    for (var match in matches) {
      final savedData = sharedPreferences.getString('prediction_${match.id}');

      if (savedData != null) {
        // Se tem palpite salvo, carrega ele em cima do jogo oficial
        final Map<String, dynamic> json = jsonDecode(savedData);
        updatedMatches.add(
          MatchEntity(
            id: match.id,
            homeTeam: match.homeTeam,
            homeFlag: match.homeFlag,
            awayTeam: match.awayTeam,
            awayFlag: match.awayFlag,
            date: match.date,
            stadium: match.stadium,
            group: match.group,
            status: match.status,
            userHomePrediction: json['home'],
            userAwayPrediction: json['away'],
          ),
        );
      } else {
        // Se não tem palpite salvo, usa o jogo limpo que veio do Firebase
        updatedMatches.add(match);
      }
    }

    return updatedMatches;
  }

  @override
  Future<void> savePrediction(
    String matchId,
    int homeScore,
    int awayScore,
  ) async {
    // Salva o palpite localmente. A nuvem não é alterada!
    final data = jsonEncode({'home': homeScore, 'away': awayScore});
    await sharedPreferences.setString('prediction_$matchId', data);
  }
}
