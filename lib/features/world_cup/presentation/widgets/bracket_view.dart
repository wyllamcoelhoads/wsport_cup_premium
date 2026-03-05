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
  bool _isInteractive = false;

  // Variáveis de layout todas centralizadas dentro do State
  final double cardWidth = 160.0;
  final double cardHeight = 60.0; // Trazido para dentro da classe
  final double connectorWidth = 50.0;
  final double r16Gap = 140.0; // Aumentado para os cards da R32 não sobreporem

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  void _toggleInteractivity() {
    setState(() {
      _isInteractive = !_isInteractive;
    });

    if (!_isInteractive) {
      _transformationController.value = Matrix4.identity();
    }

    if (widget.onLockScroll != null) {
      widget.onLockScroll!(_isInteractive);
    }
  }

  // Função para navegar até a fase desejada
  void _scrollToPhase(int phaseIndex) {
    double xOffset = phaseIndex * (cardWidth + connectorWidth);

    setState(() {
      _transformationController.value = Matrix4.identity()
        ..translate(-xOffset + 20.0); // +20 para margem na esquerda
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Filtragem das fases (Adicionando R32 para Copa 2026)
    final r32 = widget.matches
        .where((m) => m.group == 'R32' || m.id.startsWith('r32'))
        .toList();
    final r16 = widget.matches
        .where((m) => m.group == 'R16' || m.id.startsWith('r16'))
        .toList();
    final qf = widget.matches
        .where((m) => m.group == 'QF' || m.id.startsWith('qf'))
        .toList();
    final sf = widget.matches
        .where((m) => m.group == 'SF' || m.id.startsWith('sf'))
        .toList();
    final finals = widget.matches.where((m) => m.group == 'FINAL').toList();

    return Stack(
      children: [
        // Visualizador Interativo
        GestureDetector(
          onDoubleTap: _toggleInteractivity,
          behavior: HitTestBehavior.opaque,
          child: InteractiveViewer(
            transformationController: _transformationController,
            constrained: false,
            panEnabled: _isInteractive,
            scaleEnabled: _isInteractive,
            minScale: 0.5,
            maxScale: 2.0,
            boundaryMargin: const EdgeInsets.symmetric(
              horizontal: 1000,
              vertical: 800,
            ),
            child: Container(
              width: 2000, // Espaço horizontal suficiente
              height:
                  1400, // Altura suficiente para os 16 jogos da fase 32-avos
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRoundColumn("32-AVOS", r32, r16Gap / 2),
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
        ),

        // Barra de Navegação
        Positioned(
          top: 80,
          left: 0,
          right: 0,
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _navButton("32-AVOS", 0),
                  _navButton("OITAVAS", 1),
                  _navButton("QUARTAS", 2),
                  _navButton("SEMI", 3),
                  _navButton("FINAL", 4),
                ],
              ),
            ),
          ),
        ),

        // Badge de Instrução
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _isInteractive ? AppColors.primaryGold : Colors.black87,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: AppColors.primaryGold),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isInteractive ? Icons.zoom_out_map : Icons.touch_app,
                    color: _isInteractive
                        ? Colors.black
                        : AppColors.primaryGold,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isInteractive
                        ? "EXPLORAÇÃO ATIVA"
                        : "DUPLO CLIQUE PARA MOVER",
                    style: TextStyle(
                      color: _isInteractive ? Colors.black : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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

  // Widgets auxiliares AGORA DENTRO DA CLASSE _BracketViewState
  Widget _navButton(String label, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ActionChip(
        backgroundColor: Colors.black87,
        side: const BorderSide(color: AppColors.primaryGold, width: 0.5),
        label: Text(
          label,
          style: const TextStyle(
            color: AppColors.primaryGold,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () => _scrollToPhase(index),
      ),
    );
  }

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
        ...matches.map((match) {
          return Container(
            height: isFinal ? null : gap,
            alignment: Alignment.center,
            child: _BracketMatchCard(
              match: match,
              isFinal: isFinal,
              width: cardWidth,
              height: cardHeight,
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildConnectors(int count, double gap) {
    if (count == 0) return SizedBox(width: connectorWidth);
    return SizedBox(
      width: connectorWidth,
      height: count * gap,
      child: CustomPaint(
        painter: BracketLinePainter(itemCount: count, gap: gap),
      ),
    );
  }
} // FIM DA CLASSE _BracketViewState

// --- Classes Independentes (Stateless e Painter) ---

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
            _row(match.homeTeam, match.userHomePrediction, isFinal),
            const Divider(height: 8, color: Colors.white10),
            _row(match.awayTeam, match.userAwayPrediction, isFinal),
          ],
        ),
      ),
    );
  }

  Widget _row(String name, int? score, bool isFinal) {
    final color = isFinal ? Colors.black : Colors.white;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
    final homeController = TextEditingController();
    final awayController = TextEditingController();

    homeController.text = (match.userHomePrediction ?? 0).toString();
    awayController.text = (match.userAwayPrediction ?? 0).toString();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          void incrementScore(TextEditingController controller, int value) {
            int current = int.tryParse(controller.text) ?? 0;
            setModalState(() => controller.text = (current + value).toString());
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
                  children: [1, 2, 3]
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
                  children: [1, 2, 3]
                      .map(
                        (v) => _buildIncBtn(
                          "+ $v",
                          () => incrementScore(awayController, v),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("VOLTAR"),
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
                child: const Text(
                  "SALVAR",
                  style: TextStyle(color: Colors.black),
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
      errorWidget: (_, __, ___) => const Icon(Icons.flag, size: 20),
    ),
  );

  Widget _buildIncBtn(String label, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(4),
        color: Colors.white.withOpacity(0.05),
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

  Widget _miniScoreInput(TextEditingController controller) {
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

class BracketLinePainter extends CustomPainter {
  final int itemCount;
  final double gap;

  BracketLinePainter({required this.itemCount, required this.gap});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryGold.withOpacity(0.4)
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
