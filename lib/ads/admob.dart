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
  static String get rewardID => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  RewardedAd? _rewardedAd;
  BannerAd? _bannerAd;
  int _numRewardedLoadAttempts = 0;
  int maxAttempts = 3;

  static initilize() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }

  void createInterstialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-3940256099942544/4411468910',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxAttempts) {
              createInterstialAd();
            }
          },
        ));
  }

  void showInterstialAds() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstialAd();
        showInterstialAds();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  banner_ad() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          print(_);
          // setState(() {
          //   _isAdLoaded = true;
          // });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );
    return _bannerAd;
  }

  void create_reward() async {
    await RewardedAd.load(
        adUnitId: rewardID,
        request: AdRequest(),
        rewardedAdLoadCallback:
            RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
          print('Reward Ads=>$ad ');
          _rewardedAd = ad;
        }, onAdFailedToLoad: (LoadAdError err) {
          print('Error=> $err');
          _rewardedAd = null;
          _numRewardedLoadAttempts += 1;
          if (_numRewardedLoadAttempts < 3) {
            create_reward();
          }
        }));
  }

  showRewardAds() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('$ad onAdShowedFullScreenContent'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent');
        ad.dispose();
        create_reward();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        create_reward();
      },
    );
    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      // setState(() {
      //   coin = coin + (reward.amount).toInt();
      // });
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    _rewardedAd = null;
  }
}
