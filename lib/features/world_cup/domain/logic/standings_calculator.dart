import '../entities/match_entity.dart';
import '../entities/team_standing.dart';

class StandingsCalculator {
  
  /// Recebe uma lista de jogos e retorna um Map organizado por grupos.
  /// Ex: {"GROUP A": [Brasil, Sérvia...], "GROUP B": [...]}
  static Map<String, List<TeamStanding>> calculate(List<MatchEntity> matches) {
    final Map<String, Map<String, TeamStanding>> tempGroups = {};

    for (var match in matches) {
      // 1. Garante que o grupo e os times existam no mapa temporário
      tempGroups.putIfAbsent(match.group, () => {});
      
      var groupMap = tempGroups[match.group]!;
      
      groupMap.putIfAbsent(match.homeTeam, 
        () => TeamStanding(teamName: match.homeTeam, flag: match.homeFlag));
      groupMap.putIfAbsent(match.awayTeam, 
        () => TeamStanding(teamName: match.awayTeam, flag: match.awayFlag));

      // 2. Verifica se o jogo tem placar (Real ou Simulado)
      // Prioridade: Palpite do Usuário > Placar Real
      int? homeScore = match.userHomePrediction ?? match.homeScore;
      int? awayScore = match.userAwayPrediction ?? match.awayScore;

      // Se não tem placar nenhum, pula para o próximo jogo (não conta pontos)
      if (homeScore == null || awayScore == null) continue;

      // 3. Aplica a Matemática da FIFA
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

    // 4. Ordenação Final (Critérios de Desempate) e Conversão para Lista
    final Map<String, List<TeamStanding>> finalStandings = {};
    
    tempGroups.forEach((groupName, teamsMap) {
      final List<TeamStanding> teamList = teamsMap.values.toList();
      
      teamList.sort((a, b) {
        // 1º Critério: Pontos (Quem tem mais, fica em cima)
        if (b.points != a.points) return b.points.compareTo(a.points);
        
        // 2º Critério: Saldo de Gols
        if (b.goalDifference != a.goalDifference) return b.goalDifference.compareTo(a.goalDifference);
        
        // 3º Critério: Gols Pró (Ataque mais positivo)
        return b.goalsFor.compareTo(a.goalsFor);
      });

      finalStandings[groupName] = teamList;
    });

    return finalStandings;
  }
}