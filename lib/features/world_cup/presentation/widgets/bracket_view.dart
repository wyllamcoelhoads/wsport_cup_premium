import 'package:flutter/material.dart';

import '../../../../core/constants/app_theme.dart';
import '../../domain/entities/match_entity.dart';

class BracketView extends StatelessWidget {
  final List<MatchEntity> matches;

  const BracketView({super.key, required this.matches});

  @override
  Widget build(BuildContext context) {
    // Separa os jogos por fase
    final r16 = matches
        .where((m) => m.group == 'R16' || m.id.startsWith('r16'))
        .toList();
    final qf = matches
        .where((m) => m.group == 'QF' || m.id.startsWith('qf'))
        .toList();
    final sf = matches
        .where((m) => m.group == 'SF' || m.id.startsWith('sf'))
        .toList();
    final finals = matches.where((m) => m.group == 'FINAL').toList();

    // INTERACTIVE VIEWER: O segredo para responsividade e zoom
    return InteractiveViewer(
      // CORREÇÃO CRÍTICA 1: Scroll infinito
      constrained: false,
      boundaryMargin: const EdgeInsets.all(400), // Margem gigante para navegar
      minScale: 0.1,
      maxScale: 4.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // CORREÇÃO CRÍTICA 2: Aumentei o espaçamento vertical (heightFactor)
            _buildRoundColumn(
              "OITAVAS",
              r16,
              180,
            ), // Antes era 140, muito apertado
            _buildConnectors(r16.length, 180),

            _buildRoundColumn("QUARTAS", qf, 360), // Dobro de 180
            _buildConnectors(qf.length, 360),

            _buildRoundColumn("SEMIFINAL", sf, 720), // Dobro de 360
            _buildConnectors(sf.length, 720),

            _buildRoundColumn("FINAL", finals, 0, isFinal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundColumn(
    String title,
    List<MatchEntity> matches,
    double heightFactor, {
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
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 30),
        ...matches.map((match) {
          return Container(
            // Altura fixa para garantir alinhamento das linhas
            height: isFinal ? null : heightFactor,
            alignment: Alignment.center,
            child: _BracketMatchCard(match: match, isFinal: isFinal),
          );
        }).toList(),
      ],
    );
  }

  // Desenha as linhas de conexão
  Widget _buildConnectors(int count, double heightFactor) {
    if (count == 0)
      return const SizedBox(width: 50); // Espaço se não tiver linha
    return SizedBox(
      width: 60, // Largura da linha
      height: count * heightFactor,
      child: CustomPaint(
        painter: BracketLinePainter(itemCount: count, gap: heightFactor),
      ),
    );
  }
}

// --- CARD MINIMALISTA PARA O CHAVEAMENTO ---
class _BracketMatchCard extends StatelessWidget {
  final MatchEntity match;
  final bool isFinal;

  const _BracketMatchCard({required this.match, this.isFinal = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isFinal ? AppColors.primaryGold : AppColors.cardSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          if (isFinal)
            BoxShadow(
              color: AppColors.primaryGold.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 5,
            ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _teamRow(match.homeTeam, match.homeFlag, match.userHomePrediction),
          const Divider(height: 8, color: Colors.black26),
          _teamRow(match.awayTeam, match.awayFlag, match.userAwayPrediction),
          if (isFinal) ...[
            const SizedBox(height: 4),
            const Text(
              "CAMPEÃO",
              style: TextStyle(
                color: Colors.black,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _teamRow(String name, String flag, int? score) {
    final textColor = isFinal ? Colors.black : Colors.white;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            score?.toString() ?? "-",
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

// --- PINTOR DE LINHAS (A MÁGICA VISUAL) ---
class BracketLinePainter extends CustomPainter {
  final int itemCount;
  final double gap;

  BracketLinePainter({required this.itemCount, required this.gap});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Lógica simplificada para conectar pares (1 e 2, 3 e 4...)
    // Assumindo que a coluna tem pares perfeitos
    for (int i = 0; i < itemCount; i += 2) {
      // Pontos Y dos cards
      // Esse cálculo é aproximado para alinhar com os containers acima
      // Ajuste fino pode ser necessário dependendo do tamanho exato dos cards
      double startY1 = (i * gap) + (gap / 2);
      double startY2 = ((i + 1) * gap) + (gap / 2);

      double midY = (startY1 + startY2) / 2;

      // Desenha o "Conector" |--|
      final path = Path();
      path.moveTo(0, startY1);
      path.lineTo(size.width / 2, startY1);
      path.lineTo(size.width / 2, startY2);
      path.lineTo(0, startY2);

      // Linha saindo para o próximo round
      path.moveTo(size.width / 2, midY);
      path.lineTo(size.width, midY);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
