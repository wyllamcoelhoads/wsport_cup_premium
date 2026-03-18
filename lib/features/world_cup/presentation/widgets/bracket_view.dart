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
      // BÔNUS: Em vez de usar Matrix4.identity() que desalinha a tela,
      // forçamos o alinhamento de volta para a primeira coluna (32-avos)
      // preservando a posição vertical que o usuário estava!
      _scrollToPhase(0);
    }

    if (widget.onLockScroll != null) {
      widget.onLockScroll!(_isInteractive);
    }
  }

  // Função para navegar até a fase desejada
  // Função para navegar até a fase desejada com alinhamento perfeito
  void _scrollToPhase(int phaseIndex) {
    // 1. Pega a largura do ecrã do telemóvel
    final screenWidth = MediaQuery.of(context).size.width;

    // 2. Matemática do layout:
    // O Container tem 2000 de largura.
    // O conteúdo total (cards + conectores) tem 1000.
    // Como está centralizado, o conteúdo começa na coordenada X = 500.
    const double startX = 600;

    // 3. Acha o centro exato da coluna clicada
    final double columnCenterX =
        startX + (phaseIndex * (cardWidth + connectorWidth)) + (cardWidth / 2);

    // 4. Calcula o movimento para alinhar o centro da coluna com o centro do ecrã
    final double xOffset = (screenWidth / 2) - columnCenterX;

    // 5. Preserva a posição vertical atual (para a tela não saltar para cima do nada)
    final currentY = _transformationController.value.getTranslation().y;

    setState(() {
      _transformationController.value = Matrix4.identity()
        ..translateByDouble(
          xOffset,
          currentY,
          0,
          0,
        ); // Aplica o deslocamento horizontal e mantém o vertical
    });
  }

  int _getMatchNumber(String id) {
    final parts = id.split('_');
    if (parts.length > 1) {
      return int.tryParse(parts.last) ?? 0;
    }
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
        // Visualizador Interativo
        GestureDetector(
          onDoubleTap: _toggleInteractivity,
          behavior: HitTestBehavior.opaque,
          child: InteractiveViewer(
            transformationController: _transformationController,
            constrained: false,
            panEnabled: true,
            scaleEnabled: _isInteractive,
            panAxis: _isInteractive ? PanAxis.free : PanAxis.vertical,
            minScale: 0.5,
            maxScale: 2.0,

            // Margens para garantir que o utilizador consiga arrastar um pouco além dos limites
            boundaryMargin: const EdgeInsets.symmetric(
              horizontal: 1000,
              vertical:
                  400, // Reduzido para evitar que a tela se perca no vazio
            ),

            child: Container(
              width: 2000,

              // 1. REMOVEMOS A ALTURA FIXA (height)! O Flutter vai calcular a altura perfeita automaticamente.

              // 2. O RESPIRO EXATO:
              // top: 160 -> Empurra o chaveamento só o suficiente para começar logo abaixo da barra de botões.
              // bottom: 100 -> Dá um espacinho no final para a última chave não ficar colada à borda do ecrã.
              padding: const EdgeInsets.only(top: 160, bottom: 100),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // O Flutter já centraliza verticalmente os elementos da Row de forma automática!
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
        ...matches.map(
          (match) {
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
          },
        ), // Mapeia cada partida para um card, com espaçamento definido pelo gap removi o .toList()
      ],
    );
  }

  Widget _buildConnectors(int count, double gap) {
    if (count == 0) return SizedBox(width: connectorWidth);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 1. O TÍTULO FANTASMA:
        // Tem o mesmo tamanho da fonte (16) para ocupar o mesmo espaço no topo e empurrar as linhas para baixo.
        const Text(
          " ",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ), // O mesmo espaçamento que existe embaixo dos títulos
        // 2. AS LINHAS:
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

    // 1. Variável de erro
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          void incrementScore(TextEditingController controller, int value) {
            int current = int.tryParse(controller.text) ?? 0;
            setModalState(() {
              controller.text = (current + value).toString();
              errorMessage =
                  null; // Limpa o erro quando o usuário muda o placar
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
                      errorMessage = null; // Limpa o erro ao resetar
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
                    _miniScoreInput(
                      homeController,
                    ), // Usando o nome correto daqui
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
                    _miniScoreInput(
                      awayController,
                    ), // Usando o nome correto daqui
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
                          // Usando o nome correto daqui
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
                          // Usando o nome correto daqui
                          "+ $v",
                          () => incrementScore(awayController, v),
                        ),
                      )
                      .toList(),
                ),

                // ==========================================
                // CAIXA DE MENSAGEM DE ERRO
                // ==========================================
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

                // ==========================================
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
                    // REGRA FIFA: Checa se é mata-mata e está empatado
                    if (match.isKnockout && h == a) {
                      setModalState(() {
                        errorMessage =
                            "Mata-mata não aceita empate! Simule um vencedor (considere a prorrogação).";
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
