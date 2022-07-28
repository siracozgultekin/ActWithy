import 'package:actwithy/Models/ActivityModel.dart';
import 'package:actwithy/Models/PostModel.dart';
import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/pages/creatingPage.dart';
import 'package:actwithy/pages/drawerPage.dart';
import 'package:actwithy/pages/profilePage.dart';
import 'package:actwithy/pages/searchPage.dart';
import 'package:actwithy/services/authService.dart';
import 'package:actwithy/services/postServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:emojis/emojis.dart';
import 'package:emojis/emoji.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<UserModel> userMList;
  int chosenEmoji=0;
  int selectedIndex = 0;
  final controller = ScrollController();
  late UserModel user;
  bool isLoading = true;
  var mediaqueryHeight;
 List<int> emojiCheck =[ //TODO HER POST OBJESİ İÇİN AYRI BİR LİSTE ATAYABİLMEN LAZIM (MUHTEMELEN FİREBASE TARAFINDA OLUŞTURULACAK.)
   0,//Hearth
   0,//Broken Hearth
   0,//Laughing
   0,//Sob
   0,//Angry
 ];
  @override
  void initState() {
    getMe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFD6E6F1),
      drawer: isLoading
          ? CircularProgressIndicator(
              backgroundColor: Color(0xFF15202B),
            )
          : DrawerPage(
              userProf: user,
            ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: isLoading
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: user.ppURL == 'ppURL'
                          ? BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            )
                          : BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(user.ppURL),
                              )),
                    ),
                  ),
          ), /*MaterialButton(
              child: Image.asset('assets/images/pp.jpg'),
              onPressed: () {Scaffold.of(context).openDrawer();}
            ),*/
        ),
        centerTitle: true,
        title: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage("assets/images/mavibg.png"),
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () async {
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
                          angryCounter: 0);
                    } else {
                      //oluşturulmuş demek
                      postModel = await PostServices().getDailyPost();
                    }

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreatingPage(
                              postModel: postModel,
                            )));
                  },
                  icon: Icon(Icons.warning)),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  "3",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(

          future: PostServices().getFriendsPosts(),
          builder: (context, AsyncSnapshot snap) {
            if (!snap.hasData) {
              return CircularProgressIndicator();
            } else {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.separated(
                    controller: controller,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => Divider(
                          color: Colors.grey,
                          height: 0.15,
                        ),
                    scrollDirection: Axis.vertical,
                    itemCount: snap.data.length, //TODO snap.data.length,
                    itemBuilder: (context, index) {
                      mediaqueryHeight=MediaQuery.of(context).size.height*0.06;
                      DenemeModel postModelObj =
                          snap.data[index] as DenemeModel;
                      return mainListTile(postModelObj);
                    }),
              );
            }
          }),
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
                  angryCounter: 0);
            } else {
              //oluşturulmuş demek
              postModel = await PostServices().getDailyPost();
            }

            setState(() {
              selectedIndex = value;
              if (selectedIndex == 0) {
                scrollUp();
              } else if (selectedIndex == 1) {
                showSearch(
                    context: context,
                    delegate: SearchPage(
                        hintText: "Search",
                        hintTextColor: TextStyle(color: Colors.white)));
              } else if (selectedIndex == 2) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreatingPage(postModel: postModel)));
              } else if (selectedIndex == 3) {
              } else if (selectedIndex == 4) {}
            });
          },
          /*  if (selected == 0) {

            }
            print(selected); */
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

  void scrollUp() {
    final double start = 0;
    controller.jumpTo(start);
  }

  getMe() async {
    UserModel us = UserModel.fromSnapshot(await PostServices().getMyDoc());
    print("snapshotugeçti");
    setState(() {
      user = us;
      isLoading = false;
    });
  }

  Widget mainListTile(DenemeModel mod) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 8.0,bottom: 8.0),
            child: Container(
              height: mod.activitiesList.length<=2 ? MediaQuery.of(context).size.height * 0.33 :MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Center(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: mediaqueryHeight,
                              width: mediaqueryHeight,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(mod.userObj.ppURL)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ("${mod.userObj.name} ${mod.userObj.surname}"),
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "@${mod.userObj.username}",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                      ],
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
                                itemCount: mod.activitiesList.length,
                                scrollDirection: Axis.vertical,
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return FutureBuilder(
                                    future: PostServices()
                                        .getParticipants(mod.activitiesList[index]),
                                    builder: (context, AsyncSnapshot snap) {
                                      if (!snap.hasData) {
                                        return CircularProgressIndicator();
                                      }else{
                                        ActivityModel activity = mod.activitiesList[index];
                                        List<UserModel> participantList = snap.data;
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
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
                                                                "${activity.time.toDate().hour}:${mod.activitiesList[index].time.toDate().minute}"),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ), // activity and clock
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child:
                                                        InkWell(child: Icon(Icons.close)),
                                                      ),
                                                    ],
                                                  ), // delete and edit icons
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
                                                          child: Container(
                                                            height: 20,
                                                            width: 20,
                                                            decoration: BoxDecoration(
                                                              color: Colors.green,
                                                              shape: BoxShape.circle,
                                                              image: DecorationImage(
                                                                image: NetworkImage(
                                                                    participantList[0].ppURL),
                                                              ),
                                                            ),
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
                                                              Container(
                                                                height: 20,
                                                                width: 20,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.green,
                                                                    shape: BoxShape.circle,
                                                                    image: DecorationImage(
                                                                      image: NetworkImage(
                                                                          participantList[1].ppURL),
                                                                    )),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height:MediaQuery.of(context).size.height * 0.05,
                      width:  MediaQuery.of(context).size.width*0.9,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(padding: EdgeInsets.zero,
                                  icon: Text("${Emojis.redHeart}",style: TextStyle(fontSize: 15),),
                                  onPressed: ()async{
                                  if(emojiCheck[0]==0){
                                    PostServices().setHeartCounter(mod.postObj.postUID, true);
                                    emojiCheck[0]=1;
                                    emojiCheck[1]=-1;
                                    emojiCheck[2]=-1;
                                    emojiCheck[3]=-1;
                                    emojiCheck[4]=-1;
                                    chosenEmoji=1;
                                  }
                                  else if(emojiCheck[0]==1){
                                    PostServices().setHeartCounter(mod.postObj.postUID, false);
                                    emojiCheck[0]=0;
                                    emojiCheck[1]=0;
                                    emojiCheck[2]=0;
                                    emojiCheck[3]=0;
                                    emojiCheck[4]=0;
                                  }
                                  else if(emojiCheck[0]==-1){
                                    PostServices().checkEmoji(chosenEmoji, mod.postObj.postUID);
                                    PostServices().setHeartCounter(mod.postObj.postUID, true);
                                    emojiCheck[0]=1;
                                    emojiCheck[1]=-1;
                                    emojiCheck[2]=-1;
                                    emojiCheck[3]=-1;
                                    emojiCheck[4]=-1;
                                    chosenEmoji=1;
                                  }

                                  },
                                ),
                                Text("${mod.postObj.heartCounter}"),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(padding: EdgeInsets.zero,
                                  icon: Text("${Emojis.brokenHeart}",style: TextStyle(fontSize: 15),),
                                  onPressed: (){ {
                                    if(emojiCheck[1]==0){
                                      PostServices().setBrokenHeartCounter(mod.postObj.postUID, true);
                                      emojiCheck[0]=-1;
                                      emojiCheck[1]=1;
                                      emojiCheck[2]=-1;
                                      emojiCheck[3]=-1;
                                      emojiCheck[4]=-1;
                                      chosenEmoji=2;
                                    }
                                    else if(emojiCheck[1]==1){
                                      PostServices().setBrokenHeartCounter(mod.postObj.postUID, false);
                                      emojiCheck[0]=0;
                                      emojiCheck[1]=0;
                                      emojiCheck[2]=0;
                                      emojiCheck[3]=0;
                                      emojiCheck[4]=0;
                                    }
                                    else if(emojiCheck[1]==-1){
                                      PostServices().checkEmoji(chosenEmoji, mod.postObj.postUID);
                                      PostServices().setBrokenHeartCounter(mod.postObj.postUID, true);
                                      emojiCheck[0]=-1;
                                      emojiCheck[1]=1;
                                      emojiCheck[2]=-1;
                                      emojiCheck[3]=-1;
                                      emojiCheck[4]=-1;
                                      chosenEmoji=2;
                                    }

                                  }
                                  },
                                ), Text("${mod.postObj.brokenHeartCounter}"),
                              ],
                            ), Row(
                              children: [
                                IconButton(padding: EdgeInsets.zero,
                                  icon: Text("${Emojis.rollingOnTheFloorLaughing}",style: TextStyle(fontSize: 15),),
                                  onPressed: (){
                                    if(emojiCheck[2]==0){
                                      PostServices().setJoyCounter(mod.postObj.postUID, true);
                                      emojiCheck[0]=-1;
                                      emojiCheck[1]=-1;
                                      emojiCheck[2]=1;
                                      emojiCheck[3]=-1;
                                      emojiCheck[4]=-1;
                                      chosenEmoji=3;
                                    }
                                    else if(emojiCheck[2]==1){
                                      PostServices().setJoyCounter(mod.postObj.postUID, false);
                                      emojiCheck[0]=0;
                                      emojiCheck[1]=0;
                                      emojiCheck[2]=0;
                                      emojiCheck[3]=0;
                                      emojiCheck[4]=0;
                                    }
                                    else if(emojiCheck[2]==-1){
                                      PostServices().checkEmoji(chosenEmoji, mod.postObj.postUID);
                                      PostServices().setJoyCounter(mod.postObj.postUID, true);
                                      emojiCheck[0]=-1;
                                      emojiCheck[1]=-1;
                                      emojiCheck[2]=1;
                                      emojiCheck[3]=-1;
                                      emojiCheck[4]=-1;
                                      chosenEmoji=3;
                                    }
                                 },
                                ),  Text("${mod.postObj.joyCounter}"),
                              ],
                            ),Row(
                              children: [
                                IconButton(padding: EdgeInsets.zero,
                                  icon: Text("${Emojis.sadButRelievedFace}",style: TextStyle(fontSize: 15),),
                                  onPressed: (){ {
                                    if(emojiCheck[3]==0){
                                      PostServices().setSobCounter(mod.postObj.postUID, true);
                                      emojiCheck[0]=-1;
                                      emojiCheck[1]=-1;
                                      emojiCheck[2]=-1;
                                      emojiCheck[3]=1;
                                      emojiCheck[4]=-1;
                                      chosenEmoji=4;
                                    }
                                    else if(emojiCheck[3]==1){
                                      PostServices().setSobCounter(mod.postObj.postUID, false);
                                      emojiCheck[0]=0;
                                      emojiCheck[1]=0;
                                      emojiCheck[2]=0;
                                      emojiCheck[3]=0;
                                      emojiCheck[4]=0;
                                    }
                                    else if(emojiCheck[3]==-1){
                                      PostServices().checkEmoji(chosenEmoji, mod.postObj.postUID);
                                      PostServices().setSobCounter(mod.postObj.postUID, true);
                                      emojiCheck[0]=-1;
                                      emojiCheck[1]=-1;
                                      emojiCheck[2]=-1;
                                      emojiCheck[3]=1;
                                      emojiCheck[4]=-1;
                                      chosenEmoji=4;
                                    }

                                  }
                                 },
                                ), Text("${mod.postObj.sobCounter}"),
                              ],
                            ),Row(
                              children: [
                                IconButton(padding: EdgeInsets.zero,
                                  icon: Text("${Emojis.angryFace}",style: TextStyle(fontSize: 15),),
                                  onPressed: (){{

                                    if(emojiCheck[4]==0){
                                      PostServices().setAngryCounter(mod.postObj.postUID, true);
                                      emojiCheck[0]=-1;
                                      emojiCheck[1]=-1;
                                      emojiCheck[2]=-1;
                                      emojiCheck[3]=-1;
                                      emojiCheck[4]=1;
                                      chosenEmoji=5;
                                    }
                                    else if(emojiCheck[4]==1){
                                      PostServices().setAngryCounter(mod.postObj.postUID, false);
                                      emojiCheck[0]=0;
                                      emojiCheck[1]=0;
                                      emojiCheck[2]=0;
                                      emojiCheck[3]=0;
                                      emojiCheck[4]=0;
                                    }
                                    else if(emojiCheck[4]==-1){
                                      PostServices().checkEmoji(chosenEmoji, mod.postObj.postUID);
                                      PostServices().setAngryCounter(mod.postObj.postUID, true);
                                      emojiCheck[0]=-1;
                                      emojiCheck[1]=-1;
                                      emojiCheck[2]=-1;
                                      emojiCheck[3]=-1;
                                      emojiCheck[4]=1;
                                      chosenEmoji=5;
                                    }


                                  }
                                  },
                                ), Text("${mod.postObj.angryCounter}"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),
          ),
        ],
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
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(user.ppURL),
                                          ),
                                        ),
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
