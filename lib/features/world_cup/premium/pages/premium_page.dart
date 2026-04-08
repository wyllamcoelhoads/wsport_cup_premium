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
  bool _isRestoring = false;
  String? _errorMessage;
  ProductDetails? _product;
  String _appVersion = '';

  // Controla se o usuário JÁ É premium (verificado localmente)
  bool _alreadyPremium = false;

  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // ─── Ciclo de vida ──────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _listenToPurchases();
    _initialize();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  // ─── Inicialização ──────────────────────────────────────────────────────────

  Future<void> _initialize() async {
    await Future.wait([_loadAppVersion(), _checkAndLoadProduct()]);
  }

  Future<void> _loadAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) setState(() => _appVersion = 'v${info.version}-alpha');
    } catch (_) {
      // Versão não é crítica — silencia o erro
    }
  }

  /// Verifica primeiro se já é premium (local). Se sim, exibe tela de
  /// confirmação. Se não, carrega o produto da loja para exibir o botão.
  Future<void> _checkAndLoadProduct() async {
    // 1. Verifica cache local (SharedPreferences)
    if (AdService.isPremium) {
      if (mounted) {
        setState(() {
          _alreadyPremium = true;
          _isLoading = false;
        });
      }
      return;
    }

    // 2. Tenta restaurar silenciosamente para sincronizar com a loja
    //    (cobre o caso do usuário ter reinstalado o app)
    try {
      await InAppPurchase.instance.restorePurchases();
      // O listener _handlePurchaseUpdates vai processar o resultado.
      // Aguardamos um curto intervalo para processar antes de carregar o produto.
      await Future.delayed(const Duration(milliseconds: 800));
    } catch (_) {
      // Restauração silenciosa: se falhar, segue normalmente
    }

    // 3. Re-checa após a tentativa de restauração
    if (AdService.isPremium) {
      if (mounted) {
        setState(() {
          _alreadyPremium = true;
          _isLoading = false;
        });
      }
      return;
    }

    // 4. Carrega o produto para compra
    await _loadProduct();
  }

  Future<void> _loadProduct() async {
    if (mounted) setState(() => _isLoading = true);

    try {
      final bool available = await InAppPurchase.instance.isAvailable();
      if (!available) {
        _setError('A loja não está disponível no momento. Tente mais tarde.');
        return;
      }

      final response = await InAppPurchase.instance.queryProductDetails({
        _productId,
      });

      if (!mounted) return;

      if (response.error != null) {
        _setError(
          'Não foi possível conectar à loja. '
          'Verifique sua conexão e tente novamente.',
        );
        return;
      }

      if (response.productDetails.isEmpty) {
        _setError(
          'Produto não encontrado. '
          'Atualize o app ou entre em contato com o suporte.',
        );
        return;
      }

      setState(() {
        _product = response.productDetails.first;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      _setError('Erro inesperado ao carregar a loja. Tente novamente.');
    }
  }

  void _setError(String message) {
    if (!mounted) return;
    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });
  }

  // ─── Listener de compras ────────────────────────────────────────────────────

  void _listenToPurchases() {
    _subscription = InAppPurchase.instance.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error) {
        // Erro no stream (ex: billingClient desconectou)
        if (mounted) {
          setState(() {
            _isPurchasing = false;
            _errorMessage =
                'Erro na conexão com a loja. Feche e abra novamente.';
          });
        }
      },
      cancelOnError: false, // mantém o stream ativo após erros
    );
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      // Ignora produtos que não são os nossos
      if (purchase.productID != _productId) continue;

      // Envolvemos todo o processamento em um try/catch para garantir que
      // a tela nunca fique travada em caso de exceção não prevista.
      try {
        switch (purchase.status) {
          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            if (purchase.pendingCompletePurchase) {
              try {
                await InAppPurchase.instance.completePurchase(purchase);
              } catch (e) {
                debugPrint("Erro ao completar compra na loja: $e");
              }
            }

            try {
              await AdService.setPremium(true);
            } catch (e) {
              debugPrint("Erro ao salvar status premium localmente: $e");
            }

            if (mounted) {
              setState(() {
                _isPurchasing = false;
                _alreadyPremium = true;
                _errorMessage = null;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Parabéns! Você agora é Premium! 🏆',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: AppColors.primaryGold,
                  duration: Duration(seconds: 3),
                ),
              );
            }
            break;

          case PurchaseStatus.error:
            // Erro 7 = ITEM_ALREADY_OWNED
            if (purchase.error?.code == '7' ||
                purchase.error?.code ==
                    'billing_response_result_item_already_owned') {
              await AdService.setPremium(true);
              if (purchase.pendingCompletePurchase) {
                try {
                  await InAppPurchase.instance.completePurchase(purchase);
                } catch (_) {}
              }

              if (mounted) {
                setState(() {
                  _alreadyPremium = true;
                  _isPurchasing = false;
                  _errorMessage = null;
                });
              }
              return;
            }

            // Completa a transação com erro para limpar do cache da Google Play
            if (purchase.pendingCompletePurchase) {
              try {
                await InAppPurchase.instance.completePurchase(purchase);
              } catch (_) {}
            }

            if (mounted) {
              setState(() {
                _isPurchasing = false;
                // Exibe uma mensagem amigável caso haja erro de rede ou pagamento recusado
                _errorMessage =
                    'Falha no pagamento. Verifique sua conexão ou forma de pagamento.';
              });
            }
            break;

          case PurchaseStatus.canceled:
            if (mounted) {
              setState(() {
                _isPurchasing = false;
                _errorMessage = 'Compra cancelada.';
              });
            }
            break;

          case PurchaseStatus.pending:
            if (mounted) setState(() => _isPurchasing = true);
            break;
        }
      } catch (e) {
        // Se QUALQUER coisa der errado durante o processamento, paramos o loading
        if (mounted) {
          setState(() {
            _isPurchasing = false;
            _errorMessage =
                'Ocorreu um erro no processamento. Tente novamente.';
          });
        }
      }
    }
  }

  // ─── Ações do usuário ───────────────────────────────────────────────────────

  Future<void> _buyPremium() async {
    if (_product == null || _isPurchasing) return;

    setState(() {
      _isPurchasing = true;
      _errorMessage = null;
    });

    // Timeout de segurança: Se o Google Play não responder em 60 segundos,
    // nós destravamos a tela do usuário para ele não ficar preso.
    Future.delayed(const Duration(seconds: 60), () {
      if (mounted && _isPurchasing) {
        setState(() {
          _isPurchasing = false;
          _errorMessage =
              'O processo está demorando muito. Verifique sua internet e tente novamente.';
        });
      }
    });

    try {
      final PurchaseParam param = PurchaseParam(productDetails: _product!);
      final bool started = await InAppPurchase.instance.buyNonConsumable(
        purchaseParam: param,
      );

      if (!started && mounted) {
        setState(() {
          _isPurchasing = false;
          _errorMessage =
              'Não foi possível iniciar a compra. Tente o botão "Restaurar".';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isPurchasing = false;
          // Mostra mensagem clara se a conexão cair bem na hora do clique
          _errorMessage =
              'Erro ao se conectar com a loja. Verifique sua internet.';
        });
      }
    }
  }

  Future<void> _restorePurchases() async {
    if (_isRestoring) return;

    setState(() {
      _isRestoring = true;
      _errorMessage = null;
    });

    try {
      await InAppPurchase.instance.restorePurchases();
      // O resultado chega pelo listener; aguardamos um momento para processar
      await Future.delayed(const Duration(seconds: 2));

      if (mounted && !AdService.isPremium) {
        // Nenhuma compra anterior encontrada
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nenhuma compra anterior encontrada.'),
            backgroundColor: Colors.grey,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'Não foi possível restaurar as compras. Tente novamente.';
        });
      }
    } finally {
      if (mounted) setState(() => _isRestoring = false);
    }
  }

  // ─── UI ─────────────────────────────────────────────────────────────────────

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
          // Só exibe "Restaurar" se ainda não é premium
          if (!_alreadyPremium)
            _isRestoring
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white54,
                      ),
                    ),
                  )
                : TextButton(
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
          : _alreadyPremium
          ? _buildAlreadyPremiumView()
          : _buildPurchaseView(),
    );
  }

  /// Tela exibida quando o usuário JÁ É Premium.
  Widget _buildAlreadyPremiumView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge de conquista
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryGold.withValues(alpha: 0.12),
                border: Border.all(color: AppColors.primaryGold, width: 2.5),
              ),
              child: const Icon(
                Icons.workspace_premium,
                size: 60,
                color: AppColors.primaryGold,
              ),
            ),
            const SizedBox(height: 28),

            const Text(
              'Você é Premium! 🏆',
              style: TextStyle(
                color: AppColors.primaryGold,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            const Text(
              'Aproveite o simulador sem nenhuma interrupção.\nObrigado por apoiar o desenvolvimento!',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),

            // Benefícios ativos
            _buildBenefitRow(Icons.block, 'Sem anúncios — para sempre'),
            _buildBenefitRow(Icons.bolt, 'Experiência mais fluida'),
            _buildBenefitRow(Icons.favorite, 'Apoiando o desenvolvimento'),

            const SizedBox(height: 48),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'VOLTAR AO SIMULADOR',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            if (_appVersion.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                _appVersion,
                style: const TextStyle(color: Colors.white24, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Tela exibida quando o usuário AINDA NÃO É Premium.
  Widget _buildPurchaseView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          const Icon(
            Icons.workspace_premium,
            size: 80,
            color: AppColors.primaryGold,
          ),
          const SizedBox(height: 24),
          const Text(
            'Simulador Copa do Mundo\n2026 Premium',
            style: TextStyle(
              color: AppColors.primaryGold,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Aproveite o simulador sem interrupções!',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildBenefitRow(Icons.block, 'Sem anúncios para sempre'),
          _buildBenefitRow(Icons.bolt, 'Experiência mais fluida'),
          _buildBenefitRow(Icons.favorite, 'Apoie o desenvolvimento'),
          const SizedBox(height: 40),

          // Caixa de erro (apenas se houver)
          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.redAccent.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  // Botão de retry inline
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                    onPressed: _loadProduct,
                  ),
                ],
              ),
            ),
          ],

          // Botão principal de compra
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                disabledBackgroundColor: AppColors.primaryGold.withValues(
                  alpha: 0.4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: (_isPurchasing || _product == null)
                  ? null
                  : _buyPremium,
              child: _isPurchasing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      _product != null
                          ? 'Seja Premium por apenas ${_product!.price}'
                          : 'CARREGANDO...',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 14),

          const Text(
            'Pagamento processado pelo Google Play.\nCompra única, sem renovação automática.',
            style: TextStyle(color: Colors.white38, fontSize: 11),
            textAlign: TextAlign.center,
          ),

          if (_appVersion.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              _appVersion,
              style: const TextStyle(color: Colors.white24, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String text) {
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
