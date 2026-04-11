import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:wsports_cup_premium/core/constants/app_theme.dart';
import 'package:wsports_cup_premium/core/services/ad_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../presentation/widgets/premium_badge_app_bar.dart';

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

    // ✅ TIMEOUT DE SEGURANÇA GARANTIDO: NUNCA FICA CARREGANDO MAIS QUE 15 SEGUNDOS
    final timeout = Timer(const Duration(seconds: 15), () {
      if (mounted && _isLoading) {
        _setError('Tempo de conexão esgotado. Verifique sua internet.');
      }
    });

    try {
      final bool available = await InAppPurchase.instance.isAvailable().timeout(
        const Duration(seconds: 8),
        onTimeout: () => false,
      );

      if (!available) {
        _setError('A loja não está disponível no momento. Tente mais tarde.');
        return;
      }

      final response = await InAppPurchase.instance
          .queryProductDetails({_productId})
          .timeout(
            const Duration(seconds: 12),
          ); // timeout específico para a consulta de produtos

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
    } finally {
      // ✅ GARANTIA ABSOLUTA: DESLIGA O LOADING MESMO SE TUDO DER ERRADO
      timeout.cancel();
      if (mounted && _isLoading) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _setError(String message) {
    // ✅ Garantia ABSOLUTA: NUNCA fica travado em loading
    // Reseta TODOS os estados de loading independentemente de qualquer coisa
    _isLoading = false;
    _isPurchasing = false;
    _isRestoring = false;
    _errorMessage = message;

    if (mounted) {
      setState(() {});
    }
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

    // ✅ TIMEOUT DE SEGURANÇA: NUNCA FICA CARREGANDO MAIS QUE 30 SEGUNDOS
    final purchaseTimeout = Timer(const Duration(seconds: 30), () {
      if (_isPurchasing) {
        _setError(
          'O processo está demorando muito. Verifique sua internet e tente novamente.',
        );
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
    } finally {
      // ✅ GARANTIA ABSOLUTA: Cancela o timeout em QUALQUER caso (sucesso, erro, exceção)
      purchaseTimeout.cancel();
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
      appBar: PremiumBadgeAppBar(
        title: 'Adquira a versão PRO',
        showBackButton: true,
        showPremiumBadge: false,
        actions: [
          // Só exibe "Restaurar" se ainda não é premium
          if (!_alreadyPremium)
            _isRestoring
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: SizedBox(
                      width: 14,
                      height: 14,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          // Card Premium com animação visual
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryGold.withValues(alpha: 0.2),
                  AppColors.successGreen.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryGold, width: 2),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.verified,
                  size: 60,
                  color: AppColors.successGreen,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Status Premium Ativo',
                  style: TextStyle(
                    color: AppColors.successGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Você está desfrutando de todos os benefícios exclusivos!',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Título dos benefícios
          const Text(
            'Seus Benefícios Incluem:',
            style: TextStyle(
              color: AppColors.primaryGold,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          // Benefícios ativos com cards
          _buildBenefitCard(
            Icons.block_flipped,
            'Sem Anúncios',
            'Navegue livremente sem interrupções de anúncios',
            AppColors.successGreen,
          ),
          _buildBenefitCard(
            Icons.bolt,
            'Experiência Fluida',
            'Interface otimizada para máxima performance',
            Colors.cyan,
          ),
          _buildBenefitCard(
            Icons.favorite,
            'Apoio ao Desenvolvimento',
            'Ajude o desenvolvedor a criar mais recursos',
            Colors.red.shade400,
          ),
          _buildBenefitCard(
            Icons.update,
            'Atualizações Prioritárias',
            'Acesso a novas features e melhorias primeiro',
            Colors.purple[300]!,
          ),

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
    );
  }

  /// Widget de card de benefício melhorado para usuários premium
  Widget _buildBenefitCard(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Tela exibida quando o usuário AINDA NÃO É Premium.
  Widget _buildPurchaseView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          // Efeito de brilho atrás do ícone para dar sensação de "Premium"
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryGold.withValues(alpha: 0.1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGold.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.workspace_premium,
              size: 60,
              color: AppColors.primaryGold,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Desbloqueie a\nExperiência PRO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Eleve suas simulações ao próximo nível sem distrações.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // ✨ UTILIZANDO OS CARDS DETALHADOS PARA VENDER MELHOR
          _buildBenefitCard(
            Icons.block_flipped,
            'Zero Anúncios',
            'Simule sem interrupções. Diga adeus aos banners e vídeos chatos para sempre.',
            AppColors.successGreen,
          ),
          _buildBenefitCard(
            Icons.bolt,
            'Mais Rápido e Limpo',
            'Interface otimizada, garantindo navegação fluida e foco total no torneio.',
            Colors.cyan,
          ),
          _buildBenefitCard(
            Icons.all_inclusive,
            'Compra Única',
            'Sem assinaturas mensais! Pague apenas uma vez e seja PRO para sempre.',
            AppColors.primaryGold,
          ),
          _buildBenefitCard(
            Icons.rocket_launch,
            'Apoie & Receba Novidades',
            'Incentive o projeto e tenha acesso prioritário aos novos recursos.',
            Colors.purple[300]!,
          ),

          const SizedBox(height: 10),

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

          // Botão principal de compra (mais destacado)
          Container(
            width: double.infinity,
            height: 55, // Ligeiramente mais alto para destacar
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (!_isPurchasing && _product != null)
                  BoxShadow(
                    color: AppColors.primaryGold.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                disabledBackgroundColor: AppColors.primaryGold.withValues(
                  alpha: 0.4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0, // A sombra é tratada pelo Container acima
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
                          ? 'Desbloquear por ${_product!.price}'
                          : 'CARREGANDO...',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w900, // Fonte mais pesada no botão
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // Garantias que reduzem a ansiedade de compra
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: Colors.white38,
                size: 14,
              ),
              const SizedBox(width: 6),
              const Text(
                'Pagamento seguro via Google Play',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),

          if (_appVersion.isNotEmpty) ...[
            const SizedBox(height: 30),
            Text(
              _appVersion,
              style: const TextStyle(color: Colors.white24, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
