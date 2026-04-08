import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wsports_cup_premium/features/world_cup/presentation/pages/world_cup_page.dart';
import 'core/services/version_check_service.dart';
import 'core/widgets/update_banner.dart';
import 'firebase_options.dart';
import 'package:wsports_cup_premium/features/world_cup/presentation/bloc/world_cup_bloc.dart';
import 'package:wsports_cup_premium/features/world_cup/presentation/bloc/world_cup_event.dart';
import 'package:wsports_cup_premium/injection_container.dart';
import 'package:wsports_cup_premium/injection_container.dart' as di;
import './core/services/ad_service.dart';
import 'core/constants/app_theme.dart';
import 'core/services/notification_service.dart';
import 'core/utils/update_banner_notifier.dart';
//import 'core/utils/team_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await di.init();

  // 2. Inicializa o serviço de notificação (handlers de clique)
  await NotificationService.initialize();

  // AdMob em background para não travar a inicialização
  unawaited(
    AdService.initialize()
        .then((_) {
          // Resolve o Item 2: Carrega o intersticial assim que o AdMob inicializar
          AdService.loadInterstitial();
        })
        .catchError((e) {
          debugPrint('Erro AdMob: $e');
        }),
  );
  // === PASSO 1: DESCOMENTE ESTA LINHA ABAIXO PARA INSERIR todas as selecoes para pagina de informacoes sobre as selecoes===
  //await popularTodasAsSelecoes(); ////////////////////////////EENVIAR DADOS PARA O BANCO FIREBASE (RODAR APENAS UMA VEZ, DEPOIS COMENTAR NOVAMENTE)
  // === PASSO 2: DESCOMENTE ESTA LINHA ABAIXO PARA INSERIR os jogos dos grupos ===
  //await popularGruposFirebase(); ////////////////////////////EENVIAR DADOS PARA O BANCO FIREBASE (RODAR APENAS UMA VEZ, DEPOIS COMENTAR NOVAMENTE)

  runApp(const MyApp());

  // ── Verificação de atualização ────────────────────────────────────────────
  // Executada APÓS o runApp para não atrasar a exibição da tela inicial.
  // O pequeno delay garante que o primeiro frame já foi renderizado.
  Future.delayed(const Duration(seconds: 2), verificarAtualizacao);
}

/// Consulta o Remote Config e exibe o banner se houver versão mais nova.
Future<void> verificarAtualizacao() async {
  try {
    final bool atualizado = await VersionCheckService().isAppUpToDate();
    if (!atualizado) {
      showUpdateBannerNotifier.value = true;
    }
  } catch (e) {
    // Silencia: falha na verificação não deve impactar o usuário
    debugPrint('[main] Erro em verificarAtualizacao: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorldCupBloc>(
      create: (context) => sl<WorldCupBloc>()..add(LoadMatchesEvent()),
      child: MaterialApp(
        title: 'Copa do Mundo 2026',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        // 3. Adicione o navigatorKey para o SnackBar in-foreground funcionar
        navigatorKey: NotificationService.navigatorKey,
        builder: (context, child) {
          if (child == null) return const SizedBox.shrink();
          return UpdateBanner(child: child);
        },
        home: const WorldCupPage(),
      ),
    );
  }
}
