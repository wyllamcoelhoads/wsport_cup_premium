import 'package:flutter/material.dart';
import 'package:wsports_cup_premium/core/constants/app_theme.dart';
import 'package:wsports_cup_premium/core/services/ad_service.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  bool _isPurchasing = false;

  Future<void> _buyPremium() async {
    setState(() => _isPurchasing = true);

    // Aqui você integrará o in_app_purchase real.
    // Por enquanto, simularemos a compra:
    await Future.delayed(const Duration(seconds: 2));
    await AdService.setPremium(true);

    if (mounted) {
      setState(() => _isPurchasing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parabéns! Você é Premium! 🏆'),
          backgroundColor: AppColors.primaryGold,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Remover Anúncios',
          style: TextStyle(color: AppColors.primaryGold),
        ),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.primaryGold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.workspace_premium,
              size: 80,
              color: AppColors.primaryGold,
            ),
            const SizedBox(height: 24),
            const Text(
              'WSports Premium',
              style: TextStyle(
                color: AppColors.primaryGold,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aproveite o simulador sem interrupções!',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildFeatureRow(Icons.block, 'Sem anúncios para sempre'),
            _buildFeatureRow(Icons.bolt, 'Experiência mais fluida'),
            _buildFeatureRow(Icons.favorite, 'Apoie o desenvolvimento'),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _isPurchasing ? null : _buyPremium,
                child: _isPurchasing
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                        'COMPRAR POR R\$ 4,99',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryGold, size: 20),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 15)),
        ],
      ),
    );
  }
}
