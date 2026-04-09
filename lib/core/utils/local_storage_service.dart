import 'package:shared_preferences/shared_preferences.dart';
import '../../features/world_cup/domain/entities/match_entity.dart';

class LocalStorageService {
  // ===========================================================================
  // 1. LÓGICA DE PALPITES (GOLS E CARTÕES)
  // ===========================================================================

  // 1. SALVAR NO CELULAR
  static Future<void> savePrediction(
    String matchId,
    int? homeScore,
    int? awayScore, {
    // Adicionamos os cartões como parâmetros opcionais
    int? homeYellows,
    int? homeDoubleYellows,
    int? homeReds,
    int? awayYellows,
    int? awayDoubleYellows,
    int? awayReds,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Se for null (Vassourinha), nós apagamos TUDO (gols e cartões) do celular
    if (homeScore == null || awayScore == null) {
      await prefs.remove('${matchId}_home');
      await prefs.remove('${matchId}_away');

      await prefs.remove('${matchId}_home_y');
      await prefs.remove('${matchId}_home_dy');
      await prefs.remove('${matchId}_home_r');

      await prefs.remove('${matchId}_away_y');
      await prefs.remove('${matchId}_away_dy');
      await prefs.remove('${matchId}_away_r');
    } else {
      // Se tiver placar, salvamos tudo!
      await prefs.setInt('${matchId}_home', homeScore);
      await prefs.setInt('${matchId}_away', awayScore);

      await prefs.setInt('${matchId}_home_y', homeYellows ?? 0);
      await prefs.setInt('${matchId}_home_dy', homeDoubleYellows ?? 0);
      await prefs.setInt('${matchId}_home_r', homeReds ?? 0);

      await prefs.setInt('${matchId}_away_y', awayYellows ?? 0);
      await prefs.setInt('${matchId}_away_dy', awayDoubleYellows ?? 0);
      await prefs.setInt('${matchId}_away_r', awayReds ?? 0);
    }
  }

  // 2. RECUPERAR DO CELULAR QUANDO O APP ABRE
  static Future<List<MatchEntity>> restorePredictions(
    List<MatchEntity> firebaseMatches,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    return firebaseMatches.map((match) {
      final savedHome = prefs.getInt('${match.id}_home');
      final savedAway = prefs.getInt('${match.id}_away');

      if (savedHome != null && savedAway != null) {
        return match.copyWith(
          userHomePrediction: savedHome,
          userAwayPrediction: savedAway,
          // Lemos os cartões (se por acaso for um palpite antigo sem cartão, default = 0)
          userHomeYellows: prefs.getInt('${match.id}_home_y') ?? 0,
          userHomeDoubleYellows: prefs.getInt('${match.id}_home_dy') ?? 0,
          userHomeReds: prefs.getInt('${match.id}_home_r') ?? 0,
          userAwayYellows: prefs.getInt('${match.id}_away_y') ?? 0,
          userAwayDoubleYellows: prefs.getInt('${match.id}_away_dy') ?? 0,
          userAwayReds: prefs.getInt('${match.id}_away_r') ?? 0,
        );
      }
      return match;
    }).toList();
  }

  // ===========================================================================
  // 3. LIMPAR TODOS OS PALPITES (RESET GLOBAL - LIXEIRA)
  // ===========================================================================
  static Future<void> clearAllPredictions() async {
    final prefs = await SharedPreferences.getInstance();

    final keysToRemove = prefs
        .getKeys()
        .where(
          (key) =>
              key.endsWith('_home') ||
              key.endsWith('_away') ||
              key.endsWith('_home_y') ||
              key.endsWith('_home_dy') ||
              key.endsWith('_home_r') ||
              key.endsWith('_away_y') ||
              key.endsWith('_away_dy') ||
              key.endsWith('_away_r'),
        )
        .toList();

    for (var key in keysToRemove) {
      await prefs.remove(key);
    }
  }

  // ===========================================================================
  // 4. LÓGICA DA REPESCAGEM (MANTIDA INTACTA)
  // ===========================================================================
  static Future<void> saveTeamSwap(
    String oldTeamName,
    String newTeamName,
    String newTeamFlag,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('swap_name_$oldTeamName', newTeamName);
    await prefs.setString('swap_flag_$oldTeamName', newTeamFlag);
  }

  static Future<List<MatchEntity>> restoreSwaps(
    List<MatchEntity> matches,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    return matches.map((match) {
      String hName = match.homeTeam;
      String hFlag = match.homeFlag;
      String aName = match.awayTeam;
      String aFlag = match.awayFlag;

      final savedHomeName = prefs.getString('swap_name_$hName');
      final savedHomeFlag = prefs.getString('swap_flag_$hName');
      if (savedHomeName != null && savedHomeFlag != null) {
        hName = savedHomeName;
        hFlag = savedHomeFlag;
      }

      final savedAwayName = prefs.getString('swap_name_$aName');
      final savedAwayFlag = prefs.getString('swap_flag_$aName');
      if (savedAwayName != null && savedAwayFlag != null) {
        aName = savedAwayName;
        aFlag = savedAwayFlag;
      }

      if (hName != match.homeTeam || aName != match.awayTeam) {
        return match.copyWith(
          homeTeam: hName,
          homeFlag: hFlag,
          awayTeam: aName,
          awayFlag: aFlag,
        );
      }
      return match;
    }).toList();
  }
}
