import 'package:flutter/material.dart';
import 'ads/admob.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'pages/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // needs to be called because run app isn't called first
  MobileAds.instance.initialize();
  runApp(MainApp());
}

AdmobService admobService = AdmobService();
BannerAd? _CorebannerAd;
RewardedAd? _CorerewardedAd;

@override
void initState() {
  admobService.createInterstialAd();
  admobService.showInterstialAds();
  admobService.create_reward();
  _CorebannerAd = admobService.banner_ad();
  _CorebannerAd?..load();
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

//@override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePagemain(),
    );
  }
}
