import 'package:flutter/material.dart';
import 'dart:io';
import '../constants/app_theme.dart'; // Não esqueça de importar caso vá colocar num arquivo novo

class NetworkAwareTab extends StatefulWidget {
  final Widget child; // O conteúdo real da aba (ex: _VideosTab)

  const NetworkAwareTab({super.key, required this.child});

  @override
  State<NetworkAwareTab> createState() => _NetworkAwareTabState();
}

class _NetworkAwareTabState extends State<NetworkAwareTab> {
  bool _isLoading = true;
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkInternet();
  }

  Future<void> _checkInternet() async {
    setState(() => _isLoading = true);
    try {
      final result = await InternetAddress.lookup('google.com');
      setState(() {
        _hasInternet = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
        _isLoading = false;
      });
    } on SocketException catch (_) {
      setState(() {
        _hasInternet = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryGold),
      );
    }

    if (!_hasInternet) {
      // TELA DE ERRO IGUAL À DA PÁGINA INICIAL
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/sem_internet.png', width: 200),
              const SizedBox(height: 20),
              const Text(
                "Ops! Você está offline.",
                style: TextStyle(
                  color: AppColors.primaryGold,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "É necessário acesso à internet para visualizar este conteúdo.",
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.refresh, color: Colors.black),
                label: const Text(
                  "TENTAR NOVAMENTE",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _checkInternet, // Tenta conectar de novo
              ),
            ],
          ),
        ),
      );
    }

    // Se tiver internet, exibe a aba normalmente!
    return widget.child;
  }
}
