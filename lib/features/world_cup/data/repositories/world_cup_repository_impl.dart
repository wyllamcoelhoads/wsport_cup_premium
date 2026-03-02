
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/match_entity.dart';
import '../../domain/repositories/world_cup_repository.dart';
import '../datasources/world_cup_mock_data.dart';

class WorldCupRepositoryImpl implements WorldCupRepository {
  final SharedPreferences sharedPreferences;

  WorldCupRepositoryImpl({required this.sharedPreferences});

  @override
  Future<List<MatchEntity>> getMatches() async {
    // 1. Pega os jogos estáticos (Mock)
    List<MatchEntity> matches = WorldCupMockData.matches;
    List<MatchEntity> updatedMatches = [];

    // 2. Verifica se o usuário já salvou algum palpite para esses jogos
    for (var match in matches) {
      final savedData = sharedPreferences.getString('prediction_${match.id}');
      
      if (savedData != null) {
        // Se tem palpite salvo, carrega ele
        final Map<String, dynamic> json = jsonDecode(savedData);
        updatedMatches.add(MatchEntity(
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
        ));
      } else {
        // Se não tem, usa o original
        updatedMatches.add(match);
      }
    }

    return updatedMatches;
  }

  @override
  Future<void> savePrediction(String matchId, int homeScore, int awayScore) async {
    // Salva no formato JSON simples: {"home": 2, "away": 1}
    final data = jsonEncode({'home': homeScore, 'away': awayScore});
    await sharedPreferences.setString('prediction_$matchId', data);
  }
}