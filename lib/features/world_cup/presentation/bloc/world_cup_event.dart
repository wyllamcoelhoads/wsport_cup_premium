import 'package:equatable/equatable.dart';

abstract class WorldCupEvent extends Equatable {
  const WorldCupEvent();

  @override
  // AQUI ESTAVA O ERRO: O Pai agora ganha a interrogação (?) e aceita nulos
  List<Object?> get props => [];
}

// Evento 1: Tela abriu, carregue os jogos
class LoadMatchesEvent extends WorldCupEvent {}

// Evento 2: Usuário clicou em "Salvar" no diálogo
class SavePredictionEvent extends WorldCupEvent {
  final String matchId;
  final int? homeScore; // Pode ser nulo (Vassoura)
  final int? awayScore; // Pode ser nulo (Vassoura)

  const SavePredictionEvent({
    required this.matchId,
    this.homeScore,
    this.awayScore,
  });

  @override
  // O Filho ganha a interrogação (?)
  List<Object?> get props => [matchId, homeScore, awayScore];
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
