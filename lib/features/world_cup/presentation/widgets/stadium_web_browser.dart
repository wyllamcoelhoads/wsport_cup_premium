import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/constants/app_theme.dart';

// ============================================================
// NAVEGADOR IN-APP ELEGANTE
// ============================================================
class StadiumWebBrowser extends StatefulWidget {
  final String url;
  final String title;

  const StadiumWebBrowser({super.key, required this.url, required this.title});

  @override
  State<StadiumWebBrowser> createState() => _StadiumWebBrowserState();
}

class _StadiumWebBrowserState extends State<StadiumWebBrowser> {
  late WebViewController _controller;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                _progress = progress / 100;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        // Remove a seta padrão de voltar que o Flutter adicionaria na esquerda
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Página Oficial',
              style: TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ],
        ),
        centerTitle: true,
        // O botão agora fica em 'actions', alinhando à direita
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.primaryGold),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de progresso charmosa
          if (_progress < 1.0)
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: AppColors.background,
              color: AppColors.primaryGold,
              minHeight: 3,
            ),
          // O site em si
          Expanded(child: WebViewWidget(controller: _controller)),
        ],
      ),
    );
  }
}
