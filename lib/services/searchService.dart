import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/services/postServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchService{

  String myId = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  CollectionReference activities = FirebaseFirestore.instance.collection('activities');


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
    PostServices().createNotification(1, myId, "reactionID", requestID);
  }

  Future<void> deleteRequest(String requestee) async {

    Query<Map<String, dynamic>> query = await FirebaseFirestore.instance.collection("requests").where("requesterUID", isEqualTo: myId).where("requesteeUID", isEqualTo: requestee).where("type", isEqualTo: 0).where("requestStatus", isEqualTo: 0);





      //TODO del notification 2
  }

  Future<bool> isPending(String requestee) async {
    
    Query<Map<String, dynamic>> query = await FirebaseFirestore.instance.collection("requests").where("requesterUID", isEqualTo: myId).where("requesteeUID", isEqualTo: requestee).where("type", isEqualTo: 0).where("requestStatus", isEqualTo: 0);

    if (query.parameters.isEmpty){
      return false;
    }
    return true;
  }

}