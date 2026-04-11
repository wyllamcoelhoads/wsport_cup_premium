import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wsports_cup_premium/core/constants/app_theme.dart';
import 'package:wsports_cup_premium/core/services/ad_service.dart';
import '../../premium/pages/premium_page.dart';

/// 🌟 SliverAppBar reutilizável com Badge Premium
/// Similar ao PremiumBadgeAppBar, mas para CustomScrollView/SliverAppBar
/// Perfeito para páginas com expandable headers (Team Detail, Ball Detail, etc)
///
/// Uso:
/// ```dart
/// CustomScrollView(
///   slivers: [
///     PremiumBadgeSliverAppBar(
///       expandedHeight: 240,
///       title: 'Time Selecionado',
///       flexibleSpace: ...,
///     ),
///     // Resto do conteúdo
///   ],
/// )
/// ```
class PremiumBadgeSliverAppBar extends StatefulWidget {
  final double expandedHeight;
  final String title;
  final Widget? flexibleSpace;
  final List<Widget>? actions;
  final Widget? leading;
  final bool pinned;
  final bool floating;
  final bool snap;
  final double elevation;
  final Color backgroundColor;
  final IconThemeData? iconTheme;

  /// Callback opcional quando o status premium muda
  final Function(bool isPremium)? onPremiumStatusChanged;

  const PremiumBadgeSliverAppBar({
    required this.expandedHeight,
    required this.title,
    this.flexibleSpace,
    this.actions,
    this.leading,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.elevation = 0,
    this.backgroundColor = AppColors.background,
    this.iconTheme,
    this.onPremiumStatusChanged,
    super.key,
  });

  @override
  State<PremiumBadgeSliverAppBar> createState() =>
      _PremiumBadgeSliverAppBarState();
}

class _PremiumBadgeSliverAppBarState extends State<PremiumBadgeSliverAppBar> {
  bool _isPremium = AdService.isPremium;
  Timer? _statusCheckTimer;

  @override
  void initState() {
    super.initState();
    _updatePremiumStatus();
    // 🔄 Sincroniza status a cada 2 segundos
    _statusCheckTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _updatePremiumStatus(),
    );
  }

  @override
  void dispose() {
    _statusCheckTimer?.cancel();
    super.dispose();
  }

  void _updatePremiumStatus() {
    if (mounted) {
      final newStatus = AdService.isPremium;
      final statusChanged = _isPremium != newStatus;

      setState(() {
        _isPremium = newStatus;
      });

      // 📊 Dispara callback se status mudou
      if (statusChanged && widget.onPremiumStatusChanged != null) {
        widget.onPremiumStatusChanged!(_isPremium);
      }
    }
  }

  void _navigateToPremium() {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PremiumPage()),
      ).then((_) {
        // 🔄 Atualiza status quando volta da PremiumPage
        _updatePremiumStatus();
      });
    } catch (e) {
      debugPrint('❌ Erro ao navegar para Premium: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Não foi possível abrir Premium'),
            backgroundColor: Colors.red.shade600,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: widget.expandedHeight,
      pinned: widget.pinned,
      floating: widget.floating,
      snap: widget.snap,
      elevation: widget.elevation,
      backgroundColor: widget.backgroundColor,
      iconTheme: widget.iconTheme,
      leading: widget.leading,
      title: Text(
        widget.title,
        style: const TextStyle(
          color: AppColors.primaryGold,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      flexibleSpace: widget.flexibleSpace,
      actions: [
        // 🌟 Badge Premium
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Center(
            child: Tooltip(
              message: _isPremium
                  ? 'Você é Premium! 🎉'
                  : 'Clique para fazer upgrade',
              child: GestureDetector(
                onTap: _navigateToPremium,
                child: Stack(
                  children: [
                    // Ícone de estrela
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: FaIcon(
                        FontAwesomeIcons.star,
                        color: AppColors.primaryGold,
                        size: 22,
                      ),
                    ),
                    // Badge com status
                    Positioned(
                      top: 0,
                      right: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: _isPremium
                              ? AppColors.successGreen
                              : Colors.orange[700],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: widget.backgroundColor,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _isPremium
                                  ? AppColors.successGreen.withValues(
                                      alpha: 0.4,
                                    )
                                  : Colors.orange.withValues(alpha: 0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          _isPremium ? 'PRO' : 'FREE',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Ações adicionais (se houver)
        ...(widget.actions ?? []),
      ],
    );
  }
}
