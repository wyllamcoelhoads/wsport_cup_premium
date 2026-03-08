import 'package:shared_preferences/shared_preferences.dart';
import '../../features/world_cup/domain/entities/match_entity.dart';

class LocalStorageService {
  // ===========================================================================
  // 1. LÓGICA DE PALPITES (MANTIDA 100% INTACTA)
  // ===========================================================================

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

  // ===========================================================================
  // 3. LIMPAR TODOS OS PALPITES (RESET)
  // ===========================================================================
  static Future<void> clearAllPredictions() async {
    final prefs = await SharedPreferences.getInstance();
    // Pega todas as chaves que terminam com '_home' ou '_away' (padrão usado nos palpites)
    final keysToRemove = prefs.getKeys().where(
      (key) => key.endsWith('_home') || key.endsWith('_away'),
    );
    for (var key in keysToRemove) {
      await prefs.remove(key);
    }
  }

  // ===========================================================================
  // 2. LÓGICA DA REPESCAGEM (NOVA FUNCIONALIDADE)
  // ===========================================================================

  // 3. SALVAR TROCA DE SELEÇÃO NO CELULAR
  static Future<void> saveTeamSwap(
    String oldTeamName,
    String newTeamName,
    String newTeamFlag,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    // Usamos um prefixo 'swap_' para não misturar com as chaves dos palpites
    await prefs.setString('swap_name_$oldTeamName', newTeamName);
    await prefs.setString('swap_flag_$oldTeamName', newTeamFlag);
  }

  // 4. RECUPERAR TROCAS DE SELEÇÃO QUANDO O APP ABRE
  static Future<List<MatchEntity>> restoreSwaps(
    List<MatchEntity> matches,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    return matches.map((match) {
      String hName = match.homeTeam;
      String hFlag = match.homeFlag;
      String aName = match.awayTeam;
      String aFlag = match.awayFlag;

      // Verifica se o time da casa sofreu alguma troca no passado
      final savedHomeName = prefs.getString('swap_name_$hName');
      final savedHomeFlag = prefs.getString('swap_flag_$hName');
      if (savedHomeName != null && savedHomeFlag != null) {
        hName = savedHomeName;
        hFlag = savedHomeFlag;
      }

      // Verifica se o time de fora sofreu alguma troca no passado
      final savedAwayName = prefs.getString('swap_name_$aName');
      final savedAwayFlag = prefs.getString('swap_flag_$aName');
      if (savedAwayName != null && savedAwayFlag != null) {
        aName = savedAwayName;
        aFlag = savedAwayFlag;
      }

      // Se descobrimos que algum dos times mudou, aplicamos a cópia com os novos dados
      if (hName != match.homeTeam || aName != match.awayTeam) {
        return match.copyWith(
          homeTeam: hName,
          homeFlag: hFlag,
          awayTeam: aName,
          awayFlag: aFlag,
        );
      }

      // Se não houver troca registrada para esses times, devolve o jogo normal
      return match;
    }).toList();
  }
}
