import 'package:flutter_bloc/flutter_bloc.dart';
//import '../../domain/entities/match_entity.dart';
import '../../domain/repositories/world_cup_repository.dart';
import '../../domain/usecases/get_matches_usecase.dart';
// Importe o seu calculador aqui!
import '../../domain/logic/bracket_calculator.dart';
import 'world_cup_event.dart';
import 'world_cup_state.dart';

class WorldCupBloc extends Bloc<WorldCupEvent, WorldCupState> {
  final GetMatchesUseCase getMatchesUseCase;
  final WorldCupRepository repository;

  WorldCupBloc({required this.getMatchesUseCase, required this.repository})
    : super(const WorldCupState()) {
    // 1. CARREGAR JOGOS
    on<LoadMatchesEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final matches = await getMatchesUseCase();

      // Sempre rodar o calculador ao carregar para garantir que o mata-mata monte
      final calculatedMatches = BracketCalculator.populate(matches);

      emit(state.copyWith(isLoading: false, matches: calculatedMatches));
    });

    // 2. SALVAR PALPITE (AQUI ESTAVA O ERRO)
    on<SavePredictionEvent>((event, emit) async {
      // Salva no banco/memória
      await repository.savePrediction(
        event.matchId,
        event.homeScore,
        event.awayScore,
      );

      // Busca a lista atualizada do banco
      final updatedMatches = await getMatchesUseCase();

      // === NOVIDADE: Roda o calculador para processar os novos vencedores ===
      final matchesWithBrackets = BracketCalculator.populate(updatedMatches);

      emit(
        state.copyWith(
          matches: matchesWithBrackets, // Emite a lista calculada
          successMessage: "Palpite salvo com sucesso! 🏆",
        ),
      );

      emit(state.copyWith(successMessage: null));
    });

    // 3. TROCA DE TIMES (SWAP)
    on<SwapTeamEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final swappedList = state.matches.map((match) {
        if (match.homeTeam == event.oldTeamName) {
          return match.copyWith(
            homeTeam: event.newTeamName,
            homeFlag: event.newTeamFlag,
            userHomePrediction: null,
            userAwayPrediction: null,
          );
        } else if (match.awayTeam == event.oldTeamName) {
          return match.copyWith(
            awayTeam: event.newTeamName,
            awayFlag: event.newTeamFlag,
            userHomePrediction: null,
            userAwayPrediction: null,
          );
        }
        return match;
      }).toList();

      // === NOVIDADE: Roda o calculador aqui também após a troca ===
      final finalCalculatedList = BracketCalculator.populate(swappedList);

      emit(
        state.copyWith(
          matches: finalCalculatedList,
          isLoading: false,
          successMessage:
              "Troca realizada: ${event.oldTeamName} ➔ ${event.newTeamName}",
        ),
      );

      emit(state.copyWith(successMessage: null));
    });
  }
}
