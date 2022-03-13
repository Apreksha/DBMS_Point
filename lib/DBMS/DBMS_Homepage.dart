import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DBMS_fav.dart';
import 'DBMS_search.dart';
import 'dbms_topics_list.dart';
import 'loadingScreen.dart';
import 'login.dart';

FSBStatus status=FSBStatus.FSB_CLOSE;
bool menuButton=false;
class DBMS_Homepage extends StatefulWidget {
  const DBMS_Homepage({Key? key}) : super(key: key);
  @override
  _DBMS_HomepageState createState() => _DBMS_HomepageState();
}

class _DBMS_HomepageState extends State<DBMS_Homepage> {
double value=0;
String result="Connected";  bool loading = true;  List fav =[];bool favs=true;
final firestoreInstance = FirebaseFirestore.instance;
final firebaseUser=FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    _checkInternetConnectivity();
    firestoreInstance.collection("Users").doc(firebaseUser!.uid).get().then((value){
      setState(() {
        fav = value.data()!["dbms_Fav"];});
      if(value.data()!["dbms_Fav"]!= null){
        loading = false;}
    });
    return internetCheck==false?loading==false?SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('      DBMS'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
            )
          ],
        ),
      extendBodyBehindAppBar: true,
        body: FoldableSidebarBuilder(
          status:  status,
          drawerBackgroundColor: Colors.deepPurple.shade600,
          drawer: CustomDrawer(closeDrawer: (){
            setState(() {
              FSBStatus.FSB_CLOSE;// For Closing the Sidebar
            });
          },),
          screenContents: ExploreScreen(),
        ),
        floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.white,
          child: Icon(menuButton?Icons.arrow_back:Icons.menu),
          onPressed: (){
            setState(() {
              menuButton=!menuButton;
              status=status==FSBStatus.FSB_OPEN?FSBStatus.FSB_CLOSE:FSBStatus.FSB_OPEN;
            });
          },
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
  void ChangeValue(String resultValue) {
    setState(() {
      result=resultValue;
    });
  }
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List topics=['Introduction','ER Model','Relational Alegbra','Relational Calculus','SQL Queries','Schema Refinement'];
  _subLists(int index,String mainTopic){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DBMS_Topic_List(topicIndex: index,mainTopic: mainTopic,)));
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.deepPurple.shade600,
                      Colors.deepPurple.shade500,Colors.deepPurple.shade400,
                      Colors.deepPurple.shade300])
            ),
            padding: EdgeInsets.all(10),
            child: Center(
              child: Stack(
                overflow: Overflow.visible,
                alignment: Alignment.topCenter,
                children: [
                  Swiper(
                    itemCount: topics.length,
                    itemBuilder: (context,index){
                      return  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: ()=>_subLists(index,topics[index]),
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 50),
                                  height: 300,
                                  width: 400,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black,width: 2,style: BorderStyle.solid),
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomRight,
                                          end: Alignment.topLeft,
                                          colors: [Colors.orange.shade500,Colors.orange.shade300,Colors.orange.shade100]),
                                      borderRadius: BorderRadius.circular(40)
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(topics[index],style: TextStyle(
                                            fontSize: 27,
                                            color: Colors.black
                                        ),),
                                        BorderedText(
                                            strokeWidth: 3,
                                            strokeColor: Colors.black,
                                            child: Text('${index+1}',style: TextStyle(
                                                fontSize: 100,
                                                color: Colors.grey
                                            ),))
                                      ],
                                    ),
                                  ),
                                ),
                                Center(child: Image.asset("assets/database.png",height: 120,)),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    pagination: SwiperPagination(),
                    control: SwiperControl(
                        color: Colors.black,
                        disableColor: Colors.white
                    ),
                    scrollDirection: Axis.horizontal,
                    loop: false,
                    viewportFraction: 0.8,
                    scale: 0.9,
                  ),
                ],
              ),
            )
        ),
      )
    );
  }
}

class CustomDrawer extends StatelessWidget {
  final Function closeDrawer;
  const CustomDrawer({Key? key,required this.closeDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery=MediaQuery.of(context);
    return Container(
      color: Colors.white,
      width: mediaQuery.size.width*0.6,
      height: mediaQuery.size.height,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 80),
            width: double.infinity,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  onTap: (){
                    menuButton=!menuButton;
                    status=status==FSBStatus.FSB_OPEN?FSBStatus.FSB_CLOSE:FSBStatus.FSB_OPEN;
                  },
                  leading: Icon(Icons.home,
                    color: Colors.black,),
                  title: Text("Home",style: TextStyle(
                      color: Colors.black
                  ),),
                ),
                ListTile(
                  onTap: (){
                    Navigator.of(context)
                        .push(
                        MaterialPageRoute(builder: (context) => DBMS_Fav()));
                  },
                  leading: Icon(Icons.favorite,
                    color: Colors.black,),
                  title: Text("Favorites",style: TextStyle(
                      color: Colors.black
                  ),),
                ),
                ListTile(
                  onTap: () async{
                    return showDialog(context: context,builder: (BuildContext context){
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)
                        ),
                        child: Stack(
                          overflow: Overflow.visible,
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                                height: 170,
                                child: Column(
                                  children: [
                                    SizedBox(height:70),
                                    Text("Do you want to logout?",
                                      style: TextStyle(
                                          fontSize: 20
                                      ),),
                                    SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                            onPressed: () async{
                                              final SharedPreferences sha = await SharedPreferences
                                                  .getInstance();
                                              sha.setBool('remember', false);
                                              Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(builder: (context) => Login()));
                                            },
                                            child: Text("Yes",
                                              style: TextStyle(
                                                  fontSize: 20
                                              ),)),
                                        TextButton(
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("No",
                                              style: TextStyle(
                                                  fontSize: 20
                                              ),)),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                            Positioned(
                                top: -60,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 60,
                                  child: Image.asset("assets/log out.png",height: 100,),
                                ))
                          ],
                        ),
                      );
                    });
                  },
                  leading: Icon(Icons.logout,
                    color: Colors.black,),
                  title: Text("Logout",style: TextStyle(
                      color: Colors.black
                  ),),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
