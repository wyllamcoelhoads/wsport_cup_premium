import '../entities/match_entity.dart';
import '../entities/team_standing.dart';
import 'standings_calculator.dart';

class BracketCalculator {
  static List<MatchEntity> populate(List<MatchEntity> allMatches) {
    final groups = StandingsCalculator.calculate(allMatches);

    final Map<String, MatchEntity> matchMap = {
      for (var m in allMatches) m.id: m,
    };

    // Atualiza a entidade de forma inteligente (Com efeito cascata)
    void setMatchTeams(String matchId, TeamStanding? home, TeamStanding? away) {
      if (matchMap.containsKey(matchId)) {
        final match = matchMap[matchId]!;

        final newHome = home?.teamName ?? "A Definir";
        final newAway = away?.teamName ?? "A Definir";

        int? newHomePred = match.userHomePrediction;
        int? newAwayPred = match.userAwayPrediction;

        // EFEITO CASCATA: Se os times mudaram (ex: Brasil virou "A Definir"),
        // apagamos o placar dessa chave também!
        if (match.homeTeam != newHome || match.awayTeam != newAway) {
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
    }

    // Pega o vencedor de um jogo do mata-mata
    TeamStanding? getWinner(String matchId) {
      if (!matchMap.containsKey(matchId)) return null;
      final match = matchMap[matchId]!;

      if (match.userHomePrediction == null || match.userAwayPrediction == null)
        return null;

      if (match.userHomePrediction! > match.userAwayPrediction!) {
        return TeamStanding(teamName: match.homeTeam, flag: match.homeFlag);
      } else if (match.userAwayPrediction! > match.userHomePrediction!) {
        return TeamStanding(teamName: match.awayTeam, flag: match.awayFlag);
      } else {
        // Empate simples: avança quem está em "casa" no layout
        return TeamStanding(teamName: match.homeTeam, flag: match.homeFlag);
      }
    }

    // Pega 1º ou 2º colocado de um grupo (mas SÓ se já tiver jogado)
    TeamStanding? getTeam(String groupName, int position) {
      if (groups.containsKey(groupName) &&
          groups[groupName]!.length > position) {
        final team = groups[groupName]![position];

        // A MÁGICA AQUI: O time só avança se tiver entrado em campo!
        if (team.played > 0) {
          return team;
        }
      }
      return null; // Retorna nulo, o que fará a tela mostrar "A Definir"
    }

    // =========================================================================
    // LÓGICA DE CLASSIFICAÇÃO DOS 8 MELHORES TERCEIROS COLOCADOS
    // =========================================================================
    List<TeamStanding> allThirds = [];
    groups.forEach((groupName, teams) {
      if (teams.length >= 3) {
        final thirdPlace = teams[2]; // Pega o 3º lugar (índice 2)

        // SÓ ENTRA NA REPESCAGEM DOS MELHORES 3ºs SE TIVER JOGADO
        if (thirdPlace.played > 0) {
          allThirds.add(thirdPlace);
        }
      }
    });

    // Ordena todos os terceiros por Pontos, depois Saldo, depois Gols
    allThirds.sort((a, b) {
      if (b.points != a.points) return b.points.compareTo(a.points);
      if (b.goalDifference != a.goalDifference)
        return b.goalDifference.compareTo(a.goalDifference);
      return b.goalsFor.compareTo(a.goalsFor);
    });

    // Filtra apenas os 8 melhores
    List<TeamStanding> best8 = allThirds.take(8).toList();

    // Função auxiliar para saber de qual grupo aquele terceiro lugar veio
    String getGroupOfTeam(TeamStanding team) {
      for (var entry in groups.entries) {
        if (entry.value.any((t) => t.teamName == team.teamName))
          return entry.key;
      }
      return '';
    }

    // Distribui os terceiros colocados conforme as chaves permitidas
    TeamStanding? getBestThird(List<String> allowedGroups) {
      for (int i = 0; i < best8.length; i++) {
        final group = getGroupOfTeam(best8[i]);
        if (allowedGroups.contains(group)) {
          return best8.removeAt(
            i,
          ); // Remove da lista para não ser usado duas vezes
        }
      }
      // Se não achar o encaixe perfeito, pega o próximo disponível para não travar o app
      if (best8.isNotEmpty) return best8.removeAt(0);
      return null;
    }

    // =========================================================================
    // 1. ROUND OF 32 (Cruzamentos Oficiais FIFA 2026)
    // =========================================================================

    // Lado Esquerdo do Chaveamento
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

    // Lado Direito do Chaveamento
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
