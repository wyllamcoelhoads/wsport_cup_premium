import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wsports_cup_premium/features/world_cup/presentation/pages/world_cup_page.dart';
// 📄 ALTERAÇÃO: Import de InfoPage como HOME principal
import 'package:wsports_cup_premium/features/world_cup/presentation/pages/info_page.dart';
// 📄 ALTERAÇÃO 4: Import do sistema de rotas nomeadas
import 'package:wsports_cup_premium/core/routes/app_routes.dart';
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
        // 📄 ALTERAÇÃO 4: Sistema de rotas nomeadas para escalabilidade
        // 💡 Usando onGenerateRoute para maior flexibilidade e controle
        //
        // Vantagens desta abordagem:
        // ✅ Todas as rotas centralizadas em um único lugar (app_routes.dart)
        // ✅ Fácil adicionar novos argumentos ou middleware
        // ✅ Sem duplicação de Navigator.push() espalhado no código
        // ✅ Suporta deep linking (URLs profundas)
        // ✅ Transições customizáveis por rota
        initialRoute: '/',
        onGenerateRoute: _generateRoute,
      ),
    );
  }

  /// 🔄 Gerador de rotas nomeadas
  ///
  /// Este método é chamado quando o app tenta navegar para uma rota.
  /// Centraliza toda a lógica de navegação e pode ser expandido para:
  /// - Passar argumentos entre telas
  /// - Definir transações customizadas por rota
  /// - Adicionar middleware/guards de autenticação
  /// - Debug de navegação
  ///
  /// 📌 Uso:
  /// ```dart
  /// Navigator.pushNamed(context, AppRoutes.worldCup);
  /// Navigator.pushNamed(context, AppRoutes.teamDetail,
  ///   arguments: {'teamId': 'brasil'});
  /// ```
  static Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const InfoPage(),
          settings: settings,
        );
      // 🏠 Rota da tela principal (Hub de Informações)
      case AppRoutes.infoPage:
        return MaterialPageRoute(
          builder: (_) => const InfoPage(),
          settings: settings,
        );

      // 🎮 Rota da tela de simulação de placares
      case AppRoutes.worldCup:
        return MaterialPageRoute(
          builder: (_) => const WorldCupPage(),
          settings: settings,
        );

      // ❌ Rota não encontrada
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Erro')),
            body: const Center(child: Text('Rota não encontrada')),
          ),
          settings: settings,
        );
    }
  }
}
