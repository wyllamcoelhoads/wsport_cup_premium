import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wsports_cup_premium/core/services/ad_service.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  Timer? _retryTimer;
  int _retryAttempts = 0;
  static const int _maxRetryAttempts = 5;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && !AdService.isPremium) _loadBanner();
  }

  void _loadBanner() {
    _bannerAd = BannerAd(
      adUnitId: AdService.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isLoaded = true;
            _retryAttempts = 0;
          });
        },

        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          setState(() => _isLoaded = false);

          // Backoff exponencial para retentativas
          if (_retryAttempts < _maxRetryAttempts) {
            final delay = Duration(seconds: 2 << _retryAttempts);
            _retryAttempts++;

            _retryTimer = Timer(delay, () {
              if (mounted && !AdService.isPremium) {
                _loadBanner();
              }
            });
          }
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _retryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (AdService.isPremium || !_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
