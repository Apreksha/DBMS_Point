import 'package:dbms/DBMS/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dbms_details.dart';

class DBMS_Topic_List extends StatefulWidget {
  final int topicIndex;final String mainTopic;
  const DBMS_Topic_List({Key? key,required this.topicIndex,required this.mainTopic}) : super(key: key);
  @override
  _DBMS_Topic_ListState createState() => _DBMS_Topic_ListState(topicIndex,mainTopic);
}

class _DBMS_Topic_ListState extends State<DBMS_Topic_List> {

late int topicIndex; late String mainTopic;
_DBMS_Topic_ListState(this.topicIndex,this.mainTopic);
  @override
  Widget build(BuildContext context) {
    var n=null;
    var topic1=Column(children: [topicList('What is DBMS?')/*,topicList('File System vs DBMS')*/,topicList('Advantages of DBMS'),topicList('Queries in DBMS'),
      subTopicList(['Query Processor','Storage Manager','Disk Storage'],'Structure of DBMS'),
      subTopicList(['Data Abstraction','Data Independence','Data Model','E-R Model'],'Describing and Storing Data')]);

    var topic2=Column(children: [topicList('Components of E-R diagram'),topicList('Keys in DBMS'),topicList('Key Constraints'),topicList('Participation Constraints'),topicList('Mapping Constraints'),
      topicList('Weak and Strong Entities'),subTopicList(['Generalisation','Specialisation','Aggregation'],"Class Hierarchies"),
      topicList('Degree of Relationship Set'),subTopicList(['Entity Sets vs Attributes','Entity sets vs Relationship','Binary vs n-ary Relationship'],"Design Issues")]) ;

    var topic3=Column(children: [topicList('Relational Algebra'),topicList('Select Operation'),topicList('Project Operation'),topicList('Union Operation'),topicList('Set Intersection Operation'),
      topicList('Set Difference Operation'),topicList('Cartesian Product'),topicList('Rename Operation'),topicList('Join Operation'),topicList('Division Operation'),
      topicList('Assignment Operation'),topicList('Generalised Projection'),topicList('Aggregate Function'),topicList('Modification in Database')]);

    var topic4=Column(children: [topicList('Relational Calculus'),topicList('Tuple Relational Calculus'),topicList('Domain Relational Calculus'),topicList('RC and RA comparison')]);

    var topic5=Column(children: [topicList('SQL'),topicList('SQL Data Types'),subTopicList(['SQL Commands','Data Definition Language','Data Manipulation Language',
      'Data Control Language','Transaction Control Language','Data Query Language'],'SQL Commands'),topicList('Arithmetic Expressions'),
      topicList('Row Selection'),topicList('Comparison Operators'),topicList('Logical Operators'),topicList('Sorting of Results'),
      topicList('Set Operations'),topicList('Aggregate Functions'),topicList('Single Row Functions'),topicList('Multi-Row Functions'),topicList('Foreign Key'),topicList('Nested Queries'),topicList('Embedded SQL I'),
      topicList('Embedded SQL II'),topicList('Dynamic SQL'),topicList('Views'),topicList('Cursors'),topicList('Assertions'),topicList('JDBC and ODBC'),topicList('Active Databases')]);

    var topic6=Column(children: [topicList('Schema Refinement'),subTopicList(['Introduction','Full Functional Dependency','Partial Functional Dependency','Closure'],'Functional Dependency'),
      subTopicList(['First Normal Form','Second Normal Form','Third Normal Form','Boyce Codd Normal Form','Fourth Normal Form','Fifth Normal Form'],'Normalisation'),/*topicList('Trigger')*/]);

    String result="Connected";
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: ()=>Navigator.of(context).pop()),
            title: Text("Data Base Management System"),
            backgroundColor: Colors.deepPurple.shade400,
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 10,left: 4,right: 4,bottom: 10),
                child:topicIndex==0?topic1:topicIndex==1?topic2:topicIndex==2?topic3:topicIndex==3?topic4:topicIndex==4?topic5:topicIndex==5?topic6:n)
          )
    ),
      )
    );
  }
Widget topicList(String topicName){
  return GestureDetector(
      onTap: (){
        int i=Data().topics.indexOf(topicName);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DBMS_Details(subTopicName: topicName,)));},
      child:Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(title: Text(topicName),leading: Image.asset('assets/database.png',height: 30,),
            trailing: IconButton(icon:Icon(Icons.arrow_forward,color: Colors.blue,), onPressed: (){
              int i=Data().topics.indexOf(topicName);
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DBMS_Details(subTopicName: topicName)));})),
      ));
}
Widget subTopicList(List sub,String top){
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black,width: 2),
      borderRadius: BorderRadius.circular(10),
    ),
    margin: EdgeInsets.all(4),
    child: ExpansionTile(title: Text(top),children: [
      for(int i=0;i<sub.length;i++)
        topicList(sub[i])]),
  );
}
}