// @dart=2.9
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'DBMS/DBMS_Homepage.dart';
import 'DBMS/login.dart';
import 'DBMS/onboarding.dart';
int initScreen;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences=await SharedPreferences.getInstance();
  initScreen=(await preferences.getInt('initScreen'));
  await preferences.setInt('initScreen', 1);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isRememberMe = false;
  @override
  void initState(){
    getData();
  }

  getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isRememberMe = prefs.getBool('remember');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen1()
    );
  }
}

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({Key key}) : super(key: key);

  @override
  _SplashScreen1State createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  @override
  void initState(){
    super.initState();
    loadData();
  }
  bool isRemember=false;
  Future<Timer> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isRemember = prefs.getBool('remember');
    });
    return Timer(Duration(seconds: 3),onDoneLoading);
  }
  onDoneLoading(){
    if(isRemember==true){
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => DBMS_Homepage()));
    }
    else{
      print(initScreen);
      initScreen==0|| initScreen==null?
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => OnboardingScreen())):
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
    }
  }

  @override
  void dispose() {
    super.dispose();
    loadData();
    onDoneLoading();
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: size.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.deepPurple.shade600,
                  Colors.deepPurple.shade500,Colors.deepPurple.shade400,
                  Colors.deepPurple.shade300])
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset('assets/splash.png',
                width: 170,
                height: 170,),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 45,top:30),
                child: Shimmer.fromColors(
                  period: Duration(seconds:2),
                    child: Center(
                      child: Text("DBMS POINT",
                        style: TextStyle(
                            fontSize: 50,
                            shadows: <Shadow>[
                              Shadow(
                                blurRadius: 18,
                                color: Colors.black87,
                              )
                            ]
                        ),),
                    ),
                    baseColor: Colors.white,
                    highlightColor: Colors.deepOrange
                )
            ),
          ],
        ),
      ),
    );
  }
}