import 'package:actwithy/Models/ActivityModel.dart';
import 'package:actwithy/Models/PostModel.dart';
import 'package:actwithy/Models/ReactionModel.dart';
import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/pages/creatingPage.dart';
import 'package:actwithy/pages/drawerPage.dart';
import 'package:actwithy/pages/notificationPage.dart';
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
  String reactid="";
  int chosenEmoji=0;
  int selectedIndex = 0;
  final controller = ScrollController();
  late UserModel user;
  bool isLoading = true;
  var mediaqueryHeight;
  List<bool> isReaction = [];
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
                                fit: BoxFit.cover,
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
                          angryCounter: 0,
                      reactionIDs: []);
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
              return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/mev.png"),
                    )),
              );
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
                      isReaction.add(false);
                      DenemeModel postModelObj =
                          snap.data[index] as DenemeModel;
                      return mainListTile(postModelObj, index);
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
                  angryCounter: 0,
              reactionIDs: []);
            } else {
              //oluşturulmuş demek
              postModel = await PostServices().getDailyPost();
            }
            UserModel currentUser = await AuthService().getCurrentUser();

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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NotificationPage()));
              } else if (selectedIndex == 4) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfilePage(user: currentUser)));
              }
              switch(selectedIndex){
                case 0: scrollUp();
                  break;
                case 1: showSearch(context: context, delegate: SearchPage(hintText: "Search", hintTextColor: TextStyle(color: Colors.white)));
                  break;
                case 2: Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreatingPage(postModel: postModel)));
                  break;
                case 3: Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationPage()));
                  break;
                case 4: Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(user: currentUser)));
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

  Widget mainListTile(DenemeModel mod, int index) {

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
                        Text("${mod.postObj.date.toDate().day}/${mod.postObj.date.toDate().month}/${mod.postObj.date.toDate().year}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
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
                  Divider(height: 1,color: Colors.blue,thickness: 0.7,),
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
                                  onPressed: isReaction[index] ? () {} : () async {
                                  ///postun reactionlarına bak şu anki kullanıcıdan reaksiyon varsa
                                    ///aynısıysa geri al (reaksiyonu sil - database + postmodel)
                                    ///farklıysa eskisini güncelle.
                                    setState(() {
                                      isReaction[index] = true;
                                    });

                                    bool check = await PostServices().checkReaction(mod.postObj);
                                    if (!check){///reaksiyon yoksa yenisini oluştur.
                                      String reactionID= await PostServices().createReaction(mod.userObj.userUID, mod.postObj.postUID, ReactionModel.heart);
                                      mod.postObj.reactionIDs.add(reactionID);
                                      mod.postObj.heartCounter++;
                                      await PostServices().updatePost(mod.postObj).then((value) {
                                        setState((){
                                        });
                                      });
                                    }else{/// reaksiyon var. reaksiyonu databaseden çek düzenle
                                      ReactionModel reaction = await PostServices().getReaction(mod.postObj);
                                      if (reaction.type==ReactionModel.heart){/// aynısına tıklanmış her yerden
                                        /// (database + postun listesi + postun counterı)
                                        mod.postObj.reactionIDs.remove(reaction.reactionUID);
                                        mod.postObj.heartCounter--;
                                        await PostServices().deleteReaction(reaction.reactionUID);
                                        await PostServices().updatePost(mod.postObj).then((value) {
                                          setState((){
                                          });
                                        });
                                      }else{/// farklı reaksiyona tıklanmış güncelle
                                        String oldReactType = reaction.type;
                                        switch(oldReactType){
                                          case 'angry':
                                            mod.postObj.angryCounter--;
                                            break;
                                          case 'brokenHeart':
                                            mod.postObj.brokenHeartCounter--;
                                            break;
                                          case 'joy':
                                            mod.postObj.joyCounter--;
                                            break;
                                          case 'sob':
                                            mod.postObj.sobCounter--;
                                            break;
                                        }
                                       
                                        reaction.type = ReactionModel.heart;
                                        mod.postObj.heartCounter++;
                                        await PostServices().updateReaction(reaction);
                                        await PostServices().updatePost(mod.postObj).then((value) {
                                          setState((){
                                          });
                                        });
                                      }

                                    }
                                    setState(() {
                                      isReaction[index] = false;
                                    });
                                  },
                                ),
                                Text("${mod.postObj.heartCounter}"),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(padding: EdgeInsets.zero,
                                  icon: Text("${Emojis.brokenHeart}",style: TextStyle(fontSize: 15),),
                                  onPressed: isReaction[index] ? () {} : ()async{
                                    setState(() {
                                      isReaction[index] = true;
                                    });
                                  bool check = await PostServices().checkReaction(mod.postObj);
                                    if (!check){///reaksiyon yoksa yenisini oluştur.
                                      String reactionID= await PostServices().createReaction(mod.userObj.userUID, mod.postObj.postUID, ReactionModel.brokenHeart);
                                      mod.postObj.reactionIDs.add(reactionID);
                                      mod.postObj.brokenHeartCounter++;
                                      await PostServices().updatePost(mod.postObj).then((value) {
                                        setState((){
                                        });
                                      });
                                    }else{
                                      ReactionModel reaction = await PostServices().getReaction(mod.postObj);
                                      if(reaction.type == ReactionModel.brokenHeart){
                                        mod.postObj.reactionIDs.remove(reaction.reactionUID);
                                        mod.postObj.brokenHeartCounter--;
                                        await PostServices().deleteReaction(reaction.reactionUID);
                                        await PostServices().updatePost(mod.postObj).then((value) {
                                          setState((){
                                          });
                                        });
                                      }else{
                                        String oldReactType = reaction.type;
                                        if(oldReactType==ReactionModel.angry)
                                          mod.postObj.angryCounter--;
                                        else if (oldReactType==ReactionModel.heart)
                                          mod.postObj.heartCounter--;
                                        else if(oldReactType == ReactionModel.joy)
                                          mod.postObj.joyCounter--;
                                        else if(oldReactType == ReactionModel.sob)
                                          mod.postObj.sobCounter--;
                                        reaction.type = ReactionModel.brokenHeart;
                                        mod.postObj.brokenHeartCounter++;
                                        await PostServices().updateReaction(reaction);
                                        await PostServices().updatePost(mod.postObj).then((value) {
                                          setState((){
                                          });
                                        });
                                      }
                                    }
                                    setState(() {
                                      isReaction[index] = false;
                                    });
                                  },
                                ), Text("${mod.postObj.brokenHeartCounter}"),
                              ],
                            ), Row(
                              children: [
                                IconButton(padding: EdgeInsets.zero,
                                  icon: Text("${Emojis.rollingOnTheFloorLaughing}",style: TextStyle(fontSize: 15),),
                                  onPressed: isReaction[index] ? () {} : ()async{
                                    setState(() {
                                      isReaction[index] = true;
                                    });
                                  bool check = await PostServices().checkReaction(mod.postObj);
                                    if (!check){
                                      String reactionID= await PostServices().createReaction(mod.userObj.userUID, mod.postObj.postUID, ReactionModel.joy);
                                      mod.postObj.reactionIDs.add(reactionID);
                                      mod.postObj.joyCounter++;
                                      await PostServices().updatePost(mod.postObj).then((value) {
                                        setState((){
                                        });
                                      });
                                    }else{
                                      ReactionModel reaction = await PostServices().getReaction(mod.postObj);
                                      if(reaction.type==ReactionModel.joy){
                                        mod.postObj.reactionIDs.remove(reaction.reactionUID);
                                        mod.postObj.joyCounter--;
                                        await PostServices().deleteReaction(reaction.reactionUID);
                                        await PostServices().updatePost(mod.postObj).then((value) {
                                          setState((){
                                          });
                                        });
                                      }else{
                                        String oldReactType = reaction.type;
                                        if(oldReactType==ReactionModel.angry)
                                          mod.postObj.angryCounter--;
                                        else if (oldReactType==ReactionModel.heart)
                                          mod.postObj.heartCounter--;
                                        else if(oldReactType == ReactionModel.brokenHeart)
                                          mod.postObj.brokenHeartCounter--;
                                        else if(oldReactType == ReactionModel.sob)
                                          mod.postObj.sobCounter--;
                                        reaction.type = ReactionModel.joy;
                                        mod.postObj.joyCounter++;
                                        await PostServices().updateReaction(reaction);
                                        await PostServices().updatePost(mod.postObj).then((value) {
                                          setState((){
                                          });
                                        });
                                      }
                                    }
                                    setState(() {
                                      isReaction[index] = false;
                                    });
                                 },
                                ),  Text("${mod.postObj.joyCounter}"),
                              ],
                            ),Row(
                              children: [
                                IconButton(padding: EdgeInsets.zero,
                                  icon: Text("${Emojis.sadButRelievedFace}",style: TextStyle(fontSize: 15),),
                                  onPressed: isReaction[index] ? () {} : ()async{
                                    setState(() {
                                      isReaction[index] = true;
                                    });
                                    bool check = await PostServices().checkReaction(mod.postObj);
                                    if (!check){
                                      String reactionID= await PostServices().createReaction(mod.userObj.userUID, mod.postObj.postUID, ReactionModel.sob);
                                      mod.postObj.reactionIDs.add(reactionID);
                                      mod.postObj.sobCounter++;
                                      await PostServices().updatePost(mod.postObj).then((value) {
                                        setState((){
                                        });
                                      });
                                    }else{
                                      ReactionModel reaction = await PostServices().getReaction(mod.postObj);
                                      if(reaction.type==ReactionModel.sob){
                                        mod.postObj.reactionIDs.remove(reaction.reactionUID);
                                        mod.postObj.sobCounter--;
                                        await PostServices().deleteReaction(reaction.reactionUID);
                                        await PostServices().updatePost(mod.postObj).then((value) {
                                          setState((){
                                          });
                                        });
                                      }else{
                                        String oldReactType = reaction.type;
                                        if(oldReactType==ReactionModel.angry)
                                          mod.postObj.angryCounter--;
                                        else if (oldReactType==ReactionModel.heart)
                                          mod.postObj.heartCounter--;
                                        else if(oldReactType == ReactionModel.brokenHeart)
                                          mod.postObj.brokenHeartCounter--;
                                        else if(oldReactType == ReactionModel.joy)
                                          mod.postObj.joyCounter--;
                                        reaction.type = ReactionModel.sob;
                                        mod.postObj.sobCounter++;
                                        await PostServices().updateReaction(reaction);
                                        await PostServices().updatePost(mod.postObj).then((value) {
                                          setState((){
                                          });
                                        });
                                      }
                                    }
                                    setState(() {
                                      isReaction[index] = false;
                                    });
                                 },
                                ), Text("${mod.postObj.sobCounter}"),
                              ],
                            ),Row(
                              children: [
                                IconButton(padding: EdgeInsets.zero,
                                  icon: Text("${Emojis.angryFace}",style: TextStyle(fontSize: 15),),
                                  onPressed: isReaction[index] ? () {} : ()async{
                                    setState(() {
                                      isReaction[index] = true;
                                    });
                                    bool check = await PostServices().checkReaction(mod.postObj);
                                    if (!check){
                                      String reactionID= await PostServices().createReaction(mod.userObj.userUID, mod.postObj.postUID, ReactionModel.angry);
                                      mod.postObj.reactionIDs.add(reactionID);
                                      mod.postObj.angryCounter++;
                                      await PostServices().updatePost(mod.postObj).then((value) {
                                        setState((){
                                        });
                                      });
                                    }else{
                                      ReactionModel reaction = await PostServices().getReaction(mod.postObj);
                                      if(reaction.type==ReactionModel.angry){
                                        mod.postObj.reactionIDs.remove(reaction.reactionUID);
                                        mod.postObj.angryCounter--;
                                        await PostServices().deleteReaction(reaction.reactionUID);
                                        await PostServices().updatePost(mod.postObj).then((value) {
                                          setState((){
                                          });
                                        });
                                      }else{
                                        String oldReactType = reaction.type;
                                        if(oldReactType==ReactionModel.sob)
                                          mod.postObj.sobCounter--;
                                        else if (oldReactType==ReactionModel.heart)
                                          mod.postObj.heartCounter--;
                                        else if(oldReactType == ReactionModel.brokenHeart)
                                          mod.postObj.brokenHeartCounter--;
                                        else if(oldReactType == ReactionModel.joy)
                                          mod.postObj.joyCounter--;
                                        reaction.type = ReactionModel.angry;
                                        mod.postObj.angryCounter++;
                                        await PostServices().updateReaction(reaction);
                                        await PostServices().updatePost(mod.postObj).then((value) {
                                          setState((){
                                          });
                                        });
                                      }
                                    }

                                    setState(() {
                                      isReaction[index] = false;
                                    });
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
