import '../entities/match_entity.dart';
import '../entities/team_standing.dart';
import 'standings_calculator.dart';

class BracketCalculator {
  static List<MatchEntity> populate(List<MatchEntity> allMatches) {
    // =========================================================================
    // FIX 1: Filtra APENAS jogos da fase de grupos antes de calcular standings.
    //
    // ANTES: StandingsCalculator.calculate(allMatches) processava todos os
    // jogos, inclusive r32/r16/qf/sf/final. Isso criava grupos fantasmas
    // ('R32', 'R16'...) na tabela, corrompendo getGroupOfTeam() e allThirds.
    //
    // AGORA: Só jogos cujo group começa com 'GRUPO' são considerados.
    // =========================================================================

    final groupStageMatches = allMatches
        .where((m) => m.group.startsWith('GRUPO'))
        .toList();

    final groups = StandingsCalculator.calculate(groupStageMatches);

    final Map<String, MatchEntity> matchMap = {
      for (var m in allMatches) m.id: m,
    };

    // =========================================================================
    // EFEITO CASCATA: Limpa a chave se os times mudarem ou não estiverem definidos
    // =========================================================================
    void setMatchTeams(String matchId, TeamStanding? home, TeamStanding? away) {
      if (!matchMap.containsKey(matchId)) return; // Proteção extra

      final match = matchMap[matchId]!;

      final newHome = home?.teamName ?? "A Definir";
      final newAway = away?.teamName ?? "A Definir";

      int? newHomePred = match.userHomePrediction;
      int? newAwayPred = match.userAwayPrediction;

      // Zera o placar se um time sair da chave ou for "A Definir"
      if (newHome == "A Definir" ||
          newAway == "A Definir" ||
          match.homeTeam != newHome ||
          match.awayTeam != newAway) {
        newHomePred = null;
        newAwayPred = null;
      }

      matchMap[matchId] = MatchEntity(
        id: match.id,
        homeTeam: newHome,
        homeFlag:
            home?.flag ??
            "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/Placeholder_no_text.svg/150px-Placeholder_no_text.svg.png",
        awayTeam: newAway,
        awayFlag:
            away?.flag ??
            "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/Placeholder_no_text.svg/150px-Placeholder_no_text.svg.png",
        date: match.date,
        stadium: match.stadium,
        country: match.country,
        location: match.location,
        group: match.group,
        status: match.status,
        homeScore: match.homeScore,
        awayScore: match.awayScore,
        userHomePrediction: newHomePred,
        userAwayPrediction: newAwayPred,
      );
    }

    // =========================================================================
    // O MOTOR DO MATA-MATA (Com travas de empate e chave incompleta)
    // =========================================================================
    TeamStanding? getWinner(String matchId) {
      if (!matchMap.containsKey(matchId)) return null;
      final match = matchMap[matchId]!;

      // Trava 1: Se a chave não tem os dois times, ninguém avança
      if (match.homeTeam == "A Definir" || match.awayTeam == "A Definir") {
        return null;
      }

      // Trava 2: Verifica se há palpite
      if (match.userHomePrediction == null ||
          match.userAwayPrediction == null) {
        return null;
      }

      // Trava 3: Desempate obrigatório
      if (match.userHomePrediction! > match.userAwayPrediction!) {
        return TeamStanding(teamName: match.homeTeam, flag: match.homeFlag);
      } else if (match.userAwayPrediction! > match.userHomePrediction!) {
        return TeamStanding(teamName: match.awayTeam, flag: match.awayFlag);
      } else {
        return null; // Empate: trava a tela até o usuário dar a vitória a um lado
      }
    }

    // =========================================================================
    // BUSCA DE TIMES DOS GRUPOS (Blindado contra Listas Vazias)
    // =========================================================================
    TeamStanding? getTeam(String groupName, int position) {
      final groupTeams = groups[groupName];

      // GARANTIA MÁXIMA: Só tenta pegar o time se a lista existir e for grande o suficiente
      if (groupTeams != null && groupTeams.length > position) {
        final team = groupTeams[position];

        if (team.played > 0) {
          return team;
        }
      }
      return null;
    }

    // =========================================================================
    // LÓGICA DE CLASSIFICAÇÃO DOS 8 MELHORES TERCEIROS COLOCADOS
    // =========================================================================
    List<TeamStanding> allThirds = [];

    // Usando `for` clássico para evitar o erro de `anonymous closure` do seu print
    for (var entry in groups.entries) {
      final teams = entry.value;

      // Só tenta pegar o 3º lugar se o grupo de fato tiver 3 ou mais times
      if (teams.length >= 3) {
        final thirdPlace = teams[2];

        if (thirdPlace.played > 0) {
          allThirds.add(thirdPlace);
        }
      }
    }

    // Ordena por Pontos > Saldo > Gols
    allThirds.sort((a, b) {
      if (b.points != a.points) return b.points.compareTo(a.points);
      if (b.goalDifference != a.goalDifference) {
        return b.goalDifference.compareTo(a.goalDifference);
      }
      return b.goalsFor.compareTo(a.goalsFor);
    });

    List<TeamStanding> best8 = allThirds.take(8).toList();

    String getGroupOfTeam(TeamStanding team) {
      for (var entry in groups.entries) {
        if (entry.value.any((t) => t.teamName == team.teamName)) {
          return entry.key;
        }
      }
      return '';
    }

    TeamStanding? getBestThird(List<String> allowedGroups) {
      if (best8.isEmpty) return null; // Proteção extra

      for (int i = 0; i < best8.length; i++) {
        final group = getGroupOfTeam(best8[i]);
        if (allowedGroups.contains(group)) {
          return best8.removeAt(i);
        }
      }

      if (best8.isNotEmpty) return best8.removeAt(0);
      return null;
    }

    // =========================================================================
    // 1. ROUND OF 32 (Cruzamentos Oficiais FIFA 2026)
    // =========================================================================

    // Lado Esquerdo
    setMatchTeams('r32_1', getTeam('GRUPO A', 1), getTeam('GRUPO B', 1));
    setMatchTeams('r32_2', getTeam('GRUPO F', 0), getTeam('GRUPO C', 1));
    setMatchTeams(
      'r32_3',
      getTeam('GRUPO E', 0),
      getBestThird(['GRUPO A', 'GRUPO B', 'GRUPO C', 'GRUPO D', 'GRUPO F']),
    );
    setMatchTeams(
      'r32_4',
      getTeam('GRUPO I', 0),
      getBestThird(['GRUPO C', 'GRUPO D', 'GRUPO F', 'GRUPO G', 'GRUPO H']),
    );
    setMatchTeams(
      'r32_5',
      getTeam('GRUPO D', 0),
      getBestThird(['GRUPO B', 'GRUPO E', 'GRUPO F', 'GRUPO I', 'GRUPO J']),
    );
    setMatchTeams(
      'r32_6',
      getTeam('GRUPO G', 0),
      getBestThird(['GRUPO A', 'GRUPO E', 'GRUPO H', 'GRUPO I', 'GRUPO J']),
    );
    setMatchTeams('r32_7', getTeam('GRUPO K', 1), getTeam('GRUPO L', 1));
    setMatchTeams('r32_8', getTeam('GRUPO H', 0), getTeam('GRUPO J', 1));

    // Lado Direito
    setMatchTeams('r32_9', getTeam('GRUPO C', 0), getTeam('GRUPO F', 1));
    setMatchTeams('r32_10', getTeam('GRUPO E', 1), getTeam('GRUPO I', 1));
    setMatchTeams(
      'r32_11',
      getTeam('GRUPO A', 0),
      getBestThird(['GRUPO C', 'GRUPO E', 'GRUPO F', 'GRUPO H', 'GRUPO I']),
    );
    setMatchTeams(
      'r32_12',
      getTeam('GRUPO L', 0),
      getBestThird(['GRUPO E', 'GRUPO H', 'GRUPO I', 'GRUPO J', 'GRUPO K']),
    );
    setMatchTeams(
      'r32_13',
      getTeam('GRUPO B', 0),
      getBestThird(['GRUPO E', 'GRUPO F', 'GRUPO G', 'GRUPO I', 'GRUPO J']),
    );
    setMatchTeams(
      'r32_14',
      getTeam('GRUPO K', 0),
      getBestThird(['GRUPO D', 'GRUPO E', 'GRUPO I', 'GRUPO J', 'GRUPO L']),
    );
    setMatchTeams('r32_15', getTeam('GRUPO J', 0), getTeam('GRUPO H', 1));
    setMatchTeams('r32_16', getTeam('GRUPO D', 1), getTeam('GRUPO G', 1));

    // =========================================================================
    // 2. OITAVAS DE FINAL
    // =========================================================================
    setMatchTeams('r16_1', getWinner('r32_1'), getWinner('r32_2'));
    setMatchTeams('r16_2', getWinner('r32_3'), getWinner('r32_4'));
    setMatchTeams('r16_3', getWinner('r32_5'), getWinner('r32_6'));
    setMatchTeams('r16_4', getWinner('r32_7'), getWinner('r32_8'));
    setMatchTeams('r16_5', getWinner('r32_9'), getWinner('r32_10'));
    setMatchTeams('r16_6', getWinner('r32_11'), getWinner('r32_12'));
    setMatchTeams('r16_7', getWinner('r32_13'), getWinner('r32_14'));
    setMatchTeams('r16_8', getWinner('r32_15'), getWinner('r32_16'));

    // =========================================================================
    // 3. QUARTAS DE FINAL
    // =========================================================================
    setMatchTeams('qf_1', getWinner('r16_1'), getWinner('r16_2'));
    setMatchTeams('qf_2', getWinner('r16_3'), getWinner('r16_4'));
    setMatchTeams('qf_3', getWinner('r16_5'), getWinner('r16_6'));
    setMatchTeams('qf_4', getWinner('r16_7'), getWinner('r16_8'));

    // =========================================================================
    // 4. SEMIFINAL
    // =========================================================================
    setMatchTeams('sf_1', getWinner('qf_1'), getWinner('qf_2'));
    setMatchTeams('sf_2', getWinner('qf_3'), getWinner('qf_4'));

    // =========================================================================
    // 5. FINAL
    // =========================================================================
    setMatchTeams('final_1', getWinner('sf_1'), getWinner('sf_2'));

    return matchMap.values.toList();
  }
}
