import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wsports_cup_premium/features/splash/presentation/pages/video_splash_screen.dart';
import 'package:wsports_cup_premium/features/world_cup/presentation/bloc/world_cup_bloc.dart';
import 'package:wsports_cup_premium/features/world_cup/presentation/bloc/world_cup_event.dart';
import 'package:wsports_cup_premium/injection_container.dart';
import 'package:wsports_cup_premium/injection_container.dart' as di;

import 'core/constants/app_theme.dart';

void main() async {
  // 1. Inicialização do Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicialização da Injeção de Dependência
  await di.init();

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

        // 3. Aplica o Tema Premium
        theme: AppTheme.darkTheme,

        // 4. Injeta o Bloco da Copa e carrega os jogos
        home: const VideoSplashScreen(),
      ),
    );
  }
}
