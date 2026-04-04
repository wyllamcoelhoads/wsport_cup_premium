import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// ─── Handler de background (DEVE ficar fora de qualquer classe) ───────────────
// O Firebase exige uma função top-level para mensagens recebidas com o app fechado.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Não precisa fazer nada aqui — o sistema operacional já exibe a notificação.
  // O clique será tratado quando o app abrir via getInitialMessage().
}

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static const String _grantedKey = 'notification_permission_granted';
  static const String _promptCountKey = 'notification_prompt_count';
  static const String _launchCountKey = 'app_launch_count';
  static const int _maxPrompts = 3;
  static const List<int> _promptOnLaunches = [1, 3, 6];

  // Link da sua loja — centralizado para fácil manutenção
  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=br.com.william.wsports_cup_premium';

  // ─── Inicialização ──────────────────────────────────────────────────────────

  /// Chame UMA VEZ no main(), após Firebase.initializeApp().
  /// Configura os handlers de clique para os três cenários possíveis.
  static Future<void> initialize() async {
    // Registra o handler de background (app fechado)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Configura como as notificações aparecem com o app em FOREGROUND
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // ── Cenário 1: App estava FECHADO e usuário clicou na notificação ────────
    // getInitialMessage() retorna a mensagem que abriu o app, se houver.
    final RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      await _handleMessageClick(initialMessage);
    }

    // ── Cenário 2: App estava em BACKGROUND e usuário clicou ─────────────────
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageClick(message);
    });

    // ── Cenário 3: App estava em FOREGROUND ───────────────────────────────────
    // A notificação chega silenciosamente — você pode exibir um banner in-app
    // e oferecer o botão de atualização manualmente.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message);
    });
  }

  // ─── Tratamento do clique ───────────────────────────────────────────────────

  /// Lê os dados da notificação e decide o que abrir.
  static Future<void> _handleMessageClick(RemoteMessage message) async {
    final data = message.data;

    // Verifica se é uma notificação de atualização pelo campo customizado
    final String? clickAction = data['click_action'];

    if (clickAction == 'OPEN_PLAY_STORE') {
      await _openPlayStore();
      return;
    }

    // Fallback: se vier uma URL direta no payload
    final String? url =
        data['url'] ?? message.notification?.android?.clickAction;
    if (url != null && url.isNotEmpty) {
      await _launchUrl(url);
    }
  }

  /// Exibe banner in-app quando a notificação chega com o app aberto.
  /// Usa o contexto global do navegador para mostrar um SnackBar.
  static void _handleForegroundMessage(RemoteMessage message) {
    final String? clickAction = message.data['click_action'];
    final bool isUpdateNotification = clickAction == 'OPEN_PLAY_STORE';

    // Busca o contexto do app para exibir o SnackBar
    final context = _navigatorKey?.currentContext;
    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message.notification?.title ?? 'Nova atualização disponível!',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFD4AF37), // AppColors.primaryGold
        duration: const Duration(seconds: 6),
        action: isUpdateNotification
            ? SnackBarAction(
                label: 'ATUALIZAR',
                textColor: Colors.black,
                onPressed: _openPlayStore,
              )
            : null,
      ),
    );
  }

  // ─── Navegação ──────────────────────────────────────────────────────────────

  static Future<void> _openPlayStore() async {
    await _launchUrl(_playStoreUrl);
  }

  static Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // Navigator key para acessar o contexto fora do widget tree.
  // Atribua isso no MaterialApp: navigatorKey: NotificationService.navigatorKey
  static GlobalKey<NavigatorState>? _navigatorKey;

  static GlobalKey<NavigatorState> get navigatorKey {
    _navigatorKey ??= GlobalKey<NavigatorState>();
    return _navigatorKey!;
  }

  // ─── Lógica de permissão (mantida intacta) ──────────────────────────────────

  static Future<void> incrementLaunchCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = (prefs.getInt(_launchCountKey) ?? 0) + 1;
    await prefs.setInt(_launchCountKey, count);
  }

  static Future<bool> shouldShowPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    final granted = prefs.getBool(_grantedKey) ?? false;
    if (granted) return false;
    final promptCount = prefs.getInt(_promptCountKey) ?? 0;
    if (promptCount >= _maxPrompts) return false;
    final launchCount = prefs.getInt(_launchCountKey) ?? 0;
    return _promptOnLaunches.contains(launchCount);
  }

  static Future<void> recordPromptShown() async {
    final prefs = await SharedPreferences.getInstance();
    final count = (prefs.getInt(_promptCountKey) ?? 0) + 1;
    await prefs.setInt(_promptCountKey, count);
  }

  static Future<void> markAsGranted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_grantedKey, true);
    await prefs.setInt(_promptCountKey, _maxPrompts);
  }

  static Future<bool> requestPermission() async {
    final NotificationSettings settings = await _messaging.requestPermission(
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

  static Future<void> _subscribeToTopics() async {
    await _messaging.subscribeToTopic('fase_de_grupos');
    await _messaging.subscribeToTopic('engajamento_geral');
  }

  static Future<bool> hasShownPrePrompt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('has_shown_notification_prompt') ?? false;
  }

  static Future<void> markPrePromptAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_shown_notification_prompt', true);
  }
}
