import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/repositories/world_cup_repository.dart';
import '../../domain/usecases/get_matches_usecase.dart';
import '../../../../core/utils/local_storage_service.dart';
import '../../domain/logic/bracket_calculator.dart';
import 'world_cup_event.dart';
import 'world_cup_state.dart';

class WorldCupBloc extends Bloc<WorldCupEvent, WorldCupState> {
  final GetMatchesUseCase getMatchesUseCase;
  final WorldCupRepository repository;

  WorldCupBloc({required this.getMatchesUseCase, required this.repository})
    : super(const WorldCupState()) {
    // 1. CARREGAR JOGOS (Quando o app abre)
    on<LoadMatchesEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      // 1. Pega os jogos limpos (sem placar) do Firebase
      final matchesFromFirebase = await getMatchesUseCase();

      // 2. A MÁGICA: Puxa do disco do celular todos os placares que o usuário já tinha digitado
      final restoredMatches = await LocalStorageService.restorePredictions(
        matchesFromFirebase,
      );

      // 3. Roda o calculador para montar as chaves com os dados restaurados
      final calculatedMatches = BracketCalculator.populate(restoredMatches);

      emit(state.copyWith(isLoading: false, matches: calculatedMatches));
    });

    // 2. SALVAR PALPITE
    on<SavePredictionEvent>((event, emit) async {
      // 1. A MÁGICA: Salva o placar (ou apaga) no disco do celular
      await LocalStorageService.savePrediction(
        event.matchId,
        event.homeScore,
        event.awayScore,
      );

      final currentMatches = state.matches;

      // 1. Atualiza o placar do jogo de forma 100% blindada
      final updatedList = currentMatches.map((match) {
        if (match.id == event.matchId) {
          // Em vez de usar "copyWith", nós recriamos a entidade inteira.
          // Assim, se a vassoura mandar 'null', o sistema engole o 'null'
          // e apaga o placar definitivamente, sem questionar!
          return MatchEntity(
            id: match.id,
            homeTeam: match.homeTeam,
            homeFlag: match.homeFlag,
            awayTeam: match.awayTeam,
            awayFlag: match.awayFlag,
            date: match.date,
            stadium: match.stadium,
            country: match.country,
            location: match.location,
            group: match.group,
            status: match.status,
            homeScore: match.homeScore,
            awayScore: match.awayScore,
            // Passamos EXATAMENTE o que veio do evento (número ou null)
            userHomePrediction: event.homeScore,
            userAwayPrediction: event.awayScore,
          );
        }
        return match;
      }).toList();

      // 3. Recalcula o mata-mata
      final matchesWithBrackets = BracketCalculator.populate(updatedList);

      emit(
        state.copyWith(
          matches: matchesWithBrackets,
          successMessage: event.homeScore == null
              ? "Placar apagado!"
              : "Palpite salvo! 🏆",
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
