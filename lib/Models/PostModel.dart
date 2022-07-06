import 'package:actwithy/Models/ActivityModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel{
  String postUID;
  Timestamp date;
  ActivityModel activity;
  int heartCounter;
  int brokenHeartCounter;
  int joyCounter;
  int sobCounter;
  int angryCounter;

  PostModel(
      this.postUID,
      this.date,
      this.activity,
      this.heartCounter,
      this.brokenHeartCounter,
      this.joyCounter,
      this.sobCounter,
      this.angryCounter);
}