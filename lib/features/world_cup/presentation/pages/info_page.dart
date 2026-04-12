import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wsports_cup_premium/core/widgets/network_aware_tab.dart';
// 📄 ALTERAÇÃO 4: Import do sistema de rotas nomeadas
import '../../../../core/routes/app_routes.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/services/ad_service.dart';
import '../../../../core/services/notification_prompt_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/logic/repescagem_data.dart';
import '../widgets/stadium_web_browser.dart';
import '../widgets/premium_badge_app_bar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import '../pages/team_detail_page.dart';
import '../pages/mascot_detail_page.dart';
import '../pages/ball_detail_page.dart';

// ============================================================
// DATA MODELS
// ============================================================

class _HostCity {
  final String city;
  final String country;
  final String flagCode;
  final String stadium;
  final String capacity;
  final int games;
  final String description;
  final bool isHighlight;
  final String? officialUrl;

  const _HostCity({
    required this.city,
    required this.country,
    required this.flagCode,
    required this.stadium,
    required this.capacity,
    required this.games,
    required this.description,
    this.isHighlight = false,
    this.officialUrl,
  });
}

// ============================================================
// STATIC DATA
// ============================================================

const List<_HostCity> _hostCities = [
  _HostCity(
    city: 'Nova York / New Jersey',
    country: 'Estados Unidos',
    flagCode: 'us',
    stadium: 'MetLife Stadium',
    capacity: '82.500',
    games: 8,
    description:
        '🏆 SEDE DA FINAL! O maior estádio da competição, em East Rutherford. Recebeu o Super Bowl e grandes shows internacionais.',
    isHighlight: true,
    officialUrl: 'https://www.metlifestadium.com/',
  ),
  _HostCity(
    city: 'Los Angeles',
    country: 'Estados Unidos',
    flagCode: 'us',
    stadium: 'SoFi Stadium',
    capacity: '70.240',
    games: 7,
    description:
        'Capital mundial do entretenimento. O SoFi é uma das arenas mais modernas e tecnológicas do planeta, inaugurada em 2020.',
    officialUrl: 'https://www.sofistadium.com/',
  ),
  _HostCity(
    city: 'Dallas / Fort Worth',
    country: 'Estados Unidos',
    flagCode: 'us',
    stadium: 'AT&T Stadium',
    capacity: '80.000',
    games: 7,
    description:
        'O lendário "Jerry World", lar do Dallas Cowboys. Um dos estádios mais famosos do mundo, sede de grandes espetáculos.',
    officialUrl: 'https://attstadium.com/',
  ),
  _HostCity(
    city: 'San Francisco / Bay Area',
    country: 'Estados Unidos',
    flagCode: 'us',
    stadium: "Levi's Stadium",
    capacity: '68.500',
    games: 6,
    description:
        'Em Santa Clara, com vista para as montanhas. Lar do San Francisco 49ers e próximo ao Vale do Silício.',
    officialUrl: 'https://levisstadium.com/',
  ),
  _HostCity(
    city: 'Seattle',
    country: 'Estados Unidos',
    flagCode: 'us',
    stadium: 'Lumen Field',
    capacity: '72.000',
    games: 6,
    description:
        'Na cidade de Seattle, com vista para as montanhas e o Puget Sound. Famoso pela torcida ensandecida dos Seahawks.',
    officialUrl: 'https://www.lumenfield.com/',
  ),
  _HostCity(
    city: 'Boston',
    country: 'Estados Unidos',
    flagCode: 'us',
    stadium: 'Gillette Stadium',
    capacity: '65.878',
    games: 6,
    description:
        'Em Foxborough, próximo a Boston. Lar do New England Patriots, um dos times de maior tradição do futebol americano.',
    officialUrl: 'https://www.gillettestadium.com/',
  ),
  _HostCity(
    city: 'Miami',
    country: 'Estados Unidos',
    flagCode: 'us',
    stadium: 'Hard Rock Stadium',
    capacity: '65.326',
    games: 6,
    description:
        'Cidade do sol da Flórida! Lar do Miami Dolphins, com clima tropical e a maior comunidade latina dos EUA.',
    officialUrl: 'https://www.hardrockstadium.com/',
  ),
  _HostCity(
    city: 'Atlanta',
    country: 'Estados Unidos',
    flagCode: 'us',
    stadium: 'Mercedes-Benz Stadium',
    capacity: '71.000',
    games: 6,
    description:
        'Estádio com teto retrátil petal único no mundo. Sede da Copa de 1994. Considerado o mais avançado arquitetonicamente.',
    officialUrl: 'https://www.mercedesbenzstadium.com/',
  ),
  _HostCity(
    city: 'Kansas City',
    country: 'Estados Unidos',
    flagCode: 'us',
    stadium: 'Arrowhead Stadium',
    capacity: '76.416',
    games: 6,
    description:
        'Um dos estádios mais barulhentos do planeta! Lar do Kansas City Chiefs, campeões do Super Bowl.',
    officialUrl: 'https://www.gehafieldatarrowhead.com/',
  ),
  _HostCity(
    city: 'Houston',
    country: 'Estados Unidos',
    flagCode: 'us',
    stadium: 'NRG Stadium',
    capacity: '72.220',
    games: 6,
    description:
        'A maior cidade do Texas. O NRG tem teto retrátil e foi sede de grandes eventos esportivos internacionais.',
    officialUrl: 'https://www.nrgpark.com/nrg-stadium/',
  ),
  _HostCity(
    city: 'Philadelphia',
    country: 'Estados Unidos',
    flagCode: 'us',
    stadium: 'Lincoln Financial Field',
    capacity: '69.796',
    games: 6,
    description:
        'A cidade da independência americana e do Rocky! Lar do Philadelphia Eagles com uma das torcidas mais apaixonadas.',
    officialUrl: 'https://www.lincolnfinancialfield.com/',
  ),
  _HostCity(
    city: 'Toronto',
    country: 'Canadá',
    flagCode: 'ca',
    stadium: 'BMO Field',
    capacity: '45.000',
    games: 6,
    description:
        'A maior cidade canadense e um dos maiores centros multiculturais do mundo. Lar do Toronto FC, o mais popular futebol canadense.',
    officialUrl: 'https://www.bmofield.com/',
  ),
  _HostCity(
    city: 'Vancouver',
    country: 'Canadá',
    flagCode: 'ca',
    stadium: 'BC Place Stadium',
    capacity: '54.500',
    games: 6,
    description:
        'Uma das cidades mais belas do mundo, entre montanhas e oceano. BC Place tem teto inflável retrátil único no mundo.',
    officialUrl: 'https://www.bcplace.com/',
  ),
  _HostCity(
    city: 'Cidade do México',
    country: 'México',
    flagCode: 'mx',
    stadium: 'Estadio Azteca',
    capacity: '87.523',
    games: 8,
    description:
        '🔥 O LENDÁRIO AZTECA! Único estádio a sediar 3 Copas do Mundo (1970, 1986 e 2026). A 2.240m de altitude, em 1986 ocorreram aqui a "Mão de Deus" e o gol do século de Maradona!',
    isHighlight: true,
    officialUrl: 'https://www.estadiobanorte.com.mx/',
  ),
  _HostCity(
    city: 'Zapopan / Guadalajara',
    country: 'México',
    flagCode: 'mx',
    stadium: 'Estadio Akron',
    capacity: '49.850',
    games: 6,
    description:
        'Na "Perla de Occidente", segunda maior cidade do México. Lar do Chivas, o clube com mais apaixonados do país.',
    officialUrl: 'https://estadioakron.mx/',
  ),
  _HostCity(
    city: 'Monterrey',
    country: 'México',
    flagCode: 'mx',
    stadium: 'Estadio BBVA',
    capacity: '53.500',
    games: 6,
    description:
        'A industrial cidade do norte do México. O BBVA Stadium é eleito um dos mais modernos e bonitos da América Latina.',
    officialUrl: 'https://estadio-bbva.mx/',
  ),
];

const List<Map<String, dynamic>> _groups = [
  {
    'group': 'GRUPO A',
    'teams': [
      {'name': 'México', 'flag': 'mx', 'conf': 'CONCACAF'},
      {'name': 'África do Sul', 'flag': 'za', 'conf': 'CAF'},
      {'name': 'Coreia do Sul', 'flag': 'kr', 'conf': 'AFC'},
      {'name': 'Repescagem UEFA D', 'flag': 'eu', 'conf': 'UEFA'},
    ],
  },
  {
    'group': 'GRUPO B',
    'teams': [
      {'name': 'Canadá', 'flag': 'ca', 'conf': 'CONCACAF'},
      {'name': 'Repescagem UEFA A', 'flag': 'eu', 'conf': 'UEFA'},
      {'name': 'Catar', 'flag': 'qa', 'conf': 'AFC'},
      {'name': 'Suíça', 'flag': 'ch', 'conf': 'UEFA'},
    ],
  },
  {
    'group': 'GRUPO C',
    'teams': [
      {'name': 'Brasil', 'flag': 'br', 'conf': 'CONMEBOL'},
      {'name': 'Marrocos', 'flag': 'ma', 'conf': 'CAF'},
      {'name': 'Haiti', 'flag': 'ht', 'conf': 'CONCACAF'},
      {'name': 'Escócia', 'flag': 'gb-sct', 'conf': 'UEFA'},
    ],
  },
  {
    'group': 'GRUPO D',
    'teams': [
      {'name': 'Estados Unidos', 'flag': 'us', 'conf': 'CONCACAF'},
      {'name': 'Paraguai', 'flag': 'py', 'conf': 'CONMEBOL'},
      {'name': 'Austrália', 'flag': 'au', 'conf': 'AFC'},
      {'name': 'Repescagem UEFA C', 'flag': 'eu', 'conf': 'UEFA'},
    ],
  },
  {
    'group': 'GRUPO E',
    'teams': [
      {'name': 'Alemanha', 'flag': 'de', 'conf': 'UEFA'},
      {'name': 'Curaçao', 'flag': 'cw', 'conf': 'CONCACAF'},
      {'name': 'Costa do Marfim', 'flag': 'ci', 'conf': 'CAF'},
      {'name': 'Equador', 'flag': 'ec', 'conf': 'CONMEBOL'},
    ],
  },
  {
    'group': 'GRUPO F',
    'teams': [
      {'name': 'Holanda', 'flag': 'nl', 'conf': 'UEFA'},
      {'name': 'Japão', 'flag': 'jp', 'conf': 'AFC'},
      {'name': 'Repescagem UEFA B', 'flag': 'eu', 'conf': 'UEFA'},
      {'name': 'Tunísia', 'flag': 'tn', 'conf': 'CAF'},
    ],
  },
  {
    'group': 'GRUPO G',
    'teams': [
      {'name': 'Bélgica', 'flag': 'be', 'conf': 'UEFA'},
      {'name': 'Egito', 'flag': 'eg', 'conf': 'CAF'},
      {'name': 'Irã', 'flag': 'ir', 'conf': 'AFC'},
      {'name': 'Nova Zelândia', 'flag': 'nz', 'conf': 'OFC'},
    ],
  },
  {
    'group': 'GRUPO H',
    'teams': [
      {'name': 'Espanha', 'flag': 'es', 'conf': 'UEFA'},
      {'name': 'Cabo Verde', 'flag': 'cv', 'conf': 'CAF'},
      {'name': 'Arábia Saudita', 'flag': 'sa', 'conf': 'AFC'},
      {'name': 'Uruguai', 'flag': 'uy', 'conf': 'CONMEBOL'},
    ],
  },
  {
    'group': 'GRUPO I',
    'teams': [
      {'name': 'França', 'flag': 'fr', 'conf': 'UEFA'},
      {'name': 'Senegal', 'flag': 'sn', 'conf': 'CAF'},
      {'name': 'Rep. Intercont. 2', 'flag': 'un', 'conf': 'Intercont.'},
      {'name': 'Noruega', 'flag': 'no', 'conf': 'UEFA'},
    ],
  },
  {
    'group': 'GRUPO J',
    'teams': [
      {'name': 'Argentina', 'flag': 'ar', 'conf': 'CONMEBOL'},
      {'name': 'Argélia', 'flag': 'dz', 'conf': 'CAF'},
      {'name': 'Áustria', 'flag': 'at', 'conf': 'UEFA'},
      {'name': 'Jordânia', 'flag': 'jo', 'conf': 'AFC'},
    ],
  },
  {
    'group': 'GRUPO K',
    'teams': [
      {'name': 'Portugal', 'flag': 'pt', 'conf': 'UEFA'},
      {'name': 'Rep. Intercont. 1', 'flag': 'un', 'conf': 'Intercont.'},
      {'name': 'Uzbequistão', 'flag': 'uz', 'conf': 'AFC'},
      {'name': 'Colômbia', 'flag': 'co', 'conf': 'CONMEBOL'},
    ],
  },
  {
    'group': 'GRUPO L',
    'teams': [
      {'name': 'Inglaterra', 'flag': 'gb-eng', 'conf': 'UEFA'},
      {'name': 'Croácia', 'flag': 'hr', 'conf': 'UEFA'},
      {'name': 'Gana', 'flag': 'gh', 'conf': 'CAF'},
      {'name': 'Panamá', 'flag': 'pa', 'conf': 'CONCACAF'},
    ],
  },
];

// ============================================================
// MAIN PAGE
// ============================================================

class InfoPage extends StatefulWidget {
  final int initialTabIndex;
  final String initialVideoFilter;
  final List<MatchEntity> matches;
  final VoidCallback? onGoToCalendar; // 👈 novo

  const InfoPage({
    super.key,
    this.initialTabIndex = 0,
    this.initialVideoFilter = 'geral',
    this.matches = const [],
    this.onGoToCalendar, // 👈 novo
  });

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  void _goToSimulator() {
    // Se veio da WorldCupPage, volta para ela preservando o estado
    if (widget.onGoToCalendar != null && Navigator.canPop(context)) {
      widget.onGoToCalendar!.call();
      Navigator.pop(context);
      return;
    }

    // Fallback para acesso direto à rota do simulador
    Navigator.pushNamed(context, AppRoutes.worldCup);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });

    // 📄 Verifica e exibe notificação de permissão
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await NotificationService.incrementLaunchCount();
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        await NotificationPromptService.checkAndShow(context);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumBadgeAppBar(
        title: '⚽ COPA DO MUNDO 2026',
        showBackButton: false,
        leading: IconButton(
          icon: const Icon(Icons.gamepad_rounded, color: AppColors.primaryGold),
          tooltip: 'Ir para Simulador Copa 2026',
          onPressed: _goToSimulator,
        ),
      ),
      // Dentro do seu Scaffold...
      bottomNavigationBar: Container(
        // O Container/Material garante que a cor de fundo preencha a área dos botões
        color: AppColors.background,
        child: SafeArea(
          top: false, // Não queremos padding no topo aqui
          child: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primaryGold,
            labelColor: AppColors.primaryGold,
            unselectedLabelColor: Colors.white38,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
            tabs: const [
              Tab(icon: Icon(Icons.sports_soccer, size: 16), text: 'COPA 2026'),
              Tab(icon: Icon(Icons.location_city, size: 16), text: 'SEDES'),
              Tab(icon: Icon(Icons.emoji_flags, size: 16), text: 'SELEÇÕES'),
              Tab(icon: Icon(Icons.play_circle_fill, size: 16), text: 'VÍDEOS'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: _tabController.index == 3
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        // 📄 ALTERAÇÃO: Ordem dos children refatorada para nova ordem das abas
        // ✨ Índices:
        //   0 (COPA 2026)  → _Copa2026Tab
        //   1 (SEDES)      → _SedesTab
        //   2 (SELEÇÕES)   → _SelecaoTab
        //   3 (VÍDEOS)     → _VideosTab
        children: [
          // 🎯 PRIMEIRO: COPA 2026 (Call-to-Action principal)
          _Copa2026Tab(
            onSwitchTab: (index) => _tabController.animateTo(index),
            onGoToCalendar: widget.onGoToCalendar,
          ),

          // 📍 SEGUNDO: SEDES (Informações sobre estádios)
          const _SedesTab(),

          // 🇧🇷 TERCEIRO: SELEÇÕES (Informações sobre times)
          NetworkAwareTab(child: _SelecaoTab(matches: widget.matches)),

          // 🎥 QUARTO: VÍDEOS (Conteúdo multimídia)
          NetworkAwareTab(
            child: _VideosTab(initialFilter: widget.initialVideoFilter),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TAB 1: SEDES
// ============================================================

class _SedesTab extends StatefulWidget {
  const _SedesTab();

  @override
  State<_SedesTab> createState() => _SedesTabState();
}

class _SedesTabState extends State<_SedesTab> {
  String? _activeFilter; // null = sem filtro, 'us' | 'ca' | 'mx'

  List<_HostCity> get _filteredCities {
    if (_activeFilter == null) return _hostCities;
    return _hostCities.where((c) => c.flagCode == _activeFilter).toList();
  }

  void _toggleFilter(String flagCode) {
    setState(() {
      _activeFilter = _activeFilter == flagCode ? null : flagCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cities = _filteredCities;
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: cities.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _buildHeader();
        return _buildCityCard(cities[index - 1], context);
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGold.withValues(alpha: 0.2),
            Colors.blue.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          const Text(
            '16 CIDADES-SEDE',
            style: TextStyle(
              color: AppColors.primaryGold,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Três países, um torneio único na história',
            style: TextStyle(color: Colors.white54, fontSize: 11),
          ),
          const SizedBox(height: 16),

          // ── Botões de filtro ─────────────────────────────────
          Row(
            children: [
              _filterButton(
                emoji: '🇺🇸',
                count: '11',
                label: 'EUA',
                flagCode: 'us',
                activeColor: const Color(0xFF3A7BD5),
              ),
              const SizedBox(width: 10),
              _filterButton(
                emoji: '🇨🇦',
                count: '2',
                label: 'Canadá',
                flagCode: 'ca',
                activeColor: const Color(0xFFF08080),
              ),
              const SizedBox(width: 10),
              _filterButton(
                emoji: '🇲🇽',
                count: '3',
                label: 'México',
                flagCode: 'mx',
                activeColor: const Color(0xFF2E7D32),
              ),
            ],
          ),

          // ── Dica de filtro ativo ─────────────────────────────
          if (_activeFilter != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryGold.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryGold.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.filter_alt,
                    color: AppColors.primaryGold,
                    size: 13,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Toque no botão novamente para remover o filtro',
                    style: TextStyle(
                      color: AppColors.primaryGold.withValues(alpha: 0.8),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _filterButton({
    required String emoji,
    required String count,
    required String label,
    required String flagCode,
    required Color activeColor,
  }) {
    final bool isActive = _activeFilter == flagCode;
    final bool hasFilter = _activeFilter != null;
    final bool isDimmed = hasFilter && !isActive;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _toggleFilter(flagCode),
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            decoration: BoxDecoration(
              color: isActive
                  ? activeColor.withValues(alpha: 0.22)
                  : isDimmed
                  ? Colors.white.withValues(alpha: 0.02)
                  : AppColors.primaryGold.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isActive
                    ? activeColor
                    : isDimmed
                    ? Colors.white12
                    : AppColors.primaryGold.withValues(alpha: 0.4),
                width: isActive ? 2 : 1,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.35),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: isActive ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    emoji,
                    style: TextStyle(
                      fontSize: 22,
                      color: isDimmed ? Colors.white38 : null,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: isActive
                        ? activeColor
                        : isDimmed
                        ? Colors.white24
                        : AppColors.primaryGold,
                    fontSize: isActive ? 22 : 20,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                  child: Text(count),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive
                        ? activeColor.withValues(alpha: 0.9)
                        : isDimmed
                        ? Colors.white24
                        : Colors.white38,
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    letterSpacing: isActive ? 0.5 : 0,
                  ),
                ),
                const SizedBox(height: 4),
                // Indicador de filtro ativo
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  height: 3,
                  width: isActive ? 24 : 0,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCityCard(_HostCity city, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        // 🟢 Necessário para o efeito de clique (ripple)
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            // Lógica de navegação híbrida (Web vs Mobile)
            if (city.officialUrl != null && city.officialUrl!.isNotEmpty) {
              // mostra o rewarded antes de abrir
              final watched = await AdService.showRewarded();
              if (!watched) return;
              if (!context.mounted) return;
              if (kIsWeb) {
                // 🌐 MODO WEB: Abre num novo separador do browser
                final Uri url = Uri.parse(city.officialUrl!);
                if (!await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                )) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Não foi possível abrir a página oficial.',
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                }
              } else {
                // 📱 MODO MOBILE: Abre o seu WebView interno (quando tiver o emulador)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => StadiumWebBrowser(
                      url: city.officialUrl!,
                      title: city.stadium,
                    ),
                  ),
                );
              }
            } else {
              // Mostrar um SnackBar avisando que não tem link
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Página oficial indisponível no momento.'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(16),
              border: city.isHighlight
                  ? Border.all(color: AppColors.primaryGold, width: 1.5)
                  : Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                // Header row
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: city.isHighlight
                        ? AppColors.primaryGold.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://flagcdn.com/w80/${city.flagCode}.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white12,
                            ),
                            child: const Icon(
                              Icons.flag,
                              color: Colors.white54,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    city.city,
                                    style: TextStyle(
                                      color: city.isHighlight
                                          ? AppColors.primaryGold
                                          : Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (city.isHighlight)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryGold,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      '★ DESTAQUE',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Text(
                              city.country,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Info chips
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: Row(
                    children: [
                      _chip(Icons.stadium_outlined, city.stadium, flex: 3),
                      const SizedBox(width: 6),
                      _chip(Icons.people_outline, city.capacity, flex: 2),
                      const SizedBox(width: 6),
                      _chip(
                        Icons.sports_soccer_outlined,
                        '${city.games} jogos',
                        flex: 2,
                      ),
                    ],
                  ),
                ),
                // Description
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Text(
                    city.description,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: AppColors.primaryGold),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white60, fontSize: 10),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// TAB 2: SELEÇÕES
// ============================================================

class _SelecaoTab extends StatelessWidget {
  final List<MatchEntity> matches;
  const _SelecaoTab({required this.matches});

  Map<String, Map<String, String>> _buildSwapMap() {
    final result = <String, Map<String, String>>{};
    for (final entry in RepescagemData.opcoes.entries) {
      final key = entry.key;
      final optionNames = entry.value.map((o) => o['name']!).toList();
      for (final match in matches) {
        if (match.homeTeam == key || optionNames.contains(match.homeTeam)) {
          result[key] = {'name': match.homeTeam, 'flag': match.homeFlag};
          break;
        }
        if (match.awayTeam == key || optionNames.contains(match.awayTeam)) {
          result[key] = {'name': match.awayTeam, 'flag': match.awayFlag};
          break;
        }
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final swapMap = _buildSwapMap();
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _groups.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _buildConfederationsHeader();
        return _buildGroupCard(_groups[index - 1], swapMap);
      },
    );
  }

  Widget _buildConfederationsHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGold.withValues(alpha: 0.2),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          const Text(
            '48 SELEÇÕES — 12 GRUPOS',
            style: TextStyle(
              color: AppColors.primaryGold,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'A maior Copa do Mundo da história',
            style: TextStyle(color: Colors.white54, fontSize: 11),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _confBadge('UEFA', '16', const Color(0xFF1565C0)),
              _confBadge('CONCACAF', '8', const Color(0xFF2E7D32)),
              _confBadge('CAF', '9', const Color(0xFFE65100)),
              _confBadge('CONMEBOL', '6', const Color(0xFF6A1B9A)),
              _confBadge('AFC', '8', const Color(0xFF00838F)),
              _confBadge('OFC + Rep.', '1+', Colors.white38),
            ],
          ),
        ],
      ),
    );
  }

  Widget _confBadge(String conf, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            conf,
            style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(
    Map<String, dynamic> group,
    Map<String, Map<String, String>> swapMap,
  ) {
    final teams = group['teams'] as List<Map<String, dynamic>>;
    final groupName = group['group'] as String;
    final placeholders = RepescagemData.placeholdersNoGrupo(groupName);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.group, color: AppColors.primaryGold, size: 15),
                const SizedBox(width: 8),
                Text(
                  groupName,
                  style: const TextStyle(
                    color: AppColors.primaryGold,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3.2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: teams.length,
            itemBuilder: (context, i) {
              final team = Map<String, dynamic>.from(teams[i]);

              // Verifica se este time é um placeholder de repescagem neste grupo
              for (final placeholder in placeholders) {
                final current = swapMap[placeholder];
                if (current != null) {
                  // Se o time estático é o placeholder EU/UN (repescagem),
                  // substitui pelo time atual
                  final isRepescagemSlot =
                      team['flag'] == 'eu' || team['flag'] == 'un';
                  if (isRepescagemSlot &&
                      (team['name'].toString().contains('Repescagem') ||
                          team['name'].toString().contains('Rep.'))) {
                    team['name'] = current['name'];
                    team['flag'] = current['flag']; // URL completa
                    team['conf'] = _getConfFromFlag(current['flag'] ?? '');
                  }
                }
              }

              return _buildTeamTile(team, context);
            },
          ),
        ],
      ),
    );
  }

  String _getConfFromFlag(String flagUrl) {
    // Extrai a confederação baseada na bandeira (simplificado)
    if (flagUrl.contains('/eu') || flagUrl.contains('Europe')) return 'UEFA';
    return 'Repescagem';
  }

  // ─── HELPER: detecta se é um slot de repescagem ───────────────
  bool _isRepescagemSlot(Map<String, dynamic> team) {
    final name = (team['name'] as String).toLowerCase();
    final flag = (team['flag'] as String).toLowerCase();

    // Flag de placeholder
    if (flag == 'eu' || flag == 'un') return true;

    // Nomes de placeholder ainda não resolvidos
    const repKeywords = [
      'repescagem',
      'rep. intercont',
      'vencedor rep',
      'playoff',
      'intercont',
    ];
    return repKeywords.any((kw) => name.contains(kw));
  }

  // ─── HELPER: extrai flag code de URL ──────────────────────────
  String _extractFlagCode(String url) {
    final regex = RegExp(r'/([a-z]{2,}(?:-[a-z]+)?)\.(?:png|svg|jpg)');
    final match = regex.firstMatch(url.toLowerCase());
    return match?.group(1) ?? 'un';
  }

  // ─── HELPER: bottom sheet elegante de repescagem ──────────────
  void _showRepescagemSheet(BuildContext context, Map<String, dynamic> team) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _RepescagemSheet(teamName: team['name'] as String),
    );
  }

  // ─── WIDGET SUBSTITUÍDO: _buildTeamTile ───────────────────────
  Widget _buildTeamTile(Map<String, dynamic> team, BuildContext context) {
    final flagValue = team['flag'] as String;
    final isUrl = flagValue.startsWith('http');
    final flagUrl = isUrl
        ? flagValue.replaceAll('/w320/', '/w40/')
        : 'https://flagcdn.com/w40/$flagValue.png';

    final isPlaceholder = _isRepescagemSlot(team);
    final teamId = isUrl ? _extractFlagCode(flagValue) : flagValue;

    return GestureDetector(
      onTap: () async {
        if (isPlaceholder) {
          // Mostra bottom sheet elegante em vez de navegar
          _showRepescagemSheet(context, team);
        } else {
          // mostra o rewarded antes de navegar
          final watched = await AdService.showRewarded();
          if (!watched) return;
          if (!context.mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TeamDetailPage(
                teamId: teamId,
                teamName: team['name'] as String,
                flagCode: isUrl ? _extractFlagCode(flagValue) : flagValue,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isPlaceholder
              ? Colors.white.withValues(alpha: 0.02)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isPlaceholder
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.white10,
          ),
        ),
        child: Row(
          children: [
            // Bandeira ou ícone de interrogação para placeholder
            isPlaceholder
                ? Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.06),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: const Icon(
                      Icons.hourglass_top_rounded,
                      size: 13,
                      color: Colors.white24,
                    ),
                  )
                : ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: flagUrl,
                      width: 26,
                      height: 26,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white12,
                        ),
                        child: const Icon(
                          Icons.flag,
                          size: 13,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                  ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team['name'],
                    style: TextStyle(
                      color: isPlaceholder ? Colors.white24 : Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      fontStyle: isPlaceholder
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    team['conf'],
                    style: const TextStyle(color: Colors.white24, fontSize: 9),
                  ),
                ],
              ),
            ),
            // Ícone diferente para placeholder vs seleção confirmada
            Icon(
              isPlaceholder ? Icons.lock_clock_outlined : Icons.chevron_right,
              color: Colors.white12,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _RepescagemSheet extends StatelessWidget {
  final String teamName;

  const _RepescagemSheet({required this.teamName});

  // Monta uma mensagem contextual baseada no nome do slot
  String get _contextMessage {
    final lower = teamName.toLowerCase();
    if (lower.contains('intercont')) {
      return 'Esta vaga será definida pelo Playoff Intercontinental da FIFA.';
    }
    if (lower.contains('uefa')) {
      return 'Esta vaga será definida pela Repescagem UEFA, disputada entre seleções europeias.';
    }
    if (lower.contains('rep c') || lower.contains('rep d')) {
      return 'Esta vaga ainda está em disputa na fase de repescagem.';
    }
    return 'Esta vaga ainda não foi definida pela respectiva confederação.';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 28),

          // Ícone animado de ampulheta
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber.withValues(alpha: 0.08),
              border: Border.all(
                color: Colors.amber.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.hourglass_top_rounded,
              color: Colors.amber,
              size: 34,
            ),
          ),
          const SizedBox(height: 18),

          // Título
          Text(
            teamName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),

          // Badge "Vaga em disputa"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: const Text(
              '⏳  VAGA EM DISPUTA',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Mensagem contextual
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Text(
              _contextMessage,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 13,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),

          // Dica de ação
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.lightBlueAccent,
                    size: 16,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'As informações desta seleção ficarão disponíveis assim que a vaga for definida, Defina uma seleção na tela de grupos para ver detalhes e curiosidades sobre ela.',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Botão fechar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  foregroundColor: Colors.white70,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Entendido',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ============================================================
// TAB 0: COPA 2026
// ============================================================

class _Copa2026Tab extends StatelessWidget {
  final void Function(int index) onSwitchTab;
  final VoidCallback? onGoToCalendar; // 👈 novo
  const _Copa2026Tab({
    required this.onSwitchTab,
    this.onGoToCalendar, // 👈 novo
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 📄 Card Hero com informações gerais da Copa
        _buildHeroCard(context, onSwitchTab, onGoToCalendar),
        const SizedBox(height: 16),

        // 📄 NOVO: Card de Call-to-Action para criar simulação
        // 💡 Este é o ponto de entrada para a funcionalidade principal do app
        _buildSimulationCTACard(context),
        const SizedBox(height: 16),

        // 📄 Card de mascote da Copa
        _buildSectionCard(
          title: '🦁  MASCOTE OFICIAL',
          icon: Icons.pets,
          child: _buildMascotContent(context),
        ),
        const SizedBox(height: 14),
        // 📄 Card de calendário resumido
        _buildSectionCard(
          title: '📅  CALENDÁRIO RESUMIDO',
          icon: Icons.calendar_today,
          child: _buildTimelineContent(),
        ),
        const SizedBox(height: 14),
        // 📄 Card de formato da competição
        _buildSectionCard(
          title: '📋  FORMATO DA COMPETIÇÃO',
          icon: Icons.format_list_bulleted,
          child: _buildFormatContent(),
        ),
        const SizedBox(height: 14),
        // 📄 Card de bola oficial
        _buildSectionCard(
          title: '⚽  BOLA OFICIAL',
          icon: Icons.sports_soccer,
          child: _buildBallContent(context),
        ),
        const SizedBox(height: 14),
        // 📄 Card de curiosidades
        _buildSectionCard(
          title: '💡  CURIOSIDADES',
          icon: Icons.lightbulb_outline,
          child: _buildCuriositiesContent(),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildHeroCard(
    BuildContext context,
    void Function(int) onSwitchTab,
    VoidCallback? onGoToCalendar,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGold.withValues(alpha: 0.25),
            Colors.blue.withValues(alpha: 0.08),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          const Text(
            'COPA DO MUNDO FIFA 2026™',
            style: TextStyle(
              color: AppColors.primaryGold,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          const Text(
            '11 de Junho — 19 de Julho de 2026',
            style: TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const SizedBox(height: 6),
          const Text(
            '🇺🇸 Estados Unidos  •  🇨🇦 Canadá  •  🇲🇽 México',
            style: TextStyle(color: Colors.white38, fontSize: 11),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // ── Botão SELEÇÕES ──────────────────────────────
              // 📄 ALTERAÇÃO: Index atualizado para nova ordem das abas
              // Antes: índice 1 | Depois: índice 2 (SELEÇÕES mudou de posição)
              Expanded(
                child: _heroStatButton(
                  value: '48',
                  label: 'Seleções',
                  icon: Icons.emoji_flags_rounded,
                  onTap: () => onSwitchTab(2),
                ),
              ),
              const SizedBox(width: 10),
              // ── Botão JOGOS (sem navegação) ─────────────────
              Expanded(
                child: _heroStatButton(
                  value: '104',
                  label: 'Jogos',
                  icon: Icons.sports_soccer,
                  onTap: onGoToCalendar != null
                      ? () {
                          Navigator.pop(context); // fecha InfoPage
                          onGoToCalendar(); // aciona o calendário no pai
                        }
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              // ── Botão PAÍSES / CIDADES ──────────────────────
              // 📄 ALTERAÇÃO: Index atualizado para nova ordem das abas
              // Antes: índice 0 | Depois: índice 1 (SEDES mudou de posição)
              Expanded(
                child: _heroStatButton(
                  value: '3/16',
                  label: 'Países/Cidades',
                  icon: Icons.location_city,
                  onTap: () => onSwitchTab(1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Botão de estatística com visual destacado
  Widget _heroStatButton({
    required String value,
    required String label,
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    final bool tappable = onTap != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
          decoration: BoxDecoration(
            color: tappable
                ? AppColors.primaryGold.withValues(alpha: 0.10)
                : Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: tappable
                  ? AppColors.primaryGold.withValues(alpha: 0.55)
                  : Colors.white12,
              width: tappable ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: tappable ? AppColors.primaryGold : Colors.white38,
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  color: tappable ? AppColors.primaryGold : Colors.white70,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: tappable
                      ? AppColors.primaryGold.withValues(alpha: 0.75)
                      : Colors.white38,
                  fontSize: 10,
                  fontWeight: tappable ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              if (tappable) ...[
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ver',
                      style: TextStyle(
                        color: AppColors.primaryGold.withValues(alpha: 0.7),
                        fontSize: 9,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 8,
                      color: AppColors.primaryGold.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 🎮 NOVO MÉTODO: Card de Call-to-Action para criar simulação
  ///
  /// 📌 Este widget é o ponto de entrada PRINCIPAL da funcionalidade core do app.
  /// 💡 Objetivo: Direcionar o usuário naturalmente da tela de informações
  ///    para a tela de simulação de placares (WorldCupPage).
  ///
  /// 🎨 Design:
  /// - Gradiente verde para destacar visualmente (ação importante)
  /// - Ícone de bola + bolinhas decorativas
  /// - Texto claro e motivador
  /// - Botão com ação de navegação
  Widget _buildSimulationCTACard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/background_card.png'),
          repeat: ImageRepeat.repeat,
        ),
        // 🎨 Gradiente verde que chama atenção (cor de ação/CTA)
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade700.withValues(alpha: 0.85),
            Colors.blue.shade900.withValues(alpha: 0.85),
            Colors.red.shade900.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.green.shade400.withValues(alpha: 0.4),
          width: 1.5,
        ),
        // 📦 Sombra para elevar o card
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // 🎮 Ícone principal - Bola de futebol
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.gamepad_rounded,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // 📝 Título principal
          const Text(
            'CRIAR SIMULAÇÃO',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),

          // 📝 Subtítulo/descrição
          const Text(
            'Faça seus palpites dos placares\ne teste sua sorte na Copa!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.5),
          ),
          const SizedBox(height: 16),

          // 🎯 Botão de ação (navegação para WorldCupPage)
          ElevatedButton.icon(
            onPressed: () {
              // 📄 ALTERAÇÃO 4: Usando rota nomeada em vez de Navigator.push()
              // 💡 Vantagens de usar rotas nomeadas:
              //    - Centralizado em app_routes.dart
              //    - Sem duplicação de código
              //    - Fácil de manutenção e refatoração
              //    - Suporta deep linking
              Navigator.pushNamed(context, AppRoutes.worldCup);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.green.shade900,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            label: const Text(
              '🎮 COMEÇAR AGORA',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primaryGold, size: 18),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primaryGold,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }

  Widget _buildMascotContent(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final watched = await AdService.showRewarded();
        if (!watched) return;
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MascotDetailPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Maple, Zayu & Clutch',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.orange.withValues(alpha: 0.6),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Alce 🦌, Onça-Pintada 🐆 e Águia 🦅 — o trio oficial que representa Canadá, México e Estados Unidos na Copa 2026.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _infoChip('🇨🇦 Maple', const Color(0xFFF08080)),
                _infoChip('🇲🇽 Zayu', const Color(0xFF2E7D32)),
                _infoChip('🇺🇸 Clutch', const Color(0xFF3A7BD5)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🐾', style: TextStyle(fontSize: 14)),
                  SizedBox(width: 6),
                  Text(
                    'Toque para conhecer o trio',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBallContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Card clicável da bola ─────────────────────────────
        GestureDetector(
          onTap: () async {
            // mostra o rewarded antes de navegar
            final watched = await AdService.showRewarded();
            if (!watched) return;
            if (!context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BallDetailPage()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Adidas — Bola Oficial FIFA 2026',
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.lightBlueAccent.withValues(alpha: 0.6),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'A Adidas é fornecedora oficial de bolas da Copa do Mundo desde 1970. Para 2026, a empresa desenvolverá uma bola com tecnologia de ponta e design inspirado nos três países anfitriões.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _infoChip('🏭 Adidas', Colors.blue),
                    _infoChip('⚡ Alta Tecnologia', Colors.blue),
                    _infoChip('📅 Desde 1970', Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        ),
        // ── Histórico de bolas (FORA do GestureDetector) ─────
        const SizedBox(height: 12),
        const Text(
          'Bolas das Copas recentes:',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _ballRow('2026 USA/CAN/MEX', 'Trionda Pro ⭐'),
        _ballRow('2022 Qatar', 'Al Rihla'),
        _ballRow('2018 Russia', 'Telstar 18'),
        _ballRow('2014 Brasil', 'Brazuca'),
        _ballRow('2010 África do Sul', 'Jabulani'),
      ],
    );
  }

  Widget _ballRow(String edition, String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(
            Icons.sports_soccer,
            size: 14,
            color: AppColors.primaryGold,
          ),
          const SizedBox(width: 8),
          Text(
            edition,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const Spacer(),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatContent() {
    final stages = [
      {
        'stage': 'Fase de Grupos',
        'desc': '12 grupos de 4 seleções • 48 jogos',
        'icon': Icons.grid_view,
        'color': Colors.blue,
      },
      {
        'stage': '32-avos de Final',
        'desc': '16 confrontos • Os 2 primeiros e 8 melhores 3ºs avançam',
        'icon': Icons.looks_one,
        'color': Colors.cyan,
      },
      {
        'stage': 'Oitavas de Final',
        'desc': '8 duelos • Eliminação direta',
        'icon': Icons.looks_two,
        'color': Colors.teal,
      },
      {
        'stage': 'Quartas de Final',
        'desc': '4 batalhas • Os 8 melhores',
        'icon': Icons.looks_3,
        'color': Colors.orange,
      },
      {
        'stage': 'Semifinais',
        'desc': '2 jogos • Luta por uma vaga na final',
        'icon': Icons.looks_4,
        'color': Colors.deepOrange,
      },
      {
        'stage': '🏆 Grande Final',
        'desc': 'MetLife Stadium • Nova York / New Jersey',
        'icon': Icons.emoji_events,
        'color': AppColors.primaryGold,
      },
    ];

    return Column(
      children: stages
          .map(
            (s) => _stageItem(
              stage: s['stage'] as String,
              desc: s['desc'] as String,
              icon: s['icon'] as IconData,
              color: s['color'] as Color,
            ),
          )
          .toList(),
    );
  }

  Widget _stageItem({
    required String stage,
    required String desc,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.15),
            ),
            child: Icon(icon, color: color, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stage,
                  style: TextStyle(
                    color: color == AppColors.primaryGold
                        ? AppColors.primaryGold
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineContent() {
    final events = [
      {
        'date': '11 Jun 2026',
        'event': '⚽ Jogo de Abertura',
        'detail': 'Estadio Azteca • Cidade do México',
        'special': true,
      },
      {
        'date': '11–27 Jun',
        'event': 'Fase de Grupos',
        'detail': '3 rodadas × 12 grupos = 48 jogos',
        'special': false,
      },
      {
        'date': '28 Jun–3 Jul',
        'event': '32-avos de Final',
        'detail': '16 confrontos eliminatórios',
        'special': false,
      },
      {
        'date': '4–7 Jul',
        'event': 'Oitavas de Final',
        'detail': '8 grandes duelos',
        'special': false,
      },
      {
        'date': '9–11 Jul',
        'event': 'Quartas de Final',
        'detail': '4 batalhas épicas',
        'special': false,
      },
      {
        'date': '14–15 Jul',
        'event': 'Semifinais',
        'detail': 'Os 4 últimos na luta pela taça',
        'special': false,
      },
      {
        'date': '19 Jul 2026',
        'event': '🏆 GRANDE FINAL',
        'detail': 'MetLife Stadium • Nova York',
        'special': true,
      },
    ];

    return Column(
      children: events.map((e) {
        final isSpecial = e['special'] as bool;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSpecial
                ? AppColors.primaryGold.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSpecial
                  ? AppColors.primaryGold.withValues(alpha: 0.5)
                  : Colors.white10,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 75,
                child: Text(
                  e['date'] as String,
                  style: TextStyle(
                    color: isSpecial ? AppColors.primaryGold : Colors.white38,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(width: 1, height: 30, color: Colors.white12),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e['event'] as String,
                      style: TextStyle(
                        color: isSpecial ? AppColors.primaryGold : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      e['detail'] as String,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCuriositiesContent() {
    final curiosities = [
      (
        '🏆',
        'Primeira Copa com 48 seleções — 50% a mais que as Copas anteriores com 32 equipes!',
      ),
      (
        '🌎',
        'Primeira Copa em 3 países diferentes! EUA, Canadá e México se uniram em candidatura histórica.',
      ),
      (
        '🏟️',
        'O Estadio Azteca será a única arena a sediar 3 Copas do Mundo (1970, 1986 e 2026).',
      ),
      (
        '📅',
        '104 partidas ao total — a Copa mais longa da história, com mais de 38 dias de competição.',
      ),
      (
        '🆕',
        'Nova fase criada: os 32-avos de final, fase inédita no formato do Mundial.',
      ),
      (
        '⛰️',
        'Cidade do México e seu Estadio Azteca ficam a 2.240 metros de altitude!',
      ),
      (
        '📺',
        'Estima-se que mais de 5 bilhões de pessoas acompanharão a Copa 2026 — recorde histórico.',
      ),
      (
        '💰',
        'Maior evento esportivo da história em termos de geração de renda e audiência global.',
      ),
      (
        '🌐',
        'Brasil, Argentina e México são as únicas seleções com jogos em seus próprios continentes e nas Américas do Norte.',
      ),
    ];

    return Column(
      children: curiosities.map((c) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(c.$1, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  c.$2,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _infoChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ============================================================
// TAB 3: VÍDEOS (YouTube WebView)
// ============================================================

class _VideosTab extends StatefulWidget {
  final String initialFilter;

  const _VideosTab({this.initialFilter = 'geral'});

  @override
  State<_VideosTab> createState() => _VideosTabState();
}

class _VideosTabState extends State<_VideosTab> {
  late WebViewController _controller;
  bool _isLoading = true;
  late String _currentFilter;

  static const Map<String, Map<String, String>> _filters = {
    'aovivo': {'label': '🔴 Ao Vivo', 'query': ''},
    'canais': {'label': '📺 Canais', 'query': ''},
    'geral': {'label': '⚽ Geral', 'query': 'Copa do Mundo 2026 FIFA oficial'},
    'brasil': {
      'label': '🇧🇷 Brasil',
      'query': 'Brasil Copa do Mundo 2026 seleção',
    },
    'grupos': {
      'label': '👥 Grupos',
      'query': 'sorteio grupos Copa do Mundo 2026',
    },
    'noticias': {
      'label': '📰 Notícias',
      'query': 'Copa do Mundo 2026 últimas notícias',
    },
    'estrelas': {
      'label': '🌟 Estrelas',
      'query':
          'Mbappé ViniJr Vinicius Cristiano Ronaldo Messi Haaland Copa 2026',
    },
    'sedes': {
      'label': '🏟️ Estádios',
      'query': 'estádios sedes Copa do Mundo 2026',
    },
  };

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.initialFilter;
    _setupWebView();
  }

  void _setupWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // 1. Evita a tela branca antes de carregar e fixa o fundo escuro nativamente
      ..setBackgroundColor(const Color(0xFF0F0F0F))
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 13; Mobile) AppleWebKit/537.36 '
        '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) async {
            if (mounted) setState(() => _isLoading = true);
            // Força tema escuro no YouTube através de múltiplas abordagens
            await _controller.runJavaScript('''
              // 1. Cookies para forçar tema escuro
              document.cookie = "PREF=f6=400&f7=100; domain=.youtube.com; path=/; max-age=31536000";
              document.cookie = "VISITOR_INFO1_LIVE=; domain=.youtube.com; path=/; max-age=31536000";
              
              // 2. localStorage para persistir tema escuro
              localStorage.setItem('yt-theme', 'dark');
              localStorage.setItem('yt-player-dark-mode', 'true');
              localStorage.setItem('yt-dark-mode', 'true');
              
              // 3. Atributos no HTML
              document.documentElement.setAttribute('dark', 'true');
              document.documentElement.setAttribute('theme', 'dark');
              document.documentElement.classList.add('dark');
              
              // 4. Meta tag para forçar tema escuro
              var meta = document.querySelector('meta[name="theme-color"]');
              if (meta) {
                meta.setAttribute('content', '#0f0f0f');
              } else {
                var newMeta = document.createElement('meta');
                newMeta.name = 'theme-color';
                newMeta.content = '#0f0f0f';
                document.head.appendChild(newMeta);
              }
            ''');
          },
          onPageFinished: (url) async {
            if (mounted) setState(() => _isLoading = false);

            // Solução equilibrada: Tema escuro + Ocultação de elementos da interface SEM bloquear conteúdo
            await _controller.runJavaScript('''
              (function() {
                'use strict';
                
                // 1. CSS PARA TEMA ESCURO E OCULTAÇÃO SELETIVA
                var style = document.createElement('style');
                style.id = 'dark-theme-balanced';
                style.innerHTML = `
                  /* Força tema escuro nos backgrounds */
                  html, body, ytm-app, #app {
                    background-color: #0f0f0f !important;
                    background: #0f0f0f !important;
                    color: #ffffff !important;
                  }
                  
                  /* Texto branco em tudo */
                  * {
                    color: #ffffff !important;
                  }
                  
                  /* Cards de vídeo com tema escuro */
                  ytm-video-card-renderer, ytm-channel-card-renderer {
                    background-color: #1a1a1a !important;
                  }
                  
                  /* OCULTAÇÃO SELETIVA: Apenas elementos específicos da interface */
                  #header, #masthead, .appbar, .search-bar, .search-container,
                  .top-bar, ytm-mobile-topbar-renderer, ytm-header-bar,
                  #nav, .bottom-nav, footer, ytm-pivot-bar, .pivot-bar,
                  ytm-pivot-bar-renderer, .mobile-nav, .navbar {
                    display: none !important;
                    visibility: hidden !important;
                    height: 0 !important;
                    max-height: 0 !important;
                    overflow: hidden !important;
                    padding: 0 !important;
                    margin: 0 !important;
                  }
                  
                  /* Permite que o conteúdo ocupe espaço */
                  ytm-app, #app {
                    padding: 0 !important;
                    margin: 0 !important;
                  }
                `;
                
                // Remove estilo antigo
                var oldStyle = document.getElementById('dark-theme-balanced');
                if (oldStyle) oldStyle.remove();
                
                document.head.appendChild(style);
                
                // 2. FUNÇÃO DE OCULTAÇÃO
                function hideInterface() {
                  var selectors = [
                    '#header', '#masthead', '.appbar', '.search-bar', '.search-container',
                    'ytm-mobile-topbar-renderer', 'ytm-header-bar',
                    '#nav', '.bottom-nav', 'footer',
                    'ytm-pivot-bar', '.pivot-bar', 'ytm-pivot-bar-renderer',
                    '.mobile-nav', '.navbar'
                  ];
                  
                  selectors.forEach(function(selector) {
                    var elements = document.querySelectorAll(selector);
                    elements.forEach(function(el) {
                      if (el) {
                        el.style.display = 'none';
                        el.style.visibility = 'hidden';
                        el.style.height = '0px';
                      }
                    });
                  });
                  
                  document.documentElement.setAttribute('dark', 'true');
                  document.body.setAttribute('dark', 'true');
                }
                
                // Executa imediatamente
                hideInterface();
                
                // Continua monitorando
                setInterval(hideInterface, 1500);
                
              })();
            ''');
          },
          onNavigationRequest: (request) {
            final url = request.url;
            if (url.contains('youtube.com') || url.contains('youtu.be')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(_buildSearchUri(_currentFilter));
  }

  Uri _buildSearchUri(String filterKey) {
    if (filterKey == 'aovivo') {
      // YouTube com filtro de conteúdo ao vivo + tema escuro forçado
      return Uri.parse(
        'https://m.youtube.com/results?search_query=Copa+do+Mundo+2026+ao+vivo&sp=EgJAAQ%3D%3D&theme=dark&app=desktop',
      );
    }
    if (filterKey == 'canais') {
      // Busca pelos canais de transmissão + tema escuro forçado
      return Uri.parse(
        'https://m.youtube.com/results?search_query=CAZE+TV+GE+Globo+Copa+Mundo+2026+transmissao+ao+vivo&theme=dark&app=desktop',
      );
    }
    final query = _filters[filterKey]?['query'] ?? 'Copa do Mundo 2026';
    final encoded = Uri.encodeComponent(query);
    return Uri.parse(
      'https://m.youtube.com/results?search_query=$encoded&theme=dark&app=desktop',
    );
  }

  void _applyFilter(String filterKey) {
    if (_currentFilter == filterKey) return;
    setState(() => _currentFilter = filterKey);
    _controller.loadRequest(_buildSearchUri(filterKey));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra de filtros principal
        Container(
          height: 52,
          color: AppColors.background,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            children: _filters.entries.map((entry) {
              final isSelected = _currentFilter == entry.key;
              final isLive = entry.key == 'aovivo';
              final isChannel = entry.key == 'canais';

              return GestureDetector(
                onTap: () => _applyFilter(entry.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isLive
                              ? Colors.red
                              : isChannel
                              ? Colors.blueGrey.shade700
                              : AppColors.primaryGold)
                        : (isLive
                              ? Colors.red.withValues(alpha: 0.12)
                              : isChannel
                              ? Colors.blueGrey.withValues(alpha: 0.12)
                              : Colors.white.withValues(alpha: 0.08)),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : isLive
                          ? Colors.red.withValues(alpha: 0.5)
                          : isChannel
                          ? Colors.blueGrey.withValues(alpha: 0.5)
                          : Colors.white24,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Indicador pulsante para Ao Vivo
                      if (isLive && !isSelected) ...[
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        entry.value['label']!,
                        style: TextStyle(
                          color: isSelected
                              ? (isLive || isChannel
                                    ? Colors.white
                                    : Colors.black)
                              : isLive
                              ? Colors.red.withValues(alpha: 0.9)
                              : isChannel
                              ? Colors.blueGrey.shade300
                              : Colors.white60,
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Banner especial para o filtro "Canais"
        if (_currentFilter == 'canais')
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade900,
              border: Border(
                bottom: BorderSide(
                  color: Colors.blueGrey.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.tv, color: Colors.white54, size: 16),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Canais que transmitirão a Copa 2026',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Botão GE
                GestureDetector(
                  onTap: () {
                    _controller.loadRequest(
                      Uri.parse(
                        'https://m.youtube.com/results?search_query=GE+Globo+Copa+do+Mundo+2026',
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0066CC).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF0066CC).withValues(alpha: 0.6),
                      ),
                    ),
                    child: const Text(
                      '📺 GE',
                      style: TextStyle(
                        color: Color(0xFF4DA6FF),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Botão CAZE TV
                GestureDetector(
                  onTap: () {
                    _controller.loadRequest(
                      Uri.parse(
                        'https://m.youtube.com/results?search_query=CAZE+TV+Copa+do+Mundo+2026+ao+vivo',
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.6),
                      ),
                    ),
                    child: const Text(
                      '⚡ CAZE',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Banner especial para Ao Vivo
        if (_currentFilter == 'aovivo')
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.08),
              border: Border(
                bottom: BorderSide(color: Colors.red.withValues(alpha: 0.2)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Conteúdo ao vivo da Copa do Mundo 2026',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

        // Divider
        Container(height: 1, color: Colors.white10),

        // WebView
        Expanded(
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (_isLoading)
                Container(
                  color: AppColors.background,
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.primaryGold,
                          strokeWidth: 2.5,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Carregando vídeos...',
                          style: TextStyle(color: Colors.white54, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
