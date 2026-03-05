import 'package:shared_preferences/shared_preferences.dart';
import '../../features/world_cup/domain/entities/match_entity.dart';

class LocalStorageService {
  // 1. SALVAR NO CELULAR
  static Future<void> savePrediction(
    String matchId,
    int? homeScore,
    int? awayScore,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    // Se for null (Vassourinha), nós apagamos do celular
    if (homeScore == null || awayScore == null) {
      await prefs.remove('${matchId}_home');
      await prefs.remove('${matchId}_away');
    } else {
      // Se tiver placar, salvamos no celular
      await prefs.setInt('${matchId}_home', homeScore);
      await prefs.setInt('${matchId}_away', awayScore);
    }
  }

  // 2. RECUPERAR DO CELULAR QUANDO O APP ABRE
  static Future<List<MatchEntity>> restorePredictions(
    List<MatchEntity> firebaseMatches,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    // Varremos os jogos que vieram do Firebase e injetamos os placares salvos
    return firebaseMatches.map((match) {
      final savedHome = prefs.getInt('${match.id}_home');
      final savedAway = prefs.getInt('${match.id}_away');

      if (savedHome != null && savedAway != null) {
        return match.copyWith(
          userHomePrediction: savedHome,
          userAwayPrediction: savedAway,
        );
      }
      return match;
    }).toList();
  }
}
