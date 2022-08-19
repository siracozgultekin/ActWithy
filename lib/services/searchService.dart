import 'package:actwithy/Models/NotificationModel.dart';
import 'package:actwithy/Models/RequestModel.dart';
import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/services/postServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchService{

  String myId = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  CollectionReference activities = FirebaseFirestore.instance.collection('activities');
  CollectionReference notifications = FirebaseFirestore.instance.collection("notifications");
  CollectionReference requests = FirebaseFirestore.instance.collection("requests");


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
        if(doc["userUID"]!=myId)
          models.add(UserModel.fromSnapshot(doc));
      }
    }
    return models;
  }

  Future<bool> isMyFriend(String userId)async{
    DocumentSnapshot myDoc = await users.doc(myId).get();
    List<String> friendsList = myDoc["friends"].cast<String>();
    return friendsList.contains(userId);
  }

  Future<void> removeFriend(String friendID)async{
    DocumentSnapshot myDoc = await users.doc(myId).get();
    List<String> friendsList = myDoc["friends"].cast<String>(); //friend ids
    friendsList.remove(friendID);
    await users.doc(myId).update({"friends": friendsList});

    DocumentSnapshot friendDoc = await users.doc(friendID).get();
    friendsList = friendDoc["friends"].cast<String>();
    friendsList.remove(myId);
    await users.doc(friendID).update({"friends": friendsList});
  }

  Future<void> addFriend(String friendID) async{
    DocumentSnapshot myDoc = await users.doc(myId).get();
    await users.doc(myId).update({"friends": myDoc["friends"]+ [friendID]});

    DocumentSnapshot friendDoc = await users.doc(friendID).get();
    await users.doc(friendID).update({"friends": friendDoc["friends"] + [myId]});
  }

  Future<void> sendRequest(String id) async {
    String requestID = await PostServices().createRequest(id, 0,"activityID");
    PostServices().createNotification(1, id, "reactionID", requestID);
  }

  Future<void> deleteRequest(String requesteeID) async {

    try{
      DocumentSnapshot doc = await users.doc(requesteeID).get();
      UserModel requestee = UserModel.fromSnapshot(doc);

      String requestID = await isPending(requesteeID);

      PostServices().deleteFriendRequest(requestee, requestID);
    }catch(e){
      print("işlem yapılamadı...");
    }


      //TODO del notification 2
  }

  Future<String> isPending(String requesteeID) async {
    String requestID = "";
    if (requesteeID==myId) return requestID;

    DocumentSnapshot doc = await users.doc(requesteeID).get();
    UserModel requestee = UserModel.fromSnapshot(doc);

    for (String notID in requestee.notifications) {
      DocumentSnapshot notdoc = await notifications.doc(notID).get();
      NotificationModel notificationModel = NotificationModel.fromSnapshot(notdoc);

      if ( notificationModel.type==1) {
        String request = notificationModel.requestID;

        DocumentSnapshot reqdoc = await requests.doc(request).get();
        RequestModel requestModel = RequestModel.fromSnapshot(reqdoc);

        if (requestModel.type==0 && requestModel.requesteeUID==requesteeID && requestModel.requesterUID==myId){
          requestID = requestModel.requestUID;
          break;
        }
      }

    }
    return requestID;
  }

  Future<String> controlFriendRequest(String id)async{
    DocumentSnapshot myDoc = await users.doc(myId).get();
    List<String> notIDs = myDoc["notifications"].cast<String>();
    for(String notId in notIDs){
      DocumentSnapshot notDoc = await notifications.doc(notId).get();
      if (notDoc["type"] == 1) {
        DocumentSnapshot requestDoc = await requests.doc(notDoc["requestID"]).get();
        if (requestDoc["type"] == 0 && requestDoc["requesterUID"]==id) {
          return requestDoc["requestUID"];
        }
      }
    }

    return "";
  }

}