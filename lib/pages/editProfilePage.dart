import 'package:actwithy/Models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {

  final UserModel userModel;
  EditProfilePage({required this.userModel});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState(userModel);
}

class _EditProfilePageState extends State<EditProfilePage> {

  UserModel user;
  _EditProfilePageState(this.user);

  Color selectedColor = Color(0xFF4C6170); //dark blue
  Color negativeColor = Color(0xFFFFFFFF);//white
  Color bgColor = Color(0xFFD6E6F1); //light blue
  Color appbarColor = Color(0xFF48B2FA); //neon blue
  Color textColor = Color(0xFF2D3A43);


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

          },
        ),
        leadingWidth: MediaQuery.of(context).size.width * 0.2,
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            alignment: Alignment.centerRight,
            child: IconButton(onPressed: () {}, icon: Icon(Icons.check), iconSize: 35,),
          ),
        ],

      ),

      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.38, //TODO boyutları kontrol et
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.21,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      child:
                      Image.network(user.backgroundURL, height: MediaQuery.of(context).size.height*0.21, width: MediaQuery.of(context).size.width,fit: BoxFit.fill,),
                      //NetworkImage(user.backgroundURL); //height width
                      //Image.asset("assets/images/img.png",height: MediaQuery.of(context).size.height*0.21, width: MediaQuery.of(context).size.width,fit: BoxFit.fill,),
                    ),
                  ),
                  Positioned(
                    left: (MediaQuery.of(context).size.width*0.87)/2, //TODO position control
                      top: (MediaQuery.of(context).size.height*0.03),
                      child: IconButton(
                        color: selectedColor,
                        icon: Icon(Icons.camera_enhance_rounded, size: MediaQuery.of(context).size.width*0.1,),
                        onPressed: () {  },
                      ))
                ],
              ),
            ),
            Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height*0.21-MediaQuery.of(context).size.width*0.158,
                  left: (MediaQuery.of(context).size.width-MediaQuery.of(context).size.width*0.316)*0.5,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.ppURL), //TODO pp-bg hallet
                    radius:  MediaQuery.of(context).size.width*0.158,    //TODO make it dynamic
                  ),
                ),
                Positioned(
                    left: (MediaQuery.of(context).size.width*1.05)/2, //TODO position control
                    top: (MediaQuery.of(context).size.height*0.25),
                    child: IconButton(
                      color: selectedColor,
                      icon: Icon(Icons.camera_enhance_rounded, size: MediaQuery.of(context).size.width*0.1,),
                      onPressed: () {  },
                    ))
              ],
            ),
          ],
        ),
      ),

    );
  }
}
