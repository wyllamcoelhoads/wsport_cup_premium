import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:wsports_cup_premium/core/constants/app_theme.dart';
import 'package:wsports_cup_premium/core/services/ad_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  static const String _productId = 'premium_remove_ads';

  bool _isPurchasing = false;
  bool _isLoading = true;
  String? _errorMessage;
  ProductDetails? _product;

  String _appVersion = '';

  late StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    super.initState();
    _listenToPurchases();
    _loadProduct();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        // Você pode usar apenas packageInfo.version (ex: 1.0.2)
        // Ou adicionar o buildNumber também (ex: 1.0.2+6) usando packageInfo.buildNumber
        _appVersion = 'Versão ${packageInfo.version}';
      });
    }
  }

  void _listenToPurchases() {
    _subscription = InAppPurchase.instance.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (_) =>
          setState(() => _errorMessage = 'Erro na conexão com a loja.'),
    );
  }

  Future<void> _loadProduct() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Loja não disponível no momento.';
      });
      return;
    }

    final response = await InAppPurchase.instance.queryProductDetails({
      _productId,
    });

    if (response.error != null || response.productDetails.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Produto não encontrado. Verifique o Play Console.';
      });
      return;
    }

    setState(() {
      _product = response.productDetails.first;
      _isLoading = false;
    });
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID != _productId) continue;

      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        await AdService.setPremium(true);
        await InAppPurchase.instance.completePurchase(purchase);

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
      } else if (purchase.status == PurchaseStatus.error) {
        await InAppPurchase.instance.completePurchase(purchase);
        setState(() {
          _isPurchasing = false;
          _errorMessage = 'Pagamento falhou. Tente novamente.';
        });
      } else if (purchase.status == PurchaseStatus.canceled) {
        setState(() => _isPurchasing = false);
      } else if (purchase.status == PurchaseStatus.pending) {
        setState(() => _isPurchasing = true);
      }
    }
  }

  Future<void> _buyPremium() async {
    if (_product == null) return;
    setState(() {
      _isPurchasing = true;
      _errorMessage = null;
    });
    final PurchaseParam param = PurchaseParam(productDetails: _product!);
    await InAppPurchase.instance.buyNonConsumable(purchaseParam: param);
  }

  Future<void> _restorePurchases() async {
    setState(() => _isLoading = true);
    await InAppPurchase.instance.restorePurchases();
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Simulador Copa do Mundo 2026',
          style: TextStyle(color: AppColors.primaryGold),
        ),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.primaryGold),
        actions: [
          TextButton(
            onPressed: _restorePurchases,
            child: const Text(
              'Restaurar',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGold),
            )
          : Padding(
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
                    'Simulador Copa do Mundo 2026 Premium',
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

                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.redAccent.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

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
                      onPressed: (_isPurchasing || _product == null)
                          ? null
                          : _buyPremium,
                      child: _isPurchasing
                          ? const CircularProgressIndicator(color: Colors.black)
                          : Text(
                              _product != null
                                  ? 'Seja Premium por apenas ${_product!.price}'
                                  : 'CARREGANDO...',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Pagamento processado pelo Google Play.\nCompra única, sem renovação automática.',
                    style: TextStyle(color: Colors.white38, fontSize: 11),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),
                  if (_appVersion.isNotEmpty)
                    Text(
                      _appVersion,
                      style: const TextStyle(
                        color: Colors.white24, // Uma cor bem sutil
                        fontSize: 12,
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
