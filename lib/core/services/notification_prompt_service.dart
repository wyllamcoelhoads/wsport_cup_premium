import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import 'notification_service.dart';

class NotificationPromptService {
  /// Verifica a condição e exibe o dialog se necessário.
  /// Chame isso em qualquer página passando o [context].
  static Future<void> checkAndShow(BuildContext context) async {
    final should = await NotificationService.shouldShowPrompt();
    if (!should) return;

    await NotificationService.recordPromptShown();
    if (!context.mounted) return;

    _show(context);
  }

  static void _show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.primaryGold, width: 1.5),
        ),
        title: const Column(
          children: [
            Icon(
              Icons.notifications_active,
              color: AppColors.primaryGold,
              size: 50,
            ),
            SizedBox(height: 15),
            Text(
              'Não perca nenhum lance!',
              style: TextStyle(
                color: AppColors.primaryGold,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: const Text(
          'Quer ser avisado quando os jogos começarem?\n',
          style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  final granted = await NotificationService.requestPermission();
                  if (granted && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Notificações ativadas com sucesso! 🏆',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: AppColors.primaryGold,
                      ),
                    );
                  }
                },
                child: const Text(
                  'SIM, QUERO RECEBER AVISOS',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  'AGORA NÃO',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
