import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wsports_cup_premium/features/world_cup/presentation/bloc/world_cup_event.dart';
import '../../../../core/constants/app_theme.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/logic/bracket_calculator.dart';
import '../../domain/logic/standings_calculator.dart';
import '../bloc/world_cup_bloc.dart';
import '../bloc/world_cup_state.dart';
import '../widgets/bracket_view.dart';

class WorldCupPage extends StatelessWidget {
  const WorldCupPage({super.key});

  String? _getChampionCode(List<MatchEntity> matches) {
    try {
      final finalMatch = matches.firstWhere((m) => m.id == 'final');
      if (finalMatch.userHomePrediction != null &&
          finalMatch.userAwayPrediction != null) {
        String winnerFlagUrl = '';
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorldCupBloc, WorldCupState>(
      listener: (context, state) {
        if (state.successMessage != null) {
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
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final String? championCode = _getChampionCode(
          BracketCalculator.populate(state.matches),
        );

        return DefaultTabController(
          length: 4, // <-- AGORA SÃO 4 ABAS
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  // ... dentro do seu NestedScrollView headerSliverBuilder
                  SliverAppBar(
                    expandedHeight:
                        200.0, // Aumentei um pouco para caber melhor os dois elementos
                    pinned: true,
                    backgroundColor: AppColors.background,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      titlePadding: const EdgeInsets.only(
                        bottom: 60,
                      ), // Espaço para a TabBar não cobrir o título
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ÍCONE DE BOLA CENTRALIZADO
                          Icon(
                            Icons.sports_soccer,
                            size: 40,
                            color: championCode != null
                                ? Colors.white.withOpacity(0.8)
                                : Colors.white.withOpacity(0.1),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            championCode != null
                                ? "CAMPEÃO 2026"
                                : "SIMULADOR 2026",
                            style: const TextStyle(
                              color: AppColors.primaryGold,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          image: championCode != null
                              ? DecorationImage(
                                  image: AssetImage(
                                    'assets/images/champions/$championCode.jpg',
                                  ),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.4),
                                    BlendMode.darken,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    bottom: const PreferredSize(
                      preferredSize: Size.fromHeight(48),
                      child: Center(
                        // Centraliza a TabBar horizontalmente
                        child: TabBar(
                          indicatorColor: AppColors.primaryGold,
                          labelColor: AppColors.primaryGold,
                          unselectedLabelColor: Colors.grey,
                          indicatorWeight: 3,
                          isScrollable:
                              false, // <-- MUDADO PARA FALSE PARA CENTRALIZAR
                          labelPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                          ), // Ajuste fino do respiro
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
                      children: [
                        // ABA 1: Calendário (Por Data)
                        _CalendarTab(matches: state.matches),
                        // ABA 2: Grupos (Por Grupo)
                        _MatchesTab(matches: state.matches),
                        // ABA 3: Tabela
                        _StandingsTab(matches: state.matches),
                        // ABA 4: Mata-Mata
                        BracketView(
                          matches: BracketCalculator.populate(state.matches),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// NOVA ABA: CALENDÁRIO (Agrupa por Data)
// =============================================================================
class _CalendarTab extends StatelessWidget {
  final List<MatchEntity> matches;

  const _CalendarTab({required this.matches});

  @override
  Widget build(BuildContext context) {
    // Filtra apenas jogos da fase de grupos para o calendário principal
    final groupMatches = matches
        .where((m) => m.group.startsWith('GROUP'))
        .toList();

    // Ordena todos os jogos por data
    groupMatches.sort((a, b) => a.date.compareTo(b.date));

    // Agrupa pela String da data (Ex: "11/06")
    final Map<String, List<MatchEntity>> groupedByDate = {};
    for (var match in groupMatches) {
      final dateStr =
          "${match.date.day.toString().padLeft(2, '0')}/${match.date.month.toString().padLeft(2, '0')}";
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GroupHeader(
              title: "DATA: $dateKey",
              showEdit: false,
            ), // Header sem lápis
            ...dayMatches
                .map((match) => _PremiumMatchCard(match: match))
                .toList(),
          ],
        );
      },
    );
  }
}

// =============================================================================
// ABA 2: GRUPOS (Antiga Aba Jogos)
// =============================================================================
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GroupHeader(title: groupName, showEdit: true), // Header com lápis
            ...groupMatches
                .map((match) => _PremiumMatchCard(match: match))
                .toList(),
          ],
        );
      },
    );
  }

  Map<String, List<MatchEntity>> _groupMatches(List<MatchEntity> matches) {
    final Map<String, List<MatchEntity>> grouped = {};
    // Filtra apenas jogos da fase de grupos
    for (var match in matches.where((m) => m.group.startsWith('GROUP'))) {
      final key = match.group;
      if (!grouped.containsKey(key)) grouped[key] = [];
      grouped[key]!.add(match);
    }
    return Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }
}

// =============================================================================
// ABA 3: CLASSIFICAÇÃO (TABELA)
// =============================================================================
class _StandingsTab extends StatelessWidget {
  final List<MatchEntity> matches;

  const _StandingsTab({required this.matches});

  @override
  Widget build(BuildContext context) {
    final standingsMap = StandingsCalculator.calculate(matches);
    final sortedGroups = standingsMap.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedGroups.length + 1,
      itemBuilder: (context, index) {
        if (index == sortedGroups.length) return const SizedBox(height: 50);

        final groupName = sortedGroups[index];
        final teams = standingsMap[groupName]!;

        return Column(
          children: [
            _GroupHeader(title: groupName, showEdit: false),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 20,
                          child: Text(
                            "#",
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "SELEÇÃO",
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                          child: Center(
                            child: Text(
                              "P",
                              style: TextStyle(
                                color: AppColors.primaryGold,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                          child: Center(
                            child: Text(
                              "J",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                          child: Center(
                            child: Text(
                              "SG",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  ...teams.asMap().entries.map((entry) {
                    final pos = entry.key + 1;
                    final team = entry.value;
                    final isQualified = pos <= 2;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        border: isQualified
                            ? const Border(
                                left: BorderSide(
                                  color: AppColors.successGreen,
                                  width: 3,
                                ),
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            child: Text(
                              "$pos",
                              style: const TextStyle(color: Colors.white54),
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
                                    errorWidget: (_, __, ___) => const Icon(
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
                          SizedBox(
                            width: 30,
                            child: Center(
                              child: Text(
                                "${team.points}",
                                style: const TextStyle(
                                  color: AppColors.primaryGold,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            child: Center(
                              child: Text(
                                "${team.played}",
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            child: Center(
                              child: Text(
                                "${team.goalDifference}",
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}

// =============================================================================
// COMPONENTES REUTILIZÁVEIS
// =============================================================================

class _GroupHeader extends StatelessWidget {
  final String title;
  final bool
  showEdit; // Adicionado para esconder o lápis no calendário e tabela

  const _GroupHeader({required this.title, this.showEdit = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(top: 20, bottom: 5),
      color: Colors.white.withOpacity(0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppColors.primaryGold,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          if (showEdit)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white38, size: 18),
              onPressed: () => _showEditGroupDialog(context, title),
              tooltip: "Editar Grupo",
            ),
        ],
      ),
    );
  }

  void _showEditGroupDialog(BuildContext context, String groupName) {
    final state = context.read<WorldCupBloc>().state;
    final groupMatches = state.matches
        .where((m) => m.group == groupName)
        .toList();
    final Set<String> currentTeams = {};
    for (var m in groupMatches) {
      currentTeams.add(m.homeTeam);
      currentTeams.add(m.awayTeam);
    }

    final replacements = [
      {'name': 'Italy', 'flag': 'https://flagcdn.com/w320/it.png'},
      {'name': 'Sweden', 'flag': 'https://flagcdn.com/w320/se.png'},
      {'name': 'Chile', 'flag': 'https://flagcdn.com/w320/cl.png'},
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.cardSurface,
          title: Text(
            "Editar $groupName",
            style: const TextStyle(color: AppColors.primaryGold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Selecione quem sai:",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 10),
                ...currentTeams.map(
                  (teamName) => ListTile(
                    dense: true,
                    title: Text(
                      teamName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(
                      Icons.exit_to_app,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _showReplacementDialog(context, teamName, replacements);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReplacementDialog(
    BuildContext context,
    String oldTeam,
    List<Map<String, String>> replacements,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        title: Text(
          "Substituir $oldTeam por:",
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: replacements.length,
            itemBuilder: (ctx, index) {
              final newTeam = replacements[index];
              return ListTile(
                leading: Image.network(newTeam['flag']!, width: 25),
                title: Text(
                  newTeam['name']!,
                  style: const TextStyle(color: AppColors.primaryGold),
                ),
                onTap: () {
                  context.read<WorldCupBloc>().add(
                    SwapTeamEvent(
                      oldTeamName: oldTeam,
                      newTeamName: newTeam['name']!,
                      newTeamFlag: newTeam['flag']!,
                    ),
                  );
                  Navigator.pop(ctx);
                },
              );
            },
          ),
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
                color: Colors.white.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Text(
                "${match.group} • ${match.date.day.toString().padLeft(2, '0')}/${match.date.month.toString().padLeft(2, '0')} • ${match.stadium}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white38, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPredictionDialog(BuildContext context, MatchEntity match) {
    final homeController = TextEditingController();
    final awayController = TextEditingController();

    if (match.userHomePrediction != null) {
      homeController.text = match.userHomePrediction.toString();
      awayController.text = match.userAwayPrediction.toString();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        title: const Center(
          child: Text(
            "SIMULAR",
            style: TextStyle(color: AppColors.primaryGold),
          ),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ScoreInput(controller: homeController),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("X", style: TextStyle(color: Colors.white)),
            ),
            _ScoreInput(controller: awayController),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCELAR", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGold,
            ),
            onPressed: () {
              final h = int.tryParse(homeController.text);
              final a = int.tryParse(awayController.text);
              if (h != null && a != null) {
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
            child: const Text("SALVAR", style: TextStyle(color: Colors.black)),
          ),
        ],
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
                errorWidget: (_, __, ___) => const Icon(Icons.flag),
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
