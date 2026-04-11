import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_theme.dart';
import '../../domain/entities/match_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/world_cup_bloc.dart';
import '../bloc/world_cup_event.dart';

class BracketView extends StatefulWidget {
  final List<MatchEntity> matches;
  final Function(bool)? onLockScroll; // mantido por compatibilidade de API

  const BracketView({super.key, required this.matches, this.onLockScroll});

  @override
  State<BracketView> createState() => _BracketViewState();
}

class _BracketViewState extends State<BracketView> {
  int _activePhaseIndex = 0;
  double _currentXOffset = 0.0;

  static const List<String> _phaseLabels = [
    '16-AVOS',
    'OITAVAS',
    'QUARTAS',
    'SEMI',
    'FINAL',
  ];

  // Controller próprio (primary: false) → não compete com o NestedScrollView
  final ScrollController _scrollController = ScrollController();

  // ── Dimensões ────────────────────────────────────────────────────────────
  final double cardWidth = 160.0;
  final double cardHeight = 60.0;
  final double connectorWidth = 50.0;
  final double r16Gap = 140.0;

  // Container 2000px, conteúdo (5×160 + 4×50) = 1000px → startX = 500
  static const double _containerWidth = 2000.0;
  static const double _startX = 500.0;

  // Overhead por coluna: header (~20dp) + SizedBox(20) + padding top/bottom (96dp) = 136dp
  static const double _columnOverhead = 180.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scrollToPhase(0);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ── Navega para a fase clicada ────────────────────────────────────────────
  void _scrollToPhase(int phaseIndex) {
    if (!mounted) return;
    final screenWidth = MediaQuery.of(context).size.width;
    final double columnCenterX =
        _startX + (phaseIndex * (cardWidth + connectorWidth)) + (cardWidth / 2);
    final double xOffset = (screenWidth / 2) - columnCenterX;

    // Volta ao topo ao trocar de fase
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }

    setState(() {
      _activePhaseIndex = phaseIndex;
      _currentXOffset = xOffset;
    });
  }

  int _getMatchNumber(String id) {
    final parts = id.split('_');
    if (parts.length > 1) return int.tryParse(parts.last) ?? 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final r32 =
        widget.matches
            .where((m) => m.group == 'R32' || m.id.startsWith('r32'))
            .toList()
          ..sort(
            (a, b) => _getMatchNumber(a.id).compareTo(_getMatchNumber(b.id)),
          );

    final r16 =
        widget.matches
            .where((m) => m.group == 'R16' || m.id.startsWith('r16'))
            .toList()
          ..sort(
            (a, b) => _getMatchNumber(a.id).compareTo(_getMatchNumber(b.id)),
          );

    final qf =
        widget.matches
            .where((m) => m.group == 'QF' || m.id.startsWith('qf'))
            .toList()
          ..sort(
            (a, b) => _getMatchNumber(a.id).compareTo(_getMatchNumber(b.id)),
          );

    final sf =
        widget.matches
            .where((m) => m.group == 'SF' || m.id.startsWith('sf'))
            .toList()
          ..sort(
            (a, b) => _getMatchNumber(a.id).compareTo(_getMatchNumber(b.id)),
          );

    final finals = widget.matches
        .where((m) => m.group == 'FINAL' || m.id.startsWith('final_'))
        .toList();

    // ── Altura do conteúdo (todas as fases têm a mesma altura) ───────────
    // R32: 16 jogos × (r16Gap/2=70dp) = 1120dp
    // R16: 8 × 140 = 1120dp, QF: 4×280 = 1120dp, SF: 2×560 = 1120dp
    // A coluna mais alta define a altura do Row → sempre ~1120dp + overhead
    final int r32Count = r32.isEmpty ? 16 : r32.length;
    final double bracketHeight = (r32Count * (r16Gap / 2)) + _columnOverhead;

    return Column(
      children: [
        // ── Barra de fases (sempre visível, fora do scroll) ───────────────
        _buildNavBar(),

        // ── Dica de scroll (sempre visível) ──────────────────────────────
        _buildScrollHint(),

        // ── Chaveamento ───────────────────────────────────────────────────
        // PROBLEMA ANTERIOR: InteractiveViewer e NestedScrollView competiam
        // pelos mesmos gestos verticais. O NestedScrollView "vencia" e travava
        // o scroll do chaveamento após colapsar a AppBar.
        //
        // SOLUÇÃO: SingleChildScrollView(primary: false) com ScrollController
        // próprio. Assim ele gerencia o scroll verticalmente de forma 100%
        // independente, sem interferir no NestedScrollView.
        //
        // Para o posicionamento horizontal das fases, usamos Transform.translate
        // (operação apenas de pintura, não afeta o layout) combinado com
        // OverflowBox (que libera o filho para 2000px de largura dentro de um
        // SizedBox menor) e ClipRect (que corta o overflow horizontal).
        //
        // O SizedBox com height=bracketHeight é ESSENCIAL: define o scroll
        // extent correto. Sem ele o SingleChildScrollView não sabe a altura
        // total e fica bloqueado, incapaz de rolar até os últimos jogos.
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double viewportWidth = constraints.maxWidth;

              return ClipRect(
                child: SingleChildScrollView(
                  primary: false,
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  child: SizedBox(
                    width: viewportWidth,
                    height: bracketHeight,
                    child: OverflowBox(
                      alignment: Alignment.topLeft,
                      maxWidth: _containerWidth,
                      minHeight: bracketHeight,
                      maxHeight: bracketHeight,
                      child: Transform.translate(
                        offset: Offset(_currentXOffset, 0),
                        child: SizedBox(
                          width: _containerWidth,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 80),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildRoundColumn("16-AVOS", r32, r16Gap / 2),
                                _buildConnectors(r32.length, r16Gap / 2),
                                _buildRoundColumn("OITAVAS", r16, r16Gap),
                                _buildConnectors(r16.length, r16Gap),
                                _buildRoundColumn("QUARTAS", qf, r16Gap * 2),
                                _buildConnectors(qf.length, r16Gap * 2),
                                _buildRoundColumn("SEMIFINAL", sf, r16Gap * 4),
                                _buildConnectors(sf.length, r16Gap * 4),
                                _buildRoundColumn(
                                  "FINAL",
                                  finals,
                                  r16Gap * 8,
                                  isFinal: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Barra de navegação de fases ───────────────────────────────────────────
  Widget _buildNavBar() {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(
        isLandscape ? 6 : 8,
        isLandscape ? 6 : 10,
        isLandscape ? 6 : 8,
        isLandscape ? 4 : 6,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _phaseLabels.length,
            (index) => _navButton(_phaseLabels[index], index),
          ),
        ),
      ),
    );
  }

  // ── Dica de scroll vertical ───────────────────────────────────────────────
  Widget _buildScrollHint() {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      color: AppColors.background,
      padding: EdgeInsets.only(bottom: isLandscape ? 4 : 8),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isLandscape ? 10 : 14,
            vertical: isLandscape ? 4 : 6,
          ),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryGold.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.swipe_vertical,
                color: AppColors.primaryGold,
                size: 16,
              ),
              SizedBox(width: 6),
              Text(
                isLandscape
                    ? "ARRASTE AS FASES  •  ROLE PARA VER JOGOS"
                    : "ROLE PARA VER TODOS OS JOGOS",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: isLandscape ? 9 : 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Botão de fase ─────────────────────────────────────────────────────────
  Widget _navButton(String label, int index) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final bool isActive = _activePhaseIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () => _scrollToPhase(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: isLandscape ? 12 : 14,
            vertical: isLandscape ? 7 : 8,
          ),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryGold : Colors.black87,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryGold,
              width: isActive ? 0 : 0.8,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primaryGold.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.black : AppColors.primaryGold,
              fontSize: isLandscape ? 10 : 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  // ── Coluna de uma rodada ──────────────────────────────────────────────────
  Widget _buildRoundColumn(
    String title,
    List<MatchEntity> matches,
    double gap, {
    bool isFinal = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primaryGold,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        ...matches.map(
          (match) => SizedBox(
            height: gap,
            child: Center(
              child: _BracketMatchCard(
                match: match,
                isFinal: isFinal,
                width: cardWidth,
                height: cardHeight,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Conectores entre colunas ──────────────────────────────────────────────
  Widget _buildConnectors(int count, double gap) {
    if (count == 0) return SizedBox(width: connectorWidth);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Espaço que alinha os conectores com os cards (header + SizedBox)
        const SizedBox(height: 36),
        SizedBox(
          width: connectorWidth,
          height: count * gap,
          child: CustomPaint(
            painter: BracketLinePainter(itemCount: count, gap: gap),
          ),
        ),
      ],
    );
  }
}

// ─── CARD DE JOGO ─────────────────────────────────────────────────────────────

class _BracketMatchCard extends StatelessWidget {
  final MatchEntity match;
  final bool isFinal;
  final double width;
  final double height;

  const _BracketMatchCard({
    required this.match,
    required this.isFinal,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPredictionDialog(context, match),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isFinal ? AppColors.primaryGold : AppColors.cardSurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _row(
              match.homeTeam,
              match.homeFlag,
              match.userHomePrediction,
              isFinal,
            ),
            const Divider(height: 8, color: Colors.white10),
            _row(
              match.awayTeam,
              match.awayFlag,
              match.userAwayPrediction,
              isFinal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String name, String flag, int? score, bool isFinal) {
    final color = isFinal ? Colors.black : Colors.white;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (name != "A Definir")
          ClipRRect(
            child: CachedNetworkImage(
              imageUrl: flag,
              width: 16,
              height: 10,
              fit: BoxFit.cover,
            ),
          ),
        if (name != "A Definir") const SizedBox(width: 4),
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          score?.toString() ?? "-",
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  void _showPredictionDialog(BuildContext context, MatchEntity match) {
    final homeController = TextEditingController(
      text: (match.userHomePrediction ?? 0).toString(),
    );
    final awayController = TextEditingController(
      text: (match.userAwayPrediction ?? 0).toString(),
    );

    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          void incrementScore(TextEditingController controller, int value) {
            int current = int.tryParse(controller.text) ?? 0;
            setModalState(() {
              controller.text = (current + value).toString();
              errorMessage = null;
            });
          }

          return AlertDialog(
            backgroundColor: AppColors.cardSurface,
            title: Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  "SIMULAR FASE",
                  style: TextStyle(
                    color: AppColors.primaryGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: () => setModalState(() {
                      homeController.text = "0";
                      awayController.text = "0";
                      errorMessage = null;
                    }),
                    child: const Icon(
                      Icons.cleaning_services,
                      color: Colors.white38,
                      size: 20,
                    ),
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
                    const SizedBox(width: 8),
                    _miniScoreInput(homeController),
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
                    _miniScoreInput(awayController),
                    const SizedBox(width: 8),
                    _buildFlagIcon(match.awayFlag),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  match.homeTeam.toUpperCase(),
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
                Wrap(
                  spacing: 4,
                  children: [1, 2, 3, 4]
                      .map(
                        (v) => _buildIncBtn(
                          "+ $v",
                          () => incrementScore(homeController, v),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  match.awayTeam.toUpperCase(),
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
                Wrap(
                  spacing: 4,
                  children: [1, 2, 3, 4]
                      .map(
                        (v) => _buildIncBtn(
                          "+ $v",
                          () => incrementScore(awayController, v),
                        ),
                      )
                      .toList(),
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
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
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("SAIR", style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                ),
                onPressed: () {
                  final h = int.tryParse(homeController.text);
                  final a = int.tryParse(awayController.text);
                  if (h != null && a != null) {
                    if (match.isKnockout && h == a) {
                      setModalState(() {
                        errorMessage =
                            "Mata-mata não aceita empate! Simule um vencedor (considere a prorrogação).";
                      });
                      return;
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

  Widget _buildFlagIcon(String url) => ClipOval(
    child: CachedNetworkImage(
      imageUrl: url,
      width: 24,
      height: 24,
      fit: BoxFit.cover,
      errorWidget: (_, _, _) => const Icon(Icons.flag, size: 20),
    ),
  );

  Widget _buildIncBtn(String label, VoidCallback onTap) => InkWell(
    onTap: onTap,
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
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  Widget _miniScoreInput(TextEditingController controller) => SizedBox(
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

// ─── PINTOR DE CONECTORES ─────────────────────────────────────────────────────

class BracketLinePainter extends CustomPainter {
  final int itemCount;
  final double gap;

  BracketLinePainter({required this.itemCount, required this.gap});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryGold.withValues(alpha: 0.4)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < itemCount; i += 2) {
      double y1 = (i * gap) + (gap / 2);
      double y2 = ((i + 1) * gap) + (gap / 2);
      double centerX = size.width / 2;
      double midY = (y1 + y2) / 2;

      final path = Path();
      path.moveTo(0, y1);
      path.lineTo(centerX, y1);
      path.lineTo(centerX, y2);
      path.moveTo(0, y2);
      path.lineTo(centerX, y2);
      path.moveTo(centerX, midY);
      path.lineTo(size.width, midY);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) => false;
}
