import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wsports_cup_premium/core/services/ad_service.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/widgets/banner_ad_widget.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/logic/bracket_calculator.dart';
import '../../domain/logic/standings_calculator.dart';
import '../../domain/logic/repescagem_data.dart';
import '../../premium/pages/premium_page.dart';
import '../bloc/world_cup_bloc.dart';
import '../bloc/world_cup_event.dart';
import '../bloc/world_cup_state.dart';
import '../widgets/bracket_view.dart';
import '../widgets/expandable_fab.dart';
import 'info_page.dart';

class WorldCupPage extends StatefulWidget {
  const WorldCupPage({super.key});

  @override
  State<WorldCupPage> createState() => _WorldCupPageState();
}

class _WorldCupPageState extends State<WorldCupPage> {
  // Variável para controlar se as abas podem deslizar lateralmente
  bool _canScrollTabs = true;
  final _fabKey = GlobalKey<ExpandableFabState>();

  String? _getChampionCode(List<MatchEntity> matches) {
    try {
      final finalMatch = matches.firstWhere((m) => m.id == 'final_1');
      if (finalMatch.userHomePrediction != null &&
          finalMatch.userAwayPrediction != null) {
        String winnerFlagUrl = ''; //.

        if (finalMatch.userHomePrediction! > finalMatch.userAwayPrediction!) {
          winnerFlagUrl = finalMatch.homeFlag;
        } else if (finalMatch.userAwayPrediction! >
            finalMatch.userHomePrediction!) {
          winnerFlagUrl = finalMatch.awayFlag;
        } else {
          winnerFlagUrl = finalMatch.homeFlag;
        }

        if (winnerFlagUrl.isNotEmpty && winnerFlagUrl.contains('/')) {
          final filename = winnerFlagUrl.split('/').last;
          return filename.split('.').first;
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  void _resetAllPredictions(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        // Renomeei para dialogContext para evitar confusão
        backgroundColor: AppColors.cardSurface,
        title: const Text(
          'Resetar todos os palpites?',
          style: TextStyle(color: AppColors.primaryGold),
        ),
        content: const Text(
          'Isso apagará todos os seus palpites e simulações.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext), // Fecha apenas o modal
            child: const Text('CANCELAR', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGold,
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              // 1. Dispara o evento pro Bloc
              context.read<WorldCupBloc>().add(ResetAllPredictionsEvent());

              // 2. Fecha o modal DEPOIS de despachar o evento

              await Future.delayed(const Duration(milliseconds: 800));
              await AdService.showRewarded();
            },
            child: const Text(
              'RESETAR',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorldCupBloc, WorldCupState>(
      // Ouve mudanças de estado para mostrar a SnackBar
      listenWhen: (previous, current) =>
          current.successMessage != previous.successMessage &&
          current.successMessage != null,
      listener: (context, state) {
        if (state.successMessage != null) {
          // Limpa qualquer SnackBar antiga antes de mostrar a nova
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.successMessage!,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: AppColors.primaryGold,
              behavior: SnackBarBehavior.fixed,
              duration: const Duration(seconds: 2), // Tempo agradável
            ),
          );
        }
      },
      builder: (context, state) {
        // ... O resto do seu código de construtor (DefaultTabController, Scaffold...) continua IGUAL daqui para baixo ...
        final String? championCode = _getChampionCode(
          BracketCalculator.populate(state.matches),
        );

        return DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: AppColors.background,
            floatingActionButton: ExpandableFab(
              key: _fabKey,
              distance: 80.0,
              children: [
                ActionButton(
                  onPressed: () {
                    _fabKey.currentState?.close();
                    _resetAllPredictions(context);
                  },
                  icon: FaIcon(FontAwesomeIcons.trashCan, size: 20),
                ),
                ActionButton(
                  onPressed: () {
                    _fabKey.currentState?.close();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PremiumPage()),
                    );
                  },
                  icon: FaIcon(FontAwesomeIcons.star, size: 20),
                ),
                ActionButton(
                  onPressed: () {
                    _fabKey.currentState?.close();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const InfoPage()),
                    );
                  },
                  icon: FaIcon(FontAwesomeIcons.personThroughWindow, size: 20),
                ),
              ],
            ), // CORREÇÃO: O FAB agora é apenas o botão, sem receber o estado ou bloc
            body: Column(
              children: [
                Expanded(
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          expandedHeight: 200.0,
                          pinned: true,
                          backgroundColor: AppColors.background,
                          elevation: 0,
                          flexibleSpace: LayoutBuilder(
                            builder: (context, constraints) {
                              // Calcula o percentual de expansão (1.0 totalmente aberto, 0.0 fechado)
                              final double appBarHeight = constraints.maxHeight;
                              final bool isExpanded =
                                  appBarHeight >
                                  150; // Altura arbitrária para detecção

                              return FlexibleSpaceBar(
                                centerTitle: true,
                                // Se estiver aberto, usa 90 de padding. Se fechar, usa 50 para caber.
                                titlePadding: EdgeInsets.only(
                                  bottom: isExpanded ? 90 : 55,
                                ),
                                title: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Opcional: Esconder o ícone quando a barra encolher para limpar o visual
                                      if (isExpanded)
                                        Icon(
                                          Icons.sports_soccer,
                                          size: 28,
                                          color: championCode != null
                                              ? Colors.white.withValues(
                                                  alpha: 0.8,
                                                )
                                              : Colors.white.withValues(
                                                  alpha: 0.1,
                                                ),
                                        ),
                                      if (isExpanded) const SizedBox(height: 4),
                                      Text(
                                        championCode != null
                                            ? "CAMPEÃO 2026"
                                            : "SIMULADOR 2026",
                                        style: const TextStyle(
                                          color: AppColors.primaryGold,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black,
                                              blurRadius: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                background: Container(
                                  /* ... seu código de background atual ... */
                                ),
                              );
                            },
                          ),
                          bottom: const PreferredSize(
                            preferredSize: Size.fromHeight(48),
                            child: Center(
                              child: TabBar(
                                indicatorColor: AppColors.primaryGold,
                                labelColor: AppColors.primaryGold,
                                unselectedLabelColor: Colors.grey,
                                indicatorWeight: 3,
                                isScrollable: false,
                                labelPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                tabs: [
                                  Tab(
                                    text: "CALENDÁRIO",
                                    icon: Icon(Icons.calendar_today, size: 18),
                                  ),
                                  Tab(
                                    text: "GRUPOS",
                                    icon: Icon(Icons.group, size: 18),
                                  ),
                                  Tab(
                                    text: "TABELA",
                                    icon: Icon(Icons.table_chart, size: 18),
                                  ),
                                  Tab(
                                    text: "MATA-MATA",
                                    icon: Icon(Icons.emoji_events, size: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: state.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryGold,
                            ),
                          )
                        : state.matches.isEmpty
                        ? const Center(
                            child: Text(
                              "Nenhum jogo encontrado.",
                              style: TextStyle(color: Colors.white54),
                            ),
                          )
                        : TabBarView(
                            // Trava o scroll lateral se _canScrollTabs for falso
                            physics: _canScrollTabs
                                ? const BouncingScrollPhysics()
                                : const NeverScrollableScrollPhysics(),
                            children: [
                              _CalendarTab(matches: state.matches),
                              _MatchesTab(matches: state.matches),
                              _StandingsTab(matches: state.matches),
                              BracketView(
                                matches: BracketCalculator.populate(
                                  state.matches,
                                ),
                                // Quando o Mata-mata trava para mover, avisamos a página pai
                                onLockScroll: (isLocked) {
                                  setState(() {
                                    _canScrollTabs = !isLocked;
                                  });
                                },
                              ),
                            ],
                          ),
                  ),
                ),
                const BannerAdWidget(),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- Componentes auxiliares ---

class _CalendarTab extends StatelessWidget {
  final List<MatchEntity> matches;
  const _CalendarTab({required this.matches});

  @override
  Widget build(BuildContext context) {
    final groupMatches = matches
        .where(
          (m) => m.friendlyGroupName.startsWith('GRUPO'),
        ) // Filtra apenas os jogos de fase de grupos
        .toList();
    groupMatches.sort((a, b) => a.date.compareTo(b.date));
    final Map<String, List<MatchEntity>> groupedByDate = {};
    for (var match in groupMatches) {
      final dateStr =
          "${match.date.day.toString().padLeft(2, '0')}/${match.date.month.toString().padLeft(2, '0')}/${match.date.year}";
      if (!groupedByDate.containsKey(dateStr)) {
        groupedByDate[dateStr] = [];
      }
      groupedByDate[dateStr]!.add(match);
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: groupedByDate.length + 1,
      itemBuilder: (context, index) {
        if (index == groupedByDate.length) return const SizedBox(height: 50);
        final dateKey = groupedByDate.keys.elementAt(index);
        final dayMatches = groupedByDate[dateKey]!;

        final dayMatchIds = dayMatches.map((m) => m.id).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GroupHeader(
              icon: Icons.calendar_today,
              title: dateKey,
              showEdit: false,
              matchIds: dayMatchIds,
            ),
            ...dayMatches.map(
              (match) => _PremiumMatchCard(match: match),
            ), // Usa o mesmo card de jogo removi o .toList(),
          ],
        );
      },
    );
  }
}

class _MatchesTab extends StatelessWidget {
  final List<MatchEntity> matches;
  const _MatchesTab({required this.matches});

  @override
  Widget build(BuildContext context) {
    final matchesByGroup = _groupMatches(matches);
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: matchesByGroup.length + 1,
      itemBuilder: (context, index) {
        if (index == matchesByGroup.length) return const SizedBox(height: 50);
        final groupName = matchesByGroup.keys.elementAt(index);
        final groupMatches = matchesByGroup[groupName]!;
        final groupMatchIds = groupMatches.map((m) => m.id).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GroupHeader(
              title: groupName,
              showEdit: true,
              matchIds: groupMatchIds,
            ),
            ...groupMatches.map(
              (match) => _PremiumMatchCard(match: match),
            ), // Usa o mesmo card de jogo removi o .toList(),
          ],
        );
      },
    );
  }

  Map<String, List<MatchEntity>> _groupMatches(List<MatchEntity> matches) {
    final Map<String, List<MatchEntity>> grouped = {};
    for (var match in matches.where(
      (m) => m.friendlyGroupName.startsWith('GRUPO'),
    )) {
      // Filtra apenas os jogos de fase de grupos
      final key =
          match.friendlyGroupName; // Usa o nome amigável do grupo como chave
      if (!grouped.containsKey(key)) grouped[key] = [];
      grouped[key]!.add(match);
    }
    return Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }
}

class _StandingsTab extends StatelessWidget {
  final List<MatchEntity> matches;
  const _StandingsTab({required this.matches});

  @override
  Widget build(BuildContext context) {
    final groupMatches = matches
        .where((m) => m.group.startsWith('GRUPO'))
        .toList();

    final standingsMap = StandingsCalculator.calculate(groupMatches);
    final sortedGroups = standingsMap.keys.toList()..sort();

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: sortedGroups.length + 1,
      itemBuilder: (context, index) {
        if (index == sortedGroups.length) return const SizedBox(height: 50);
        final groupName = sortedGroups[index];
        final teams = standingsMap[groupName]!;
        return Column(
          children: [
            _GroupHeader(title: groupName, showEdit: false),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // CABEÇALHO COM TOOLTIPS
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                            child: Text(
                              "#",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              "SELEÇÃO",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          _TooltipHeader("P", "Pontos"),
                          _TooltipHeader("J", "Jogos"),
                          _TooltipHeader("V", "Vitórias"),
                          _TooltipHeader("E", "Empates"),
                          _TooltipHeader("D", "Derrotas"),
                          _TooltipHeader("GP", "Gols Pró"),
                          _TooltipHeader("GC", "Gols Contra"),
                          _TooltipHeader("SG", "Saldo de Gols"),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Colors.white10),

                    // LINHAS DOS TIMES
                    ...teams.asMap().entries.map((entry) {
                      final pos = entry.key + 1;
                      final team = entry.value;

                      return Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Text(
                                    "$pos",
                                    style: const TextStyle(
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: team.flag,
                                          width: 20,
                                          height: 20,
                                          fit: BoxFit.cover,
                                          errorWidget: (_, _, _) => const Icon(
                                            Icons.circle,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          team.teamName,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _StatCell(
                                  "${team.points}",
                                  color: AppColors.primaryGold,
                                  bold: true,
                                ),
                                _StatCell("${team.played}"),
                                _StatCell(
                                  "${team.won}",
                                  color: AppColors.successGreen,
                                ),
                                _StatCell(
                                  "${team.drawn}",
                                  color: Colors.white54,
                                ),
                                _StatCell(
                                  "${team.lost}",
                                  color: Colors.redAccent,
                                ),
                                _StatCell("${team.goalsFor}"),
                                _StatCell("${team.goalsAgainst}"),
                                _StatCell(
                                  "${team.goalDifference}",
                                  color: team.goalDifference > 0
                                      ? AppColors.successGreen
                                      : team.goalDifference < 0
                                      ? Colors.redAccent
                                      : Colors.white70,
                                ),
                              ],
                            ),
                          ),
                          if (pos <= 2)
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: Container(
                                  width: 3.5,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppColors.successGreen,
                                    borderRadius: const BorderRadius.horizontal(
                                      right: Radius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Widget do cabeçalho com tooltip
class _TooltipHeader extends StatelessWidget {
  final String label;
  final String tooltip;
  const _TooltipHeader(this.label, this.tooltip);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      triggerMode: TooltipTriggerMode.tap,
      decoration: BoxDecoration(
        color: AppColors.primaryGold,
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      child: SizedBox(
        width: 30,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.primaryGold,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}

// Widget de célula de estatística
class _StatCell extends StatelessWidget {
  final String value;
  final Color color;
  final bool bold;
  const _StatCell(this.value, {this.color = Colors.white70, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      child: Center(
        child: Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}

// CORREÇÃO: O _GroupHeader agora não pede allMatches
class _GroupHeader extends StatelessWidget {
  final String title;
  final bool showEdit;
  final List<String> matchIds;
  final IconData? icon;

  const _GroupHeader({
    required this.title,
    this.showEdit = true,
    this.matchIds = const [],
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Verifica se este grupo tem algum placeholder de repescagem
    final placeholders = RepescagemData.placeholdersNoGrupo(title);
    final bool canEdit = showEdit && placeholders.isNotEmpty;
    final bool canDice = matchIds.isNotEmpty;

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(top: 20, bottom: 5),
      color: Colors.white.withValues(alpha: 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppColors.primaryGold, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primaryGold,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primaryGold.withValues(alpha: 0.5),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (canEdit)
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.edit,
                      color: AppColors.primaryGold,
                      size: 20,
                    ),
                    onPressed: () =>
                        _showEditRepescagemDialog(context, placeholders),
                  ),
                if (canEdit && canDice)
                  Container(
                    width: 1,
                    height: 18,
                    color: AppColors.primaryGold.withValues(alpha: 0.3),
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                  ),
                if (canDice)
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.casino,
                      color: AppColors.primaryGold,
                      size: 20,
                    ),
                    onPressed: () => _showRandomDialog(context),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRandomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        title: const Text(
          'Gerar Placares Aleatórios?',
          style: TextStyle(
            color: AppColors.primaryGold,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Isso vai gerar placares aleatórios para todos os jogos de "$title".\n\nPalpites existentes serão substituídos.',
          style: const TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('CANCELAR', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGold,
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              final watched = await AdService.showRewarded();
              if (watched) {
                context.read<WorldCupBloc>().add(
                  GenerateRandomScoresEvent(matchIds: matchIds),
                );
              }
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.casino, color: Colors.black, size: 16),
                SizedBox(width: 6),
                Text(
                  'GERAR',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditRepescagemDialog(
    BuildContext context,
    List<String> placeholders,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "DEFINIR CLASSIFICADO DA REPESCAGEM",
              style: TextStyle(
                color: AppColors.primaryGold,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...placeholders.map((placeholder) {
              final options = RepescagemData.opcoes[placeholder] ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    placeholder,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final team = options[index];
                        return GestureDetector(
                          onTap: () {
                            // pegar a lista de jogos atual do estado Bloc
                            final currentMatches = context
                                .read<WorldCupBloc>()
                                .state
                                .matches;

                            // Encontra quem está atualmente na vaga atual da repescagem (placeholder)
                            // Começando assumindo que é o placeholder orginial (Ex: "VENCEDOR REPESCAGEM A"), mas se já tiver um time trocado, usamos ele
                            String teamToReplace = placeholder;
                            // Pegamos os nomes das opções para comparação
                            final nomesDasOpcoes = options
                                .map((t) => t['name']!)
                                .toList();

                            // Pegar apenas os nomes dos times que estão disponiveis para troca nessa vaga de repescagem
                            // se estiver, siginifica que ele é o time que deve ser substituído, e não o placeholder
                            for (var match in currentMatches) {
                              if (nomesDasOpcoes.contains(match.homeTeam)) {
                                // Verifica se o time da casa é o placeholder (ou seja, ainda não foi definido um time real para a vaga da repescagem)
                                // Encontramos o time que está atualmente ocupando a vaga da repescagem
                                teamToReplace = match
                                    .homeTeam; // Atualizamos o time a ser substituído para o nome real do time que está na vaga
                                break;
                              } else if (nomesDasOpcoes.contains(
                                match.awayTeam,
                              )) {
                                // Verifica se o time visitante é o placeholder
                                // Verificamos o outro lado do jogo, caso o time da repescagem esteja lá
                                teamToReplace = match
                                    .awayTeam; // Atualizamos o time a ser substituído para o nome real do time que está na vaga
                                break;
                              }
                            }
                            // Agora que temos o nome do time real que está ocupando a vaga da repescagem (ou o placeholder original se ainda não tiver sido definido), podemos disparar o evento de troca de time no Bloc, informando qual time deve ser substituído e qual é o novo time escolhido para ocupar a vaga da repescagem
                            context.read<WorldCupBloc>().add(
                              // DISPARA O EVENTO DE TROCA DE TIME, INFORMANDO QUAL TIME ESTÁ SENDO SUBSTITUÍDO (PODE SER O NOME DO TIME REAL OU O PLACEHOLDER ORIGINAL) E QUAL É O NOVO TIME ESCOLHIDO
                              SwapTeamEvent(
                                oldTeamName:
                                    teamToReplace, // Substituímos o placeholder ou o time atualmente na vaga
                                newTeamName:
                                    team['name']!, // O novo time escolhido para ocupar a vaga da repescagem
                                newTeamFlag:
                                    team['flag']!, // A bandeira do novo time escolhido
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    team['flag']!,
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  team['name']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }), // Fim do map dos placeholders removido o .toList()
          ],
        ),
      ),
    );
  }
}

class _PremiumMatchCard extends StatelessWidget {
  final MatchEntity match;
  const _PremiumMatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final bool hasPrediction = match.userHomePrediction != null;

    return GestureDetector(
      // 1. O clique chama a função abaixo
      onTap: () => _showPredictionDialog(context, match),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: hasPrediction
              ? Border.all(color: AppColors.primaryGold, width: 1.0)
              : Border.all(color: Colors.transparent),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TeamFlag(name: match.homeTeam, url: match.homeFlag),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      hasPrediction
                          ? "${match.userHomePrediction} - ${match.userAwayPrediction}"
                          : "VS",
                      style: TextStyle(
                        color: hasPrediction
                            ? AppColors.primaryGold
                            : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _TeamFlag(name: match.awayTeam, url: match.awayFlag),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.05,
                ), // Fundo levemente destacado para a área de informações mudei para withValues
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Text.rich(
                TextSpan(
                  // Estilo padrão para todos os textos dentro deste Text.rich
                  style: const TextStyle(color: Colors.white38, fontSize: 10),
                  children: [
                    // 1. Nome do Grupo
                    const WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.only(right: 4.0),
                        child: Icon(
                          Icons.group,
                          size: 12,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: match.friendlyGroupName,
                    ), // Nome do grupo removido a interpolação do número do grupo, pois já temos o nome amigável completo no match
                    // 2. Ícone de Calendário
                    const WidgetSpan(
                      alignment: PlaceholderAlignment
                          .middle, // Alinha o ícone com o centro do texto
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 16.0,
                          right: 4.0,
                        ), // Dá um espacinho entre o ícone e a data
                        child: Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.white38,
                        ),
                      ),
                    ),

                    // 3. Data e Horário)
                    TextSpan(
                      text:
                          "${match.date.day.toString().padLeft(2, '0')}/${match.date.month.toString().padLeft(2, '0')}/${match.date.year}   às ${match.date.hour.toString().padLeft(2, '0')}:${match.date.minute.toString().padLeft(2, '0')}",
                    ),

                    // 4. Ícone de Localização
                    const WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 4.0),
                        child: Icon(
                          Icons.location_on,
                          size: 12,
                          color: Colors.white38,
                        ),
                      ),
                    ),

                    // 5. Estádio e País (Ajuste com as variáveis corretas do seu match)
                    TextSpan(text: "${match.stadium}, ${match.country}"),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. A função completa do Modal de Palpite
  void _showPredictionDialog(BuildContext context, MatchEntity match) {
    final homeController = TextEditingController(
      text: match.userHomePrediction?.toString() ?? "0",
    );
    final awayController = TextEditingController(
      text: match.userAwayPrediction?.toString() ?? "0",
    );

    // 1. CRIAMOS UMA VARIÁVEL PARA O ERRO AQUI
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          void incrementScore(TextEditingController controller, int value) {
            int current = int.tryParse(controller.text) ?? 0;
            setModalState(() {
              controller.text = (current + value).toString();
              // 2. SE O USUÁRIO MEXER NO PLACAR, LIMPAMOS A MENSAGEM DE ERRO
              errorMessage = null;
            });
          }

          return AlertDialog(
            backgroundColor: AppColors.cardSurface,
            title: Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  "SIMULAR",
                  style: TextStyle(
                    color: AppColors.primaryGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.cleaning_services,
                      color: Colors.white38,
                      size: 20,
                    ),
                    onPressed: () {
                      setModalState(() {
                        homeController.text = "0";
                        awayController.text = "0";
                        errorMessage = null; // Limpa erro ao resetar
                      });
                    },
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFlagIcon(match.homeFlag),
                    const SizedBox(width: 10),
                    _ScoreInput(controller: homeController),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "X",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _ScoreInput(controller: awayController),
                    const SizedBox(width: 10),
                    _buildFlagIcon(match.awayFlag),
                  ],
                ),
                const SizedBox(height: 20),

                Text(
                  match.homeTeam.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: [1, 2, 3, 4]
                      .map(
                        (val) => _buildIncrementButton(
                          "+ $val",
                          () => incrementScore(homeController, val),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 15),

                Text(
                  match.awayTeam.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: [1, 2, 3, 4]
                      .map(
                        (val) => _buildIncrementButton(
                          "+ $val",
                          () => incrementScore(awayController, val),
                        ),
                      )
                      .toList(),
                ),

                // ==========================================
                // 3. CAIXA DE MENSAGEM DE ERRO DENTRO DO POP-UP
                // ==========================================
                if (errorMessage != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.redAccent.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                // ==========================================
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "CANCELAR",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                ),
                onPressed: () {
                  final h = int.tryParse(homeController.text);
                  final a = int.tryParse(awayController.text);

                  if (h != null && a != null) {
                    // ==========================================
                    // 4. REGRA DE NEGÓCIO: BLOQUEIA APENAS MATA-MATA
                    // ==========================================
                    if (match.isKnockout && h == a) {
                      setModalState(() {
                        errorMessage =
                            "Mata-mata não aceita empate! Informe o placar final (incluindo prorrogação/pênaltis).";
                      });
                      return; // Trava o fechamento do modal
                    }

                    context.read<WorldCupBloc>().add(
                      SavePredictionEvent(
                        matchId: match.id,
                        homeScore: h,
                        awayScore: a,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  "SALVAR",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Widget auxiliar para as bandeiras dentro do modal
  Widget _buildFlagIcon(String url) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        width: 32,
        height: 32,
        fit: BoxFit.cover,
        errorWidget: (_, _, _) => const Icon(Icons.flag, color: Colors.white24),
      ),
    );
  }

  // Widget auxiliar para os botões de +1, +2, etc
  Widget _buildIncrementButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white10),
          borderRadius: BorderRadius.circular(4),
          color: Colors.white.withValues(alpha: 0.05),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.primaryGold,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _TeamFlag extends StatelessWidget {
  final String name;
  final String url;
  const _TeamFlag({required this.name, required this.url});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: url,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => const Icon(Icons.flag),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 11),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

class _ScoreInput extends StatelessWidget {
  final TextEditingController controller;

  const _ScoreInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 20),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
