import 'package:actwithy/Models/PostModel.dart';
import 'package:actwithy/Models/ReactionModel.dart';
import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/services/postServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isToDo = true;
  Color negativeColor = Color(0xFFD6E6F1); //light blue
  Color selectedColor = Color(0xFF2D3A43); //dark blue

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications"),backgroundColor: Color(0xFF48B2FA),),
      body: Column(
        children: [
          DividerWidget(),
          Expanded(child: isToDo ? Container(color: Colors.blueGrey,) : Container(color: Colors.red,)),
        ],

      ),
    );
  }


  Widget DividerWidget() {
    return
      Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isToDo = true;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,

                      child: Center(child: Text('Reactions', style: TextStyle(color: isToDo ? selectedColor: negativeColor, fontWeight: isToDo ? FontWeight.bold : FontWeight.normal,fontSize: 18),)),
                      decoration: BoxDecoration(
                        border: Border(

                          bottom: isToDo ? BorderSide(width: 2.2, color: selectedColor) :  BorderSide(width: 1.5, color: negativeColor),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState((){
                        isToDo = false;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Center(child: Text('Requests', style: TextStyle(color: !isToDo ? selectedColor: negativeColor, fontWeight: !isToDo ? FontWeight.bold : FontWeight.normal,fontSize: 18),)),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: !isToDo ? BorderSide(width: 2.2, color: selectedColor): BorderSide(width: 1.5, color: negativeColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      )
    ;
  }

  Widget ReactionWidget(){
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: FutureBuilder(
        future: PostServices().getNotificationReactions(),
    builder: (context, AsyncSnapshot snap) {
      if (!snap.hasData) {
        return CircularProgressIndicator();
      } else {
        List<NotificationActivityModel> notifications = snap.data;
        return Column(
          children: [ListView.builder( shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              itemCount: notifications.length,
              itemBuilder: (context,index){
            return ListViewTile(notifications[index]);
              })],
        );
      }
    }
      ),

    );
  }

  Widget ListViewTile(NotificationActivityModel model){
    PostModel postObj = model.post;
    UserModel userObj = model.user;
    ReactionModel reactionObj = model.reaction;
    return Container(
      height: MediaQuery.of(context).size.height*0.1,
      width: MediaQuery.of(context).size.width*0.8,
      color: Colors.blueGrey,
      child: Text(userObj.username),
    );
  }

}
