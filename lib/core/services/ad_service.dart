import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class AdService {
  static const String _premiumKey = 'is_premium';

  // IDs de TESTE — substitua pelos reais antes de publicar
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';

  static bool _isPremium = false;
  static InterstitialAd? _interstitialAd;

  static Future<void> initialize() async {
    // AdMob não suporta Web
    if (kIsWeb) return;

    await MobileAds.instance.initialize();
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool(_premiumKey) ?? false;
  }

  static bool get isPremium => _isPremium;

  static Future<void> setPremium(bool value) async {
    _isPremium = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, value);
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
