<<<<<<< Updated upstream
=======
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

 Future<String> createActivity(String selectedItem, Timestamp time, String location) async{
   /* await activities.add(model.createMap()).then((value) async {
     String postId = value.id;
     await activities.doc(postId).update({'activityUID': postId,});
     PostModel obj=PostModel(date:Timestamp.now(), activityUID:postId, heartCounter, brokenHeartCounter, joyCounter, sobCounter, angryCounter)
     await posts.add(model.createMap());
     print('myID:$myId');
   });
   */
String returnID="";
   await activities.add({
    "activityType" : selectedItem,
     "location" : location,
     "time" : time,
     //TODO participant parametresi oluşturup CreatingPage'den participants'a değer yolla.
    // "participants" : participants,
   }).then((value) async {
     returnID=value.id;
     await activities.doc(value.id).update({"activityUID":value.id});
   });
return returnID;
  }

  Future<void> updatePost(PostModel postModel) async{
   await posts.doc(postModel.postUID).set(postModel.createMap());

  }

  Future<PostModel> createPost()async{
   String id = "";
   await posts.add({
     "date": Timestamp.now(),
     "activityUID":[],
     'heartCounter':0,
     'brokenHeartCounter':0,
     'joyCounter':0,
     'sobCounter':0,
     'angryCounter':0,
   }).then((value) async{
     await posts.doc(value.id).update({"postUID":value.id});
     id=value.id;
   });

   DocumentSnapshot dc= await users.doc(myId).get();
   await users.doc(myId).update({"lastPostStamp": Timestamp.now(), "lastPostID": id, "postCount":dc["postCount"]+1 ,"posts":dc["posts"]+[id]});
   return PostModel.fromSnapshot(await posts.doc(id).get());
  }




  Future<List<UserModel>> getFriendsProfiles(String search) async {
    List<UserModel> models = [];
    QuerySnapshot query = await users.where('friends', arrayContains: myId ).get();
    String temp = "";
    for(var doc in query.docs){
      temp = doc['name'];
      temp=temp.toLowerCase();


      if(temp.contains(search)){
        models.add(UserModel.fromSnapshot(doc));
      }
    }
    return models;
  }

  Future<bool> checkDailyPost()async{
   bool result= false;
   DocumentSnapshot dc= await users.doc(myId).get();
   if(dc["lastPostStamp"]!= null && dc["lastPostStamp"].toDate().year== DateTime.now().year && dc["lastPostStamp"].toDate().month== DateTime.now().month && dc["lastPostStamp"].toDate().day== DateTime.now().day){
      result = true;
   }
   return result;
  }

  Future<PostModel> getDailyPost()async{
    DocumentSnapshot ds= await users.doc(myId).get();
  String lastpostid= ds['lastPostID'];
    DocumentSnapshot lp= await posts.doc(lastpostid).get();
  return PostModel.fromSnapshot(lp);
  }



 
}
>>>>>>> Stashed changes
