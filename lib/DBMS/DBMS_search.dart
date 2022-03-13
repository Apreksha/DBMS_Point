import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'data.dart';
import 'dbms_details.dart';

final firestoreInstance = FirebaseFirestore.instance;
final firebaseUser=FirebaseAuth.instance.currentUser;
List search =[],topics=[],recent=[];
late String topic="";

class DataSearch extends SearchDelegate<String>{
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [IconButton(icon: Icon(Icons.clear), onPressed: (){
      query="";
      Navigator.of(context).pop();
    })];
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: AnimatedIcon(
          icon:AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ), onPressed: (){
      close(context,"");
    });
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Center(child: Container(
      color: Colors.white,
      child: Image.asset("assets/no.jpg"),));
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    topics=Data().topics;
    final suggestionList=query.isEmpty
        ?recent
        :topics.where((p) =>
        p.toString().toLowerCase().contains(query)).toList();
    return ListView.builder(
      itemBuilder: (context,index)=>ListTile(
          onTap: (){
            print("topic:${suggestionList[index]}");
            topic=suggestionList[index];
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DBMS_Details(subTopicName: topic)));
          },
          leading: Icon(Icons.library_books),
          title: RichText(
            text:TextSpan(
                text:suggestionList[index].substring(0,query.length),
                style: TextStyle(
                    color: Colors.black,
                    //fontWeight: FontWeight.bold
                ),
                children: [
                  TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(color: Colors.black)
                  )
                ]
            ),
          )
      ),
      itemCount: suggestionList.length,
    );
    throw UnimplementedError();
  }

}