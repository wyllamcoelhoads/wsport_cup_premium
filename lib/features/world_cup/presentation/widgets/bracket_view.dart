import 'package:flutter/material.dart';
import '../../../../core/constants/app_theme.dart';
import '../../domain/entities/match_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Certifique de importar o bloc no topo do arquivo se necessário
import '../bloc/world_cup_bloc.dart';
import '../bloc/world_cup_event.dart';

class BracketView extends StatefulWidget {
  final List<MatchEntity> matches;
  // Callback para avisar o pai (Tabs) para travar/destravar o scroll
  final Function(bool)? onLockScroll;

  const BracketView({super.key, required this.matches, this.onLockScroll});

  @override
  State<BracketView> createState() => _BracketViewState();
}

class _BracketViewState extends State<BracketView> {
  late TransformationController _transformationController;
  bool _isInteractive = false;

  final double cardWidth = 160.0;
  final double connectorWidth = 50.0;
  final double r16Gap = 100.0;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  void _toggleInteractivity() {
    setState(() {
      _isInteractive = !_isInteractive;
    });

    // IMPORTANTE: Avisa o pai para travar as Tabs
    if (widget.onLockScroll != null) {
      widget.onLockScroll!(_isInteractive);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isInteractive
              ? "Modo Exploração: Arraste e Zoom liberados"
              : "Modo Fixo: Navegação entre abas liberada",
        ),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        GestureDetector(
          onDoubleTap: _toggleInteractivity,
          behavior:
              HitTestBehavior.opaque, // Impede o toque de passar para a TabBar
          child: InteractiveViewer(
            transformationController: _transformationController,
            constrained: false,
            panEnabled: _isInteractive, // Só move se estiver ativo
            scaleEnabled: _isInteractive,
            minScale: 0.1,
            maxScale: 3.0,
            boundaryMargin: const EdgeInsets.all(200),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
              child: Row(
                children: [
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
                boxShadow: [
                  if (_isInteractive)
                    BoxShadow(
                      color: AppColors.primaryGold.withOpacity(0.3),
                      blurRadius: 10,
                    ),
                ],
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

  // ... (Mantenha _buildRoundColumn, _buildConnectors, _BracketMatchCard e BracketLinePainter)
  // Certifique-se de copiar as funções auxiliares do código anterior.
  //altura fixa para o card para facilitar o cálculo do centro
  final double cardHeight = 60.0;
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
            // O Container externo ocupa o 'gap' total (espaço entre os centros)
            height: isFinal ? null : gap,
            alignment: Alignment.center,
            child: _BracketMatchCard(
              match: match,
              isFinal: isFinal,
              width: cardWidth,
              height: cardHeight, // Passamos a altura fixa
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
}

// --- Card com Altura Fixa ---
// --- Card Interativo no Mata-Mata ---
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
    // 1. Envolvemos o card com GestureDetector no BracketView também
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

  // 2. Diálogo adaptado para o BracketView
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
            "SIMULAR FASE",
            style: TextStyle(color: AppColors.primaryGold),
          ),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _miniScoreInput(homeController),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("X", style: TextStyle(color: Colors.white)),
            ),
            _miniScoreInput(awayController),
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

// --- Painter Ajustado para o Centro ---
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
      // O cálculo (i * gap) + (gap / 2) encontra o centro exato do container do card
      double y1 = (i * gap) + (gap / 2);
      double y2 = ((i + 1) * gap) + (gap / 2);
      double centerX = size.width / 2;
      double midY = (y1 + y2) / 2;

      final path = Path();

      // Linha horizontal saindo do centro do Card Superior
      path.moveTo(0, y1);
      path.lineTo(centerX, y1);

      // Linha vertical conectando os dois
      path.lineTo(centerX, y2);

      // Linha horizontal saindo do centro do Card Inferior
      path.moveTo(0, y2);
      path.lineTo(centerX, y2);

      // Linha de saída para a próxima fase (exatamente no meio dos dois cards)
      path.moveTo(centerX, midY);
      path.lineTo(size.width, midY);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) => false;
}
