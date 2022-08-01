import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/services/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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

  Color selectedColor = Color(0xFF4C6170); //dark blue
  Color negativeColor = Color(0xFFFFFFFF);//white
  Color bgColor = Color(0xFFD6E6F1); //light blue
  Color appbarColor = Color(0xFF48B2FA); //neon blue
  Color textColor = Color(0xFF2D3A43);

  getURL() async {
    String u = await AuthService().getUserURL(isPP);
    setState(() {
      url = u;
    });
  }

  initState() {
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
                backgroundImage: NetworkImage(url),
                radius: MediaQuery.of(context).size.width/4,
              ):
              Container(
                  child:
                  Image.network(url, height: MediaQuery.of(context).size.height*0.21, width: MediaQuery.of(context).size.width,fit: BoxFit.fill,)
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
              child: TextButton(onPressed: () {} , child: Row(
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
              child: TextButton(onPressed: () {} , child: Row(
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
