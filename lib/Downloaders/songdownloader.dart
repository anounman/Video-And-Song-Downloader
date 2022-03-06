import 'dart:convert';
import 'dart:io';
import '../ads/admob.dart';
import '../pages/music_search.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../main.dart';

bool isPlayed = false;

class MusicDownload extends StatefulWidget {
  final String name;
  const MusicDownload({Key? key, required this.name}) : super(key: key);

//@override
  _MusicDownloadState createState() => _MusicDownloadState();
}

String fetchUrl = "";
var link = "";
var hd_link = "";
String display_image = "";
bool permissionGranted = false;
bool resPonce = false;
String filename = "";
String error = "";
bool isAdsPlay = false;
final _player = AudioPlayer();

class _MusicDownloadState extends State<MusicDownload> {
  // In the constructor, require a RecordObject.
  AdmobService admobService = AdmobService();
  void initState() {
    super.initState();
    filename = widget.name.toString();
    resPonce = false;
    fetchUrl =
        "https://songapiv1.herokuapp.com/?name=${widget.name.toString()}";
    display_image = "";
    link = "";
    display_image = "";

    this.getJsonData();
  }

  Future getJsonData() async {
    try {
      // print("\n\nFetch_Url > ${fetchUrl}\n\n");
      var responce = await http.get(Uri.parse(fetchUrl));
      setState(() {
        if (responce.body != "We are unabel to fetch your data") {
          final data = json.decode(responce.body);
          link = data["audio"];
          // print(link);
          hd_link = data["hd_audio"];
          display_image = data["thumbnail"];
        }
      });
    } catch (e) {
      print("Error>${e.toString()}");
      setState(() {
        resPonce = true;
      });
    }
  }
  //@override

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Body(),
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

  void downloadMusic() async {
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
      int lent = 21;
      try {
        if (filename.length <= 20) {
          lent = filename.length;
        }
        filename = filename.replaceAll('/', '');
        filename = filename.replaceAll('https', '');
        filename = filename.replaceAll(':', '');
        print(filename.characters.take(lent));
      } catch (e) {
        print("Name Change Error$e");
      }

      Directory path_name = await Directory("${path}/${filename}.mp3");
      print(path_name.existsSync());
      if (await path_name.exists()) {
        path_name.delete();
      }
      await dio.download(hd_link, "${path}/${filename}.mp3",
          onReceiveProgress: (rec, total) {
        var percentage = (rec / total) * 100;
        if (percentage < 100) {
          _percentage = percentage / 100;
          setState(() {
            downloadText = "Downloading....${percentage.floor()}%";
          });
        } else {
          downloadText = "Download Completed";
          setState(() {
            _isDownload = true;
          });
        }
      });
    } catch (e) {
      await Permission.storage.request();
      setState(() {
        isClicked = false;
        downloadText = "Download Faild";
      });
      print("Download Throug>${e}");
    }
  }

  bool isClicked = false;
  String downloadText = "";
  double _percentage = 0;
  bool _isDownload = false;

  Widget build(BuildContext context) {
    return resPonce
        ? Scaffold(
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: music(),
                                type: PageTransitionType.rightToLeft));
                      },
                      child: Container(
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 30,
                          color: Colors.red,
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
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage("assets/images/background.jpg"),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: music(),
                                          type:
                                              PageTransitionType.rightToLeft));
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
                          ).pOnly(left: 15, top: 10),
                          Container(
                            decoration:
                                BoxDecoration(border: Border.all(width: 2)),
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
                                  InkWell(
                                      onTap: () async {
                                        await _player.setAudioSource(
                                            AudioSource.uri(Uri.parse(link)));
                                        isPlayed
                                            ? _player.pause()
                                            : _player.play();
                                        setState(() {
                                          isPlayed
                                              ? (isPlayed = false)
                                              : (isPlayed = true);
                                        });
                                      },
                                      child: isPlayed
                                          ? Icon(
                                              CupertinoIcons.pause_circle,
                                              color: Colors.red,
                                              size: 40,
                                            )
                                          : Icon(
                                              CupertinoIcons.play_circle,
                                              color: Colors.red,
                                              size: 40,
                                            )),
                                ],
                              ).pOnly(left: 15),
                              Column(
                                children: [
                                  InkWell(
                                      onTap: () => downloadMusic(),
                                      child: Icon(
                                        Icons.download_rounded,
                                        color: Colors.red,
                                        size: 40,
                                      )),
                                ],
                              ).pOnly(left: 215),
                            ],
                          ).pOnly(left: 15),
                          // ProgressBar(
                          //   progress: Duration.zero,
                          //   total: Duration.zero,
                          //   baseBarColor: Colors.red,
                          // ).pOnly(left: 40, right: 40, top: 20),
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Material(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.circular(isClicked ? 50 : 8),
                                child: InkWell(
                                  onTap: () => downloadMusic(),
                                  child: AnimatedContainer(
                                    duration: Duration(seconds: 1),
                                    width: isClicked ? 70 : 150,
                                    height: 70,
                                    child: Center(
                                        child: _isDownload
                                            ? Icon(Icons.done,
                                                color: Colors.white)
                                            : (isClicked
                                                ? CircularProgressIndicator(
                                                    value: _percentage,
                                                    color: Colors.white,
                                                    strokeWidth: 10,
                                                    backgroundColor: Colors.red,
                                                  )
                                                : Text(
                                                    "Download",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ))),
                                  ),
                                )),
                          ),
                          Text(
                            downloadText,
                            style: TextStyle(color: Colors.white),
                          ).p16(),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 50,
                              child: AdWidget(
                                key: UniqueKey(),
                                ad: admobService.myBanner..load(),
                              ),
                            ),
                          ).pOnly(top: 300),
                        ],
                      ),
                    ],
                  ),
                ),
              );
  }
}
