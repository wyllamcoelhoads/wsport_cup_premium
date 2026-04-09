import 'package:equatable/equatable.dart';

abstract class WorldCupEvent extends Equatable {
  const WorldCupEvent();

  @override
  // O Pai ganha a interrogação (?) e aceita nulos
  List<Object?> get props => [];
}

// Evento 1: Tela abriu, carregue os jogos
class LoadMatchesEvent extends WorldCupEvent {}

// Evento 2: Usuário clicou em "Salvar" no diálogo
class SavePredictionEvent extends WorldCupEvent {
  final String matchId;
  final int? homeScore; // Pode ser nulo (Vassoura)
  final int? awayScore; // Pode ser nulo (Vassoura)

  // -- NOVAS VARIÁVEIS DE FAIR PLAY --
  final int? homeYellows;
  final int? homeDoubleYellows;
  final int? homeReds;

  final int? awayYellows;
  final int? awayDoubleYellows;
  final int? awayReds;

  const SavePredictionEvent({
    required this.matchId,
    this.homeScore,
    this.awayScore,
    this.homeYellows,
    this.homeDoubleYellows,
    this.homeReds,
    this.awayYellows,
    this.awayDoubleYellows,
    this.awayReds,
  });

  @override
  // O Filho ganha a interrogação (?) e lista todas as propriedades
  List<Object?> get props => [
    matchId,
    homeScore,
    awayScore,
    homeYellows,
    homeDoubleYellows,
    homeReds,
    awayYellows,
    awayDoubleYellows,
    awayReds,
  ];
}

// Evento 3: Troca de times
class SwapTeamEvent extends WorldCupEvent {
  final String oldTeamName;
  final String newTeamName;
  final String newTeamFlag;

  const SwapTeamEvent({
    required this.oldTeamName,
    required this.newTeamName,
    required this.newTeamFlag,
  });

  @override
  // Ganha a interrogação (?) para padronizar tudo
  List<Object?> get props => [oldTeamName, newTeamName, newTeamFlag];
}

// Evento 4: Resetar completamente os palpites
class ResetAllPredictionsEvent extends WorldCupEvent {}

// Evento 5: Gerar placares aleatórios para uma lista de jogos
class GenerateRandomScoresEvent extends WorldCupEvent {
  final List<String> matchIds;

  const GenerateRandomScoresEvent({required this.matchIds});

  @override
  List<Object?> get props => [matchIds];
}
