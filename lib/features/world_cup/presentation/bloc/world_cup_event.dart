import 'package:equatable/equatable.dart';

abstract class WorldCupEvent extends Equatable {
  const WorldCupEvent();

  @override
  List<Object> get props => [];
}

// Evento 1: Tela abriu, carregue os jogos
class LoadMatchesEvent extends WorldCupEvent {}

// Evento 2: Usuário clicou em "Salvar" no diálogo
class SavePredictionEvent extends WorldCupEvent {
  final String matchId;
  final int homeScore;
  final int awayScore;

  const SavePredictionEvent({
    required this.matchId,
    required this.homeScore,
    required this.awayScore,
  });

  @override
  List<Object> get props => [matchId, homeScore, awayScore];
}

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
  List<Object> get props => [oldTeamName, newTeamName, newTeamFlag];
}