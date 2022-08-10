import 'package:cloud_firestore/cloud_firestore.dart';

class ReactionModel {
  static String heart = 'heart';
  static String brokenHeart = 'brokenHeart';
  static String joy = 'joy';
  static String sob = 'sob';
  static String angry = 'angry';
  String reactionUID;
  String reacterID;
  String reacteeID;
  String postID;
  String type;

  ReactionModel(
      {required this.reactionUID,
      required this.reacterID,
      required this.reacteeID,
      required this.postID,
      required this.type});

  factory ReactionModel.fromSnapshot(DocumentSnapshot doc) {
    return ReactionModel(
        reactionUID: doc["reactionUID"],
        reacterID: doc["reacterID"],
        reacteeID: doc["reacteeID"],
        postID: doc["postID"],
        type: doc["type"]);
  }

  Map<String, dynamic> createMap() {
    return {
      "reactionUID": this.reactionUID,
      "reacterID": this.reacterID,
      "reacteeID": this.reacteeID,
      "postID": this.postID,
      "type": this.type,
    };
  }
}
