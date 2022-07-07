import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel{
  String requestUID;
  int type; // 0->friendship 1->activity
  String requesterUID;
  String requesteeUID;
  int requestStatus; // -1->disapproved, 0->waiting 1->approved
  Timestamp time;
  String activityUID;

  RequestModel(
      this.requestUID,
      this.type,
      this.requesterUID,
      this.requesteeUID,
      this.requestStatus,
      this.time,
      this.activityUID); // if request type is 1


}