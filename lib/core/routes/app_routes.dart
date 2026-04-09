// 📄 IMPORT: Flutter Material (necessário para WidgetBuilder)
import 'package:flutter/material.dart';

/// 🔄 GERENCIADOR DE ROTAS DA APLICAÇÃO
/// ================================================================
/// Arquivo responsável por centralizar todas as rotas (navegações)
/// do aplicativo. Utiliza rotas nomeadas para melhor escalabilidade
/// e manutenção.
///
/// 📌 Vantagens das Rotas Nomeadas:
/// - Centralização: todas rotas em um único lugar
/// - Sem duplicação: evita ter Navigator.push() espalhado no código
/// - Fácil refatoração: trocar rota em um único lugar
/// - Type-safe: constants previnem typos
/// - Deep linking: permite navegar via URLs
///
/// ================================================================
/// 📝 ARQUITETURA:
///
/// 1. AppRoutes → Define nomes de rotas (constantes)
///
/// 2. main.dart → Gerador de rotas (onGenerateRoute)
///    └─> Mapeia rotas para widgets
///    └─> Pode adicionar lógica de transições custom
///    └─> Suporta argumentos (via settings)
///
/// 3. Telas → Usam rotas nomeadas
///    └─> Navigator.pushNamed(context, AppRoutes.worldCup)
/// ================================================================

/// 📍 CONSTANTES DE ROTAS
///
/// Use estas constantes quando precisar navegar.
/// Exemplo:
/// ```dart
/// // ❌ ANTIGO (sem rotas nomeadas):
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (_) => const WorldCupPage())
/// );
///
/// // ✅ NOVO (com rotas nomeadas):
/// Navigator.pushNamed(context, AppRoutes.worldCup);
/// ```
class AppRoutes {
  // 🏠 Tela principal de informações sobre a Copa
  // Contém abas: Sedes, Seleções, Copa 2026, Vídeos
  // Primeiro ponto de entrada do app
  static const String infoPage = '/info';

  // 🎮 Tela principal de simulação de placares
  // Contém abas: Grupos, Oitavas, Quartas, Semifinal/Final
  // Funcionalidade CORE do aplicativo
  static const String worldCup = '/world-cup';

  // 📝 Detalhes de uma seleção específica
  // Pode receber argumento: teamId (ex: 'brasil')
  // TODO: Implementar quando necessário
  static const String teamDetail = '/team-detail';

  // ⚽ Detalhes da bola oficial
  // Abre a página de detalhes sobre a bola Jabulani 2026
  // TODO: Implementar quando necessário
  static const String ballDetail = '/ball-detail';

  // 💎 Página premium (recursos pagos)
  // Contém informações sobre planos premium
  // TODO: Implementar quando necessário
  static const String premium = '/premium';
}

/// 🗺️ CONFIGURAÇÃO DE ROTAS
///
/// ❌ ANTIGO METHOD (não recomendado):
/// ```dart
/// MaterialApp(
///   routes: {
///     '/': (_) => const InfoPage(),
///     '/world-cup': (_) => const WorldCupPage(),
///   },
/// )
/// ```
///
/// ✅ NOVO METHOD (recomendado):
/// ```dart
/// MaterialApp(
///   initialRoute: AppRoutes.infoPage,
///   onGenerateRoute: _generateRoute, // Ver em main.dart
/// )
/// ```
///
/// 💡 O método onGenerateRoute é MAIS PODEROSO porque é chamado
///    como função, permitindo:
///    - Acessar argumentos (settings.arguments)
///    - Adicionar middleware/guards
///    - Definir transições customizadas
///    - Fazer deep linking
///    - Debug completo de navegação
class AppRoutesConfig {
  // ✅ Este método retorna o mapa de rotas para o MaterialApp
  // Para adicionar uma nova tela, crie um novo caso em onGenerateRoute
  // (em main.dart), NÃO aqui.
  //
  // Este classe é mantida para referência histórica.
  static Map<String, WidgetBuilder> getRoutes() {
    return const <String, WidgetBuilder>{
      // Importações abaixo (adicione conforme necessário)
      // Nota: Esto método não está sendo usado atualmente.
      // Use onGenerateRoute em main.dart conforme exemplo.
    };
  }
}

/// 📖 COMO ADICIONAR NOVA ROTA
/// 
/// Passo 1: Adicione constante aqui em AppRoutes
/// ```dart
/// static const String novaRota = '/nova-rota';
/// ```
/// 
/// Passo 2: Adicione case no onGenerateRoute (main.dart)
/// ```dart
/// case AppRoutes.novaRota:
///   return MaterialPageRoute(
///     builder: (_) => const NovaTela(),
///     settings: settings,
///   );
/// ```
/// 
/// Passo 3: Use em suas telas
/// ```dart
/// Navigator.pushNamed(context, AppRoutes.novaRota);
/// ```
/// 
/// Passo 4 (OPCIONAL): Passar argumentos
/// ```dart
/// Navigator.pushNamed(
///   context, 
///   AppRoutes.teamDetail,
///   arguments: {'teamId': 'brasil'}
/// );
/// 
/// // Na tela receptora:
/// final args = settings.arguments as Map<String, String>;
/// final teamId = args['teamId'];
/// ```

