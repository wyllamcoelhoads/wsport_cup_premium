// lib/features/world_cup/presentation/pages/ball_detail_page.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/services/ad_service.dart';
import '../../../../core/widgets/banner_ad_widget.dart';
import '../widgets/premium_badge_sliver_app_bar.dart';
import '../widgets/stadium_web_browser.dart';

class BallDetailPage extends StatefulWidget {
  const BallDetailPage({super.key});

  @override
  State<BallDetailPage> createState() => _BallDetailPageState();
}

class _BallDetailPageState extends State<BallDetailPage> {
  int _selectedImageIndex = 0;

  static const List<String> _imageUrls = [
    'https://assets.adidas.com/images/w_600,f_auto,q_auto/4229e87f23044869a5218fbc64c4fd71_9366/Bola_Copa_do_Mundo_da_FIFA_26tm_Trionda_Pro_Branco_JD8021_HM1.jpg',
    'https://assets.adidas.com/images/w_600,f_auto,q_auto/b2564db734674535a463385a27124493_9366/Bola_Copa_do_Mundo_da_FIFA_26tm_Trionda_Pro_Branco_JD8021_HM3_hover.jpg',
    'https://assets.adidas.com/images/w_600,f_auto,q_auto/c3e76d9cbbd94d97bc29c7d27691ead8_9366/Bola_Copa_do_Mundo_da_FIFA_26tm_Trionda_Pro_Branco_JD8021_HM4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildQuickStats(),
                const SizedBox(height: 16),
                _buildDesignCard(),
                const SizedBox(height: 16),
                _buildTechCard(),
                const SizedBox(height: 16),
                _buildSpecsCard(),
                const SizedBox(height: 16),
                _buildHistoryCard(),
                const SizedBox(height: 16),
                _buildCommonGoalCard(),
                const SizedBox(height: 16),
                _buildBuyButton(),
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
  Widget _buildSliverAppBar() {
    return PremiumBadgeSliverAppBar(
      expandedHeight: 340,
      pinned: true,
      backgroundColor: AppColors.background,
      title: 'Bola Oficial 2026',
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
                AppColors.primaryGold.withValues(alpha: 0.15),
                AppColors.background,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Imagem principal
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: _imageUrls[_selectedImageIndex],
                    fit: BoxFit.contain,
                    placeholder: (_, _) => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGold,
                        strokeWidth: 2,
                      ),
                    ),
                    errorWidget: (_, _, _) => const Icon(
                      Icons.sports_soccer,
                      color: AppColors.primaryGold,
                      size: 80,
                    ),
                  ),
                ),
                // Miniaturas
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_imageUrls.length, (i) {
                      final isSelected = i == _selectedImageIndex;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedImageIndex = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isSelected ? 50 : 42,
                          height: isSelected ? 50 : 42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryGold
                                  : Colors.white12,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: CachedNetworkImage(
                              imageUrl: _imageUrls[i],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                // Nome e badges
                const Text(
                  'Trionda Pro',
                  style: TextStyle(
                    color: AppColors.primaryGold,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Bola Oficial • Copa do Mundo FIFA 2026™',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── QUICK STATS ──────────────────────────────────────────────────────────
  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          _stat('⭐', '4.9', '153 avaliações'),
          _divider(),
          _stat('🏅', 'FIFA', 'Quality Pro'),
          _divider(),
          _stat('⚽', 'Tam.', '5 oficial'),
          _divider(),
          _stat('🎨', '4', 'painéis'),
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
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 9),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 44, color: Colors.white10);

  // ─── DESIGN ───────────────────────────────────────────────────────────────
  Widget _buildDesignCard() {
    return _sectionCard(
      title: '🎨  DESIGN — TRIONDA',
      icon: Icons.palette_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1565C0).withValues(alpha: 0.15),
                  const Color(0xFFD32F2F).withValues(alpha: 0.10),
                  const Color(0xFF2E7D32).withValues(alpha: 0.10),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryGold.withValues(alpha: 0.25),
              ),
            ),
            child: const Text(
              '"Trionda" — inspirada na icônica "ola" dos estádios das Américas. O design fluido de quatro painéis mistura a estrela 🇺🇸, a folha de maple 🇨🇦 e a águia 🇲🇽 em ondas azuis, vermelhas e verdes representando os três países anfitriões.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _colorChip('🔵 Azul Solar', const Color(0xFF1E88E5)),
              const SizedBox(width: 8),
              _colorChip('🔴 Vermelho', const Color(0xFFD32F2F)),
              const SizedBox(width: 8),
              _colorChip('🟢 Verde Flash', const Color(0xFF2E7D32)),
            ],
          ),
          const SizedBox(height: 8),
          _colorChip('⚪ Branco Base', Colors.white38),
        ],
      ),
    );
  }

  Widget _colorChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color == Colors.white38 ? Colors.white54 : color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ─── TECNOLOGIA ───────────────────────────────────────────────────────────
  Widget _buildTechCard() {
    final techs = [
      {
        'icon': Icons.texture,
        'color': Colors.lightBlueAccent,
        'title': 'Superfície Texturizada',
        'desc':
            'Textura estrategicamente posicionada em relevo para trajetória mais previsível e precisão ideal durante o voo.',
      },
      {
        'icon': Icons.water_drop_outlined,
        'color': Colors.blue,
        'title': 'Baixa Absorção de Água',
        'desc':
            'Tecnologia de superfície que reduz a absorção de água, mantendo o peso e o comportamento da bola estáveis em campo.',
      },
      {
        'icon': Icons.link,
        'color': Colors.orange,
        'title': 'Liga Térmica Sem Costura',
        'desc':
            'Estrutura de liga térmica sem costuras para maior desempenho, durabilidade e consistência de formato.',
      },
      {
        'icon': Icons.verified,
        'color': AppColors.primaryGold,
        'title': 'FIFA Quality Pro',
        'desc':
            'A mais alta classificação da FIFA. Aprovada nos testes de peso, absorção de água, formato e retenção de tamanho.',
      },
    ];

    return _sectionCard(
      title: '⚡  TECNOLOGIA',
      icon: Icons.bolt,
      child: Column(
        children: techs.map((t) {
          final color = t['color'] as Color;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.15),
                  ),
                  child: Icon(t['icon'] as IconData, color: color, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t['title'] as String,
                        style: TextStyle(
                          color: color == AppColors.primaryGold
                              ? AppColors.primaryGold
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t['desc'] as String,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
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
    );
  }

  // ─── ESPECIFICAÇÕES ───────────────────────────────────────────────────────
  Widget _buildSpecsCard() {
    final specs = [
      ('Material', '100% Poliuretano'),
      ('Câmara', 'Butil de alta qualidade'),
      ('Estrutura', 'Liga térmica sem costura'),
      ('Certificação', 'FIFA Quality Pro'),
      ('Tamanho', '5 (oficial)'),
      ('Estado', 'Inflada'),
      ('Código', 'JD8021'),
      ('Cores', 'White / Solar Blue / Hi-Res Red / Flash Lime'),
    ];

    return _sectionCard(
      title: '📋  ESPECIFICAÇÕES TÉCNICAS',
      icon: Icons.list_alt_outlined,
      child: Column(
        children: specs.map((s) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.sports_soccer,
                  size: 13,
                  color: AppColors.primaryGold,
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: Text(
                    s.$1,
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ),
                Expanded(
                  child: Text(
                    s.$2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── HISTÓRICO DE BOLAS ───────────────────────────────────────────────────
  Widget _buildHistoryCard() {
    final balls = [
      (2026, 'Trionda Pro', true),
      (2022, 'Al Rihla', false),
      (2018, 'Telstar 18', false),
      (2014, 'Brazuca', false),
      (2010, 'Jabulani', false),
      (2006, 'Teamgeist', false),
      (2002, 'Fevernova', false),
    ];

    return _sectionCard(
      title: '⚽  BOLAS OFICIAIS DA HISTÓRIA',
      icon: Icons.history,
      child: Column(
        children: balls.map((b) {
          final isCurrent = b.$3;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isCurrent
                  ? AppColors.primaryGold.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isCurrent
                    ? AppColors.primaryGold.withValues(alpha: 0.5)
                    : Colors.white10,
              ),
            ),
            child: Row(
              children: [
                Text(
                  b.$1.toString(),
                  style: TextStyle(
                    color: isCurrent ? AppColors.primaryGold : Colors.white38,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    b.$2,
                    style: TextStyle(
                      color: isCurrent ? AppColors.primaryGold : Colors.white70,
                      fontSize: 13,
                      fontWeight: isCurrent
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (isCurrent)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGold,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '★ ATUAL',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── COMMON GOAL ──────────────────────────────────────────────────────────
  Widget _buildCommonGoalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.withValues(alpha: 0.12), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withValues(alpha: 0.15),
            ),
            child: const Icon(
              Icons.favorite_outline,
              color: Colors.greenAccent,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'adidas × Common Goal',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '1% das vendas líquidas globais de bolas de futebol é doado para apoiar comunidades locais que promovem inclusão e empoderamento através do esporte (até €1,5 milhão).',
                  style: TextStyle(
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
  }

  // ─── BOTÃO COMPRAR ────────────────────────────────────────────────────────
  Widget _buildBuyButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          // Mostra rewarded antes de abrir
          final watched = await AdService.showRewarded();
          if (!watched) return;
          if (!mounted) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => const StadiumWebBrowser(
                url:
                    'https://www.fifa.com/pt/tournaments/mens/worldcup/canadamexicousa2026/articles/bola-oficial-copa-mundo-26-trionda-pro-adidas',
                title: 'Adidas — Trionda Pro',
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryGold,
                AppColors.primaryGold.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info, color: Colors.black, size: 18),
              SizedBox(width: 10),
              Text(
                'Informações oficiais',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── HELPERS ──────────────────────────────────────────────────────────────
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
