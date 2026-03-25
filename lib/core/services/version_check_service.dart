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
      return true;
    }
  }

  // Lógica de desmembramento para não dar erro na comparação de strings
  bool _isVersionGreaterThanOrEqual(String current, String min) {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> minParts = min.split('.').map(int.parse).toList();

    for (int i = 0; i < currentParts.length; i++) {
      int minPart = i < minParts.length ? minParts[i] : 0;
      if (currentParts[i] > minPart) return true;
      if (currentParts[i] < minPart) return false;
    }
    return true;
  }
}
