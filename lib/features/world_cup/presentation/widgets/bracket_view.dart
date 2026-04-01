import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_theme.dart';
import '../../domain/entities/match_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/world_cup_bloc.dart';
import '../bloc/world_cup_event.dart';

class BracketView extends StatefulWidget {
  final List<MatchEntity> matches;
  final Function(bool)? onLockScroll;

  const BracketView({super.key, required this.matches, this.onLockScroll});

  @override
  State<BracketView> createState() => _BracketViewState();
}

class _BracketViewState extends State<BracketView> {
  late TransformationController _transformationController;

  // Índice da fase atualmente visível (para highlight do botão ativo)
  int _activePhaseIndex = 0;

  // Variáveis de layout centralizadas
  final double cardWidth = 160.0;
  final double cardHeight = 60.0;
  final double connectorWidth = 50.0;
  final double r16Gap = 140.0;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();

    // ─── CORREÇÃO PRINCIPAL ───────────────────────────────────────────────────
    // Agenda a navegação para o primeiro frame após o widget ser montado.
    // Sem isso, o controller fica em (0,0) e a tela aparece preta porque
    // o conteúdo está centralizado dentro de um container de 2000px.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scrollToPhase(0);
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  // ─── NAVEGAÇÃO HORIZONTAL (SOMENTE VIA BOTÕES) ────────────────────────────
  void _scrollToPhase(int phaseIndex) {
    if (!mounted) return;

    final screenWidth = MediaQuery.of(context).size.width;

    // O container tem 2000px de largura e o conteúdo fica centralizado.
    // startX = 600 é o ponto onde o primeiro card começa (margem do center).
    const double startX = 600;

    final double columnCenterX =
        startX + (phaseIndex * (cardWidth + connectorWidth)) + (cardWidth / 2);

    final double xOffset = (screenWidth / 2) - columnCenterX;

    // Preserva a posição vertical atual para não pular para o topo
    final currentY = _transformationController.value.getTranslation().y;

    setState(() {
      _activePhaseIndex = phaseIndex;
      _transformationController.value = Matrix4.translationValues(
        xOffset,
        currentY,
        0,
      );
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

    return Stack(
      children: [
        // ─── CHAVEAMENTO (scroll apenas VERTICAL, horizontal via botões) ──────
        InteractiveViewer(
          transformationController: _transformationController,
          constrained: false,
          // ► PAN HORIZONTAL DESABILITADO — apenas vertical para ver todos os jogos
          panAxis: PanAxis.vertical,
          panEnabled: true, //
          scaleEnabled: false, // zoom desabilitado para simplicidade
          boundaryMargin: const EdgeInsets.symmetric(
            horizontal: 2000,
            vertical: 1400, //
          ),
          child: Container(
            width: 2000,
            padding: const EdgeInsets.only(top: 100, bottom: 400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRoundColumn("16-AVOS", r32, r16Gap / 2),
                _buildConnectors(r32.length, r16Gap / 2),
                _buildRoundColumn("OITAVAS", r16, r16Gap),
                _buildConnectors(r16.length, r16Gap),
                _buildRoundColumn("QUARTAS", qf, r16Gap * 2),
                _buildConnectors(qf.length, r16Gap * 2),
                _buildRoundColumn("SEMIFINAL", sf, r16Gap * 4),
                _buildConnectors(sf.length, r16Gap * 4),
                _buildRoundColumn("FINAL", finals, 0, isFinal: true),
              ],
            ),
          ),
        ),

        // ─── BARRA DE NAVEGAÇÃO POR FASE ─────────────────────────────────────
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _navButton("16-AVOS", 0),
                  _navButton("OITAVAS", 1),
                  _navButton("QUARTAS", 2),
                  _navButton("SEMI", 3),
                  _navButton("FINAL", 4),
                ],
              ),
            ),
          ),
        ),

        // ─── DICA DE SCROLL VERTICAL ─────────────────────────────────────────
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryGold.withValues(alpha: 0.4),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.swipe_vertical,
                    color: AppColors.primaryGold,
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Text(
                    "ROLE PARA VER TODOS OS JOGOS",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── BOTÃO DE NAVEGAÇÃO ───────────────────────────────────────────────────
  Widget _navButton(String label, int index) {
    final bool isActive = _activePhaseIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () => _scrollToPhase(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  // ─── COLUNA DE UMA RODADA ────────────────────────────────────────────────
  Widget _buildRoundColumn(
    String title,
    List<MatchEntity> matches,
    double gap, {
    bool isFinal = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
          (match) => Container(
            height: isFinal ? null : gap,
            alignment: Alignment.center,
            child: _BracketMatchCard(
              match: match,
              isFinal: isFinal,
              width: cardWidth,
              height: cardHeight,
            ),
          ),
        ),
      ],
    );
  }

  // ─── CONECTORES ──────────────────────────────────────────────────────────
  Widget _buildConnectors(int count, double gap) {
    if (count == 0) return SizedBox(width: connectorWidth);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          " ",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
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
