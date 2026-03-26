import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static const String _grantedKey = 'notification_permission_granted';
  static const String _promptCountKey = 'notification_prompt_count';
  static const String _launchCountKey = 'app_launch_count';
  static const int _maxPrompts = 3;
  // Abre nas aberturas: 1ª, 3ª, 6ª
  static const List<int> _promptOnLaunches = [1, 3, 6];

  /// Chame isso no initState do WorldCupPage (ou no main) a cada abertura
  static Future<void> incrementLaunchCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = (prefs.getInt(_launchCountKey) ?? 0) + 1;
    await prefs.setInt(_launchCountKey, count);
  }

  /// Retorna true se devemos mostrar o dialog agora
  static Future<bool> shouldShowPrompt() async {
    final prefs = await SharedPreferences.getInstance();

    // Já tem permissão concedida? Nunca mais mostra.
    final granted = prefs.getBool(_grantedKey) ?? false;
    if (granted) return false;

    // Já atingiu o limite de tentativas?
    final promptCount = prefs.getInt(_promptCountKey) ?? 0;
    if (promptCount >= _maxPrompts) return false;

    // Verifica se o número de aberturas bate com um dos momentos definidos
    final launchCount = prefs.getInt(_launchCountKey) ?? 0;
    return _promptOnLaunches.contains(launchCount);
  }

  /// Chame ANTES de mostrar o dialog para registrar a tentativa
  static Future<void> recordPromptShown() async {
    final prefs = await SharedPreferences.getInstance();
    final count = (prefs.getInt(_promptCountKey) ?? 0) + 1;
    await prefs.setInt(_promptCountKey, count);
  }

  /// Chame quando a permissão for concedida
  static Future<void> markAsGranted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_grantedKey, true);
    // Zera o contador — não precisa mais perguntar
    await prefs.setInt(_promptCountKey, _maxPrompts);
  }

  // Função que pede a permissão oficial do sistema
  static Future<bool> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await markAsGranted();
      await _subscribeToTopics();
      return true;
    }
    return false;
  }

  // Inscreve o usuário em canais específicos
  static Future<void> _subscribeToTopics() async {
    await _messaging.subscribeToTopic('fase_de_grupos');
    await _messaging.subscribeToTopic('engajamento_geral');
  }

  // Verifica se já mostramos o nosso banner bonito para não incomodar toda hora
  static Future<bool> hasShownPrePrompt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('has_shown_notification_prompt') ?? false;
  }

  // Marca que já mostramos o banner
  static Future<void> markPrePromptAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_shown_notification_prompt', true);
  }
}
