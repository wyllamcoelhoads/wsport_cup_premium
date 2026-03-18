import 'package:equatable/equatable.dart';

class MatchEntity extends Equatable {
  final String id;
  // Times
  final String homeTeam;
  final String homeFlag;
  final String awayTeam;
  final String awayFlag;
  // Detalhes
  final DateTime date;
  final String stadium;
  final String country;
  final String location; // Ex: "Mexico City"
  final String group; // Ex: "Group G"
  final String status; // Ex: "Scheduled", "Finished"
  // Placar Real
  final int? homeScore;
  final int? awayScore;
  // Simulação do Usuário (Local)
  final int? userHomePrediction;
  final int? userAwayPrediction;

  const MatchEntity({
    required this.id,
    required this.homeTeam,
    required this.homeFlag,
    required this.awayTeam,
    required this.awayFlag,
    required this.date,
    required this.stadium,
    required this.country,
    required this.location,
    required this.group,
    required this.status,
    this.homeScore,
    this.awayScore,
    this.userHomePrediction,
    this.userAwayPrediction,
  });

  // Adicione este método dentro da classe MatchEntity
  // Método para limpar palpites de forma segura
  MatchEntity clearPredictions() {
    return MatchEntity(
      id: id,
      homeTeam: homeTeam,
      homeFlag: homeFlag,
      awayTeam: awayTeam,
      awayFlag: awayFlag,
      date: date,
      stadium: stadium,
      country: country,
      location: location,
      group: group,
      status: status,
      homeScore: homeScore,
      awayScore: awayScore,

      // O SEGREDO: Forçamos os palpites a ficarem nulos direto na raiz
      userHomePrediction: null,
      userAwayPrediction: null,
    );
  }

  bool get isKnockout {
    // Se não começar com "GROUP" ou "Grupo", é mata-mata
    return !group.toUpperCase().startsWith(
      'GRUP',
    ); // Cobre "GROUP" e "Grupo" (português)
  }

  // ==========================================
  // O SEGREDO: TRADUTOR DE NOMES PARA A UI
  // ==========================================
  String get friendlyGroupName {
    switch (group) {
      case 'R32':
        return '32-Avos de Final';
      case 'R16':
        return 'Oitavas de Final';
      case 'QF':
        return 'Quartas de Final';
      case 'SF':
        return 'Semifinal';
      case 'FINAL':
        return 'Final';
      default:
        return group; // Se for "GRUPO A", ele simplesmente retorna "GRUPO A"
    }
  }

  // ADICIONE ESTE MÉTODO:
  MatchEntity copyWith({
    String? id,
    String? homeTeam,
    String? homeFlag,
    String? awayTeam,
    String? awayFlag,
    String? group,
    String? country,
    String? location,
    int? userHomePrediction,
    int? userAwayPrediction,
  }) {
    return MatchEntity(
      id: id ?? this.id,
      homeTeam: homeTeam ?? this.homeTeam,
      homeFlag: homeFlag ?? this.homeFlag,
      awayTeam: awayTeam ?? this.awayTeam,
      awayFlag: awayFlag ?? this.awayFlag,
      date: date, // Data e estádio não mudam no copyWith
      stadium: stadium,
      country: country ?? this.country,
      location: location ?? this.location,
      group: group ?? this.group,
      status: status, // Status também permanece o mesmo
      homeScore: homeScore, // Placar real não é alterado aqui
      awayScore: awayScore,
      userHomePrediction: userHomePrediction ?? this.userHomePrediction,
      userAwayPrediction: userAwayPrediction ?? this.userAwayPrediction,
    );
  }

  @override
  List<Object?> get props => [
    id,
    homeTeam,
    awayTeam,
    userHomePrediction,
    userAwayPrediction,
    status,
    country,
    location,
  ];
}
