import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class AdService {
  static const String _premiumKey = 'is_premium';

  // IDs de TESTE — substitua pelos reais antes de publicar
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String rewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917'; // ← NOVO

  static bool _isPremium = false;
  static InterstitialAd? _interstitialAd;
  static RewardedAd? _rewardedAd;

  static Future<void> initialize() async {
    // AdMob não suporta Web
    if (kIsWeb) return;
    await MobileAds.instance.initialize();
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool(_premiumKey) ?? false;
    await loadRewarded();
  }

  static bool get isPremium => _isPremium;

  static Future<void> setPremium(bool value) async {
    _isPremium = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, value);
  }

  static Future<void> loadRewarded() async {
    if (_isPremium || kIsWeb) return;
    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (error) => _rewardedAd = null,
      ),
    );
  }

  // Retorna true se o usuário assistiu, false se pulou ou falhou
  static Future<bool> showRewarded() async {
    if (_isPremium) return true; // Premium não precisa ver anúncio

    if (_rewardedAd == null) {
      await loadRewarded();
      // Se ainda não carregou, deixa passar (não bloqueia o usuário)
      if (_rewardedAd == null) return true;
    }

    bool rewarded = false;

    final completer = Completer<bool>();

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        loadRewarded(); // já carrega o próximo
        if (!completer.isCompleted) completer.complete(rewarded);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        loadRewarded();
        if (!completer.isCompleted)
          completer.complete(true); // falhou, deixa passar
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        rewarded = true; // usuário assistiu até o fim!
      },
    );

    return completer.future;
  }

  static Future<void> loadInterstitial() async {
    if (_isPremium) return;
    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (_) => _interstitialAd = null,
      ),
    );
  }

  static void showInterstitial() {
    if (_isPremium) return;
    _interstitialAd?.show();
    _interstitialAd = null;
    loadInterstitial(); // já carrega o próximo
  }
}
