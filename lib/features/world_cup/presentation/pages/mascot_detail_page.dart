import 'package:flutter/material.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/services/ad_service.dart';
import '../../../../core/widgets/banner_ad_widget.dart';
import '../widgets/premium_badge_sliver_app_bar.dart';
import '../widgets/stadium_web_browser.dart';

class MascotDetailPage extends StatelessWidget {
  const MascotDetailPage({super.key});

  static const String _fifaUrl =
      'https://www.fifa.com/pt/tournaments/mens/worldcup/canadamexicousa2026/articles/mascotes-oficiais-copa-mundo-2026';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildIntroCard(),
                const SizedBox(height: 16),
                _buildMapleCard(),
                const SizedBox(height: 16),
                _buildZayuCard(),
                const SizedBox(height: 16),
                _buildClutchCard(),
                const SizedBox(height: 16),
                _buildFunFactsCard(),
                const SizedBox(height: 16),
                _buildFifaButton(context),
                const SizedBox(height: 20),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: BannerAdWidget()),
        ],
      ),
    );
  }

  // ─── SLIVER APP BAR ───────────────────────────────────────────────────────
  Widget _buildSliverAppBar(BuildContext context) {
    return PremiumBadgeSliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.background,
      title: 'Mascotes Oficiais 2026',
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
                const Color(0xFFF08080).withValues(alpha: 0.2),
                const Color(0xFF2E7D32).withValues(alpha: 0.15),
                const Color(0xFF3A7BD5).withValues(alpha: 0.15),
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
                const SizedBox(height: 8),
                // Trio de mascotes em emoji
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _mascotEmoji('🦌', 'Maple', const Color(0xFFF08080)),
                    const SizedBox(width: 16),
                    _mascotEmoji('🐆', 'Zayu', const Color(0xFF2E7D32)),
                    const SizedBox(width: 16),
                    _mascotEmoji('🦅', 'Clutch', const Color(0xFF3A7BD5)),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'MAPLE • ZAYU • CLUTCH',
                  style: TextStyle(
                    color: AppColors.primaryGold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Mascotes Oficiais • Copa do Mundo FIFA 2026™',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _countryBadge('🇨🇦', 'Canadá', const Color(0xFFF08080)),
                    const SizedBox(width: 8),
                    _countryBadge('🇲🇽', 'México', const Color(0xFF2E7D32)),
                    const SizedBox(width: 8),
                    _countryBadge('🇺🇸', 'EUA', const Color(0xFF3A7BD5)),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mascotEmoji(String emoji, String name, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.12),
            border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.25),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 32)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _countryBadge(String flag, String name, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(flag, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 5),
          Text(
            name,
            style: TextStyle(
              color: color.withValues(alpha: 0.9),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ─── INTRO ────────────────────────────────────────────────────────────────
  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGold.withValues(alpha: 0.12),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('🏆', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'O TIME DOS 26',
                  style: TextStyle(
                    color: AppColors.primaryGold,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Pela primeira vez na história, a Copa do Mundo conta com três mascotes oficiais — um para cada país-sede. Maple (Canadá), Zayu (México) e Clutch (EUA) formam o trio mais animado do Mundial.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.7),
          ),
          const SizedBox(height: 10),
          const Text(
            'Cada mascote carrega a identidade cultural, a fauna e o espírito de seu país, unidos pelo amor ao futebol.',
            style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.6),
          ),
        ],
      ),
    );
  }

  // ─── MAPLE ────────────────────────────────────────────────────────────────
  Widget _buildMapleCard() {
    return _mascotCard(
      name: 'MAPLE',
      emoji: '🦌',
      positionEmoji: '🧤',
      color: const Color(0xFFF08080),
      country: '🇨🇦 Canadá',
      animal: 'Alce',
      position: 'Goleiro — Camisa 1',
      description:
          'Maple nasceu para vagar, viajando por todas as províncias e territórios do Canadá. Artista de rua amante da música, ele é criativo, resiliente e tem um talento especial para fazer defesas lendárias.',
      nameOrigin:
          'Maple (bordo em inglês) é a árvore símbolo do Canadá — presente em sua bandeira e em toda a sua identidade nacional.',
      traits: [
        ('🎵', 'Artista', 'Amante do estilo urbano e da música'),
        ('🧤', 'Goleiro', 'Defesas lendárias sob pressão'),
        ('🌲', 'Natureza', 'Conectado à fauna e flora canadenses'),
        ('❤️', 'Coração', 'Liderança e força inabaláveis'),
      ],
    );
  }

  // ─── ZAYU ─────────────────────────────────────────────────────────────────
  Widget _buildZayuCard() {
    return _mascotCard(
      name: 'ZAYU',
      emoji: '🐆',
      positionEmoji: '⚽',
      color: const Color(0xFF2E7D32),
      country: '🇲🇽 México',
      animal: 'Onça-Pintada (Jaguar)',
      position: 'Atacante — Camisa 9',
      description:
          'Vindo das selvas do sul do México, Zayu personifica a rica herança e o espírito vibrante do país. Em campo, é um atacante ágil e criativo que intimida os defensores com sua velocidade.',
      nameOrigin:
          'Zayu vem do náuatle, língua dos astecas, e significa "jovem". O nome simboliza união, força e alegria — valores centrais da cultura mexicana.',
      traits: [
        ('🏃', 'Velocidade', 'Agilidade que intimida qualquer defesa'),
        ('💃', 'Cultura', 'Abraça dança, comida e tradição mexicana'),
        ('🌮', 'Identidade', 'Representante das civilizações pré-colombianas'),
        ('🎯', 'Criativo', 'Finalizações imprevisíveis e geniais'),
      ],
    );
  }

  // ─── CLUTCH ───────────────────────────────────────────────────────────────
  Widget _buildClutchCard() {
    return _mascotCard(
      name: 'CLUTCH',
      emoji: '🦅',
      positionEmoji: '🎮',
      color: const Color(0xFF3A7BD5),
      country: '🇺🇸 Estados Unidos',
      animal: 'Águia-Careca',
      position: 'Meio-Campo — Camisa 10',
      description:
          'Clutch possui uma sede insaciável por aventura, voando pelos Estados Unidos e abraçando todas as culturas do país. Como camisa 10, dita o ritmo do jogo e decide as partidas nos momentos mais importantes.',
      nameOrigin:
          '"Clutch" é uma expressão do esporte americano para descrever jogadores decisivos — aqueles que brilham quando a pressão é máxima.',
      traits: [
        ('🦅', 'Símbolo', 'A águia-careca é o animal nacional dos EUA'),
        ('🎯', 'Decisivo', 'Decide partidas nos momentos críticos'),
        ('🌍', 'Aventura', 'Explora a diversidade cultural americana'),
        ('👑', 'Liderança', 'Coragem, força e espírito coletivo'),
      ],
    );
  }

  Widget _mascotCard({
    required String name,
    required String emoji,
    required String positionEmoji,
    required Color color,
    required String country,
    required String animal,
    required String position,
    required String description,
    required String nameOrigin,
    required List<(String, String, String)> traits,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.15),
                    border: Border.all(
                      color: color.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: color,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        animal,
                        style: TextStyle(
                          color: color.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            country,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                          const Text(
                            '  •  ',
                            style: TextStyle(color: Colors.white24),
                          ),
                          Text(
                            '$positionEmoji $position',
                            style: TextStyle(
                              color: color.withValues(alpha: 0.8),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Conteúdo
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 14),
                // Origem do nome
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('📖', style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Origem do nome',
                              style: TextStyle(
                                color: color,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              nameOrigin,
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                // Traits grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 2.6,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: traits.map((t) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: color.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Text(t.$1, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              t.$2,
                              style: TextStyle(
                                color: color,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── CURIOSIDADES ─────────────────────────────────────────────────────────
  Widget _buildFunFactsCard() {
    final facts = [
      (
        '🏆',
        'Primeira vez com trio',
        'Pela primeira vez desde 2002 (Japão/Coreia), a Copa tem mais de um mascote — e pela primeira vez, são três.',
      ),
      (
        '🎮',
        'Mascotes jogáveis',
        'Maple, Zayu e Clutch são personagens jogáveis no FIFA Heroes, jogo de futebol de cinco da FIFA.',
      ),
      (
        '🌎',
        'Representação cultural',
        'Alce (Canadá), onça-pintada (México) e águia-careca (EUA) são animais simbólicos de cada nação anfitriã.',
      ),
      (
        '⚽',
        'Time completo',
        'Juntos formam um time: Maple no gol (camisa 1), Zayu no ataque (camisa 9) e Clutch no meio (camisa 10).',
      ),
      (
        '👕',
        'Uniformes oficiais',
        'Cada mascote usa as cores da seleção de seu país: vermelho (Canadá), verde (México) e azul (EUA).',
      ),
    ];

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
                const Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.primaryGold,
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  '💡  CURIOSIDADES',
                  style: TextStyle(
                    color: AppColors.primaryGold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: facts.map((f) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(f.$1, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              f.$2,
                              style: const TextStyle(
                                color: AppColors.primaryGold,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              f.$3,
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ─── BOTÃO FIFA ───────────────────────────────────────────────────────────
  Widget _buildFifaButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final watched = await AdService.showRewarded();
          if (!watched) return;
          if (!context.mounted) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => const StadiumWebBrowser(
                url: _fifaUrl,
                title: 'Maple, Zayu & Clutch — FIFA Oficial',
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF08080), Color(0xFF2E7D32), Color(0xFF3A7BD5)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGold.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🌟', style: TextStyle(fontSize: 18)),
              SizedBox(width: 10),
              Text(
                'Ver na FIFA Oficial',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.open_in_new, color: Colors.white70, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
