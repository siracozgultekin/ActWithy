import 'package:actwithy/Models/ActivityModel.dart';
import 'package:actwithy/Models/PostModel.dart';
import 'package:actwithy/Models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


class PostServices{
  String myId = FirebaseAuth.instance.currentUser!.uid;
CollectionReference users = FirebaseFirestore.instance.collection('users');
CollectionReference posts = FirebaseFirestore.instance.collection('posts');
CollectionReference activities = FirebaseFirestore.instance.collection('activities');

 Future<void> createActivity(String selectedItem, Timestamp time, String location) async{
   /*await activities.add(model.createMap()).then((value) async {
     String postId = value.id;
     await activities.doc(postId).update({'activityUID': postId,});
     PostModel obj=PostModel(date:Timestamp.now(), activityUID:postId, heartCounter, brokenHeartCounter, joyCounter, sobCounter, angryCounter)
     await posts.add(model.createMap());
     print('myID:$myId');
   });*/

   await activities.add({
    "activityType" : selectedItem,
     "location" : location,
     "time" : time
   }).then((value) async {await activities.doc(value.id).update({"activityUID":value.id});});

  }

  Future<List<UserModel>> getAllProfiles(String search) async {
    List<UserModel> models = [];
    QuerySnapshot query = await users.where('name', isLessThanOrEqualTo: search + 'z').orderBy('name',descending: false).get();
    String temp = "";
    for(var doc in query.docs){
      temp = doc['name'];
      temp=temp.toLowerCase();
      print('temp: $temp');
      print('aranan kelime: $search');

      if(temp.contains(search)){
        print('iceriyor: $search');
        models.add(UserModel.fromSnapshot(doc));
      }
    }
    return models;
  }



}