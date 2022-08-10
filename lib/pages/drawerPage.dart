import 'package:actwithy/Models/PostModel.dart';
import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/pages/homePage.dart';
import 'package:actwithy/pages/profilePage.dart';
import 'package:actwithy/services/authService.dart';
import 'package:actwithy/services/postServices.dart';
import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';

import '../Models/ActivityModel.dart';



class DrawerPage extends StatefulWidget {
  UserModel userProf;
  DrawerPage({required this.userProf});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}


class _DrawerPageState extends State<DrawerPage> {
  var page = HomePage();

  @override
  Widget build(BuildContext context) {
    late double pad= MediaQuery.of(context).size.height*0.04;

    return Drawer(
      backgroundColor: Color(0xFF4C6170),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 170,
            color: Color(0xFF4C6170),
            child: Padding(
              padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(
                                    user: widget.userProf,
                                  )),

                          );
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: widget.userProf.ppURL == 'ppURL'
                              ? BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey
                          )
                              : BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(widget.userProf.ppURL),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 8),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Text(
                                      "${widget.userProf.name}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Text(
                                    "@${widget.userProf.username}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold

                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 2.0),
                                        child: Text(
                                          "${widget.userProf.friends.length}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Text(
                                        "Friends",
                                        style: TextStyle(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 2.0, left: 10),
                                        child: Text(
                                          "${widget.userProf.postCount}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Text(
                                        "Posts",
                                        style: TextStyle(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Divider(
              color: Colors.grey[600],
              height: 0.05,thickness: 1,
            ),
          ),
          Stack(children: [
            Padding(
              padding:  EdgeInsets.fromLTRB(0, pad, 0, 0),
              child: FutureBuilder(
                  future:PostServices().getDailyPost(),builder: (context, AsyncSnapshot snap) {
                if (!snap.hasData) {
                  return Center(
                    child: Container(
                        height: 50,width: 50,
                        child: CircularProgressIndicator()),
                  );
                } else {
                  PostModel post = snap.data;
                  return Center(
                    child: Container(
                      height: post.activityUID.length<=2 ? MediaQuery.of(context).size.height * 0.33
                          :MediaQuery.of(context).size.height * 0.445,
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                          color: Color(0XFFD6E6F1), borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey[300], borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20.0,bottom: 1),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Center(child: Text("My Daily Post",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold, ),)),

                                      Text("${post.date.toDate().day}/${post.date.toDate().month}/${post.date.toDate().year}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                                    ],
                                  ),
                                ),
                              ),
                              //TODO HATA Text(mod.activitiesList![0].activityUID),
                              Expanded(
                                child: Container(
                                  child: SingleChildScrollView(
                                    physics: ClampingScrollPhysics(),
                                    child: Column(
                                       children: [
                                        ListView.builder(
                                            itemCount: post.activityUID.length,
                                            scrollDirection: Axis.vertical,
                                            physics: ClampingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return FutureBuilder(
                                                future: PostServices()
                                                    .getParticipantsByID(post.activityUID[index]),
                                                builder: (context, AsyncSnapshot snap) {
                                                  if (!snap.hasData) {
                                                    return Center(
                                                      child: Container(
                                                          height: 50,width: 50,
                                                          child: CircularProgressIndicator()),
                                                    );
                                                  }else{
                                                    Map<ActivityModel,List<UserModel>> map = snap.data;
                                                    late ActivityModel activity;
                                                    late List<UserModel> participantList;
                                                    map.forEach((key, value) {
                                                      activity= key;
                                                      participantList = value;
                                                      print('Key = $key : Value = $value');
                                                    });
                                                    return Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(8,1,8,8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(activity
                                                                  .activityType),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    padding: EdgeInsets.all(0.0),
                                                                    child: InkWell(
                                                                        child: Icon(Icons
                                                                            .watch_later_outlined)),
                                                                  ),
                                                                  Text(
                                                                      "${activity.time.toDate().hour}:${activity.time.toDate().minute}"),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(Icons.location_on),
                                                                Text(
                                                                    "${activity.location}"),
                                                              ],
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                ParticipantPopUp(participantList);
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  if (activity.participants
                                                                      .length >=
                                                                      1)
                                                                    Padding(
                                                                      padding:
                                                                      const EdgeInsets.only(left: 8.0),
                                                                      child: CircleAvatar(
                                                                        
                                                                           radius: 10,
                                                                        backgroundImage: NetworkImage(participantList[0].ppURL),
                                                                     ),
                                                                    ),
                                                                  if (activity.participants
                                                                      .length >=
                                                                      2)
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(
                                                                        left: 4.0,
                                                                      ),
                                                                      child: Row(
                                                                        children: [
                                                                          CircleAvatar(
                                                                            radius: 10,
                                                                            backgroundImage: NetworkImage(participantList[1].ppURL),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  if (activity.participants
                                                                      .length >
                                                                      2)
                                                                    Padding(
                                                                      padding:
                                                                      const EdgeInsets.only(left: 8.0),
                                                                      child: Column(
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              "+${activity.participants.length - 2}"),
                                                                          Row(
                                                                            children: [
                                                                              Container(
                                                                                height: 5,
                                                                                width: 5,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.black,
                                                                                  shape: BoxShape.circle,
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding:
                                                                                const EdgeInsets.only(
                                                                                    left: 2.0,
                                                                                    right: 2),
                                                                                child: Container(
                                                                                  height: 5,
                                                                                  width: 5,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.black,
                                                                                    shape: BoxShape.circle,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 5,
                                                                                width: 5,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.black,
                                                                                  shape: BoxShape.circle,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Divider(height: 3,thickness: 1.50,),
                                                      ],
                                                    );
                                                  }
                                                },
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Divider(height: 1,color: Colors.blue,),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                Row(
                                  children: [
                                  Text("${Emojis.redHeart}",style: TextStyle(fontSize: 15),),
                                  Text("${post.heartCounter}"),
                                ],),
                                  Row(
                                    children: [
                                      Text("${Emojis.brokenHeart}",style: TextStyle(fontSize: 15),),
                                      Text("${post.brokenHeartCounter}"),
                                    ],),
                                  Row(
                                    children: [
                                      Text("${Emojis.rollingOnTheFloorLaughing}",style: TextStyle(fontSize: 15),),
                                      Text("${post.joyCounter}"),
                                    ],),
                                  Row(
                                    children: [
                                      Text("${Emojis.sadButRelievedFace}",style: TextStyle(fontSize: 15),),
                                      Text("${post.sobCounter}"),
                                    ],),
                                  Row(
                                    children: [
                                      Text("${Emojis.angryFace}",style: TextStyle(fontSize: 15),),
                                      Text("${post.angryCounter}"),
                                    ],),
                              ],),
                            ],
                          )),
                    ),
                  );
                }
              }
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.zero,
                height: 50,width: MediaQuery.of(context).size.width * 0.75,
                child: Image(
                  image: AssetImage("assets/images/tell.png"),),

              ),
            ),
          ],),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    await AuthService().signOut(context);
                  },
                  child: ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.logout),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Log Out',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget listTile(Icon icon, String text, var page) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => page));
      },
      child: ListTile(
        leading: icon,
        title: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
  ParticipantPopUp(List<UserModel> participantList) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.only(left: 10, right: 10),
          title: Center(
              child: Text(
                "Participants",
                style: TextStyle(fontSize: 25, color: Color(0xFF2D3A43)),
              )),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.7,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ClampingScrollPhysics(),
                    itemCount: participantList.length,
                    separatorBuilder:  (context, index) =>Divider(thickness: 10,),
                    itemBuilder: (context, index) {
                      UserModel user = participantList[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                      user: user,
                                    )));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0XFFD6E6F1),
                            ),
                            child: Padding(
                              padding:
                              const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(user.ppURL),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(
                                                10, 0, 5, 0),
                                            child: Text(
                                              user.username,
                                              style: TextStyle(
                                                  color: Color(0xFF2D3A43),
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(
                                                10, 0, 5, 0),
                                            child: Text(
                                              "${user.name} ${user.surname}",
                                              style: TextStyle(
                                                  color: Color(0xFF4C6170),
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text("Ok")),
          ],
        ));
  }
}