import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data.dart';
import 'loadingScreen.dart';

class DBMS_Details extends StatefulWidget {
  final String subTopicName,prev,next;
  const DBMS_Details({Key? key,required this.subTopicName,required this.prev,required this.next}) : super(key: key);
  @override
  _DBMS_DetailsState createState() => _DBMS_DetailsState(subTopicName,prev,next);
}

class _DBMS_DetailsState extends State<DBMS_Details> {
  var subTopicName,prev,next;
  _DBMS_DetailsState(this.subTopicName,this.prev,this.next);
  final firestoreInstance = FirebaseFirestore.instance;
  final firebaseUser=FirebaseAuth.instance.currentUser;
  bool checkFav=false;bool loading=true;
  String result="Connected";
  void _checkFavMarked(){
    if(fav.contains(subTopicName)){
      checkFav=true;}
  }
  List fav=[];
  Future<void> _launchInBrowser(String url) async{
if(await canLaunch(url)){
  await launch(
    url,
    forceSafariVC: false,
    forceWebView: false,
    headers: <String,String>{'header_key':'header_value'},
  );
}
else{
  throw 'Could not launch $url';
}
}

  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    firestoreInstance.collection("Users").doc(firebaseUser!.uid).get().then((value){
      setState(() {
        fav = value.data()!["dbms_Fav"];});
      if(value.data()!["dbms_Fav"]!= null){
        loading = false;}
    });
    _checkFavMarked();
_checkInternetConnectivity();
    return internetCheck==false?loading==false?SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            Container(
              width: 50,
              color:Colors.deepPurple.shade700,
              child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back,color: Colors.white,size: 30,),
                    onPressed: (){
                      int i=Data().topics.indexOf(subTopicName);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                          DBMS_Details(subTopicName: subTopicName,prev: Data().topics[i-1],next: Data().topics[i+1],)));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: IconButton(
                    icon: Icon(checkFav?Icons.favorite:Icons.favorite_border,color: Colors.white,size: 30,),
                    onPressed: (){favsbuilder();},
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: height-220,
                  margin: EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.only(top: 10),
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Text(subTopicName,style: TextStyle(
                      color: Colors.white,
                      fontSize: 27
                    ),),
                  ),
                ),
              ],
            ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 60,width: width-50,
                    color:Colors.deepPurple.shade700,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            onTap: (){
                          _launchInBrowser(Data().chrome[subTopicName]!);
                        }, child: Container(
                          height: 40,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              shape: BoxShape.rectangle,
                              border: Border.all(color: Colors.white,width: 2)
                            ),
                            child: Text('Browser',
                            style: TextStyle(color: Colors.white,fontSize: 16),))),
                        /*GestureDetector(
                            onTap: (){
                              _launchInBrowser('https://www.youtube.com/watch?v=ET4HfMH-AoQ');
                            }, child: Container(
                            height: 40,
                            width: 80,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                shape: BoxShape.rectangle,
                                border: Border.all(color: Colors.white,width: 2)
                            ),
                            child: Text('Youtube',
                              style: TextStyle(color: Colors.white,fontSize: 16),))),*/
                        //IconButton(onPressed: (){}, icon: Icon(Icons.lightbulb,color: Colors.white,size: 35,))
                      ],
                    ),
                  ),
                  Container(
                      width: width-70,
                      height: height*0.84,
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.all(10),
                      child: SingleChildScrollView(child:Data().subTopics[subTopicName])
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ):LoadingScreen():Scaffold(
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
  favsbuilder() async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      var firebaseUser = FirebaseAuth.instance.currentUser;
      firestoreInstance.collection("Users").doc(firebaseUser!.uid).get().then((
          value) {
        print("uid: ${firebaseUser.uid}");
        if (value.data()!["dbms_Fav"].contains(subTopicName) == true) {
          firestoreInstance.collection("Users")
              .doc(firebaseUser.uid)
              .update({
            "dbms_Fav": FieldValue.arrayRemove(["$subTopicName"]),
          }).then((_) {
            setState(() {
              checkFav=false;
            });
          });
        }
        else {
          firestoreInstance.collection("Users")
              .doc(firebaseUser.uid)
              .update({
            "dbms_Fav": FieldValue.arrayUnion(["$subTopicName"]),
          }).then((_) {
            setState(() {
              checkFav=true;
            });
          });
        }
      });
    }
    catch (e) {
      print("error is $e");
    }
  }
}
