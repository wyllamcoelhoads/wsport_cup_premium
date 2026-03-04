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
