import 'package:actwithy/Models/ActivityModel.dart';
import 'package:actwithy/Models/PostModel.dart';
import 'package:actwithy/Models/ReactionModel.dart';
import 'package:actwithy/Models/RequestModel.dart';
import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/pages/homePage.dart';
import 'package:actwithy/pages/profilePage.dart';
import 'package:actwithy/services/postServices.dart';
import 'package:actwithy/services/searchService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emojis/emojis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FriendRequestPage extends StatefulWidget {
  const FriendRequestPage({Key? key}) : super(key: key);

  @override
  State<FriendRequestPage> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  List<bool> isClicked = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friend Requests"),
        backgroundColor: Color(0xFF48B2FA),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: (){
                  setState(() {

                  });
                },
                child: Icon(Icons.person_add_alt_1)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: RefreshIndicator(
          displacement: 1,
          onRefresh: func,
          child: FutureBuilder(
            future: PostServices().getFriendRequests(),
            builder: (context, AsyncSnapshot snap) {
              if (!snap.hasData) {
                return CircularProgressIndicator();
              } else {
                List<List<dynamic>> notifications = snap.data;
                return Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          isClicked.add(false);
                          return ListViewTile(notifications[index],index);
                        })
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget ListViewTile(List<dynamic> list, int index) {
    UserModel user = list[1] as UserModel;
    RequestModel request = list[0] as RequestModel;
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Color(0XFFD6E6F1),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: InkWell(
                  onTap:()
                  {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ProfilePage(user: user)));},
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.065,
                    width: MediaQuery.of(context).size.height * 0.065,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(user.ppURL),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap:()
                    {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ProfilePage(user: user)));},
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.25,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${user.name} ${user.surname.substring(0,1).toUpperCase()}.",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                            ),
                            Text(
                              "@${user.username}",
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold,),

                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.23,
                        child: Text(
                          "sent a friend request",
                          maxLines: 2,
                        )),
                    InkWell(
                      child: Icon(
                        Icons.clear,
                        color: Colors.red,
                        size: 32,
                      ),
                      onTap: (isClicked[index])? (){}: () async {
                        // requesti ve notificationu sil userı güncelle
                        setState((){isClicked[index]=true;});
                        UserModel me = UserModel.fromSnapshot(
                            await PostServices().getMyDoc());
                        await PostServices()
                            .deleteFriendRequest(me, request.requestUID).then((value) {
                              setState((){isClicked[index]=false;});
                        });
                        //setState((){});
                      },
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.done,
                          color: Colors.green,
                          size: 35,
                        ),
                      ),
                      onTap: (isClicked[index])? (){}: () async {
                        setState((){isClicked[index]=true;});
                        await SearchService().addFriend(user.userUID);
                        UserModel me = UserModel.fromSnapshot(
                            await PostServices().getMyDoc());
                        await PostServices()
                            .deleteFriendRequest(me, request.requestUID).then((value) {
                              setState((){isClicked[index]=false;});
                        });
                        //setState((){});
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> func() async {
    setState(() {

    });
  }
}
