import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/repositories/world_cup_repository.dart';
import '../../domain/usecases/get_matches_usecase.dart';
import '../../../../core/utils/local_storage_service.dart';
import '../../domain/logic/bracket_calculator.dart';
import '../bloc/world_cup_event.dart';
import '../bloc/world_cup_state.dart';

class WorldCupBloc extends Bloc<WorldCupEvent, WorldCupState> {
  final GetMatchesUseCase getMatchesUseCase;
  final WorldCupRepository repository;

  WorldCupBloc({required this.getMatchesUseCase, required this.repository})
    : super(const WorldCupState()) {
    // ==========================================================
    // 1. CARREGAR JOGOS
    // ==========================================================
    on<LoadMatchesEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final matchesFromFirebase = await getMatchesUseCase();
      final matchesWithSwaps = await LocalStorageService.restoreSwaps(
        matchesFromFirebase,
      );
      final restoredMatches = await LocalStorageService.restorePredictions(
        matchesWithSwaps,
      );
      final calculatedMatches = BracketCalculator.populate(restoredMatches);
      emit(state.copyWith(isLoading: false, matches: calculatedMatches));
    });

    // ==========================================================
    // 2. SALVAR PALPITE
    // ==========================================================
    on<SavePredictionEvent>((event, emit) async {
      await LocalStorageService.savePrediction(
        event.matchId,
        event.homeScore,
        event.awayScore,
      );

      final currentMatches = state.matches;
      final updatedList = currentMatches.map((match) {
        if (match.id == event.matchId) {
          return match.copyWith(
            userHomePrediction: event.homeScore,
            userAwayPrediction: event.awayScore,
          );
        }
        return match;
      }).toList();

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
      await LocalStorageService.saveTeamSwap(
        event.oldTeamName,
        event.newTeamName,
        event.newTeamFlag,
      );

      final swappedList = state.matches.map((match) {
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

    // ==========================================================
    // 4. RESETAR TODOS OS PALPITES (AGORA NO LUGAR CERTO!)
    // ==========================================================
    on<ResetAllPredictionsEvent>((event, emit) async {
      await LocalStorageService.clearAllPredictions();

      final clearedMatches = state.matches.map((match) {
        return match.copyWith(
          userHomePrediction: null,
          userAwayPrediction: null,
        );
      }).toList();

      final recalculatedMatches = BracketCalculator.populate(clearedMatches);

      emit(
        state.copyWith(
          matches: recalculatedMatches,
          successMessage: "Todos os palpites foram resetados! 🧹",
        ),
      );
      emit(state.copyWith(successMessage: null));
    });
  }
}
