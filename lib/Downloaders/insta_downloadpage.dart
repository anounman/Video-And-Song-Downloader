import 'dart:convert';
import '../ads/admob.dart';
import '../pages/home.dart';
import '../utility/route.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/cupertino.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class DownloadPage extends StatefulWidget {
  final String name;
  const DownloadPage({Key? key, required this.name}) : super(key: key);
////@override
  _DownloadPageState createState() => _DownloadPageState();
}

String fetchUrl = "";
String username = "";
var link = "";
String display_image = "";
String like = "";
String comment = "";
bool permissionGranted = false;
String dataType = "";
bool resPonce = false;

class _DownloadPageState extends State<DownloadPage> {
  AdmobService admobService = new AdmobService();
  // In the constructor, require a RecordObject.
  void initState() {
    resPonce = false;
    fetchUrl = '';
    // fetchUrl = url;
    super.initState();
    this.getJsonData();
    try {
      admobService.showInterstialAds();
    } catch (e) {
      print("Error TO Showing Ads $e");
    }
  }

  Future getJsonData() async {
    fetchUrl = "https://igv4api.herokuapp.com/?link=${widget.name.toString()}";
    print(fetchUrl);
    try {
      var responce = await http.get(Uri.parse(fetchUrl));
      setState(() {
        if (responce.body != "We are unabel to fetch your data") {
          final data = json.decode(responce.body);
          like = data["like"];
          comment = data["comment"];
          link = data["link"];
          display_image = data["src_image"];
          username = data["username"];
          dataType = data["type"];
        }
      });
    } catch (e) {
      print("Error>${e}");
      setState(() {
        resPonce = true;
      });
    }
  }
  ////@override

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: new DecorationImage(
                  image: new AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover),
            ),
            child: ListView(
              children: [
                Body(),
              ],
            )),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

////@override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
//@override
  bool isClicked = false;
  String downloadText = "";
  double _percentage = 0;
  bool _isDownload = false;
  bool isAdsPlay = false;
  bool _isDownloadFaild = false;

  void downloadInsta() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await Permission.storage.request();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });
    }
    setState(() {
      isClicked = true;
    });
    try {
      var path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      Dio dio = Dio();
      print(path);
      await dio.download(
          link,
          ((dataType == "video")
              ? "${path}/${like}.mp4"
              : "${path}/${like}.jpg"), onReceiveProgress: (rec, total) {
        var percentage = (rec / total) * 100;
        if (percentage < 100) {
          _percentage = percentage / 100;
          setState(() {
            downloadText = "Downloading....${percentage.floor()} %";
          });
        } else {
          downloadText = "Download Completed";
          setState(() {
            _isDownload = true;
          });
        }
      });
    } catch (e) {
      isClicked = false;
      _isDownloadFaild = true;
      print("Download Throug>${e}");
    }
  }

  Widget build(BuildContext context) {
    AdmobService admobService = new AdmobService();
    return resPonce
        ? Scaffold(
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePagemain()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Container(
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ).p12(),
                Padding(
                  padding: EdgeInsets.only(top: 300),
                  child: Row(
                    children: [
                      "This Data Is Not Downloadable"
                          .text
                          .bold
                          .xl2
                          .blue800
                          .make(),
                      Icon(
                        Icons.broken_image_rounded,
                        color: Colors.red,
                        size: 40,
                      )
                    ],
                  ).pOnly(left: 50),
                ),
              ],
            ),
          )
        : (link.isEmpty)
            ? Center(
                child: CircularProgressIndicator(color: Colors.red),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, MyRoute.instagram);
                          },
                          child: Container(
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ).p12(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.account_circle_rounded,
                          color: Colors.red,
                          size: 40,
                        ),
                        "$username".text.bold.white.size(30).make()
                      ],
                    ).pOnly(left: 15, top: 10),
                    Container(
                      decoration: BoxDecoration(border: Border.all(width: 2)),
                      child: Image.network(
                        display_image,
                        fit: BoxFit.scaleDown,
                      ).p16(),
                    ).p16(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 68,
                              width: 76,
                              child: Image(
                                image: AssetImage("assets/images/love.jpeg"),
                              ),
                            ),
                            "$like".text.bold.white.size(30).make()
                          ],
                        ).pOnly(left: 15),
                        Column(
                          children: [
                            Container(
                              height: 68,
                              width: 76,
                              child: Image(
                                image: AssetImage("assets/images/comment.jpeg"),
                              ),
                            ),
                            "$comment".text.bold.white.size(30).make()
                          ],
                        ).pOnly(left: 180),
                      ],
                    ).pOnly(left: 15),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Material(
                        color: Color.fromRGBO(236, 85, 105, 1),
                        borderRadius: BorderRadius.circular(isClicked ? 50 : 8),
                        child: InkWell(
                          onTap: () => downloadInsta(),
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            width: isClicked ? 70 : 150,
                            height: 70,
                            child: Center(
                                child: _isDownload
                                    ? Icon(Icons.done, color: Colors.white)
                                    : (isClicked
                                        ? CircularProgressIndicator(
                                            value: _percentage,
                                            color: Colors.white,
                                            strokeWidth: 10,
                                            backgroundColor: Colors.red,
                                          )
                                        : Text(
                                            _isDownloadFaild
                                                ? "Donwload Faild"
                                                : "Download",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      downloadText,
                      style: TextStyle(color: Colors.white),
                    ).p16(),
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: 50,
                      child: AdWidget(
                        key: UniqueKey(),
                        ad: admobService.myBanner..load(),
                      ),
                    )
                  ],
                ),
              );
  }
}
