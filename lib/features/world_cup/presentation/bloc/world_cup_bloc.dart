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
    // ==========================================================
    // 1. CARREGAR JOGOS (Quando o app abre)
    // ==========================================================
    on<LoadMatchesEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final matchesFromFirebase = await getMatchesUseCase();

      // 1. Restaurar as trocas de seleções da repescagem (Novo)
      final matchesWithSwaps = await LocalStorageService.restoreSwaps(
        matchesFromFirebase,
      );

      // 2. Restaurar palpites
      final restoredMatches = await LocalStorageService.restorePredictions(
        matchesWithSwaps,
      );

      final calculatedMatches = BracketCalculator.populate(restoredMatches);
      emit(state.copyWith(isLoading: false, matches: calculatedMatches));
    });

    // ==========================================================
    // 2. SALVAR PALPITE (Faltava este bloco no seu código)
    // ==========================================================
    on<SavePredictionEvent>((event, emit) async {
      // 1. Salva o placar (ou apaga) no disco do celular
      await LocalStorageService.savePrediction(
        event.matchId,
        event.homeScore,
        event.awayScore,
      );

      final currentMatches = state.matches;

      // 2. Atualiza o placar do jogo
      final updatedList = currentMatches.map((match) {
        if (match.id == event.matchId) {
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
            userHomePrediction: event.homeScore,
            userAwayPrediction: event.awayScore,
          );
        }
        return match;
      }).toList();

      // 3. Recalcula o mata-mata com os novos placares
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

    // ==========================================================
    // 3. TROCA DE TIMES DA REPESCAGEM (SWAP)
    // ==========================================================
    on<SwapTeamEvent>((event, emit) async {
      // 1. Persistir a troca localmente
      await LocalStorageService.saveTeamSwap(
        event.oldTeamName,
        event.newTeamName,
        event.newTeamFlag,
      );

      final swappedList = state.matches.map((match) {
        // Substitui em qualquer lugar que o placeholder apareça
        String hName = match.homeTeam == event.oldTeamName
            ? event.newTeamName
            : match.homeTeam;
        String hFlag = match.homeTeam == event.oldTeamName
            ? event.newTeamFlag
            : match.homeFlag;
        String aName = match.awayTeam == event.oldTeamName
            ? event.newTeamName
            : match.awayTeam;
        String aFlag = match.awayTeam == event.oldTeamName
            ? event.newTeamFlag
            : match.awayFlag;

        return match.copyWith(
          homeTeam: hName,
          homeFlag: hFlag,
          awayTeam: aName,
          awayFlag: aFlag,
          // Ao trocar o time, limpamos o palpite para evitar bugs de lógica
          userHomePrediction:
              (match.homeTeam == event.oldTeamName ||
                  match.awayTeam == event.oldTeamName)
              ? null
              : match.userHomePrediction,
          userAwayPrediction:
              (match.homeTeam == event.oldTeamName ||
                  match.awayTeam == event.oldTeamName)
              ? null
              : match.userAwayPrediction,
        );
      }).toList();

      final finalCalculatedList = BracketCalculator.populate(swappedList);
      emit(
        state.copyWith(
          matches: finalCalculatedList,
          successMessage: "Seleção definida!",
        ),
      );
      emit(state.copyWith(successMessage: null));
    });
  }
}
