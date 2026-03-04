import '../entities/match_entity.dart';
import '../entities/team_standing.dart';
import 'standings_calculator.dart';

class BracketCalculator {
  static List<MatchEntity> populate(List<MatchEntity> allMatches) {
    final groups = StandingsCalculator.calculate(allMatches);

    final Map<String, MatchEntity> matchMap = {
      for (var m in allMatches) m.id: m,
    };

    void setMatchTeams(String matchId, TeamStanding? home, TeamStanding? away) {
      if (matchMap.containsKey(matchId) && home != null && away != null) {
        final match = matchMap[matchId]!;
        matchMap[matchId] = MatchEntity(
          id: match.id,
          homeTeam: home.teamName,
          homeFlag: home.flag,
          awayTeam: away.teamName,
          awayFlag: away.flag,
          date: match.date,
          stadium: match.stadium,
          country: match.country,
          location: match.location,
          group: match.group,
          status: match.status,
          userHomePrediction: match.userHomePrediction,
          userAwayPrediction: match.userAwayPrediction,
        );
      }
    }

    TeamStanding? getWinner(String matchId) {
      if (!matchMap.containsKey(matchId)) return null;
      final match = matchMap[matchId]!;

      if (match.userHomePrediction == null ||
          match.userAwayPrediction == null) {
        return null;
      }

      if (match.userHomePrediction! > match.userAwayPrediction!) {
        return TeamStanding(teamName: match.homeTeam, flag: match.homeFlag);
      } else if (match.userAwayPrediction! > match.userHomePrediction!) {
        return TeamStanding(teamName: match.awayTeam, flag: match.awayFlag);
      } else {
        // Empate: No mata-mata real haveria pênaltis.
        // Aqui passamos o "Home" como critério de desempate simples.
        return TeamStanding(teamName: match.homeTeam, flag: match.homeFlag);
      }
    }

    // =========================================================================
    // 1. ROUND OF 32 (Cruzamentos Oficiais Simplificados)
    // =========================================================================

    // Cruzando 1ºs e 2ºs conforme o regulamento de 48 times
    setMatchTeams(
      'r32_1',
      _getTeam(groups, 'GROUP A', 0),
      _getTeam(groups, 'GROUP C', 1),
    );
    setMatchTeams(
      'r32_2',
      _getTeam(groups, 'GROUP B', 0),
      _getTeam(groups, 'GROUP D', 1),
    );
    setMatchTeams(
      'r32_3',
      _getTeam(groups, 'GROUP C', 0),
      _getTeam(groups, 'GROUP E', 1),
    );
    setMatchTeams(
      'r32_4',
      _getTeam(groups, 'GROUP D', 0),
      _getTeam(groups, 'GROUP F', 1),
    );
    setMatchTeams(
      'r32_5',
      _getTeam(groups, 'GROUP E', 0),
      _getTeam(groups, 'GROUP G', 1),
    );
    setMatchTeams(
      'r32_6',
      _getTeam(groups, 'GROUP F', 0),
      _getTeam(groups, 'GROUP H', 1),
    );
    setMatchTeams(
      'r32_7',
      _getTeam(groups, 'GROUP G', 0),
      _getTeam(groups, 'GROUP I', 1),
    );
    setMatchTeams(
      'r32_8',
      _getTeam(groups, 'GROUP H', 0),
      _getTeam(groups, 'GROUP J', 1),
    );
    setMatchTeams(
      'r32_9',
      _getTeam(groups, 'GROUP I', 0),
      _getTeam(groups, 'GROUP K', 1),
    );
    setMatchTeams(
      'r32_10',
      _getTeam(groups, 'GROUP J', 0),
      _getTeam(groups, 'GROUP L', 1),
    );
    setMatchTeams(
      'r32_11',
      _getTeam(groups, 'GROUP K', 0),
      _getTeam(groups, 'GROUP A', 1),
    );
    setMatchTeams(
      'r32_12',
      _getTeam(groups, 'GROUP L', 0),
      _getTeam(groups, 'GROUP B', 1),
    );

    // Exemplo de cruzamento para contemplar 16 jogos (incluindo alguns 3ºs lugares se necessário)
    setMatchTeams(
      'r32_13',
      _getTeam(groups, 'GROUP A', 1),
      _getTeam(groups, 'GROUP B', 1),
    );
    setMatchTeams(
      'r32_14',
      _getTeam(groups, 'GROUP C', 1),
      _getTeam(groups, 'GROUP D', 1),
    );
    setMatchTeams(
      'r32_15',
      _getTeam(groups, 'GROUP E', 1),
      _getTeam(groups, 'GROUP F', 1),
    );
    setMatchTeams(
      'r32_16',
      _getTeam(groups, 'GROUP G', 1),
      _getTeam(groups, 'GROUP H', 1),
    );

    // =========================================================================
    // 2. OITAVAS DE FINAL (R16)
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
    // 3. QUARTAS DE FINAL (QF)
    // =========================================================================
    setMatchTeams('qf_1', getWinner('r16_1'), getWinner('r16_2'));
    setMatchTeams('qf_2', getWinner('r16_3'), getWinner('r16_4'));
    setMatchTeams('qf_3', getWinner('r16_5'), getWinner('r16_6'));
    setMatchTeams('qf_4', getWinner('r16_7'), getWinner('r16_8'));

    // =========================================================================
    // 4. SEMIFINAL (SF)
    // =========================================================================
    setMatchTeams('sf_1', getWinner('qf_1'), getWinner('qf_2'));
    setMatchTeams('sf_2', getWinner('qf_3'), getWinner('qf_4'));

    // =========================================================================
    // 5. FINAL
    // =========================================================================
    setMatchTeams('final', getWinner('sf_1'), getWinner('sf_2'));

    return matchMap.values.toList();
  }

  static TeamStanding? _getTeam(
    Map<String, List<TeamStanding>> groups,
    String groupName,
    int index,
  ) {
    if (groups.containsKey(groupName) && groups[groupName]!.length > index) {
      return groups[groupName]![index];
    }
    return null;
  }
}
