import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel{
  String notificationUID;
  Timestamp time;
  int type; // 0->reaction 1->request
  String userID; //from who //gereksiz
  String reactionID; //if type is 0
  String requestID;

  NotificationModel(
      {required this.notificationUID,
        required this.time,
        required this.type,
        required this.userID,
        required this.reactionID,
        required this.requestID,
     }); //if type is 0


  factory NotificationModel.fromSnapshot(DocumentSnapshot doc) {

    return NotificationModel(
      notificationUID: doc['notificationUID'],
      time: doc['time'],
      type: doc['type'],
      userID: doc["userID"],
      reactionID: doc['reactionID'],
      requestID: doc['requestID'],

    );

  }

}