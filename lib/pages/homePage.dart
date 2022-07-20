import 'package:actwithy/Models/PostModel.dart';
import 'package:actwithy/pages/creatingPage.dart';
import 'package:actwithy/pages/searchPage.dart';
import 'package:actwithy/services/authService.dart';
import 'package:actwithy/services/postServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 appBar: AppBar(
   title: Text("HomePage"),
   centerTitle: true,
   actions: [
     IconButton(
         onPressed: () async {
            bool check = await PostServices().checkDailyPost();
            PostModel postModel;

            if (!check){
                  postModel = PostModel(postUID: "postUID", date: Timestamp.now(), activityUID: [], heartCounter: 0, brokenHeartCounter: 0, joyCounter: 0, sobCounter: 0, angryCounter: 0);
            }else{ //oluşturulmuş demek
             postModel= await PostServices().getDailyPost();

            }

           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CreatingPage( postModel: postModel,)));

         },
         icon: Icon(Icons.add)),
   ],
 ),
    body:Column(
      children: [
        ElevatedButton(
          onPressed: () async {
              await AuthService().signOut(context);

          },
          child: Center(
            child: Text(
              "Log Out",
              style: TextStyle(color: Color(0xFF9AC6C5)),
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Color(0xff4C6170),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            minimumSize: Size(200, 35),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            showSearch(context: context, delegate: SearchPage());


          },
          child: Center(
            child: Text(
              "Search",
              style: TextStyle(color: Color(0xFF9AC6C5)),
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Color(0xff4C6170),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            minimumSize: Size(200, 35),
          ),
        ),
      ],
    ),

    );
  }


}
