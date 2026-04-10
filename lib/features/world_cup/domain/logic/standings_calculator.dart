import 'package:flutter/foundation.dart';

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

      // Se não tem placar de gols, o time fica com 0 pontos e ignoramos o resto do cálculo
      if (homeScore == null || awayScore == null) continue;

      final home = groupMap[match.homeTeam]!;
      final away = groupMap[match.awayTeam]!;

      // ── 1. CÁLCULO BÁSICO (JOGOS E GOLS) ──
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

      // ── 2. CÁLCULO DE FAIR PLAY DA FIFA ──
      // Multiplica a quantidade de cada cartão pelo seu peso negativo.
      int homeFairPlay =
          ((match.userHomeYellows ?? 0) * -1) +
          ((match.userHomeDoubleYellows ?? 0) * -3) +
          ((match.userHomeReds ?? 0) * -4);

      int awayFairPlay =
          ((match.userAwayYellows ?? 0) * -1) +
          ((match.userAwayDoubleYellows ?? 0) * -3) +
          ((match.userAwayReds ?? 0) * -4);

      home.fairPlayPoints += homeFairPlay;
      away.fairPlayPoints += awayFairPlay;

      // 📄 NOVO: Contar cartões por time
      home.totalYellows += (match.userHomeYellows ?? 0);
      home.totalDoubleYellows += (match.userHomeDoubleYellows ?? 0);
      home.totalReds += (match.userHomeReds ?? 0);

      away.totalYellows += (match.userAwayYellows ?? 0);
      away.totalDoubleYellows += (match.userAwayDoubleYellows ?? 0);
      away.totalReds += (match.userAwayReds ?? 0);
    }

    final Map<String, List<TeamStanding>> finalStandings = {};

    tempGroups.forEach((groupName, teamsMap) {
      final List<TeamStanding> teamList = teamsMap.values.toList();

      teamList.sort((a, b) {
        // Critério 1: Total de Pontos (maior primeiro)
        if (a.points != b.points) {
          return b.points.compareTo(a.points);
        }

        // Critério 2: Saldo de Gols (maior primeiro)
        if (a.goalDifference != b.goalDifference) {
          return b.goalDifference.compareTo(a.goalDifference);
        }

        // Critério 3: Gols Marcados (maior primeiro)
        if (a.goalsFor != b.goalsFor) {
          return b.goalsFor.compareTo(a.goalsFor);
        }

        // Critério 4: Fair Play - Cartões VERMELHOS (MENOR primeiro)
        if (a.totalReds != b.totalReds) {
          return a.totalReds.compareTo(b.totalReds);
        }

        // Critério 5: Fair Play - Cartões AMARELOS (MENOR primeiro)
        if (a.totalYellows != b.totalYellows) {
          return a.totalYellows.compareTo(b.totalYellows);
        }

        // Critério 6: Fair Play - Duplos AMARELOS (MENOR primeiro)
        if (a.totalDoubleYellows != b.totalDoubleYellows) {
          return a.totalDoubleYellows.compareTo(b.totalDoubleYellows);
        }

        // Critério Final: Ordem alfabética (estabilidade)
        return a.teamName.compareTo(b.teamName);
      });

      // 🔍 DEBUG: Verificar cartões
      for (final team in teamList) {
        debugPrint(
          '[$groupName] ${team.teamName}: P=${team.points} SG=${team.goalDifference} '
          'V=${team.totalReds} 🟨=${team.totalYellows} 🟨🟨=${team.totalDoubleYellows}',
        );
      }

      finalStandings[groupName] = teamList;
    });

    return finalStandings;
  }
}
