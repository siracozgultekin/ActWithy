import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel{
 String activityUID;
  String activityType;
  Timestamp time;
  String location;
  List<String> requests;
  List<String> participants; //stores user uids

  ActivityModel(
      {required this.activityType,
     required this.activityUID,
    required  this.time,
     required this.location,
required this.requests,
      required this.participants

   });


  Map<String, dynamic> createMap() {
    Map<String, dynamic> map = {
      'activityUID':this.activityUID,
      'activityType':activityType,
      'time':this.time,
      'location':this.location,
'requests':this.requests,
  'participants':this.participants

    };
    return map;
  }

 factory ActivityModel.fromSnapshot(DocumentSnapshot doc) {


   return ActivityModel(
     activityUID: doc['activityUID'],
     activityType: doc['activityType'],
     time: doc['time'],
     location: doc["location"],
       requests:doc["requests"].cast<String>(),
   participants: doc['participants'].cast<String>(),



   );
}}