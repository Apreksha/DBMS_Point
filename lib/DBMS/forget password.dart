import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> with SingleTickerProviderStateMixin {
  String _email="";  String result="Connected";
  final auth=FirebaseAuth.instance;
  late Animation<double> containerSize;
  late AnimationController animationController;
  Duration animationDuration=Duration(milliseconds: 270);

  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    animationController=AnimationController(vsync: this,duration: animationDuration);
  }

  @override
  void dispose(){
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    Size size=MediaQuery.of(context).size;
    double viewInset=MediaQuery.of(context).viewInsets.bottom;
    double defaultLoginSize=size.height-(size.height*0.2);
    double defaultRegisterSize=size.height-(size.height*0.1);
    containerSize=Tween<double>(begin: size.height*0.1,end: defaultRegisterSize).animate(CurvedAnimation(parent: animationController, curve: Curves.linear));
    _checkInternetConnectivity();
    return internetCheck==false?SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
                top: 100,
                right: -50,
                child:Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.deepPurple.shade700,
                  ),
                )
            ),
            Positioned(
                top: -50,
                left: -50,
                child:Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.deepPurple.shade700,
                  ),
                )
            ),
            Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Container(
                  width: size.width,
                  height: defaultLoginSize,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Reset Password',style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24
                      ),),
                      SizedBox(height: 40,),
                      Image.asset('assets/database.png',width: 100,height: 100,),
                      SizedBox(height: 40,),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        width: size.width*0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.deepPurple.shade100,
                          //border: Border.all(color: Colors.black,width: 1),
                        ),
                        child: TextField(
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                              icon: Icon(Icons.email,color: Colors.deepPurple.shade700,),
                              hintText: 'Email',
                              border: InputBorder.none
                          ),
                          onChanged: (value){
                            setState((){
                              _email=value.trim();
                            });
                          },
                        ),
                      ),
                      InkWell(
                        onTap: ()async{
                          if(_email==""){
                            Fluttertoast.showToast(
                                msg: "Invalid Input",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }
                          else{
                            auth.sendPasswordResetEmail(email: _email);
                            Fluttertoast.showToast(
                                msg: "An email has been sent on your registered Email ID",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => Login()));
                          }
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: size.width*0.8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.deepPurple.shade700
                          ),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          alignment: Alignment.center,
                          child: Text('Forgot Password',style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
                          ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ):Scaffold(
        backgroundColor: Colors.orange.shade100,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: 150,
                  width: 200,
                  child: Image.asset("assets/embarrassed.png")),
            ),
            Center(child: Text("Unable to connect to Internet",style: TextStyle(
              fontSize: 20,
            ),)),
            Center(child: Text("Try again!",style: TextStyle(
              fontSize: 20,
            ),)),
          ],
        ));
  }
  bool internetCheck = true;
  _checkInternetConnectivity()async{
    var result = await Connectivity().checkConnectivity();
    setState(() {
      if(result == ConnectivityResult.wifi|| result == ConnectivityResult.mobile){
        setState(() {
          internetCheck = false;
        });
      }else{
        internetCheck = true;
      }
    });
  }
  void ChangeValue(String resultValue){
    setState(() {
      result=resultValue;
    });
  }
}
