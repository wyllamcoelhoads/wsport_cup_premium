// lib/features/info/presentation/pages/team_detail_page.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_theme.dart';

import '../../domain/entities/team_info_entity.dart';
import '../../data/repositories/team_info_repository.dart';

class TeamDetailPage extends StatefulWidget {
  /// ID do documento no Firestore (ex: 'br', 'ar', 'de')
  final String teamId;

  /// Nome de exibição para mostrar enquanto carrega
  final String teamName;

  /// Flag code para mostrar enquanto carrega
  final String flagCode;

  const TeamDetailPage({
    super.key,
    required this.teamId,
    required this.teamName,
    required this.flagCode,
  });

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  final _repo = TeamInfoRepository();
  TeamInfoEntity? _team;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTeam();
  }

  Future<void> _loadTeam() async {
    try {
      final team = await _repo.getTeamById(widget.teamId);
      if (mounted) {
        setState(() {
          _team = team;
          _loading = false;
          _error = team == null ? 'Informações ainda não disponíveis.' : null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Erro ao carregar dados: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _loading
          ? _buildLoader()
          : _error != null
          ? _buildError()
          : _buildContent(),
    );
  }

  // ─── LOADER ───────────────────────────────────────────────────────────────
  Widget _buildLoader() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primaryGold,
            strokeWidth: 2.5,
          ),
          const SizedBox(height: 16),
          Text(
            'Carregando ${widget.teamName}...',
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ─── ERROR ────────────────────────────────────────────────────────────────
  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: 'https://flagcdn.com/w160/${widget.flagCode}.png',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.teamName,
              style: const TextStyle(
                color: AppColors.primaryGold,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                    size: 28,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _error!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() => _loading = true);
                      _loadTeam();
                    },
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Tentar novamente'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGold,
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                '← Voltar',
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── MAIN CONTENT ─────────────────────────────────────────────────────────
  Widget _buildContent() {
    final t = _team!;
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(t),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Bio
              if (t.bio != null && t.bio!.isNotEmpty) ...[
                _bioCard(t.bio!),
                const SizedBox(height: 16),
              ],

              // Stats rápidos
              _quickStats(t),
              const SizedBox(height: 16),

              // Treinador & Capitão
              _staffCard(t),
              const SizedBox(height: 16),

              // Uniformes
              _uniformsCard(t),
              const SizedBox(height: 16),

              // Histórico de Copas
              _worldCupHistoryCard(t),
              const SizedBox(height: 16),

              // Títulos
              if (t.worldCupWins > 0) ...[
                _titlesCard(t),
                const SizedBox(height: 16),
              ],
            ]),
          ),
        ),
      ],
    );
  }

  // ─── SLIVER APP BAR ───────────────────────────────────────────────────────
  Widget _buildSliverAppBar(TeamInfoEntity t) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.primaryGold,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryGold.withValues(alpha: 0.18),
                AppColors.background,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Brasão
                _buildCoatOfArms(t),
                const SizedBox(height: 14),
                // Nome
                Text(
                  t.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                // Apelido + Confederação
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (t.nickname.isNotEmpty)
                      Text(
                        '"${t.nickname}"',
                        style: const TextStyle(
                          color: AppColors.primaryGold,
                          fontSize: 12,
                        ),
                      ),
                    if (t.nickname.isNotEmpty)
                      const Text(
                        '  •  ',
                        style: TextStyle(color: Colors.white24),
                      ),
                    Text(
                      t.confederation,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoatOfArms(TeamInfoEntity t) {
    final hasCoat =
        t.coatOfArmsUrl.isNotEmpty && t.coatOfArmsUrl.startsWith('http');
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.cardSurface,
            border: Border.all(
              color: AppColors.primaryGold.withValues(alpha: 0.6),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGold.withValues(alpha: 0.2),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipOval(
            child: hasCoat
                ? CachedNetworkImage(
                    imageUrl: t.coatOfArmsUrl,
                    fit: BoxFit.contain,
                    placeholder: (_, _) => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGold,
                        strokeWidth: 1.5,
                      ),
                    ),
                    errorWidget: (_, _, _) => _flagFallback(t.flagCode),
                  )
                : _flagFallback(t.flagCode),
          ),
        ),
        // Bandeira pequena como overlay
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.background, width: 2),
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: 'https://flagcdn.com/w80/${t.flagCode}.png',
              fit: BoxFit.cover,
              errorWidget: (_, _, _) =>
                  const Icon(Icons.flag, size: 14, color: Colors.white38),
            ),
          ),
        ),
      ],
    );
  }

  Widget _flagFallback(String flagCode) {
    return CachedNetworkImage(
      imageUrl: 'https://flagcdn.com/w160/$flagCode.png',
      fit: BoxFit.cover,
      errorWidget: (_, _, _) =>
          const Icon(Icons.shield, color: AppColors.primaryGold, size: 40),
    );
  }

  // ─── BIO ──────────────────────────────────────────────────────────────────
  Widget _bioCard(String bio) {
    return _card(
      child: Text(
        bio,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          height: 1.6,
        ),
      ),
    );
  }

  // ─── QUICK STATS ──────────────────────────────────────────────────────────
  Widget _quickStats(TeamInfoEntity t) {
    return _card(
      child: Row(
        children: [
          _stat('🏆', t.worldCupWins.toString(), 'Títulos'),
          _divider(),
          _stat('⚽', t.worldCupAppearances.toString(), 'Copas'),
          _divider(),
          _stat('🌍', '#${t.fifaRanking}', 'FIFA Ranking'),
          _divider(),
          _stat('📅', t.founded.toString(), 'Fundação'),
        ],
      ),
    );
  }

  Widget _stat(String emoji, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primaryGold,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 44, color: Colors.white10);

  // ─── STAFF: TREINADOR & CAPITÃO ───────────────────────────────────────────
  Widget _staffCard(TeamInfoEntity t) {
    return _sectionCard(
      title: '👨‍💼  COMISSÃO TÉCNICA & ELENCO',
      icon: Icons.people_outline,
      child: Row(
        children: [
          Expanded(
            child: _staffTile(
              icon: Icons.sports,
              label: 'Treinador',
              value: t.coach,
              color: Colors.lightBlueAccent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _staffTile(
              icon: Icons.emoji_events_outlined,
              label: 'Capitão',
              value: t.captain,
              color: AppColors.primaryGold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _staffTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 15),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // ─── UNIFORMES ────────────────────────────────────────────────────────────
  Widget _uniformsCard(TeamInfoEntity t) {
    final hasHome = t.uniformHomeUrl.isNotEmpty;
    final hasAway = t.uniformAwayUrl.isNotEmpty;

    return _sectionCard(
      title: '👕  UNIFORMES OFICIAIS',
      icon: Icons.checkroom_outlined,
      child: Row(
        children: [
          Expanded(
            child: _uniformTile(
              label: 'TITULAR',
              imageUrl: hasHome ? t.uniformHomeUrl : null,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _uniformTile(
              label: 'RESERVA',
              imageUrl: hasAway ? t.uniformAwayUrl : null,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _uniformTile({
    required String label,
    required String? imageUrl,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          height:
              200, // altura fixa para manter consistência visual, mesmo que a imagem falhe
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl != null
                ? Padding(
                    // ✅ Adicione padding interno para a imagem não encostar nas bordas
                    padding: const EdgeInsets.all(2),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (_, _) => const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryGold,
                          strokeWidth:
                              1.5, // Reduzi o strokeWidth para combinar melhor com o espaço disponível
                        ),
                      ),
                      errorWidget: (_, _, _) => _uniformPlaceholder(color),
                    ),
                  )
                : _uniformPlaceholder(color),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _uniformPlaceholder(Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.checkroom, color: color.withValues(alpha: 0.4), size: 40),
        const SizedBox(height: 8),
        Text(
          'Em breve',
          style: TextStyle(color: color.withValues(alpha: 0.4), fontSize: 11),
        ),
      ],
    );
  }

  // ─── HISTÓRICO DE COPAS ───────────────────────────────────────────────────
  Widget _worldCupHistoryCard(TeamInfoEntity t) {
    return _sectionCard(
      title: '🌍  PARTICIPAÇÕES NA COPA DO MUNDO',
      icon: Icons.sports_soccer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${t.worldCupAppearances} participação${t.worldCupAppearances != 1 ? 's' : ''}',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          if (t.worldCupYears.isEmpty)
            const Text(
              'Histórico não disponível.',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: t.worldCupYears.map((year) {
                final isTitle = t.worldCupTitlesYears.contains(year);
                final isCurrent = year == 2026;
                return _yearChip(year, isTitle: isTitle, isCurrent: isCurrent);
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _yearChip(int year, {required bool isTitle, required bool isCurrent}) {
    Color bg, border, text;

    if (isTitle) {
      bg = AppColors.primaryGold.withValues(alpha: 0.2);
      border = AppColors.primaryGold.withValues(alpha: 0.8);
      text = AppColors.primaryGold;
    } else if (isCurrent) {
      bg = Colors.lightBlueAccent.withValues(alpha: 0.1);
      border = Colors.lightBlueAccent.withValues(alpha: 0.5);
      text = Colors.lightBlueAccent;
    } else {
      bg = Colors.white.withValues(alpha: 0.04);
      border = Colors.white12;
      text = Colors.white54;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isTitle) const Text('🏆 ', style: TextStyle(fontSize: 11)),
          if (isCurrent && !isTitle)
            const Text('⚽ ', style: TextStyle(fontSize: 11)),
          Text(
            year.toString(),
            style: TextStyle(
              color: text,
              fontSize: 12,
              fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // ─── TÍTULOS ──────────────────────────────────────────────────────────────
  Widget _titlesCard(TeamInfoEntity t) {
    return _sectionCard(
      title: '🏆  TÍTULOS MUNDIAIS',
      icon: Icons.emoji_events,
      child: Column(
        children: [
          // Troféus
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              t.worldCupWins,
              (_) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text('🏆', style: TextStyle(fontSize: 28)),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Anos dos títulos
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: t.worldCupTitlesYears
                .map(
                  (year) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryGold.withValues(alpha: 0.3),
                          AppColors.primaryGold.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primaryGold.withValues(alpha: 0.7),
                      ),
                    ),
                    child: Text(
                      year.toString(),
                      style: const TextStyle(
                        color: AppColors.primaryGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  // ─── HELPERS ──────────────────────────────────────────────────────────────
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }

  Widget _sectionCard({
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
              color: AppColors.primaryGold.withValues(alpha: 0.07),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primaryGold, size: 16),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primaryGold,
                    fontSize: 12,
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
}
