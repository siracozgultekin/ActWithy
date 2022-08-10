import 'dart:io';
import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/pages/homePage.dart';
import 'package:actwithy/pages/welcomePage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AuthService{
  String uid='';
  CollectionReference users = FirebaseFirestore.instance.collection('users');


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
        "bio": "Hi I am ${name} and this is my ToDo List",
        "ppURL": "https://firebasestorage.googleapis.com/v0/b/actwithy.appspot.com/o/default%2Fpp.png?alt=media&token=9284a7da-2f75-4ea9-8fcf-9919ebe5acfc",
        "backgroundURL": "https://firebasestorage.googleapis.com/v0/b/actwithy.appspot.com/o/default%2Fbgg.png?alt=media&token=bad5930e-bb80-47a7-bec1-7c5aa85dae04x",
        "friends":friends,
        "posts": posts,
        "registerDate": Timestamp.now(),
        "lastSeen": Timestamp.now(),
        "postCount": 0,
        "lastPostID":"lastPostID",
        "lastPostStamp":null,
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

  Future<String> getUserURL(bool isPP) async {
    String userID = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot doc = await users.doc(userID).get();
    UserModel user = UserModel.fromSnapshot(doc) as UserModel;
    return isPP ? user.ppURL : user.backgroundURL;
  }

  Future takeNewImage(ImageSource source, bool isPP) async {

    String userId = FirebaseAuth.instance.currentUser!.uid;


    final image = await ImagePicker().pickImage(source: source);
    if (image == null) {
      UserModel user = UserModel.fromSnapshot(await users.doc(userId).get());
      String userUrl = isPP ? user.ppURL : user.backgroundURL;
      return userUrl;
    }

    final file = File(image.path);

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('userProfiles/${userId}/${Timestamp.now()}');
    UploadTask task = reference.putFile(file);
    await task.whenComplete(() {
      print("uploaded");
    });
    String url = await reference.getDownloadURL();
    return url;
  }

  Future approveImage(String url, bool isPP) async{
    String userId = FirebaseAuth.instance.currentUser!.uid;
    if (isPP) {
      await users.doc(userId).update({'ppURL': url}).then((value) {

      });
    }else{
      await FirebaseFirestore.instance.collection("users").doc(userId).update({'backgroundURL': url}).then((value) {

      });
    }
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

