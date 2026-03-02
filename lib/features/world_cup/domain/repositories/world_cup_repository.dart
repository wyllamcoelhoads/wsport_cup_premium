import '../entities/match_entity.dart';
abstract class WorldCupRepository {
  // Contrato: Quero buscar todos os jogos
  Future<List<MatchEntity>> getMatches();
  
  // Contrato: Quero salvar um palpite
  Future<void> savePrediction(String matchId, int homeScore, int awayScore);
}