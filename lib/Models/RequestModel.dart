import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  String requestUID;
  int type; // 0->friendship 1->activity
  String requesterUID;
  String requesteeUID;
  int requestStatus; // -1->disapproved, 0->waiting 1->approved
  Timestamp time;
  String activityUID;

  RequestModel({
    required this.requestUID,
    required this.type,
    required this.requesterUID,
    required this.requesteeUID,
    required this.requestStatus,
    required this.time,
    required this.activityUID,
  }); // if request type is 1

  factory RequestModel.fromSnapshot(DocumentSnapshot doc) {
    return RequestModel(
      requestUID: doc["requestUID"],
      type: doc["type"],
      requesterUID: doc["requesterUID"],
      requesteeUID: doc["requesteeUID"],
      requestStatus: doc["requestStatus"],
      time: doc["time"],
      activityUID: doc["activityUID"],
    );
  }

  Map<String, dynamic> createMap() {
    return {
      "requestUID": this.requestUID,
      "type": this.type,
      "requesterUID": this.requesterUID,
      "requesteeUID": this.requesteeUID,
      "requestStatus": this.requestStatus,
      "time": this.time,
      "activityUID": this.activityUID,
    };
  }

}