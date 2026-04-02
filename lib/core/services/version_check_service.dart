// lib/core/services/version_check_service.dart
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionCheckService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<bool> isAppUpToDate() async {
    try {
      // Configuração para forçar a busca de forma rápida durante o desenvolvimento
      // Dica: Em produção, mude o minimumFetchInterval para algumas horas
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval:
              Duration.zero, // Em testes, mude para Duration.zero
        ),
      );
      await _remoteConfig.fetchAndActivate();

      // Busca a versão lá do seu Firebase Console
      String minVersionString = _remoteConfig.getString('min_version_android');
      if (minVersionString.isEmpty) return true;

      // Lê a versão atual definida no seu pubspec.yaml
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersionString = packageInfo.version;

      return _isVersionGreaterThanOrEqual(
        currentVersionString,
        minVersionString,
      );
    } catch (e) {
      // Se der erro (ex: sem internet), a gente deixa o app seguir sem mostrar o banner
      print("Erro no Remote Config: $e");
      return true;
    }
  }

  // Lógica de desmembramento para não dar erro na comparação de strings
  bool _isVersionGreaterThanOrEqual(String current, String min) {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> minParts = min.split('.').map(int.parse).toList();

    // Pega o tamanho da maior lista para garantir que todas as casas decimais sejam checadas
    int maxLength = currentParts.length > minParts.length
        ? currentParts.length
        : minParts.length;

    for (int i = 0; i < maxLength; i++) {
      int c = i < currentParts.length ? currentParts[i] : 0;
      int m = i < minParts.length ? minParts[i] : 0;

      if (c > m) return true;
      if (c < m) return false;
    }
    return true;
  }
}
