import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/pages/profilePage.dart';
import 'package:actwithy/services/authService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ImagePickerPage extends StatefulWidget {
  final bool isPP;
  ImagePickerPage({required this.isPP});

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState(isPP);
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  bool isPP;
  _ImagePickerPageState(this.isPP);
  String url = "";
  String newUrl = "";

  Color selectedColor = Color(0xFF4C6170); //dark blue
  Color negativeColor = Color(0xFFFFFFFF);//white
  Color bgColor = Color(0xFFD6E6F1); //light blue
  Color appbarColor = Color(0xFF48B2FA); //neon blue
  Color textColor = Color(0xFF2D3A43);

  getURL() async {
    String u = await AuthService().getUserURL(isPP) as String;
    setState(() {
      url = u;
      newUrl = u;
    });
  }

  void initState() {
    getURL();
    print(newUrl);
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
              String uid = FirebaseAuth.instance.currentUser!.uid;
              DocumentSnapshot dc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
              UserModel user = UserModel.fromSnapshot(dc) as UserModel;

              setState((){url = newUrl;
              newUrl="";});
              AuthService().approveImage(url, isPP);
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfilePage(user: user)));

            }, icon: Icon(Icons.check), iconSize: 35,),
          ),
        ],

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: isPP ? CircleAvatar(
                radius: MediaQuery.of(context).size.width/4,
                child: Image.network(newUrl,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Text('Your error widget...');
                  },),
              ):
              Container(
                  child:
                  Image.network(newUrl,
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Text('Your error widget...');
                  },)
              )
              ,
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

                newUrl = await AuthService().takeNewImage(ImageSource.gallery, isPP);

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

                newUrl = await AuthService().takeNewImage(ImageSource.camera, isPP);

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
      ),
    );
  }
}
