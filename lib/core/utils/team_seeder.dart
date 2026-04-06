// lib/core/utils/team_seeder.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Ajuste este import para apontar corretamente para a sua TeamInfoEntity
import '../../features/world_cup/domain/entities/team_info_entity.dart';

Future<void> popularTodasAsSelecoes() async {
  final firestore = FirebaseFirestore.instance;

  final List<TeamInfoEntity> todasAsSelecoes = [
    // === BRASIL ===
    const TeamInfoEntity(
      id: 'br',
      name: 'Brasil',
      flagCode: 'br',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/pt/thumb/2/2b/Confedera%C3%A7%C3%A3o_Brasileira_de_Futebol_2019.svg/512px-Confedera%C3%A7%C3%A3o_Brasileira_de_Futebol_2019.svg.png',
      coach: 'Dorival Júnior',
      captain: 'Marquinhos',
      uniformHomeUrl: '',
      uniformAwayUrl: '',
      confederation: 'CONMEBOL',
      nickname: 'Seleção Canarinha',
      fifaRanking: 5,
      founded: 1914,
      worldCupAppearances: 22,
      worldCupWins: 5,
      worldCupYears: [
        1930,
        1934,
        1938,
        1950,
        1954,
        1958,
        1962,
        1966,
        1970,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1958, 1962, 1970, 1994, 2002],
      bio:
          'A Seleção Brasileira é a única a ter participado de todas as edições da Copa do Mundo FIFA.',
    ),

    // === ARGENTINA ===
    const TeamInfoEntity(
      id: 'ar',
      name: 'Argentina',
      flagCode: 'ar',
      coatOfArmsUrl:
          'https://upload.wikimedia.org/wikipedia/en/thumb/c/c1/Argentina_national_football_team_logo.svg/800px-Argentina_national_football_team_logo.svg.png',
      coach: 'Lionel Scaloni',
      captain: 'Lionel Messi',
      uniformHomeUrl: '',
      uniformAwayUrl: '',
      confederation: 'CONMEBOL',
      nickname: 'La Albiceleste',
      fifaRanking: 1,
      founded: 1893,
      worldCupAppearances: 18,
      worldCupWins: 3,
      worldCupYears: [
        1930,
        1934,
        1958,
        1962,
        1966,
        1974,
        1978,
        1982,
        1986,
        1990,
        1994,
        1998,
        2002,
        2006,
        2010,
        2014,
        2018,
        2022,
        2026,
      ],
      worldCupTitlesYears: [1978, 1986, 2022],
      bio:
          'A atual campeã mundial, a Argentina tem uma das histórias mais ricas no futebol mundial.',
    ),

    // 👇 Adicione as outras 46 seleções aqui abaixo...
  ];

  debugPrint('⏳ Iniciando a inserção de ${todasAsSelecoes.length} seleções...');
  int inseridasComSucesso = 0;

  for (var selecao in todasAsSelecoes) {
    try {
      await firestore
          .collection('teams_info')
          .doc(selecao.id)
          .set(selecao.toMap());

      inseridasComSucesso++;
      debugPrint('✅ ${selecao.name} inserida!');
    } catch (e) {
      debugPrint('❌ ERRO ao inserir ${selecao.name}: $e');
    }
  }

  debugPrint(
    '🎉 CONCLUÍDO: $inseridasComSucesso/${todasAsSelecoes.length} seleções salvas no Firestore!',
  );
}
