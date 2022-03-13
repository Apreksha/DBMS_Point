import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database{
  final String uid;
  Database({required this.uid});
  final CollectionReference users=FirebaseFirestore.instance.collection("Users");
  Future updateUserData(String email,String userName,var phone,bool emailVerified,bool phoneVerified,List dbms_fav) async{
    return await users.doc(uid).set({
      'Email': email,
      'Username': userName,
      'emailVerified':emailVerified,
      'Phone':phone,
      'phoneVerified':phoneVerified,
      'dbms_Fav':dbms_fav
    });
  }
  Future UserDataDelete(uid) async{
    return await users.doc(uid).delete();
  }
  Future updateVerified(bool verify) async{
    return await users.doc(uid).update({
      'emailVerified':verify,
    });
  }
}