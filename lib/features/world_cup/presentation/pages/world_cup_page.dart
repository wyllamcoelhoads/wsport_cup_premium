
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // JOGOS, TABELA, MATA-MATA
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 120.0,
                pinned: true,
                backgroundColor: AppColors.background,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  // Ajuste para o título não bater nas abas
                  titlePadding: const EdgeInsets.only(bottom: 50),
                  title: const Text(
                    "SIMULADOR 2026",
                    style: TextStyle(
                      color: AppColors.primaryGold,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  background: Container(
                    color: AppColors.background,
                    child: Center(
                      child: Icon(Icons.sports_soccer, 
                        size: 60, color: Colors.white.withOpacity(0.05)),
                    ),
                  ),
                ),
                bottom: const TabBar(
                  indicatorColor: AppColors.primaryGold,
                  labelColor: AppColors.primaryGold,
                  unselectedLabelColor: Colors.grey,
                  indicatorWeight: 3,
                  tabs: [
                    Tab(text: "JOGOS"),
                    Tab(text: "TABELA"),
                    Tab(text: "MATA-MATA"),
                  ],
                ),
              ),
            ];
          },
          body: BlocConsumer<WorldCupBloc, WorldCupState>(
            listener: (context, state) {
              if (state.successMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.successMessage!,
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    backgroundColor: AppColors.primaryGold,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primaryGold));
              }
              if (state.matches.isEmpty) {
                return const Center(child: Text("Nenhum jogo encontrado.", style: TextStyle(color: Colors.white54)));
              }

              return TabBarView(
                children: [
                  // ABA 1: Jogos
                  _MatchesTab(matches: state.matches),
                  // ABA 2: Tabela
                  _StandingsTab(matches: state.matches),
                  // ABA 3: Mata-Mata
                  BracketView(
                    matches: BracketCalculator.populate(state.matches),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// WIDGET DA ABA DE JOGOS
// =============================================================================
class _MatchesTab extends StatelessWidget {
  // CORREÇÃO: Tipagem adicionada <MatchEntity>
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
            // Header com Botão de Editar
            _GroupHeader(title: groupName),
            ...groupMatches.map((match) => _PremiumMatchCard(match: match)).toList(),
          ],
        );
      },
    );
  }

  Map<String, List<MatchEntity>> _groupMatches(List<MatchEntity> matches) {
    final Map<String, List<MatchEntity>> grouped = {};
    for (var match in matches) {
      final key = match.group;
      if (!grouped.containsKey(key)) grouped[key] = [];
      grouped[key]!.add(match);
    }
    return Map.fromEntries(grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  }
}

// =============================================================================
// WIDGET DA ABA DE CLASSIFICAÇÃO (TABELA)
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
            _GroupHeader(title: groupName), // Reutiliza o Header (sem edição aqui se preferir)
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Cabeçalho da Tabela
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      children: const [
                        SizedBox(width: 20, child: Text("#", style: TextStyle(color: Colors.grey, fontSize: 10))),
                        Expanded(child: Text("SELEÇÃO", style: TextStyle(color: Colors.grey, fontSize: 10))),
                        SizedBox(width: 30, child: Center(child: Text("P", style: TextStyle(color: AppColors.primaryGold, fontWeight: FontWeight.bold, fontSize: 12)))),
                        SizedBox(width: 30, child: Center(child: Text("J", style: TextStyle(color: Colors.grey, fontSize: 10)))),
                        SizedBox(width: 30, child: Center(child: Text("SG", style: TextStyle(color: Colors.grey, fontSize: 10)))),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Colors.white10),
                  // Linhas dos Times
                  ...teams.asMap().entries.map((entry) {
                    final pos = entry.key + 1;
                    final team = entry.value;
                    final isQualified = pos <= 2;

                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(
                        border: isQualified
                            ? const Border(left: BorderSide(color: AppColors.successGreen, width: 3))
                            : null,
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 20, child: Text("$pos", style: const TextStyle(color: Colors.white54))),
                          Expanded(
                            child: Row(
                              children: [
                                ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: team.flag, width: 20, height: 20, fit: BoxFit.cover,
                                    errorWidget: (_,__,___) => const Icon(Icons.circle, size: 20, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(team.teamName, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500))),
                              ],
                            ),
                          ),
                          SizedBox(width: 30, child: Center(child: Text("${team.points}", style: const TextStyle(color: AppColors.primaryGold, fontWeight: FontWeight.bold)))),
                          SizedBox(width: 30, child: Center(child: Text("${team.played}", style: const TextStyle(color: Colors.white70)))),
                          SizedBox(width: 30, child: Center(child: Text("${team.goalDifference}", style: const TextStyle(color: Colors.white70)))),
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

// CORREÇÃO: HEADER AGORA TEM BOTÃO DE EDITAR
class _GroupHeader extends StatelessWidget {
  final String title;
  const _GroupHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(top: 20, bottom: 5),
      color: Colors.white.withOpacity(0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title.toUpperCase(), style: const TextStyle(color: AppColors.primaryGold, fontWeight: FontWeight.w900, fontSize: 16)),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white38, size: 18),
            onPressed: () => _showEditGroupDialog(context, title),
            tooltip: "Editar Grupo",
          )
        ],
      ),
    );
  }

  void _showEditGroupDialog(BuildContext context, String groupName) {
    // 1. Pega os times atuais desse grupo através do Bloc
    final state = context.read<WorldCupBloc>().state;
    // Filtra jogos do grupo para extrair os nomes dos times únicos
    final groupMatches = state.matches.where((m) => m.group == groupName).toList();
    final Set<String> currentTeams = {};
    for (var m in groupMatches) {
      currentTeams.add(m.homeTeam);
      currentTeams.add(m.awayTeam);
    }

    // 2. Times disponíveis para entrar (Mock)
    final replacements = [
      {'name': 'Italy', 'flag': 'https://flagcdn.com/w320/it.png'},
      {'name': 'Sweden', 'flag': 'https://flagcdn.com/w320/se.png'},
      {'name': 'Chile', 'flag': 'https://flagcdn.com/w320/cl.png'},
      {'name': 'Nigeria', 'flag': 'https://flagcdn.com/w320/ng.png'},
      {'name': 'Egypt', 'flag': 'https://flagcdn.com/w320/eg.png'},
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.cardSurface,
          title: Text("Editar $groupName", style: const TextStyle(color: AppColors.primaryGold)),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Selecione quem sai:", style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 10),
                // Lista os times ATUAIS do grupo
                ...currentTeams.map((teamName) => ListTile(
                  dense: true,
                  title: Text(teamName, style: const TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.exit_to_app, color: Colors.redAccent, size: 20),
                  onTap: () {
                    Navigator.pop(ctx); // Fecha o primeiro dialog
                    _showReplacementDialog(context, teamName, replacements); // Abre o de escolha
                  },
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  // Segundo Dialog: Escolhe quem entra
  void _showReplacementDialog(BuildContext context, String oldTeam, List<Map<String, String>> replacements) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        title: Text("Substituir $oldTeam por:", style: const TextStyle(color: Colors.white, fontSize: 14)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: replacements.length,
            itemBuilder: (ctx, index) {
              final newTeam = replacements[index];
              return ListTile(
                leading: Image.network(newTeam['flag']!, width: 25),
                title: Text(newTeam['name']!, style: const TextStyle(color: AppColors.primaryGold)),
                onTap: () {
                  // AQUI A MÁGICA ACONTECE
                  context.read<WorldCupBloc>().add(
                    SwapTeamEvent(
                      oldTeamName: oldTeam,
                      newTeamName: newTeam['name']!,
                      newTeamFlag: newTeam['flag']!
                    )
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      hasPrediction
                          ? "${match.userHomePrediction} - ${match.userAwayPrediction}"
                          : "VS",
                      style: TextStyle(
                        color: hasPrediction ? AppColors.primaryGold : Colors.white,
                        fontSize: 18, fontWeight: FontWeight.bold,
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
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Text(
                "${match.date.day}/${match.date.month} • ${match.stadium}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white38, fontSize: 10),
              ),
            )
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
        title: const Center(child: Text("SIMULAR", style: TextStyle(color: AppColors.primaryGold))),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ScoreInput(controller: homeController),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("X", style: TextStyle(color: Colors.white))),
            _ScoreInput(controller: awayController),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCELAR", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGold),
            onPressed: () {
              final h = int.tryParse(homeController.text);
              final a = int.tryParse(awayController.text);
              if (h != null && a != null) {
                context.read<WorldCupBloc>().add(SavePredictionEvent(matchId: match.id, homeScore: h, awayScore: a));
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
            radius: 20, backgroundColor: Colors.transparent,
            child: ClipOval(
              child: CachedNetworkImage(imageUrl: url, width: 40, height: 40, fit: BoxFit.cover, errorWidget: (_,__,___) => const Icon(Icons.flag)),
            ),
          ),
          const SizedBox(height: 4),
          Text(name, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 11), maxLines: 1),
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
        controller: controller, keyboardType: TextInputType.number, textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 20),
        decoration: InputDecoration(
          filled: true, fillColor: Colors.black,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}