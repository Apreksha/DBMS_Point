import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'database.dart';
import 'login.dart';

class Verify extends StatefulWidget {
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final auth=FirebaseAuth.instance;
  late User user;
  late Timer timer;

  @override
  void initState(){
    user=auth.currentUser!;
    user.sendEmailVerification();
    timer=Timer.periodic(Duration(seconds: 1), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.deepPurple.shade500,
                  Colors.deepPurple.shade400,Colors.deepPurple.shade300,Colors.deepPurple.shade200])
        ),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 110,
                  width: 110,
                  child: Image.asset("assets/tick.png"),
                ),
                Text("A verification link has been sent to ${user.email}.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("\nPlease click on the link sent to your email account"
                        "to verify your email and continue the registration process.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                      ),
                    )
                ),
              ],
            )
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async{
    user=auth.currentUser!;
    User? updateUser=FirebaseAuth.instance.currentUser;
    await user.reload();
    if(user.emailVerified){
      Database(uid: updateUser!.uid).updateVerified(true);
      timer.cancel();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context)=> Login()));
    }
  }
}
