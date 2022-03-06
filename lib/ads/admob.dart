import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class AdmobService {
  static String get bannerId => Platform.isAndroid
      ? 'ca-app-pub-3922299637282329/6558094634'
      : 'ca-app-pub-3922299637282329/6558094634';
      // ? 'ca-app-pub-3940256099942544/6300978111'
      // : 'ca-app-pub-3940256099942544/6300978111';
  static String get interstialId => Platform.isAndroid
      ? 'ca-app-pub-3922299637282329/6233633338'
      : 'ca-app-pub-3922299637282329/6233633338';
      // ? 'ca-app-pub-3940256099942544/1033173712'
      // : 'ca-app-pub-3940256099942544/1033173712';
  InterstitialAd? _interstitialAd;

  static initilize() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }

  final BannerAd myBanner = new BannerAd(
    adUnitId: bannerId,
    size: AdSize.largeBanner,
    request: AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    ),
  );


  void createInterstialAd() {
    print("\n\nAds Created\n\n");
    InterstitialAd.load(
        adUnitId: interstialId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            this._interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _interstitialAd = null;
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

   showInterstialAds() {
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),
    );
    createInterstialAd();
    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
