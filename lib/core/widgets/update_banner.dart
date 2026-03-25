// lib/core/widgets/update_banner.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Você pode importar a variável global do seu main.dart, ou passá-la por parâmetro
import '../../main.dart';

class UpdateBanner extends StatelessWidget {
  final Widget child; // O restante do seu aplicativo

  const UpdateBanner({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Oculta ou mostra o banner com base no Notifier
        ValueListenableBuilder<bool>(
          valueListenable:
              showUpdateBannerNotifier, // Acessando a variável global
          builder: (context, showBanner, _) {
            if (!showBanner) return const SizedBox.shrink();

            return Material(
              elevation: 4,
              child: Container(
                width: double.infinity,
                color: Colors.blueAccent,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 8,
                  bottom: 8,
                  left: 16,
                  right: 8,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Nova versão disponível, atualize o App!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white24,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onPressed: () async {
                        // O link da sua loja
                        final Uri url = Uri.parse(
                          // link do teste aqui
                          'https://play.google.com/apps/internaltest/4700377440538203475',
                          //'https://play.google.com/store/apps/details?id=br.com.william.wsports_cup_premium',
                        );
                        if (await canLaunchUrl(url)) {
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      child: const Text("ATUALIZAR"),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        showUpdateBannerNotifier.value = false;
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // Renderiza o restante do seu aplicativo (Telas, navegação, etc)
        Expanded(child: child),
      ],
    );
  }
}
