import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dbms_details.dart';
import 'loadingScreen.dart';

class DBMS_Fav extends StatefulWidget {
  const DBMS_Fav({Key? key}) : super(key: key);

  @override
  _DBMS_FavState createState() => _DBMS_FavState();
}

class _DBMS_FavState extends State<DBMS_Fav> {
  final firestoreInstance = FirebaseFirestore.instance;
  final firebaseUser=FirebaseAuth.instance.currentUser;
  List fav =[];bool favs=true;String result="Connected";
  bool loading=true;
  List<Color> colors=[
    Color(0xffff6968),Color(0xff7a54ff),Color(0xffff8f61),Color(0xff2ac3ff),Colors.green,];

  @override
  Widget build(BuildContext context) {
    _checkInternetConnectivity();
    firestoreInstance.collection("Users").doc(firebaseUser!.uid).get().then((value){
      setState(() {
        fav = value.data()!["dbms_Fav"];});
      favs = (value.data()!["dbms_Fav"].isEmpty) ? false : true;
      if(value.data()!["dbms_Fav"]!=null){
        loading = false;}
    });
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
//return Scaffold(
    return internetCheck==false?loading==false?Scaffold(
        appBar: AppBar(
          title: Text("Favorites"),
          backgroundColor: Colors.deepPurple.shade300,
        ),
        body: favs?Container(
          margin: EdgeInsets.all(10),
          height: height,
          width: width,
        child: GridView.builder(
          itemCount: fav.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
            itemBuilder: (context,index){
            int tempIndex=index+1;
            return GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DBMS_Details(subTopicName: fav[index])));
              },
              child: Card(
                margin: EdgeInsets.all(5),
                elevation: 6,
                color: tempIndex%5==1?colors[0]:tempIndex%5==2?colors[1]:tempIndex%5==3?colors[2]:tempIndex%5==4?colors[3]:colors[4],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(fav[index],style: TextStyle(color: Colors.white,fontSize: 20),textAlign: TextAlign.center,)
                    ],
                  ),
                ),
              ),
            );
            }),
        ):Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.25),
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/favoriteEmpty.png")
                  )
              ),
            ),
            Text("You have no favorites",style: TextStyle(
              fontSize: 20,
            ),),
          ],
        )
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

}