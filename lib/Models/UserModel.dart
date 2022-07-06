import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userUID;
  String email;
  String password;
  String name;
  String surname;
  String username;
  String bio;
  String ppURL;
  String backgroundURL;
  List<String> friends; //stores user uids
  List<String> posts; //stores post uids
  int postCount;
  Timestamp registerDate;
  Timestamp lastSeen;

  UserModel(
      this.userUID,
      this.email,
      this.password,
      this.name,
      this.surname,
      this.username,
      this.bio,
      this.ppURL,
      this.backgroundURL,
      this.friends,
      this.posts,
      this.postCount,
      this.registerDate,
      this.lastSeen);
}