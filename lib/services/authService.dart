import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/pages/homePage.dart';
import 'package:actwithy/pages/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService{
  String uid='';
  CollectionReference users = FirebaseFirestore.instance.collection('users');


  Future<bool> register(String email, String pass, String username, String name,String surname) async {
    bool result = false;
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass)
        .then((value) async {
      String uid = value.user!.uid;

      Map<String, dynamic> usermap = {
        "userUID": uid,
        "email": email,
        "password":pass,
        "name": name,
        "surname":surname,
        "kullaniciadi": username,
        "bio": "Hi I am ${name} and this is my ToDo List",
        "ppURL": "https://firebasestorage.googleapis.com/v0/b/actwithy.appspot.com/o/default%2Fpp.png?alt=media&token=9284a7da-2f75-4ea9-8fcf-9919ebe5acfc",
        "backgroundURL": "https://firebasestorage.googleapis.com/v0/b/actwithy.appspot.com/o/default%2Fbgg.png?alt=media&token=bad5930e-bb80-47a7-bec1-7c5aa85dae04x",
        "friends":[],
        "posts": [],
        "registerDate": Timestamp.now(),
        "lastSeen": Timestamp.now(),
        "postCount": 0,
        "lastPostID":"lastPostID",
        "lastPostStamp":Timestamp.fromDate(DateTime(2000)),
        "notifications":[],
      };
      print("Result: $result");
      await FirebaseFirestore.instance.collection('users').doc(uid).set(usermap)
          .onError((error, stackTrace) {
        result = false;
        print("İLGİLİ HATA:::: $error");
      });
      result = true;
    }).onError((error, stackTrace) {
      result = false;
    });
    return result;
  }
  Future<void> signIn(String email, String pass, BuildContext context) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((value) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(snacks("Hata oluştu. Tekrar deneyiniz"));
    });
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => WelcomePage()));
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(snacks("Hata oluştu. Daha sonra tekrar deneyiniz"));
    });
  }

  getUserURL(bool isPP) async {
    String userID = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot doc = await users.doc(userID).get();
    UserModel user = UserModel.fromSnapshot(doc) as UserModel;

    return isPP ? user.ppURL : user.backgroundURL;
  }

  SnackBar snacks(String text) {
    return SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: "X",
        onPressed: () {},
      ),
    );
  }

  Future<UserModel> getCurrentUser() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot doc = await users.doc(uid).get();
    UserModel user = UserModel.fromSnapshot(doc);

    return user;

  }
}

