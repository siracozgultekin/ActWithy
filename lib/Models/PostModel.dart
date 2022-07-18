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

  PostModel(
     { required this.postUID,

        required this.date,
        required  this.activityUID,
        required  this.heartCounter,
        required  this.brokenHeartCounter,
        required  this.joyCounter,
        required  this.sobCounter,
        required  this.angryCounter});

  Map<String, dynamic> createMap() {
    Map<String, dynamic> map = {
      'postUID':'',
      'activityUID':this.activityUID,
      'heartCounter':this.heartCounter,
      'brokenHeartCounter':this.brokenHeartCounter,
      'joyCounter':this.joyCounter,
      'sobCounter':this.sobCounter,
      'angryCounter':this.angryCounter,
    };
    return map;
  }

}