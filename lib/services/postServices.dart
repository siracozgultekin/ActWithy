import 'package:actwithy/Models/ActivityModel.dart';
import 'package:actwithy/Models/PostModel.dart';
import 'package:actwithy/Models/ReactionModel.dart';
import 'package:actwithy/Models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostServices {
  String myId = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  CollectionReference activities =
      FirebaseFirestore.instance.collection('activities');
  CollectionReference reactions =
      FirebaseFirestore.instance.collection('reactions');

  Future<String> createActivity(String selectedItem, Timestamp time,
      String location, List<String> participants) async {
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

  Future<void> updateActivity(ActivityModel activityModel) async {
    await activities
        .doc(activityModel.activityUID)
        .set(activityModel.createMap());
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
      'reactionIDs': [],
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
  Future<List<UserModel>> getFriends(List<String> friends) async {
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

    for (String postID in postList.reversed) {
      DocumentSnapshot postDoc = await posts.doc(postID).get();
      post.add(PostModel.fromSnapshot(postDoc));
    }
    return post;
  }

  Future<bool> checkDailyPost() async {
    bool result = false;
    DocumentSnapshot dc = await users.doc(myId).get();
    if (dc["lastPostStamp"] != null &&
        dc["lastPostStamp"].toDate().year == DateTime.now().year &&
        dc["lastPostStamp"].toDate().month == DateTime.now().month &&
        dc["lastPostStamp"].toDate().day == DateTime.now().day) {
      result = true;
    }
    return result;
  }

  Future<PostModel> getDailyPost() async {
    bool check = await checkDailyPost();

    if (!check) {
      return PostModel(
          postUID: "postUID",
          date: Timestamp.now(),
          activityUID: [],
          heartCounter: 0,
          brokenHeartCounter: 0,
          joyCounter: 0,
          sobCounter: 0,
          angryCounter: 0,
          reactionIDs: []);
    }

    DocumentSnapshot ds = await users.doc(myId).get();
    String lastpostid = ds['lastPostID'];
    DocumentSnapshot lp = await posts.doc(lastpostid).get();
    return PostModel.fromSnapshot(lp);
  }

  Future<List<UserModel>> getParticipants(ActivityModel activityModel) async {
    List<UserModel> usersList = [];
    for (String userID in activityModel.participants) {
      DocumentSnapshot myDoc = await users.doc(userID).get();
      usersList.add(UserModel.fromSnapshot(myDoc));
    }
    return usersList;
  }

  Future<Map<ActivityModel, List<UserModel>>> getParticipantsByID(
      String activityID) async {
    List<UserModel> usersList = [];
    DocumentSnapshot doc = await activities.doc(activityID).get();
    ActivityModel activityModel = ActivityModel.fromSnapshot(doc);
    for (String userID in activityModel.participants) {
      DocumentSnapshot myDoc = await users.doc(userID).get();
      usersList.add(UserModel.fromSnapshot(myDoc));
    }
    return {activityModel: usersList};
  }

  Future<List<ActivityModel>> getDailyActivities() async {
    PostModel postModel = await getDailyPost();
    List<String> actIDs = postModel.activityUID;
    List<ActivityModel> activitiesList = [];

    for (String id in actIDs) {
      DocumentSnapshot dc = await activities.doc(id).get();
      print("id: ${dc["activityUID"]}");
      activitiesList.add(ActivityModel.fromSnapshot(dc));
    }
    print("activitiesList: ${activitiesList}");
    activitiesList.sort((a, b) => a.time.compareTo(b.time));
    return activitiesList;
  }

  Future<List<DenemeModel>> getFriendsPosts() async {
    List<DenemeModel> postsList = [];
    DocumentSnapshot myDoc = await users.doc(myId).get();
    List<String> friendsList = myDoc["friends"].cast<String>(); //friend ids

    for (String friendID in friendsList) {
      DocumentSnapshot friendDoc = await users.doc(friendID).get();

      List<String> friendsPosts =
          friendDoc["posts"].cast<String>(); //friend's post ids
      for (String postID in friendsPosts) {
        DocumentSnapshot postDoc = await posts.doc(postID).get();
        //  DenemeModel deneme = DenemeModel(postObj: PostModel.fromSnapshot(postDoc));
        //  deneme.setUser(UserModel.fromSnapshot(friendDoc));
        List<String> activityIDs = postDoc['activityUID'].cast<String>();
        List<ActivityModel> md = [];
        for (String id in activityIDs) {
          DocumentSnapshot dc = await activities.doc(id).get();
          md.add(ActivityModel.fromSnapshot(dc));
        }
        md.sort((a, b) => a.time.compareTo(b.time));
        // deneme.setActivities(md);
        DenemeModel deneme = DenemeModel(
            userObj: UserModel.fromSnapshot(friendDoc),
            activitiesList: md,
            postObj: PostModel.fromSnapshot(postDoc));
        md = [];
        postsList.add(deneme);
      }
    }
    postsList.sort((a, b) => b.postObj.date.compareTo(a.postObj.date));
    return postsList;
  }

  Future<List<PostModel>> getMyPosts() async {
    List<PostModel> postsList = [];
    DocumentSnapshot myDoc = await users.doc(myId).get();
    List<String> myPostIDs = myDoc["posts"].cast<String>();

    for (String postID in myPostIDs) {
      DocumentSnapshot postDoc = await posts.doc(postID).get();
      postsList.add(PostModel.fromSnapshot(postDoc));
    }

    return postsList;
  }

  Future<DocumentSnapshot> getMyDoc() async {
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

    for (String id in activityIDs) {
      DocumentSnapshot dc = await activities.doc(id).get();
      activityModels.add(ActivityModel.fromSnapshot(dc));
    }
    activityModels.sort((a, b) => a.time.compareTo(b.time));
    return activityModels;
  }

  Future<List<UserModel>> getAllParticipants(List<String> actIDs) async {
    List<UserModel> participants = [];

    for (String id in actIDs) {
      DocumentSnapshot actDoc = await activities.doc(id).get();
      var actPartList = ActivityModel.fromSnapshot(actDoc).participants;

      for (String part in actPartList) {
        DocumentSnapshot partDoc = await users.doc(part).get();
        UserModel user = UserModel.fromSnapshot(partDoc);
        if (!participants.contains(user.userUID)) {
          participants.add(user);
        }
      }
    }
    return participants;
  }

  Future<void> editProfile(String name, String surname, String bio) async {
    await users
        .doc(myId)
        .update({'name': name, 'surname': surname, 'bio': bio});
  }

  Future<UserModel> returnUser(String uid) async {
    return UserModel.fromSnapshot(await users.doc(uid).get());
  }

  Future<void> setAngryCounter(String postUID, bool check) async {
    DocumentSnapshot postDoc = await posts.doc(postUID).get();
    int count;
    if (check) {
      count = postDoc["angryCounter"] + 1;
      print("CountForTrueCondition:: $count");
      await posts.doc(postUID).update({
        "angryCounter": count,
      });
    } else {
      count = postDoc["angryCounter"] - 1;
      print("CountForFalseCondition:: $count");
      await posts.doc(postUID).update({
        "angryCounter": count,
      });
    }
  }

  Future<void> setJoyCounter(String postUID, bool check) async {
    DocumentSnapshot postDoc = await posts.doc(postUID).get();
    int count;
    if (check) {
      count = postDoc["joyCounter"] + 1;
      print("CountForTrueCondition:: $count");
      await posts.doc(postUID).update({
        "joyCounter": count,
      });
    } else {
      count = postDoc["joyCounter"] - 1;
      print("CountForFalseCondition:: $count");
      await posts.doc(postUID).update({
        "joyCounter": count,
      });
    }
  }

  Future<void> setBrokenHeartCounter(String postUID, bool check) async {
    DocumentSnapshot postDoc = await posts.doc(postUID).get();
    int count;
    if (check) {
      count = postDoc["brokenHeartCounter"] + 1;
      print("CountForTrueCondition:: $count");
      await posts.doc(postUID).update({
        "brokenHeartCounter": count,
      });
    } else {
      count = postDoc["brokenHeartCounter"] - 1;
      print("CountForFalseCondition:: $count");
      await posts.doc(postUID).update({
        "brokenHeartCounter": count,
      });
    }
  }

  Future<void> setSobCounter(String postUID, bool check) async {
    DocumentSnapshot postDoc = await posts.doc(postUID).get();
    int count;
    if (check) {
      count = postDoc["sobCounter"] + 1;
      print("CountForTrueCondition:: $count");
      await posts.doc(postUID).update({
        "sobCounter": count,
      });
    } else {
      count = postDoc["sobCounter"] - 1;
      print("CountForFalseCondition:: $count");
      await posts.doc(postUID).update({
        "sobCounter": count,
      });
    }
  }

  Future<void> setHeartCounter(String postUID, bool check) async {
    DocumentSnapshot postDoc = await posts.doc(postUID).get();
    int count;
    if (check) {
      count = postDoc["heartCounter"] + 1;
      print("CountForTrueCondition:: $count");
      await posts.doc(postUID).update({
        "heartCounter": count,
      });
    } else {
      count = postDoc["heartCounter"] - 1;
      print("CountForFalseCondition:: $count");
      await posts.doc(postUID).update({
        "heartCounter": count,
      });
    }
  }

  Future<void> checkEmoji(int val, String postUID) async {
    if (val == 1) {
      setHeartCounter(postUID, false);
    } else if (val == 2) {
      setBrokenHeartCounter(postUID, false);
    } else if (val == 3) {
      setJoyCounter(postUID, false);
    } else if (val == 4) {
      setSobCounter(postUID, false);
    } else if (val == 5) {
      setAngryCounter(postUID, false);
    } else {
      val = 0;
    }
  }

  Future<String> createReaction(
      String reacteeID, String postID, String reactType) async {
    String myID = await FirebaseAuth.instance.currentUser!.uid;
    String reactionid = "";
    await reactions.add({
      "reacterID": myID,
      "reacteeID": reacteeID,
      "postID": postID,
      "type": reactType,
    }).then((value) async {
      reactionid = value.id;
      print("reactionid in func. ::::$reactionid");
      await reactions.doc(value.id).update({"reactionUID": value.id});
    });

    return reactionid;
  }

  Future<void> updateReactionType(
      String reactionUID, String reactionType) async {
    await reactions.doc(reactionUID).update({"type": reactionType});
  }

  Future<void> deleteReaction(String reactionUID) async {
    if (reactionUID != "") {
      await reactions.doc(reactionUID).delete();
    }
  }

  Future<bool> checkReacterID(String reacterID) async {
    bool res = false;
    QuerySnapshot x =
        await reactions.where("reacterID", isEqualTo: reacterID).get();
    if (x.size == 0) {
      res = true;
    }

    return res;
  }

  Future<bool> checkReaction(PostModel postModel) async {
    List<String> reactionsList = postModel.reactionIDs;
    String currentUser = await FirebaseAuth.instance.currentUser!.uid;
    for (String reaction in reactionsList){
      DocumentSnapshot documentSnapshot = await reactions.doc(reaction).get();
      if(documentSnapshot["reacterID"]==currentUser)
        return true;
    }
    return false;
  }

  Future<ReactionModel> getReaction(PostModel postModel)async{
    String currentUser = await FirebaseAuth.instance.currentUser!.uid;
    String reactID ="";
    for (String reactionId in postModel.reactionIDs){
      DocumentSnapshot documentSnapshot = await reactions.doc(reactionId).get();
      if (documentSnapshot["reacterID"] == currentUser){
        reactID = documentSnapshot["reactionUID"];
        break;
      }
    }
    DocumentSnapshot doc = await reactions.doc(reactID).get();

    return ReactionModel.fromSnapshot(doc);
  }

  Future<void> updateReaction(ReactionModel reactionModel)async {
    await reactions.doc(reactionModel.reactionUID).set(reactionModel.createMap());
  }


}

class DenemeModel {
  PostModel postObj;
  List<ActivityModel> activitiesList;
  UserModel userObj;

  DenemeModel(
      {required this.userObj,
      required this.activitiesList,
      required this.postObj});

  void setUser(UserModel muser) {
    this.userObj = muser;
  }

  void setActivities(List<ActivityModel> m) {
    this.activitiesList = m;
  }
}
