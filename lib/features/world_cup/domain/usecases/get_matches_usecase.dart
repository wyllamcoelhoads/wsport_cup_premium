
import '../entities/match_entity.dart';
import '../repositories/world_cup_repository.dart';

class GetMatchesUseCase {
  final WorldCupRepository repository;

  GetMatchesUseCase(this.repository);

  Future<List<MatchEntity>> call() async {
    return await repository.getMatches();
  }
}