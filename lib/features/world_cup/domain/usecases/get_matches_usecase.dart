import '../entities/match_entity.dart';
import '../repositories/world_cup_repository.dart';

class GetMatchesUseCase {
  final WorldCupRepository
  repository; //  Injeção de dependência: O contrato do repositório é injetado aqui, mas a implementação concreta fica lá no "data layer". Assim, o "domain layer" fica totalmente desacoplado de onde os dados vêm.

  GetMatchesUseCase(this.repository); // Contrato: Quero buscar todos os jogos

  Future<List<MatchEntity>> call() async {
    return await repository
        .getMatches(); // Delegando a responsabilidade para o repositório
  }
}
