import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wsports_cup_premium/core/constants/app_theme.dart';
import 'package:wsports_cup_premium/core/services/ad_service.dart';
import '../../premium/pages/premium_page.dart';

/// AppBar reutilizável com Badge Premium
/// ✨ Mostra ⭐ com badge "FREE" ou "PRO" conforme isPremium
/// 🎯 Acessível de TODAS as telas do app
/// 🔄 Sincroniza em tempo real quando status muda
class PremiumBadgeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Color? titleColor;
  final bool showBackButton;
  final Widget? leading;
  final bool showPremiumBadge;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final double? elevation;

  /// Callback opcional quando o status premium muda
  /// Útil para analytics ou atualizar UI da página pai
  final Function(bool isPremium)? onPremiumStatusChanged;

  const PremiumBadgeAppBar({
    required this.title,
    this.titleColor,
    this.showBackButton = false,
    this.leading,
    this.showPremiumBadge = true,
    this.actions,
    this.onBackPressed,
    this.elevation = 0,
    this.onPremiumStatusChanged,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<PremiumBadgeAppBar> createState() => _PremiumBadgeAppBarState();
}

class _PremiumBadgeAppBarState extends State<PremiumBadgeAppBar> {
  bool _isPremium = AdService.isPremium;
  Timer? _statusCheckTimer;

  @override
  void initState() {
    super.initState();
    _updatePremiumStatus();
    // 🔄 Sincroniza status a cada 2 segundos
    // Útil para quando premium é comprado em outra tela
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
    return AppBar(
      automaticallyImplyLeading:
          widget.showBackButton && widget.leading == null,
      title: Text(
        widget.title,
        style: TextStyle(
          color: widget.titleColor ?? AppColors.primaryGold,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      backgroundColor: AppColors.background,
      elevation: widget.elevation ?? 0,
      leading: widget.showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primaryGold),
              onPressed: widget.onBackPressed ?? () => Navigator.pop(context),
            )
          : widget.leading,
      actions: [
        if (widget.showPremiumBadge)
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
                            color:
                                _isPremium // ✅ Dinâmico!
                                ? AppColors.successGreen
                                : Colors.orange[700],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.background,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    _isPremium // ✅ Sombra adaptativa
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
                            _isPremium ? 'PRO' : 'FREE', // ✅ Texto dinâmico
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
