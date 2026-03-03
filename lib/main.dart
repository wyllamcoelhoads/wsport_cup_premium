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
  await popularBancoFirebase();
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

Future<void> popularBancoFirebase() async {
  final firestore = FirebaseFirestore.instance;
  final collection = firestore.collection('matches');

  final jogos = [
    // --- GRUPO A (México) ---
    {
      'id': 'gA_1',
      'group': 'GROUP A',
      'homeTeam': 'Mexico',
      'homeFlag': 'https://flagcdn.com/w320/mx.png',
      'awayTeam': 'South Africa',
      'awayFlag': 'https://flagcdn.com/w320/za.png',
      'date': DateTime(2026, 6, 11, 16, 0),
      'stadium': 'Estádio Azteca',
    },
    {
      'id': 'gA_2',
      'group': 'GROUP A',
      'homeTeam': 'A3',
      'homeFlag': 'https://flagcdn.com/w320/un.png',
      'awayTeam': 'A4',
      'awayFlag': 'https://flagcdn.com/w320/un.png',
      'date': DateTime(2026, 6, 11, 20, 0),
      'stadium': 'Estádio Guadalajara',
    },

    // --- GRUPO B (Canadá) ---
    {
      'id': 'gB_1',
      'group': 'GROUP B',
      'homeTeam': 'Canada',
      'homeFlag': 'https://flagcdn.com/w320/ca.png',
      'awayTeam': 'B2',
      'awayFlag': 'https://flagcdn.com/w320/un.png',
      'date': DateTime(2026, 6, 12, 16, 0),
      'stadium': 'BMO Field (Toronto)',
    },

    // --- GRUPO C (Brasil - Conforme seu pedido) ---
    {
      'id': 'gC_1',
      'group': 'GROUP C',
      'homeTeam': 'Brazil',
      'homeFlag': 'https://flagcdn.com/w320/br.png',
      'awayTeam': 'Morocco',
      'awayFlag': 'https://flagcdn.com/w320/ma.png',
      'date': DateTime(2026, 6, 13, 16, 0),
      'stadium': 'MetLife Stadium',
    },
    {
      'id': 'gC_2',
      'group': 'GROUP C',
      'homeTeam': 'Brazil',
      'homeFlag': 'https://flagcdn.com/w320/br.png',
      'awayTeam': 'Haiti',
      'awayFlag': 'https://flagcdn.com/w320/ht.png',
      'date': DateTime(2026, 6, 19, 16, 0),
      'stadium': 'Lincoln Financial Field',
    },
    {
      'id': 'gC_3',
      'group': 'GROUP C',
      'homeTeam': 'Brazil',
      'homeFlag': 'https://flagcdn.com/w320/br.png',
      'awayTeam': 'Scotland',
      'awayFlag': 'https://flagcdn.com/w320/gb-sct.png',
      'date': DateTime(2026, 6, 24, 16, 0),
      'stadium': 'Hard Rock Stadium',
    },

    // --- GRUPO D (EUA) ---
    {
      'id': 'gD_1',
      'group': 'GROUP D',
      'homeTeam': 'USA',
      'homeFlag': 'https://flagcdn.com/w320/us.png',
      'awayTeam': 'D2',
      'awayFlag': 'https://flagcdn.com/w320/un.png',
      'date': DateTime(2026, 6, 12, 21, 0),
      'stadium': 'SoFi Stadium (Los Angeles)',
    },

    // ... (Repete a lógica para Grupos E até L - Total de 72 jogos de grupo) ...

    // --- MATA-MATA (ROUND OF 32 - Início do novo formato) ---
    {
      'id': 'r32_73',
      'group': 'ROUND OF 32',
      'homeTeam': 'Vencedor Grupo A',
      'homeFlag': 'https://flagcdn.com/w320/un.png',
      'awayTeam': '3º C/E/F/H/I',
      'awayFlag': 'https://flagcdn.com/w320/un.png',
      'date': DateTime(2026, 6, 28, 18, 0),
      'stadium': 'SoFi Stadium',
    },

    // --- FINAIS ---
    {
      'id': 'm_101',
      'group': 'SEMIFINAL',
      'homeTeam': 'Vencedor QF1',
      'homeFlag': 'https://flagcdn.com/w320/un.png',
      'awayTeam': 'Vencedor QF2',
      'awayFlag': 'https://flagcdn.com/w320/un.png',
      'date': DateTime(2026, 7, 14, 20, 0),
      'stadium': 'AT&T Stadium (Dallas)',
    },
    {
      'id': 'm_103',
      'group': '3RD PLACE',
      'homeTeam': 'Perdedor SF1',
      'homeFlag': 'https://flagcdn.com/w320/un.png',
      'awayTeam': 'Perdedor SF2',
      'awayFlag': 'https://flagcdn.com/w320/un.png',
      'date': DateTime(2026, 7, 18, 16, 0),
      'stadium': 'Hard Rock Stadium (Miami)',
    },
    {
      'id': 'm_104',
      'group': 'FINAL',
      'homeTeam': 'Vencedor SF1',
      'homeFlag': 'https://flagcdn.com/w320/un.png',
      'awayTeam': 'Vencedor SF2',
      'awayFlag': 'https://flagcdn.com/w320/un.png',
      'date': DateTime(2026, 7, 19, 16, 0),
      'stadium': 'MetLife Stadium (NY/NJ)',
    },
  ];

  print('⏳ Enviando jogos para o Firebase...');

  for (var jogo in jogos) {
    // Insere ou atualiza o documento com a ID exata (ex: gC_1)
    await collection.doc(jogo['id'] as String).set({
      'id': jogo['id'],
      'group': jogo['group'],
      'homeTeam': jogo['homeTeam'],
      'homeFlag': jogo['homeFlag'],
      'awayTeam': jogo['awayTeam'],
      'awayFlag': jogo['awayFlag'],
      // Converte o DateTime do Flutter para o formato Timestamp exigido pelo Firebase
      'date': Timestamp.fromDate(jogo['date'] as DateTime),
      'stadium': jogo['stadium'],
    });
  }
  print('🔥 BANCO POPULADO COM SUCESSO!');
}
