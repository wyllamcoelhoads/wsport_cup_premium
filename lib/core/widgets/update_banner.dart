import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class UpdateBanner extends StatefulWidget {
  final Widget child;

  const UpdateBanner({super.key, required this.child});

  @override
  State<UpdateBanner> createState() => _UpdateBannerState();
}

class _UpdateBannerState extends State<UpdateBanner> {
  bool _needsUpdate = false;

  // Link direto para o seu app na Play Store
  final String _storeUrl =
      'https://play.google.com/store/apps/details?id=br.com.william.wsports_cup_premium';

  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  // Remove os pontos da versão para comparar como número (Ex: 1.0.1 vira 101)
  int _parseVersion(String version) {
    try {
      // Pega apenas a parte antes do '+' (ignora o build number)
      final cleanVersion = version.split('+')[0];
      return int.parse(cleanVersion.replaceAll('.', ''));
    } catch (e) {
      return 0;
    }
  }

  Future<void> _checkForUpdates() async {
    try {
      // 1. Descobre a versão atual do app (do seu pubspec.yaml)
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      int currentVersion = _parseVersion(packageInfo.version);

      // 2. Inicializa o Remote Config
      final remoteConfig = FirebaseRemoteConfig.instance;

      // Configuração de tempo de cache (0 segundos para facilitar seus testes agora)
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(seconds: 0),
        ),
      );

      // 3. Valor padrão caso o celular esteja sem internet
      await remoteConfig.setDefaults(const {"min_app_version": "1.0.0"});

      // 4. Busca o valor "1.0.1" que você configurou lá no painel do Firebase
      await remoteConfig.fetchAndActivate();

      String requiredVersionString = remoteConfig.getString("min_app_version");
      int requiredVersion = _parseVersion(requiredVersionString);

      // 5. Se a versão exigida no Firebase for MAIOR que a do app, mostra o banner vermelho
      if (currentVersion < requiredVersion) {
        setState(() {
          _needsUpdate = true;
        });
      }
    } catch (e) {
      debugPrint("Erro ao verificar versão: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_needsUpdate)
          Material(
            color: Colors.red.shade700,
            elevation: 4,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.system_update_alt, color: Colors.white),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Nova versão obrigatória disponível! Atualize para continuar.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: const Size(0, 36),
                      ),
                      onPressed: () async {
                        final uri = Uri.parse(_storeUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      child: const Text(
                        'ATUALIZAR',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        // Aqui o restante do seu app é desenhado normalmente
        Expanded(child: widget.child),
      ],
    );
  }
}
