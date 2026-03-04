import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// 1. Importações obrigatórias do Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:wsports_cup_premium/features/splash/presentation/pages/video_splash_screen.dart';
import 'package:wsports_cup_premium/features/world_cup/presentation/bloc/world_cup_bloc.dart';
import 'package:wsports_cup_premium/features/world_cup/presentation/bloc/world_cup_event.dart';
import 'package:wsports_cup_premium/injection_container.dart';
import 'package:wsports_cup_premium/injection_container.dart' as di;

import 'core/constants/app_theme.dart';

void main() async {
  // 1. Inicialização do Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. A MÁGICA ACONTECE AQUI: Inicializa o Firebase apontando para o seu banco
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 3. Inicialização da Injeção de Dependência (agora segura, pois o Firebase já acordou)
  await di.init();
  // 1. Descomente esta linha para rodar o insert, depois comente novamente!
  //await popularGruposFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorldCupBloc>(
      create: (context) => sl<WorldCupBloc>()..add(LoadMatchesEvent()),
      child: MaterialApp(
        title: 'WSports World Cup',
        debugShowCheckedModeBanner: false,

        // Aplica o Tema Premium
        theme: AppTheme.darkTheme,

        // Injeta o Bloco da Copa e carrega os jogos
        home: const VideoSplashScreen(),
      ),
    );
  }
}

Future<void> popularGruposFirebase() async {
  final firestore = FirebaseFirestore.instance;
  final collection = firestore.collection('matches');

  // Tabela Oficial - Primeira Rodada dos 12 Grupos
  final jogos = [
    // === GRUPO A ===
    {
      'id': 'gA_1',
      'group': 'GROUP A',
      'homeTeam': 'Mexico',
      'homeFlag': 'https://flagcdn.com/w320/mx.png',
      'awayTeam': 'South Africa',
      'awayFlag': 'https://flagcdn.com/w320/za.png',
      'date': DateTime(2026, 6, 11, 16, 0),
      'stadium': 'Estádio Azteca',
      'status': 'Agendado',
    },
    {
      'id': 'gA_2',
      'group': 'GROUP A',
      'homeTeam': 'South Korea',
      'homeFlag': 'https://flagcdn.com/w320/kr.png',
      'awayTeam': 'Rep. Europa D',
      'awayFlag':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/Flag_of_Europe.svg/320px-Flag_of_Europe.svg.png',
      'date': DateTime(2026, 6, 11, 20, 0),
      'stadium': 'TBD',
      'status': 'Agendado',
    },

    // === GRUPO B ===
    {
      'id': 'gB_1',
      'group': 'GROUP B',
      'homeTeam': 'Canada',
      'homeFlag': 'https://flagcdn.com/w320/ca.png',
      'awayTeam': 'Rep. Europa A',
      'awayFlag':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/Flag_of_Europe.svg/320px-Flag_of_Europe.svg.png',
      'date': DateTime(2026, 6, 12, 16, 0),
      'stadium': 'TBD',
      'status': 'Agendado',
    },
    {
      'id': 'gB_2',
      'group': 'GROUP B',
      'homeTeam': 'Qatar',
      'homeFlag': 'https://flagcdn.com/w320/qa.png',
      'awayTeam': 'Switzerland',
      'awayFlag': 'https://flagcdn.com/w320/ch.png',
      'date': DateTime(2026, 6, 12, 20, 0),
      'stadium': 'TBD',
      'status': 'Agendado',
    },

    // === GRUPO C (Brasil) ===
    {
      'id': 'gC_1',
      'group': 'GROUP C',
      'homeTeam': 'Brazil',
      'homeFlag': 'https://flagcdn.com/w320/br.png',
      'awayTeam': 'Morocco',
      'awayFlag': 'https://flagcdn.com/w320/ma.png',
      'date': DateTime(2026, 6, 13, 16, 0),
      'stadium': 'TBD',
      'status': 'Agendado',
    },
    {
      'id': 'gC_2',
      'group': 'GROUP C',
      'homeTeam': 'Haiti',
      'homeFlag': 'https://flagcdn.com/w320/ht.png',
      'awayTeam': 'Scotland',
      'awayFlag': 'https://flagcdn.com/w320/gb-sct.png',
      'date': DateTime(2026, 6, 13, 20, 0),
      'stadium': 'TBD',
      'status': 'Agendado',
    },

    // === GRUPO D ===
    {
      'id': 'gD_1',
      'group': 'GROUP D',
      'homeTeam': 'USA',
      'homeFlag': 'https://flagcdn.com/w320/us.png',
      'awayTeam': 'Paraguay',
      'awayFlag': 'https://flagcdn.com/w320/py.png',
      'date': DateTime(2026, 6, 14, 16, 0),
      'stadium': 'TBD',
      'status': 'Agendado',
    },
    {
      'id': 'gD_2',
      'group': 'GROUP D',
      'homeTeam': 'Australia',
      'homeFlag': 'https://flagcdn.com/w320/au.png',
      'awayTeam': 'Rep. Europa C',
      'awayFlag':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/Flag_of_Europe.svg/320px-Flag_of_Europe.svg.png',
      'date': DateTime(2026, 6, 14, 20, 0),
      'stadium': 'TBD',
      'status': 'Agendado',
    },

    // === GRUPO E ===
    {
      'id': 'gE_1',
      'group': 'GROUP E',
      'homeTeam': 'Germany',
      'homeFlag': 'https://flagcdn.com/w320/de.png',
      'awayTeam': 'Curaçao',
      'awayFlag': 'https://flagcdn.com/w320/cw.png',
      'date': DateTime(2026, 6, 15, 16, 0),
      'stadium': 'TBD',
      'status': 'Agendado',
    },
    {
      'id': 'gE_2',
      'group': 'GROUP E',
      'homeTeam': 'Ivory Coast',
      'homeFlag': 'https://flagcdn.com/w320/ci.png',
      'awayTeam': 'Ecuador',
      'awayFlag': 'https://flagcdn.com/w320/ec.png',
      'date': DateTime(2026, 6, 15, 20, 0),
      'stadium': 'TBD',
      'status': 'Agendado',
    },

    // === GRUPO F ===
    {
      'id': 'gF_1',
      'group': 'GROUP F',
      'homeTeam': 'Netherlands',
      'homeFlag': 'https://flagcdn.com/w320/nl.png',
      'awayTeam': 'Japan',
      'awayFlag': 'https://flagcdn.com/w320/jp.png',
      'date': DateTime(2026, 6, 16, 16, 0),
      'stadium': 'TBD',
      'status': 'Agendado',
    },
    {
      'id': 'gF_2',
      'group': 'GROUP F',
      'homeTeam': 'Rep. Europa B',
      'homeFlag':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/Flag_of_Europe.svg/320px-Flag_of_Europe.svg.png',
      'awayTeam': 'Tunisia',
      'awayFlag': 'https://flagcdn.com/w320/tn.png',
      'date': DateTime(2026, 6, 16, 20, 0),
      'stadium': 'TBD',
      'status': 'Agendado',
    },

    // === GRUPO G ===
    {
      'id': 'gG_1',
      'group': 'GROUP G',
      'homeTeam': 'Belgium',
      'homeFlag': 'https://flagcdn.com/w320/be.png',
      'awayTeam': 'Egypt',
      'awayFlag': 'https://flagcdn.com/w320/eg.png',
      'date': DateTime(2026, 6, 17, 16, 0),
      'stadium': 'TBD',
      'status': 'Agendado',
    },

    // === GRUPO H ===
    {
      'id': 'gH_1',
      'group': 'GROUP H',
      'homeTeam': 'Spain',
      'homeFlag': 'https://flagcdn.com/w320/es.png',
      'awayTeam': 'Cape Verde',
      'awayFlag': 'https://flagcdn.com/w320/cv.png',
      'date': DateTime(2026, 6, 18, 16, 0),
      'stadium': 'TBD',
      'status': 'Agendado',
    },

    // === GRUPO I ===
    {
      'id': 'gI_1',
      'group': 'GROUP I',
      'homeTeam': 'France',
      'homeFlag': 'https://flagcdn.com/w320/fr.png',
      'awayTeam': 'Senegal',
      'awayFlag': 'https://flagcdn.com/w320/sn.png',
      'date': DateTime(2026, 6, 19, 16, 0),
      'stadium': 'TBD',
      'status': 'Agendado',
    },

    // === GRUPO J ===
    {
      'id': 'gJ_1',
      'group': 'GROUP J',
      'homeTeam': 'Argentina',
      'homeFlag': 'https://flagcdn.com/w320/ar.png',
      'awayTeam': 'Algeria',
      'awayFlag': 'https://flagcdn.com/w320/dz.png',
      'date': DateTime(2026, 6, 20, 16, 0),
      'stadium': 'TBD',
      'status': 'Agendado',
    },

    // === GRUPO K ===
    {
      'id': 'gK_1',
      'group': 'GROUP K',
      'homeTeam': 'Portugal',
      'homeFlag': 'https://flagcdn.com/w320/pt.png',
      'awayTeam': 'Rep. Inter 1',
      'awayFlag':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ef/International_Flag_of_Planet_Earth.svg/320px-International_Flag_of_Planet_Earth.svg.png',
      'date': DateTime(2026, 6, 21, 16, 0),
      'stadium': 'TBD',
      'status': 'Agendado',
    },

    // === GRUPO L ===
    {
      'id': 'gL_1',
      'group': 'GROUP L',
      'homeTeam': 'England',
      'homeFlag': 'https://flagcdn.com/w320/gb-eng.png',
      'awayTeam': 'Croatia',
      'awayFlag': 'https://flagcdn.com/w320/hr.png',
      'date': DateTime(2026, 6, 22, 16, 0),
      'stadium': 'TBD',
      'status': 'Agendado',
    },
  ];

  print('⏳ Enviando grupos oficias para o Firebase...');

  for (var jogo in jogos) {
    await collection.doc(jogo['id'] as String).set({
      'id': jogo['id'],
      'group': jogo['group'],
      'homeTeam': jogo['homeTeam'],
      'homeFlag': jogo['homeFlag'],
      'awayTeam': jogo['awayTeam'],
      'awayFlag': jogo['awayFlag'],
      'date': Timestamp.fromDate(jogo['date'] as DateTime),
      'stadium': jogo['stadium'],
      'status': jogo['status'],
    });
  }
  print('🔥 GRUPOS POPULADOS COM SUCESSO!');
}
