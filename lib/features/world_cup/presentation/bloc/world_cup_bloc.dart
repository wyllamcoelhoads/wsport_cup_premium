import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/world_cup_repository.dart';
import '../../domain/usecases/get_matches_usecase.dart';
import '../../../../core/utils/local_storage_service.dart';
import '../../domain/logic/bracket_calculator.dart';
import '../bloc/world_cup_event.dart';
import '../bloc/world_cup_state.dart';
import 'dart:math';
import 'dart:io';

class WorldCupBloc extends Bloc<WorldCupEvent, WorldCupState> {
  final GetMatchesUseCase getMatchesUseCase;
  final WorldCupRepository repository;

  /// ✅ CORREÇÃO: Função movida para fora do construtor (corrige memory leak)
  /// Verifica conectividade com internet
  static Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  WorldCupBloc({required this.getMatchesUseCase, required this.repository})
    : super(const WorldCupState()) {
    // ==========================================================
    // 1. CARREGAR JOGOS
    // ==========================================================
    on<LoadMatchesEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, clearError: true));
      try {
        final matchesFromFirebase = await getMatchesUseCase();

        // Se a lista vier vazia, o Firebase não tem cache. Vamos validar a internet!
        if (matchesFromFirebase.isEmpty) {
          bool isConnected = await hasInternet();
          if (!isConnected) {
            emit(
              state.copyWith(
                isLoading: false,
                errorMessage: "Sem conexão com a internet.",
              ),
            );
            return; // Para a execução aqui
          }
        }

        final matchesWithSwaps = await LocalStorageService.restoreSwaps(
          matchesFromFirebase,
        );
        final restoredMatches = await LocalStorageService.restorePredictions(
          matchesWithSwaps,
        );
        final calculatedMatches = BracketCalculator.populate(restoredMatches);

        emit(state.copyWith(isLoading: false, matches: calculatedMatches));
      } catch (e) {
        // Se o Firebase estourar um erro direto, checamos a rede
        bool isConnected = await hasInternet();
        if (!isConnected) {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: "Sem conexão com a internet.",
            ),
          );
        } else {
          // Erro genérico no servidor
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: "Erro ao carregar dados do servidor.",
            ),
          );
        }
      }
    });

    // ==========================================================
    // 2. SALVAR PALPITE
    // ==========================================================
    on<SavePredictionEvent>((event, emit) async {
      // Limpa qualquer mensagem antiga antes de processar o novo salvamento
      emit(state.copyWith(successMessage: null));

      // ATENÇÃO: Mantive assim por enquanto para não "quebrar" seu código.
      // O próximo passo será atualizar esse LocalStorageService para salvar os cartões na memória do celular.
      await LocalStorageService.savePrediction(
        event.matchId,
        event.homeScore,
        event.awayScore,
        homeYellows: event.homeYellows,
        homeDoubleYellows: event.homeDoubleYellows,
        homeReds: event.homeReds,
        awayYellows: event.awayYellows,
        awayDoubleYellows: event.awayDoubleYellows,
        awayReds: event.awayReds,
      );

      final currentMatches = state.matches;
      final updatedList = currentMatches.map((match) {
        if (match.id == event.matchId) {
          return match.copyWith(
            userHomePrediction: event.homeScore,
            userAwayPrediction: event.awayScore,
            // ── LIGANDO OS FIOS DOS CARTÕES AQUI ──
            userHomeYellows: event.homeYellows,
            userHomeDoubleYellows: event.homeDoubleYellows,
            userHomeReds: event.homeReds,
            userAwayYellows: event.awayYellows,
            userAwayDoubleYellows: event.awayDoubleYellows,
            userAwayReds: event.awayReds,
          );
        }
        return match;
      }).toList();

      // Recalcula o chaveamento com a lógica de Cascata (que te passei antes)
      final matchesWithBrackets = BracketCalculator.populate(updatedList);

      // Emite o sucesso! A tela vai escutar isso e mostrar o SnackBar
      emit(
        state.copyWith(
          matches: matchesWithBrackets,
          successMessage: event.homeScore == null
              ? "Placar apagado!"
              : "Palpite salvo! 🏆",
        ),
      );
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

        bool hasSwapped =
            match.homeTeam == event.oldTeamName ||
            match.awayTeam == event.oldTeamName;

        return match.copyWith(
          homeTeam: hName,
          homeFlag: hFlag,
          awayTeam: aName,
          awayFlag: aFlag,
          userHomePrediction: hasSwapped ? null : match.userHomePrediction,
          userAwayPrediction: hasSwapped ? null : match.userAwayPrediction,
          // SE O TIME FOR TROCADO, APAGAMOS OS CARTÕES TAMBÉM
          userHomeYellows: hasSwapped ? null : match.userHomeYellows,
          userHomeDoubleYellows: hasSwapped
              ? null
              : match.userHomeDoubleYellows,
          userHomeReds: hasSwapped ? null : match.userHomeReds,
          userAwayYellows: hasSwapped ? null : match.userAwayYellows,
          userAwayDoubleYellows: hasSwapped
              ? null
              : match.userAwayDoubleYellows,
          userAwayReds: hasSwapped ? null : match.userAwayReds,
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
    // 4. RESETAR TODOS OS PALPITES
    // ==========================================================
    on<ResetAllPredictionsEvent>((event, emit) async {
      // 1. Limpa tudo do armazenamento local do celular
      await LocalStorageService.clearAllPredictions();

      // 2. Chama o nosso novo método que zera os palpites (e agora cartões) de forma segura
      final clearedMatches = state.matches.map((match) {
        return match.clearPredictions();
      }).toList();

      // 3. Recalcula o mata-mata com a lista limpa
      final recalculatedMatches = BracketCalculator.populate(clearedMatches);

      // 4. Atualiza a tela
      emit(
        state.copyWith(
          matches: recalculatedMatches,
          successMessage: "Todos os palpites foram apagados! 🧹",
        ),
      );

      // 5. Micro-atraso mágico para garantir que a SnackBar apareça corretamente
      await Future.delayed(const Duration(milliseconds: 100));
      emit(state.copyWith(successMessage: null));
    });

    // ==========================================================
    // 5. GERAR PLACARES ALEATÓRIOS
    // ==========================================================
    on<GenerateRandomScoresEvent>((event, emit) async {
      emit(state.copyWith(successMessage: null));

      final random = Random();

      final updatedList = state.matches.map((match) {
        if (!event.matchIds.contains(match.id)) return match;

        int home = random.nextInt(6); // 0 a 5
        int away = random.nextInt(6); // 0 a 5

        // Mata-mata não pode empatar!
        if (match.isKnockout && home == away) {
          if (random.nextBool()) {
            home++;
          } else {
            away++;
          }
        }

        // Deixei para zerar os cartões na geração aleatória,
        // senão a tabela ia virar um caos de expulsões rs
        return match.copyWith(
          userHomePrediction: home,
          userAwayPrediction: away,
          userHomeYellows: 0,
          userHomeDoubleYellows: 0,
          userHomeReds: 0,
          userAwayYellows: 0,
          userAwayDoubleYellows: 0,
          userAwayReds: 0,
        );
      }).toList();

      // Salva cada palpite gerado no armazenamento local
      for (var match in updatedList) {
        if (event.matchIds.contains(match.id)) {
          await LocalStorageService.savePrediction(
            match.id,
            match.userHomePrediction,
            match.userAwayPrediction,
          );
        }
      }

      final calculated = BracketCalculator.populate(updatedList);
      emit(
        state.copyWith(
          matches: calculated,
          successMessage: "Placares gerados! 🎲",
        ),
      );
    });
  }
}
