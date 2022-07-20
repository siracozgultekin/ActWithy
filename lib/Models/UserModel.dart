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
  String lastPostID;
  Timestamp lastPostStamp;

  UserModel(
      {
      required  this.userUID,
        required this.email,
        required this.password,
        required  this.name,
        required this.surname,
        required this.username,
        required this.bio,
        required this.ppURL,
        required  this.backgroundURL,
        required  this.friends,
        required  this.posts,
        required  this.postCount,
        required this.registerDate,
        required this.lastSeen,
        required this.lastPostID,
        required this.lastPostStamp,
      });


  Map<String, dynamic> createMap() {
    Map<String, dynamic> map = {
    "userUID":this.userUID,
     "email":this.email,
     "password":this.password,
     "name":this.name,
     "surname":this.surname,
     "username":this.username,
     "bio":this.bio,
     "ppURL":this.ppURL,
     "backgroundURL":this.backgroundURL,
    "friends":this.friends,
     "posts":this.posts,
     "postCount":this.postCount,
     "registerDate":this.registerDate,
     "lastSeen":this.lastSeen,
     "lastPostID":this.lastPostID,
     "lastPostStamp":this.lastPostStamp,
    };
    return map;
  }

  factory UserModel.fromSnapshot(DocumentSnapshot doc) {
/*
    List<String> fr = [];
    List<String> ps = [];

    for (var f in doc["friends"]) {
      fr.add(f as String);
    }

    for (var f in doc["posts"]) {
      ps.add(f as String);
    }
*/
    return UserModel(
        backgroundURL: doc['backgroundURL'],
        bio: doc['bio'],
        email: doc['email'],
        friends: doc["friends"].cast<String>(),
        username: doc['kullaniciadi'],
        lastSeen: doc['lastSeen'],
        name: doc['name'],
        password: doc['password'],
        posts: doc["posts"].cast<String>(),
        ppURL: doc['ppURL'],
        registerDate: doc['registerDate'],
        surname: doc['surname'],
        userUID: doc['userUID'],
        postCount: doc['postCount'],
        lastPostID : doc["lastPostID"],
        lastPostStamp : doc["lastPostStamp"],
      );

  }

}