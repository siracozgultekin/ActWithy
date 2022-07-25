
import 'package:actwithy/Models/ActivityModel.dart';
import 'package:actwithy/Models/PostModel.dart';
import 'package:actwithy/Models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostServices {
  String myId = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  CollectionReference activities = FirebaseFirestore.instance.collection('activities');

  Future<String> createActivity(String selectedItem, Timestamp time,
      String location, List<String> participants) async {
    /* await activities.add(model.createMap()).then((value) async {

     String postId = value.id;
     await activities.doc(postId).update({'activityUID': postId,});
     PostModel obj=PostModel(date:Timestamp.now(), activityUID:postId, heartCounter, brokenHeartCounter, joyCounter, sobCounter, angryCounter)
     await posts.add(model.createMap());
     print('myID:$myId');
   });
   */

    String returnID = "";
    await activities.add({
      "activityType": selectedItem,
      "location": location,
      "time": time,
      //TODO participant parametresi oluşturup CreatingPage'den participants'a değer yolla.
      "participants": participants,
    }).then((value) async {
      returnID = value.id;
      await activities.doc(value.id).update({"activityUID": value.id});
    });
    return returnID;

  }

  Future<void> updatePost(PostModel postModel) async {
    await posts.doc(postModel.postUID).set(postModel.createMap());
  }

  Future<PostModel> createPost() async {
    String id = "";
    await posts.add({
      "date": Timestamp.now(),
      "activityUID": [],
      'heartCounter': 0,
      'brokenHeartCounter': 0,
      'joyCounter': 0,
      'sobCounter': 0,
      'angryCounter': 0,
    }).then((value) async {
      await posts.doc(value.id).update({"postUID": value.id});
      id = value.id;
    });

    DocumentSnapshot dc = await users.doc(myId).get();
    await users.doc(myId).update({
      "lastPostStamp": Timestamp.now(),
      "lastPostID": id,
      "postCount": dc["postCount"] + 1,
      "posts": dc["posts"] + [id]
    });
    return PostModel.fromSnapshot(await posts.doc(id).get());
  }

  Future<void> addParticipant(
      ActivityModel activityModel, UserModel participant) async {
    activityModel.participants.add(participant.userUID);

    //DocumentSnapshot doc = await activities.doc(activityModel.activityUID).get();
    activities
        .doc(activityModel.activityUID)
        .update({"participants": activityModel.participants});

  }

  Future<List<UserModel>> getFriendsProfiles(String search) async {
    List<UserModel> models = [];
    DocumentSnapshot myDoc = await users.doc(myId).get();
    List<String> friendsList = myDoc["friends"].cast<String>(); //friend ids
    String temp = "";
    for (String friendID in friendsList) {
      DocumentSnapshot friendDoc = await users.doc(friendID).get();
      temp = friendDoc['name'];
      temp = temp.toLowerCase();

      if (temp.contains(search)) {
        models.add(UserModel.fromSnapshot(friendDoc));
      }
    }
    return models;
  }


  //TODO profil sahibinin arkadaşlarını model olarak dönüştür
  Future<List<UserModel>> getFriends (List<String> friends) async {
    List<UserModel> models = [];

    for (String friendID in friends) {
      models.add(UserModel.fromSnapshot(await users.doc(friendID).get()));
    }

    return models;

  }

  Future<List<PostModel>> getPosts(String profileID) async {

    List<PostModel> post = [];
    DocumentSnapshot dc = await users.doc(profileID).get();
    List<String> postList = dc["posts"].cast<String>();

    for (String postID in postList){
      DocumentSnapshot postDoc = await posts.doc(postID).get();
      post.add(PostModel.fromSnapshot(postDoc));
    }
    return post;

  }


  Future<bool> checkDailyPost()async{
   bool result= false;
   DocumentSnapshot dc= await users.doc(myId).get();
   if(dc["lastPostStamp"]!= null && dc["lastPostStamp"].toDate().year== DateTime.now().year && dc["lastPostStamp"].toDate().month== DateTime.now().month && dc["lastPostStamp"].toDate().day== DateTime.now().day){
      result = true;
    }
    return result;
  }

  Future<PostModel> getDailyPost() async {
    /*bool check = await checkDailyPost();
   if(check){
     return PostModel(postUID: "postUID", date: Timestamp.now(), activityUID: [], heartCounter: 0, brokenHeartCounter: 0, joyCounter: 0, sobCounter: 0, angryCounter: 0);
   }*/

    DocumentSnapshot ds = await users.doc(myId).get();
    String lastpostid = ds['lastPostID'];
    DocumentSnapshot lp = await posts.doc(lastpostid).get();
    return PostModel.fromSnapshot(lp);
  }

  Future<List<UserModel>> getParticipants(ActivityModel activityModel) async{
    List<UserModel> usersList = [];
    for (String userID in activityModel.participants){
      DocumentSnapshot myDoc = await users.doc(userID).get();
      usersList.add(UserModel.fromSnapshot(myDoc));
    }
    return usersList;
  }

  Future<List<ActivityModel>> getDailyActivities() async {
    PostModel postModel = await getDailyPost();
    List<String> actIDs = postModel.activityUID;
    List<ActivityModel> activitiesList = [];
    print("activitiesListYUKARI: ${activitiesList}");

    for (String id in actIDs) {
      DocumentSnapshot dc = await activities.doc(id).get();
      print("id: ${dc["activityUID"]}");
      activitiesList.add(ActivityModel.fromSnapshot(dc));
    }
    print("activitiesList: ${activitiesList}");

    return activitiesList;
  }

  Future<List<PostModel>> getFriendsPosts() async {
    List<PostModel> postsList = [];
    DocumentSnapshot myDoc = await users.doc(myId).get();
    List<String> friendsList = myDoc["friends"].cast<String>(); //friend ids

    for (String friendID in friendsList) {
      DocumentSnapshot friendDoc = await users.doc(friendID).get();
      List<String> friendsPosts =
      friendDoc["posts"].cast<String>(); //friend's post ids
      for (String postID in friendsPosts) {
        DocumentSnapshot postDoc = await posts.doc(postID).get();
        postsList.add(PostModel.fromSnapshot(postDoc));
      }
    }
    postsList.sort((a, b) => a.date.compareTo(b.date));
    return postsList;
  }

  Future<List<PostModel>> getMyPosts()async{
    List<PostModel> postsList = [];
    DocumentSnapshot myDoc = await users.doc(myId).get();
    List<String> myPostIDs = myDoc["posts"].cast<String>();

    for (String postID in myPostIDs){
      DocumentSnapshot postDoc = await posts.doc(postID).get();
      postsList.add(PostModel.fromSnapshot(postDoc));
    }

    return postsList;
  }
<<<<<<< Updated upstream
=======
  
Future<DocumentSnapshot> getMyDoc()async{
  DocumentSnapshot myDoc = await users.doc(myId).get();
  return myDoc;
}

// Future<List<PostModel>> getMyFriendsPosts() async{
//     List<PostModel> postList=[];
//     DocumentSnapshot myDoc= await users.doc(myId).get();
//     List<String> myFriendsList= myDoc["Friends"].cast<String>();
//     for(String myFriendID in myFriendsList){
//       DocumentSnapshot myFriendDoc= await users.doc(myFriendID).get();
//      List<String> myFriendPostsList= myFriendDoc["posts"].cast<String>();
//      for(String myFriendPostID in myFriendPostsList){
//        DocumentSnapshot MyFriendPost= await posts.doc("myFriendPostID").get();
//        postList.add(PostModel.fromSnapshot(MyFriendPost));
//      }
//
//     }
//     postList.sort((a, b) => a.date.compareTo(b.date));
//     return postList;
// }
  Future<List<ActivityModel>> getActivities(List<String> activityIDs) async {
    List<ActivityModel> activityModels = [];

    for ( String id in activityIDs) {
      DocumentSnapshot dc = await activities.doc(id).get();
      activityModels.add(ActivityModel.fromSnapshot(dc));
    }
    return activityModels;
  }


  
>>>>>>> Stashed changes

  Future<List<UserModel>> getAllParticipants(List<String> actIDs) async {

    List<UserModel> participants = [] ;

    for (String id in actIDs) {
      DocumentSnapshot actDoc = await activities.doc(id).get();
      var actPartList = ActivityModel.fromSnapshot(actDoc).participants;

      for (String part in actPartList) {
        DocumentSnapshot partDoc = await users.doc(part).get();
        participants.add(UserModel.fromSnapshot(partDoc));
      }
    }

    return participants;

  }

}
