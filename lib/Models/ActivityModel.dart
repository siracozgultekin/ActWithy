import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel{
  String activityUID;
  Timestamp time;
  int type; // 0->input, 1->select
  String location;
  List<String> participants; //stores user uids

  ActivityModel(this.activityUID, this.time, this.type, this.location,
      this.participants);

}