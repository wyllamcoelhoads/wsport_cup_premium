// lib/core/services/version_check_service.dart
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionCheckService {
  static const String _remoteConfigKey = 'min_version_android';

  // ─── Intervalo de fetch ───────────────────────────────────────────────────
  // Em TESTES:    Duration.zero       → busca sempre (cota: ~5/hora no Firebase)
  // Em PRODUÇÃO:  Duration(hours: 4)  → evita uso excessivo de cota
  static const Duration _fetchInterval = Duration(hours: 4);

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  /// Retorna `true` se o app está atualizado (não precisa mostrar o banner).
  /// Retorna `false` se existe uma versão mínima maior que a atual.
  Future<bool> isAppUpToDate() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 30),
          minimumFetchInterval: _fetchInterval,
        ),
      );

      // fetchAndActivate retorna true se novos valores foram ativados
      await _remoteConfig.fetchAndActivate();

      final String rawMinVersion = _remoteConfig
          .getString(_remoteConfigKey)
          .trim();

      // Chave não configurada no Firebase → sem restrição
      if (rawMinVersion.isEmpty) return true;

      final PackageInfo packageInfo = await PackageInfo.fromPlatform();

      // packageInfo.version pode vir como "1.2.8" (sem build number)
      // Sanitizamos para garantir que só temos "MAJOR.MINOR.PATCH"
      final String currentVersion = _sanitizeVersion(packageInfo.version);
      final String minVersion = _sanitizeVersion(rawMinVersion);

      final bool upToDate = _isVersionGreaterThanOrEqual(
        currentVersion,
        minVersion,
      );

      debugPrint(
        '[VersionCheck] atual=$currentVersion | mínima=$minVersion | '
        'atualizado=$upToDate',
      );

      return upToDate;
    } catch (e, stack) {
      // Sem internet ou Remote Config indisponível → não bloqueia o usuário
      debugPrint('[VersionCheck] Erro ao verificar versão: $e\n$stack');
      return true;
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Remove tudo que não seja dígitos e pontos.
  /// "1.2.8+10"  → "1.2.8"
  /// " 1.3.0 "   → "1.3.0"
  /// "1.3.0-beta"→ "1.3.0"
  String _sanitizeVersion(String version) {
    // Descarta build metadata (+) e pre-release (-)
    final cleaned = version
        .split('+')
        .first // remove build number
        .split('-')
        .first // remove pre-release tag
        .trim();

    // Garante que cada segmento é numérico; substitui inválidos por "0"
    return cleaned
        .split('.')
        .map((seg) => int.tryParse(seg.trim())?.toString() ?? '0')
        .join('.');
  }

  /// Compara versões segmento a segmento.
  /// Retorna `true`  se [current] >= [min].
  /// Retorna `false` se [current] <  [min].
  bool _isVersionGreaterThanOrEqual(String current, String min) {
    final List<int> currentParts = _toParts(current);
    final List<int> minParts = _toParts(min);

    final int maxLength = currentParts.length > minParts.length
        ? currentParts.length
        : minParts.length;

    for (int i = 0; i < maxLength; i++) {
      final int c = i < currentParts.length ? currentParts[i] : 0;
      final int m = i < minParts.length ? minParts[i] : 0;

      if (c > m) return true; // ex: 1.3.0 > 1.2.9
      if (c < m) return false; // ex: 1.2.8 < 1.2.9
    }

    return true; // versões idênticas → está atualizado
  }

  /// Converte "1.2.8" em [1, 2, 8].
  /// Segmentos inválidos viram 0.
  List<int> _toParts(String version) {
    return version.split('.').map((s) => int.tryParse(s) ?? 0).toList();
  }
}
