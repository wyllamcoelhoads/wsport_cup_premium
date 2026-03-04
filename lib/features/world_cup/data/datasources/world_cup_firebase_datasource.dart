import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/match_entity.dart';

class WorldCupFirebaseDatasource {
  final FirebaseFirestore firestore;

  WorldCupFirebaseDatasource({required this.firestore});

  Future<List<MatchEntity>> getMatches() async {
    try {
      // 1. Vai no Firebase e busca todos os jogos cadastrados
      final snapshot = await firestore.collection('matches').get();

      // 2. Transforma o JSON do Firebase na sua MatchEntity
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return MatchEntity(
          id: doc.id,
          homeTeam: data['homeTeam'],
          homeFlag: data['homeFlag'],
          awayTeam: data['awayTeam'],
          awayFlag: data['awayFlag'],
          date: (data['date'] as Timestamp)
              .toDate(), // Converte a data do Firebase para o app
          stadium: data['stadium'] ?? 'TBD',
          country: data['country'] ?? 'TBD',
          location: data['location'] ?? 'TBD',
          group: data['group'],
          status: 'Scheduled',
          // 3. O SEGREDO: O placar inicial sempre nasce nulo (vazio) na memória!
          userHomePrediction: null,
          userAwayPrediction: null,
        );
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar jogos do Firebase: $e');
    }
  }
}
