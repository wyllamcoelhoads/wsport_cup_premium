import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Função que pede a permissão oficial do sistema
  static Future<bool> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Se ele aceitar, inscrevemos ele nos tópicos para receber as mensagens do Firebase!
      await _subscribeToTopics();
      return true;
    }
    return false;
  }

  // Inscreve o usuário em canais específicos
  static Future<void> _subscribeToTopics() async {
    // Tópico para avisos de jogos da fase de grupos
    await _messaging.subscribeToTopic('fase_de_grupos');
    // Tópico para mensagens de engajamento (ex: "Já simulou hoje?")
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
