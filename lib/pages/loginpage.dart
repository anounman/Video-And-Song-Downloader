import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'LoginFunctionPage.dart';
import 'home.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.purpleAccent, Colors.deepPurple])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () async{
                  setState(() {
                    isClicked = true;
                  });
                  await Future.delayed(Duration(seconds: 2));
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginFunctionPage()),
                        (Route<dynamic> route) => false,
                  );
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isClicked
                              ? "".text.make()
                              : "Login For".text.white.make().pOnly(right: 15),
                          isClicked
                              ? "".text.make()
                              : "Download".text.white.make().pOnly(right: 15),
                          isClicked
                              ? "".text.make()
                              : "Private Post".text.white.make().pOnly(right: 6),
                        ],
                      ),
                      AnimatedContainer(
                          duration: Duration(seconds: 2),
                          height: isClicked ? 100 : 50,
                          width: isClicked ? 100 : 50,
                          child: Image(
                            image: AssetImage("assets/images/instagram.jpeg"),
                            fit: BoxFit.cover,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePagemain()));
                },
                child: "Or Just Skipped >>".text.black.bold.size(20).make().pOnly(top:100)),
          ],
        ),
      ),
    );
  }
}
