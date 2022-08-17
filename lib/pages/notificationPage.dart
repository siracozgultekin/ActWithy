import 'package:actwithy/Models/ActivityModel.dart';
import 'package:actwithy/Models/PostModel.dart';
import 'package:actwithy/Models/ReactionModel.dart';
import 'package:actwithy/Models/RequestModel.dart';
import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/pages/creatingPage.dart';
import 'package:actwithy/pages/friendRequestPage.dart';
import 'package:actwithy/pages/homePage.dart';
import 'package:actwithy/pages/profilePage.dart';
import 'package:actwithy/pages/searchPage.dart';
import 'package:actwithy/services/authService.dart';
import 'package:actwithy/services/postServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emojis/emojis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int selectedIndex = 0;
  bool isReaction = true;
  Color negativeColor = Color(0xFFD6E6F1); //light blue
  Color selectedColor = Color(0xFF2D3A43); //dark blue

  List<bool> isClicked = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Color(0xFF48B2FA),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(child: Icon(Icons.person_add_alt_1),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FriendRequestPage()));
            },),
          ),
        ],
      ),
      body: Column(
        children: [
          DividerWidget(),
          Expanded(
              child: isReaction
                  ? ReactionWidget()
                  : RequestWidget()),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: MediaQuery.of(context).size.height * 0.075,
          indicatorColor: Colors.transparent,
          backgroundColor: Color(0xFF9AC6C5),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) async {
            bool check = await PostServices().checkDailyPost();

            PostModel postModel;

            if (!check) {
              postModel = PostModel(
                  postUID: "postUID",
                  date: Timestamp.now(),
                  activityUID: [],
                  heartCounter: 0,
                  brokenHeartCounter: 0,
                  joyCounter: 0,
                  sobCounter: 0,
                  angryCounter: 0,
                  reactionIDs: []);
            } else {
              //oluşturulmuş demek
              postModel = await PostServices().getDailyPost();
            }
            UserModel currentUser = await AuthService().getCurrentUser();

            setState(() {
              selectedIndex = value;

              switch(selectedIndex){
                case 0: Navigator.of(context).pop();
                break;
                case 1: showSearch(context: context, delegate: SearchPage(hintText: "Search", hintTextColor: TextStyle(color: Colors.white)));
                break;
                case 2: Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CreatingPage(postModel: postModel)));
                break;
                case 4: Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfilePage(user: currentUser)));
                break;

              }




            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home, color: Colors.white),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.search, color: Colors.white),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.post_add, color: Colors.white),
              label: '',
            ),
            NavigationDestination(
              icon:
              Icon(Icons.notifications_none_outlined, color: Colors.white),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.person, color: Colors.white),
              label: '',
            ),
          ],
        ),
      ),
    );
  }

  Widget DividerWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
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
                      isReaction = true;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Center(
                        child: Text(
                      'Reactions',
                      style: TextStyle(
                          color: isReaction ? selectedColor : negativeColor,
                          fontWeight:
                              isReaction ? FontWeight.bold : FontWeight.normal,
                          fontSize: 18),
                    )),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: isReaction
                            ? BorderSide(width: 2.2, color: selectedColor)
                            : BorderSide(width: 1.5, color: negativeColor),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isReaction = false;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Center(
                        child: Text(
                      'Requests',
                      style: TextStyle(
                          color: !isReaction ? selectedColor : negativeColor,
                          fontWeight:
                              !isReaction ? FontWeight.bold : FontWeight.normal,
                          fontSize: 18),
                    )),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: !isReaction
                            ? BorderSide(width: 2.2, color: selectedColor)
                            : BorderSide(width: 1.5, color: negativeColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget ReactionWidget() {
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
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        return ListViewTile(notifications[index]);
                      })
                ],
              );
            }
          }),
    );
  }

  Widget ListViewTile(NotificationActivityModel model) {
    PostModel postObj = model.post;
    UserModel userObj = model.user;
    ReactionModel reactionObj = model.reaction;
    String reactionString = "left ";

    switch (reactionObj.type) {
      case 'heart':
        reactionString += Emojis.redHeart;
        break;
      case 'brokenHeart':
        reactionString += Emojis.brokenHeart;
        break;
      case 'joy':
        reactionString += Emojis.rollingOnTheFloorLaughing;
        break;
      case 'sob':
        reactionString += Emojis.sadButRelievedFace;
        break;
      case 'angry':
        reactionString += Emojis.angryFace;
        break;
    }
    reactionString += " to your " +
        postObj.date.toDate().day.toString() +
        "/" +
        postObj.date.toDate().month.toString() +
        "/" +
        postObj.date.toDate().year.toString() +
        " ToDo";
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          //padding: EdgeInsets.fromLTRB(20,10,20,10),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(userObj.ppURL),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${userObj.name} ${userObj.surname.toUpperCase().substring(0,1)}.",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "@${userObj.username}",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Text(
                      reactionString,
                      maxLines: 3,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget RequestWidget() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: FutureBuilder(
          future: PostServices().getActivityRequestNotification(),
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
                      physics: ClampingScrollPhysics(),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        isClicked.add(false);
                        return ListViewRequests(notifications[index],index);
                      })
                ],
              );
            }
          }),
    );
  }

  Widget ListViewRequests(List<dynamic> list, int index) {
    UserModel user = list[1] as UserModel;
    ActivityModel activity = list[2] as ActivityModel;
    RequestModel request = list[0] as RequestModel;
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.13,
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
                child: Container( height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(user.ppURL),
                    ),
                  ),),
              ),
              Expanded(
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   "${user.name} ${user.surname.substring(0,1)}.",
                        //   style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        // ),
                        // Text(
                        //   "@${user.username}",
                        //   style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        //
                        // ),
                      ],
                    ),
                    Container(
                       height: MediaQuery.of(context).size.height * 0.12,
                       width: MediaQuery.of(context).size.width * 0.45,
                        child: Center(
                          child: Text(
                            "${user.name} wants to attend the '${activity.activityType}' event on ${activity.time.toDate().day}/${activity.time.toDate().month}/${activity.time.toDate().year} at ${activity.time.toDate().hour}.${activity.time.toDate().minute} ",style: TextStyle(fontSize: 12.5),
                            maxLines: 5,
                          ),
                        )),
                    Row(
                      children:  (!controlDate(activity.time.toDate())) ?[
                        Icon(Icons.clear,color: Colors.transparent,),
                        Icon(Icons.done, color: Colors.transparent,),
                      ]:  [
                          InkWell(
                            child: Icon(Icons.clear,color: Colors.red,size:35),
                            onTap:(isClicked[index])? (){}: ()async{
                              setState((){
                                isClicked[index] = true;
                              });
                              await PostServices().deleteActivityRequest(activity, request).then((value) {
                                setState((){
                                  isClicked[index] = false;
                                });
                              });
                            },
                          ),
                          SizedBox(
                            width:  MediaQuery.of(context).size.width * 0.025,
                          ),
                          InkWell(child: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Icon(Icons.done, color: Colors.green,size:35),

                          ),
                            onTap:(isClicked[index])? (){}:  ()async{
                              setState((){
                                isClicked[index] = true;
                              });
                            if(await PostServices().controlRequest(user.userUID)){
                              activity.participants.add(user.userUID);
                              await PostServices().updateActivity(activity);
                              await PostServices().deleteActivityRequest(activity, request).then((value) {
                                setState((){
                                  isClicked[index] = false;
                                });
                              });
                            }
                            },),
                       
                        
                      ],
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

  bool controlDate(DateTime dateTime){
    DateTime today = DateTime.now();
    if(dateTime.year==today.year&&dateTime.month==today.month&&dateTime.day==today.day)
      return true;
    return false;

  }
}
