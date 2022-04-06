import 'package:flutter/material.dart';
import 'home.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginFunctionPage extends StatefulWidget {
  const LoginFunctionPage({Key? key}) : super(key: key);

  @override
  _LoginFunctionPageState createState() => _LoginFunctionPageState();
}

class _LoginFunctionPageState extends State<LoginFunctionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isClicked = false;
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.purpleAccent, Colors.deepPurple])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
              duration: Duration(seconds: 2),
              height: isClicked ? 350 : 150,
              width: isClicked ? 350 : 150,
              child: Image(
                image: AssetImage("assets/images/instagram.jpeg"),
                fit: BoxFit.cover,
              )).p12(),
          isClicked
              ? Container()
              : TextFormField(
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter UserName",
                    labelText: "Username",
                    hintStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(
                        color: Colors.white,
                        width: 2,
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
                ).p16(),
          isClicked
              ? Container()
              : TextFormField(
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter UserName",
                    labelText: "Username",
                    hintStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(
                        color: Colors.white,
                        width: 2,
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
                ).p16(),
          InkWell(
              onTap: () async {
                print("asdas");
                setState(() {
                  isClicked = true;
                });
                await Future.delayed(Duration(seconds: 1));
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePagemain()),
                    (Route<dynamic> route) => false);
              },
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                width: isClicked ? 70 : 150,
                height: isClicked ? 70 : 70,
                child: Center(
                  child: isClicked
                      ? Icon(
                          Icons.done,
                          color: Colors.deepPurpleAccent,
                          size: 35,
                        )
                      : "Login".text.purple500.make(),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(isClicked ? 30 : 20),
                    color: Colors.white),
              )).pOnly(top: 20)
        ],
      ),
    );
  }
}
