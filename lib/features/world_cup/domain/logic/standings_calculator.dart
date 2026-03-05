import '../entities/match_entity.dart';
import '../entities/team_standing.dart';

class StandingsCalculator {
  static Map<String, List<TeamStanding>> calculate(List<MatchEntity> matches) {
    final Map<String, Map<String, TeamStanding>> tempGroups = {};

    for (var match in matches) {
      // Cria o grupo se não existir
      tempGroups.putIfAbsent(match.group, () => {});
      var groupMap = tempGroups[match.group]!;

      // Registra os times (mesmo se ainda não jogaram)
      groupMap.putIfAbsent(
        match.homeTeam,
        () => TeamStanding(teamName: match.homeTeam, flag: match.homeFlag),
      );
      groupMap.putIfAbsent(
        match.awayTeam,
        () => TeamStanding(teamName: match.awayTeam, flag: match.awayFlag),
      );

      int? homeScore = match.userHomePrediction ?? match.homeScore;
      int? awayScore = match.userAwayPrediction ?? match.awayScore;

      // Se não tem placar, o time fica com 0 pontos (aguardando simulação)
      if (homeScore == null || awayScore == null) continue;

      final home = groupMap[match.homeTeam]!;
      final away = groupMap[match.awayTeam]!;

      home.played++;
      away.played++;

      home.goalsFor += homeScore;
      home.goalsAgainst += awayScore;
      away.goalsFor += awayScore;
      away.goalsAgainst += homeScore;

      if (homeScore > awayScore) {
        home.points += 3;
        home.won++;
        away.lost++;
      } else if (awayScore > homeScore) {
        away.points += 3;
        away.won++;
        home.lost++;
      } else {
        home.points += 1;
        away.points += 1;
        home.drawn++;
        away.drawn++;
      }
    }

    final Map<String, List<TeamStanding>> finalStandings = {};

    tempGroups.forEach((groupName, teamsMap) {
      final List<TeamStanding> teamList = teamsMap.values.toList();

      teamList.sort((a, b) {
        if (b.points != a.points) return b.points.compareTo(a.points);
        if (b.goalDifference != a.goalDifference)
          return b.goalDifference.compareTo(a.goalDifference);
        return b.goalsFor.compareTo(a.goalsFor);
      });

      finalStandings[groupName] = teamList;
    });

    return finalStandings;
  }
}
