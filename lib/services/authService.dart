import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService{
  String uid='';
  Future<bool> register(String email, String pass, String username, String name) async {
    bool result = false;
    print('Register basarili...');

    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass)
        .then((value) async {
      uid = value.user!.uid;
      List<String> followers =[];
      List<String> following =[];
      Map<String, dynamic> usermap = {
        "userId": uid,
        "email": email,
        "password":pass,

        "kullaniciadi": username,
        "name": name,
        "olusturmaTarihi": Timestamp.now(),


        "follower": 0,
        "following": 0,
        "bio": "bio",
        "userBackgroundPhoto": "picUrl",
        "userPicUrl": "picUrl",
        "followersId" : followers,
        "followingId" : following,
      };
      await FirebaseFirestore.instance.collection('users').doc(uid).set(usermap)
          .onError((error, stackTrace) {
        result = false;
      });
      result = true;
    }).onError((error, stackTrace) {
      result = false;
    });
    return result;
  }
}

