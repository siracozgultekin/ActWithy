import 'package:actwithy/Models/ActivityModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel{
  String postUID;
  Timestamp date;
  List<String> activityUID;

  int heartCounter;
  int brokenHeartCounter;
  int joyCounter;
  int sobCounter;
  int angryCounter;

  List<String> reactionIDs;

  PostModel(
      { required this.postUID,
        required this.date,
        required this.activityUID,
        required this.heartCounter,
        required this.brokenHeartCounter,
        required this.joyCounter,
        required this.sobCounter,
        required this.angryCounter,
        required this.reactionIDs,
      });



  Map<String, dynamic> createMap() {
    Map<String, dynamic> map = {
      'postUID':this.postUID,
      'activityUID':this.activityUID,
      'date' :this.date,
      'heartCounter':this.heartCounter,
      'brokenHeartCounter':this.brokenHeartCounter,
      'joyCounter':this.joyCounter,
      'sobCounter':this.sobCounter,
      'angryCounter':this.angryCounter,
      'reactionIDs':this.reactionIDs,
    };
    return map;
  }
  factory PostModel.fromSnapshot(DocumentSnapshot doc) {


    return PostModel(
      postUID: doc['postUID'],
      date: doc['date'],
      activityUID: doc['activityUID'].cast<String>(),
      heartCounter: doc["heartCounter"],
      brokenHeartCounter: doc['brokenHeartCounter'],
      joyCounter: doc['joyCounter'],
      sobCounter: doc['sobCounter'],
      angryCounter: doc['angryCounter'],
      reactionIDs: doc['reactionIDs'].cast<String>(),
    );


  }
}