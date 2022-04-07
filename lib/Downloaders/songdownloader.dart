import 'dart:convert';
import 'dart:io';
import 'package:app/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
import 'package:app/ads/admob.dart';
import 'package:open_file/open_file.dart';
import '../pages/home.dart';

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
bool isBack = false;
bool isDownloading = false;

class _MusicDownloadState extends State<MusicDownload> {
  // In the constructor, require a RecordObject.
  AdmobService admobService = AdmobService();
  BannerAd? bannerAd;
  void initState() {
    super.initState();
    bannerAd = admobService.banner_ad();
    bannerAd?.load();
    filename = widget.name.toString();
    resPonce = false;
    fetchUrl =
        "https://songapiv1.herokuapp.com/?name=${widget.name.toString()}+ lyrics";
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
        body: Body(
          bannerAd: bannerAd!,
          admobService: admobService,
        ),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key, required this.bannerAd, required this.admobService})
      : super(key: key);
  final BannerAd bannerAd;
  final AdmobService admobService;
////@override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
//@override
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  int Adshow = 0;
  int DownlodsAdd = 0;
  int notifiactionID = 0;
  void initState() {
    super.initState();
    if (downloads <= 30) admobService.create_reward();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initSettings = InitializationSettings(android: android);
    if (Adshow == 0) admobService.createInterstialAd();
    flutterLocalNotificationsPlugin!
        .initialize(initSettings, onSelectNotification: _onSelectNotification);
  }

  void getData() {
    setState(() {
      downloads = prefs.getInt('downloaded') ?? 0;
    });
  }

  void _onSelectNotification(String? json) async {
    final obj = jsonDecode(json!);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final text = downloadStatus['text'];
    int percentage = downloadStatus['percentage'];
    final android = AndroidNotificationDetails('channel id', 'channel name',
        enableVibration: (text != '') ? false : true,
        showProgress: (text != '') ? true : false,
        enableLights: false,
        maxProgress: 100,
        progress: percentage,
        onlyAlertOnce: (text != '') ? true : false,
        priority: (text != '') ? Priority.min : Priority.high,
        importance: (text != '') ? Importance.low : Importance.max);
    final platform = NotificationDetails(android: android);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin!.show(
        notifiactionID, // notification id
        (text != '') ? text : (isSuccess ? 'Downloaded' : 'Failed'),
        (text != '')
            ? ''
            : (isSuccess
                ? 'File has been downloaded successfully!'
                : 'There was an error while downloading the file.'),
        platform,
        payload: json);
  }

  void downloadMusic() async {
    isDownloading = true;
    // try {
    //   admobService.showInterstialAds();
    //   Adshow += 1;
    // } catch (e) {
    //   print("Error>${e.toString()}");
    // } finally {
    //   admobService.dispose_interstial();
    // }
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
      'text': '',
      'percentage': 0,
      'total': 0,
    };
    // if (permissionGranted) {
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => HomePagemain()),
    //     (Route<dynamic> route) => false,
    //   );
    // }
    notifiactionID += 1;
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
    if (downloads <= 30) {
      try {
        admobService.showRewardAds();
        admobService.showInterstialAds();
        downloads += 30;
      } catch (e) {
        DownlodsAdd = downloads + 30;
        isDownloading = false;
        downloads = DownlodsAdd;
        prefs.setInt('downloaded', DownlodsAdd);
      } finally {
        downloadMusic();
      }
    } else {
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
            if (!isBack) {
              setState(() {
                downloadText = "Downloading....${percentage.floor()}%";
              });
            } else {
              downloadText = "Downloading.....${percentage.floor()}%";
            }
            result['text'] = downloadText;
            result['percentage'] = percentage.floor();
            result['total'] = total;
            _showNotification(result);
          } else {
            downloadText = "Download Completed";
            setState(() {
              _isDownload = true;
            });
          }
        });
        result['isSuccess'] = true;
        result['filePath'] = "${path}/${filename}.mp3";
      } catch (e) {
        result['error'] = e.toString();
        await Permission.storage.request();
        isDownloading = false;
        if (!isBack) {
          setState(() {
            isClicked = false;
            downloadText = "Download Faild";
          });
        } else {
          downloadText = "Download Faild";
        }
        print("Download Throug>${e}");
      } finally {
        result['text'] = '';
        isDownloading = false;
        downloads -= 10;
        await _showNotification(result);
        admobService.showInterstialAds();
      }
    }
  }

  bool isClicked = false;
  String downloadText = "";
  double _percentage = 0;
  bool _isDownload = false;

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("Backing....");
        setState(() {
          isBack = true;
        });
        return !await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePagemain()),
            (Route<dynamic> route) => false);
      },
      child: resPonce
          ? Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: HomePagemain(),
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
                                    setState(() {
                                      isBack = true;
                                    });
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            child: HomePagemain(),
                                            type: PageTransitionType
                                                .rightToLeft));
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
                                            ? Icon(Icons.done)
                                            : (isClicked
                                                ? CircularProgressIndicator(
                                                    value: _percentage,
                                                    color: Colors.white,
                                                    strokeWidth: 10,
                                                    backgroundColor: Colors.red,
                                                  )
                                                : Text("Download",
                                                    style: TextStyle(
                                                        color: Colors.white))),
                                      ),
                                    ),
                                  )),
                            ),
                            Text(
                              downloadText,
                              style: TextStyle(color: Colors.white),
                            ).p16(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
