import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Downloaders/youtubedownloader.dart';
import '../ads/admob.dart';
import 'home.dart';
import 'music_search.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class YouTube extends StatefulWidget {
  const YouTube({Key? key}) : super(key: key);

  // @override
  _YouTubeState createState() => _YouTubeState();
}

class _YouTubeState extends State<YouTube> {
  // @override
  String data = "";
  final _fromkey = GlobalKey<FormState>();
  bool isClicked = false;
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
                  "YouTube Downloader"
                      .text
                      .size(45)
                      .white
                      .make()
                      .pOnly(top: 80, left: 20),
                  TextFormField(
                    onFieldSubmitted: (value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                YouTubeDownloader(name: value)),
                      );
                    },
                    cursorColor: Colors.white,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter The  Link",
                      labelText: "Enter Post Link.................",
                      hintStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                      focusColor: Colors.white,
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
                                  color: Color.fromRGBO(252, 221, 236, 1),
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
                                      builder: (context) => music()),
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
                                            "assets/images/music.jpeg"),
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
                            )
                          ],
                        ),
                        Container(
                          height: 50,
                          child: AdWidget(
                            key: UniqueKey(),
                            ad: admobService.myBanner..load(),
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
