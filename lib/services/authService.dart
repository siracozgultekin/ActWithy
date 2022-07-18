import 'package:actwithy/pages/homePage.dart';
import 'package:actwithy/pages/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService{
  String uid='';
  Future<bool> register(String email, String pass, String username, String name,String surname) async {
    bool result = false;
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass)
        .then((value) async {
      String uid = value.user!.uid;
      List<String> friends =[];
      List<String> posts =[];

      Map<String, dynamic> usermap = {
        "userUID": uid,
        "email": email,
        "password":pass,
        "name": name,
        "surname":surname,
        "kullaniciadi": username,
        "bio": "bio",
        "ppURL": "ppURL",
        "backgroundURL": "bgURL",
        "friends":friends,
        "posts": posts,
        "registerDate": Timestamp.now(),
        "lastSeen": Timestamp.now(),
        "postCount": 0,
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

  SnackBar snacks(String text) {
    return SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: "X",
        onPressed: () {},
      ),
    );
  }
}

