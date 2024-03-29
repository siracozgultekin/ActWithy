import 'dart:io';

import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/pages/profilePage.dart';
import 'package:actwithy/services/authService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


class ImagePickerPage extends StatefulWidget {
  final bool isPP;
  ImagePickerPage({required this.isPP});

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  String url = "";
  String newUrl = "";


  Color selectedColor = Color(0xFF4C6170); //dark blue
  Color negativeColor = Color(0xFFFFFFFF);//white
  Color bgColor = Color(0xFFD6E6F1); //light blue
  Color appbarColor = Color(0xFF48B2FA); //neon blue
  Color textColor = Color(0xFF2D3A43);

  getURL() async {
    String u = await AuthService().getUserURL(widget.isPP) as String;
    print(u);
    setState(() {
      url = u;
    });
  }

  void initState() {
    getURL();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appbarColor,
        centerTitle: true,
        title: Text("Edit Profile"),
        leading: IconButton(
          icon: Icon(Icons.close),
          iconSize: 35,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        leadingWidth: MediaQuery.of(context).size.width * 0.2,
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            alignment: Alignment.centerRight,
            child: IconButton(onPressed: () async {

              setState((){
                if (!newUrl.isEmpty) {
                  url = newUrl;
                  newUrl ="";
                }
              });


             await AuthService().approveImage(url, widget.isPP);

              String uid = FirebaseAuth.instance.currentUser!.uid;
              DocumentSnapshot dc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
              UserModel user = UserModel.fromSnapshot(dc) as UserModel;

              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfilePage(user: user)));

            }, icon: Icon(Icons.check), iconSize: 35,),
          ),
        ],

      ),
      body: FutureBuilder(
        future: AuthService().getUserURL(widget.isPP),
        builder: (context, AsyncSnapshot snap) {
          if (!snap.hasData) {
            return CircularProgressIndicator();
          }else{
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.isPP ? Container(

                      height: MediaQuery.of(context).size.width/2,
                      width: MediaQuery.of(context).size.width/2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image:  DecorationImage(
                          fit: BoxFit.cover,
                          image:
                          NetworkImage(
                            //TODO AuthService().newUrl
                              (newUrl.isEmpty) ?
                              url : newUrl
                          ),
                        ),
                      )
                  )
                      :
                  Container(

                      height: MediaQuery.of(context).size.height*0.21,
                      width: MediaQuery.of(context).size.width,
                      decoration:  BoxDecoration(
                          image:  DecorationImage(
                              fit: BoxFit.cover,
                              image: new NetworkImage(
                                //TODO AuthService().newUrl
                                  (newUrl.isEmpty) ?
                                  url : newUrl
                              )))
                  )
                  ,

                  SizedBox(
                    height: MediaQuery.of(context).size.width/20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: textColor),
                      borderRadius: BorderRadius.all(
                          Radius.circular(30.0) //                 <--- border radius here
                      ),
                    ),
                    width: MediaQuery.of(context).size.width/2,
                    child: TextButton(onPressed: () async {

                      newUrl = await AuthService().takeNewImage(ImageSource.gallery, widget.isPP);
                      setState((){});

                      //TODO new url update

                    } , child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_outlined,color: textColor,),
                        Text('Pick Gallery',style:TextStyle(color: textColor,))
                      ],
                    )),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width/20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: textColor),
                      borderRadius: BorderRadius.all(
                          Radius.circular(30.0) //                 <--- border radius here
                      ),
                    ),
                    width: MediaQuery.of(context).size.width/2,
                    child: TextButton(onPressed: () async {

                      newUrl= await AuthService().takeNewImage(ImageSource.camera, widget.isPP);
                      setState((){});
                      //TODO AuthService().updateNewUrl(false, Url, isPP);

                    } , child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined,color: textColor,),
                        Text('Pick Camera',style:TextStyle(color: textColor,))
                      ],
                    )),
                  ),
                ],
              ),
            );
          }
        },
      ),

    );
  }
}


