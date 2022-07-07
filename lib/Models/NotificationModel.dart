import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel{
  String notificationUID;
  Timestamp time;
  int type; // 0->reaction 1->request
  String userID; //from who
  String reactionID; //if type is 0
  String requestID;

  NotificationModel(this.notificationUID, this.time, this.type, this.userID,
      this.reactionID, this.requestID); //if type is 0


}