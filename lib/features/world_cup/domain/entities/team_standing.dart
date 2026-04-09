class TeamStanding {
  final String teamName;
  final String flag;
  int points;
  int played;
  int won;
  int drawn;
  int lost;
  int goalsFor;
  int goalsAgainst;
  int
  fairPlayPoints; // NOVO CAMPO: Pontos de Fair Play (ex: -1 por amarelo, -3 por vermelho)

  TeamStanding({
    required this.teamName,
    required this.flag,
    this.points = 0,
    this.played = 0,
    this.won = 0,
    this.drawn = 0,
    this.lost = 0,
    this.goalsFor = 0,
    this.goalsAgainst = 0,
    this.fairPlayPoints = 0,
  });

  // Getter inteligente para o Saldo de Gols
  int get goalDifference => goalsFor - goalsAgainst;
}
