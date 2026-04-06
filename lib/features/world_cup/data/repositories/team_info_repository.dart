// lib/features/info/data/repositories/team_info_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/team_info_entity.dart';

class TeamInfoRepository {
  final FirebaseFirestore _firestore;

  // Nome da coleção no Firestore
  static const String _collection = 'teams_info';

  TeamInfoRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // ─── Busca uma seleção pelo ID do documento ───────────────────────────────
  Future<TeamInfoEntity?> getTeamById(String teamId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(teamId).get();
      if (!doc.exists || doc.data() == null) return null;
      return TeamInfoEntity.fromMap(doc.id, doc.data()!);
    } catch (e) {
      // ignore: avoid_print
      print('TeamInfoRepository.getTeamById error: $e');
      return null;
    }
  }

  // ─── Busca todas as seleções ──────────────────────────────────────────────
  Future<List<TeamInfoEntity>> getAllTeams() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs
          .map((doc) => TeamInfoEntity.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('TeamInfoRepository.getAllTeams error: $e');
      return [];
    }
  }

  // ─── Stream em tempo real de uma seleção ─────────────────────────────────
  Stream<TeamInfoEntity?> watchTeam(String teamId) {
    return _firestore.collection(_collection).doc(teamId).snapshots().map((
      snap,
    ) {
      if (!snap.exists || snap.data() == null) return null;
      return TeamInfoEntity.fromMap(snap.id, snap.data()!);
    });
  }

  // ─── Cria ou atualiza um documento ───────────────────────────────────────
  Future<void> upsertTeam(TeamInfoEntity team) async {
    await _firestore
        .collection(_collection)
        .doc(team.id)
        .set(team.toMap(), SetOptions(merge: true));
  }

  // ─── Deleta um documento ──────────────────────────────────────────────────
  Future<void> deleteTeam(String teamId) async {
    await _firestore.collection(_collection).doc(teamId).delete();
  }
}
