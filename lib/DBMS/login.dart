import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dbms/DBMS/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DBMS_Homepage.dart';
import 'database.dart';
import 'forget password.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  List reads=[];
  List dbms_fav=[];
  String _signupEmail="",_signupPassword="",_signupUsername="";
  var signupPhone;
  bool emailVerified=false,phoneVerified=false,verify=false;
  final auth=FirebaseAuth.instance;
  String _loginEmail="",_loginPassword="";
  var f=0;String result="";

  bool isLogin=true;
  late Animation<double> containerSize;
  late AnimationController animationController;
  Duration animationDuration=Duration(milliseconds: 270);

  @override
  void initState(){
    super.initState();
    animationController=AnimationController(vsync: this,duration: animationDuration);
  }

  @override
  void dispose(){
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.purple.withOpacity(0.3),
    ));
_checkInternetConnectivity();
    Size size=MediaQuery.of(context).size;
    double viewInset=MediaQuery.of(context).viewInsets.bottom;
    double defaultLoginSize=size.height-(size.height*0.2);
    double defaultRegisterSize=size.height-(size.height*0.1)-25;
containerSize=Tween<double>(begin: size.height*0.1,end: defaultRegisterSize).animate(CurvedAnimation(parent: animationController, curve: Curves.linear));
    return internetCheck==false? SafeArea(
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
            AnimatedOpacity(
              opacity: isLogin?0.0:1.0,
              duration: animationDuration,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(width: size.width,
                height: size.height*0.1,alignment: Alignment.bottomCenter,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed:isLogin?null: (){
                    animationController.reverse();
                    setState(() {
                      isLogin=!isLogin;
                    });
                  },
                  color: Colors.blue,
                ),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: isLogin?1.0:0.0,
              duration: animationDuration*4,
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Container(
                    width: size.width,
                    height: defaultLoginSize,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10,),
                        Image.asset('assets/welcomeBack.png',width: 200,height:200,),
                        //SizedBox(height: 15,),
                        Container(
                          //margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          width: size.width*0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.deepPurple.shade100,
                          ),
                          child: TextField(
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              icon: Icon(Icons.email,color: Colors.deepPurple.shade700,),
                              hintText: 'Email',
                              border: InputBorder.none
                            ),
                            onChanged: (value){
                              setState(() {
                                _loginEmail=value.trim();
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          width: size.width*0.8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            color: Colors.deepPurple.shade100,
                          ),
                          child: TextField(
                            cursorColor: Colors.grey,
                            obscureText: true,
                            decoration: InputDecoration(
                                icon: Icon(Icons.lock,color: Colors.deepPurple.shade700,),
                                hintText: 'Password',
                                border: InputBorder.none
                            ),
                            onChanged: (value){
                              setState((){
                                _loginPassword=value.trim();
                              });
                            },
                          ),
                        ),
                        Container(
                          width: size.width*0.8,
                          margin: EdgeInsets.only(bottom: 5),
                          alignment: Alignment.centerRight,
                          child: TextButton(onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ForgotPassword()));},
                              child: Text('Forgot Password',style: TextStyle(
                                fontSize: 17,
                                color: Colors.black
                              ),)
                          ),
                        ),
                        InkWell(
                          onTap: () async{
                            if(_loginEmail=="" || _loginPassword==""){
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
                              _login(_loginEmail,_loginPassword);
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
                            child: Text('LOGIN',style: TextStyle(
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
            ),
            AnimatedBuilder(
              animation: animationController,
              builder: (context,child){
                if(viewInset==0 && isLogin) {
                  return buildRegisterContainer();
                }
                else if(!isLogin){
                  return buildRegisterContainer();
                }
                return Container();
              },
            ),
            AnimatedOpacity(
              opacity: isLogin?0.0:1.0,
              duration: animationDuration*5,
              child: Visibility(
                visible: !isLogin,
                  child:Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: size.width,
                      height: defaultLoginSize-40,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/welcome.png',width: 100,height: 100,),
                            SizedBox(height: 20,),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              width: size.width*0.8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.deepPurple.shade100,
                              ),
                              child: TextField(
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.email,color: Colors.deepPurple.shade700,),
                                    hintText: 'Email',
                                    border: InputBorder.none
                                ),
                                onChanged: (value){
                                  setState(() {
                                    _signupEmail=value.trim();
                                  });
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              width: size.width*0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.deepPurple.shade100,
                              ),
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.phone_android,color: Colors.deepPurple.shade700,),
                                    hintText: 'Mobile',
                                    border: InputBorder.none
                                ),
                                onChanged: (value){
                                  setState((){
                                   signupPhone=value.trim();
                                  });
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              width: size.width*0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.deepPurple.shade100,
                              ),
                              child: TextField(
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.face_outlined,color: Colors.deepPurple.shade700,),
                                    hintText: 'Username',
                                    border: InputBorder.none
                                ),
                                onChanged: (value){
                                  setState((){
                                    _signupUsername=value.trim();
                                  });
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              width: size.width*0.8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                color: Colors.deepPurple.shade100,
                              ),
                              child: TextField(
                                cursorColor: Colors.grey,
                                obscureText: true,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.lock,color: Colors.deepPurple.shade700,),
                                    hintText: 'Password',
                                    border: InputBorder.none
                                ),
                                onChanged: (value){
                                  setState((){
                                    _signupPassword=value.trim();
                                  });
                                },
                              ),
                            ),
                            InkWell(
                              onTap: () async{
                                if(_signupEmail=="" || _signupPassword==""|| _signupUsername==""||signupPhone==""||signupPhone.toString().length<10||signupPhone.toString().length>10){
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
                                  _signup(_signupEmail,_signupPassword);
                                }
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                width: size.width*0.8,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                  color:Colors.deepPurple.shade700,
                                ),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.symmetric(vertical: 20),
                                alignment: Alignment.center,
                                child: Text('SIGN UP',style: TextStyle(
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
              ),
            )
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

  Widget buildRegisterContainer(){
return Align(
  alignment: Alignment.bottomCenter,
  child: Container(
    width: double.infinity,
    height: containerSize.value,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(100),
            topRight: Radius.circular(100)),
        color: Colors.grey.shade300
    ),
    alignment: Alignment.center,
    child: GestureDetector(
      onTap: !isLogin?null:(){
        animationController.forward();
        setState(() {
          isLogin=!isLogin;
        });
      },
      child: isLogin?Text("Don't have an account? Sign up",style: TextStyle(
          color: Colors.deepPurple.shade700,
          fontSize: 18
      ),):null,
    ),
  ),
);
  }

  _login(String _email,String _password) async {
    User? updateUser = FirebaseAuth.instance.currentUser;
    late User user;
    final firestoreInstance=FirebaseFirestore.instance;
    var firebaseUser=FirebaseAuth.instance.currentUser;
    bool verified=false;
    try {
      await auth.signInWithEmailAndPassword(
          email: _email,
          password: _password);
      firestoreInstance.collection("Users").doc(firebaseUser!.uid).get().then((value) async{
        verified=value.data()!["emailVerified"];
        if(verified==true){
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('remember', true);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => DBMS_Homepage()));
        }
        else if(verified==false){
          Fluttertoast.showToast(
              msg: "You are not verified. Register again.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0
          );
          Database(uid: updateUser!.uid).UserDataDelete(updateUser.uid);
          updateUser.delete();
        }
      });

    }
    on FirebaseAuthException catch (error) {
      print(error.message);
      Fluttertoast.showToast(
          msg: "${error.message}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  _signup(String _email,String _password) async{
    try{
      await auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password);
      User? updateUser=FirebaseAuth.instance.currentUser;
      updateUser!.updateDisplayName(_signupUsername);
      Database(uid: updateUser.uid).updateUserData(_email,_signupUsername,signupPhone,emailVerified,phoneVerified,dbms_fav);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Verify()));
    }
    on FirebaseAuthException catch(error){
      Fluttertoast.showToast(
          msg: "${error.message}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 14.0
      );
    }
  }

}
