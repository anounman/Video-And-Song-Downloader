import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../ads/admob.dart';
import '../main.dart';
import 'home.dart';
import '../Downloaders/songdownloader.dart';
import 'youtube.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

String name = "";

class music extends StatefulWidget {
  const music({Key? key}) : super(key: key);

  // @override
  _musicState createState() => _musicState();
}

class _musicState extends State<music> {
  // @override
  final _fromkey = GlobalKey<FormState>();
  bool isClicked = false;
  String data = "";
  BannerAd? _bannerAd;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bannerAd = admobService.banner_ad();
    _bannerAd?..load();
  }

  @override
  Widget build(BuildContext context) {
    AdmobService admobService = new AdmobService();
    final _fromkey = GlobalKey<FormState>();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover),
        ),
        child: ListView(
          children: [
            Form(
              key: _fromkey,
              child: Column(
                children: [
                  "Song  Downloader"
                      .text
                      .size(45)
                      .white
                      .make()
                      .pOnly(top: 80, left: 20),
                  TextFormField(
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    onFieldSubmitted: (value) {
                      AdmobService().showInterstialAds();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MusicDownload(name: value)),
                      );
                    },
                    // cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: "Enter Song Name",
                      labelText: "Enter Song Name................",
                      hintStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                      // focusColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),

                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter A  Valid Url";
                      } else {
                        data = value;
                        return null;
                      }
                    },
                  ).pOnly(top: 30, left: 20, right: 20),
                  Container(
                    height: 350,
                    child: Column(
                      children: [
                        Container(
                          height: 10,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(233, 233, 233, 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ).pOnly(bottom: 40, top: 18),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                admobService.createInterstialAd();
                                admobService.showInterstialAds();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePagemain()),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: Container(
                                child: Center(
                                  child: Container(
                                      height: 63,
                                      width: 63,
                                      child: Image(
                                        image: AssetImage(
                                            "assets/images/instagram.jpeg"),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                height: 123,
                                width: 106,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(233, 233, 233, 1),
                                  borderRadius: BorderRadius.circular(37),
                                ),
                              ).pOnly(bottom: 40, left: 19),
                            ),
                            InkWell(
                              onTap: () {
                                admobService.createInterstialAd();
                                admobService.showInterstialAds();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => YouTube()),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: Container(
                                child: Center(
                                  child: Container(
                                      height: 63,
                                      width: 63,
                                      child: Image(
                                        image: AssetImage(
                                            "assets/images/youtube.jpeg"),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                height: 123,
                                width: 106,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(233, 233, 233, 1),
                                  borderRadius: BorderRadius.circular(37),
                                ),
                              ).pOnly(bottom: 40, left: 19),
                            ),
                            InkWell(
                              onTap: () {
                                admobService.createInterstialAd();
                                admobService.showInterstialAds();
                              },
                              child: Container(
                                child: Center(
                                  child: Container(
                                      height: 63,
                                      width: 63,
                                      child: Image(
                                        image: AssetImage(
                                            "assets/images/music.jpeg"),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                height: 123,
                                width: 106,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(252, 221, 236, 1),
                                  borderRadius: BorderRadius.circular(37),
                                ),
                              ).pOnly(bottom: 40, left: 19),
                            )
                          ],
                        ),
                        Container(
                          height: 50,
                          child: AdWidget(
                            key: UniqueKey(),
                            ad: _bannerAd!,
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                      color: Colors.white,
                    ),
                  ).pOnly(top: 240),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
