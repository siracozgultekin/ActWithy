import 'package:actwithy/Models/ActivityModel.dart';
import 'package:actwithy/Models/PostModel.dart';
import 'package:actwithy/Models/ReactionModel.dart';
import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/pages/creatingPage.dart';
import 'package:actwithy/pages/editProfilePage.dart';
import 'package:actwithy/pages/homePage.dart';
import 'package:actwithy/pages/searchPage.dart';
import 'package:actwithy/services/postServices.dart';
import 'package:actwithy/services/searchService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emojis/emojis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'notificationPage.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;
  ProfilePage({required this.user});
  @override
  State<ProfilePage> createState() => _ProfilePageState(user);
}


class _ProfilePageState extends State<ProfilePage> {

  UserModel user;
  _ProfilePageState(this.user);
  List<ActivityModel> actList = [];
  //TODO emojilerdeki List<bool> gibi yappp

  bool isToDo = true;
  bool isMyFriend = false;
  String buttonText = "";
  final controller = ScrollController();



  getIsMyFriend() async {
    bool result = await SearchService().isMyFriend(user.userUID);
    setState(() {
      isMyFriend = result;
      if (isMyFriend) {
        buttonText = "Remove Friend";
      }else buttonText = "Add Friend";
    });
  }

  getActList(String postId) async {
    actList = await PostServices().getPostsActivities(postId);
  }

  initState()  {
    getActList(user.lastPostID);
    getIsMyFriend();
    super.initState();
  }

  Color selectedColor = Color(0xFF4C6170); //dark blue
  Color negativeColor = Color(0xFFFFFFFF);//white
  Color bgColor = Color(0xFFD6E6F1); //light blue
  Color appbarColor = Color(0xFF48B2FA); //neon blue
  Color textColor = Color(0xFF2D3A43);
  NumberFormat formatter = new NumberFormat("00");

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 4;
    bool isMyPage = user.userUID==FirebaseAuth.instance.currentUser!.uid;


    return Scaffold(
      backgroundColor: bgColor,
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

            setState(() {
              selectedIndex = value;
              if (selectedIndex == 0) {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> HomePage()), (route) => false);
              } else if (selectedIndex == 1) {
                showSearch(
                    context: context,
                    delegate: SearchPage(
                        hintText: "Search",
                        hintTextColor: TextStyle(color: Colors.white)));
              } else if (selectedIndex == 2) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => CreatingPage(postModel: postModel)));
              } else if (selectedIndex == 3) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NotificationPage()));
              } else if (selectedIndex == 4) {
                scrollUp();

              }
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
      appBar: AppBar(
        backgroundColor: appbarColor,
        centerTitle: true,
        title: !isMyPage ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text('@${user.username}', style: TextStyle(fontSize: 15,),), //TODO align left
                Text('${user.postCount} Posts', style: TextStyle(fontSize: 15),),
              ],
            ),
          ],
        ): Container(),
        leading: isMyPage ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('@${user.username}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            Text('${user.postCount} Posts', style: TextStyle(fontSize: 15),),
          ],
        ): BackButton(
          color: negativeColor,
        ),
        leadingWidth: isMyPage? MediaQuery.of(context).size.width * 0.5 :MediaQuery.of(context).size.width * 0.2,
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            alignment: Alignment.centerRight,
            child: IconButton(onPressed: () {}, icon: Icon(Icons.settings), iconSize: 35,),
          ),

        ],
      ),

      body: Column(
        children: [
          ProfileWidget(isMyPage),
          DividerWidget(),
          Expanded(child: isToDo ? ToDoWidget() : FriendWidget()),
        ],
      ),

    );
  }

  //TODO bio karakter kısıtlaması getir

  Widget ProfileWidget(bool isMyPage) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.38, //TODO boyutları kontrol et
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              child:
              Image.network(user.backgroundURL, height: MediaQuery.of(context).size.height*0.21, width: MediaQuery.of(context).size.width,fit: BoxFit.cover,),
              //NetworkImage(user.backgroundURL); //height width
              //Image.asset("assets/images/img.png",height: MediaQuery.of(context).size.height*0.21, width: MediaQuery.of(context).size.width,fit: BoxFit.fill,),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height*0.21-MediaQuery.of(context).size.width*0.158,
            left: (MediaQuery.of(context).size.width-MediaQuery.of(context).size.width*0.316)*0.5,
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.ppURL), //TODO pp-bg hallet
              radius:  MediaQuery.of(context).size.width*0.158,    //TODO make it dynamic
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height*0.21,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column( //TODO wrap with sized box
                children: [
                  Text('${user.name}', style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.036,fontWeight: FontWeight.bold, color: textColor),),
                  Text('${user.surname}', style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.036,fontWeight: FontWeight.bold, color: textColor),),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height*0.21,
            right: 8.0,
            child: ElevatedButton(
              onPressed: ()  async {
                if(isMyPage) {
                  ///TODO editle profili
                  //UserModel userModel = UserModel.fromSnapshot(await FirebaseFirestore.instance.collection('users').doc(user.userUID).get()) as UserModel;
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> EditProfilePage(userModel: user))).then((value) {setState((){});});
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditProfilePage(userModel: user,)));
                }else if (!isMyPage && isMyFriend) {
                  await SearchService().removeFriend(user.userUID).then((value) {
                    setState((){isMyFriend = !isMyFriend;buttonText = "Add Friend";});
                  });
                }else if (!isMyPage && !isMyFriend) {
                  await SearchService().addFriend(user.userUID).then((value) {setState((){isMyFriend = !isMyFriend; buttonText = "Remove Friend";});});
                }

              },
              child: Text(isMyPage? "Edit Profile":buttonText,style: TextStyle(color: negativeColor,fontSize: MediaQuery.of(context).size.width*0.028),),
              style: ElevatedButton.styleFrom(
                primary: selectedColor,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                minimumSize: Size(100, 30),
              ),
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height*0.23+MediaQuery.of(context).size.width*0.158,
              left: 8.0,
              height: MediaQuery.of(context).size.height*0.07,
              child: Text(user.bio, style: TextStyle(
                color: textColor,
              ),)),
        ],
      ),
    );
  }

  Widget DividerWidget() {
    return
      SizedBox(
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

                    child: Center(child: Text('ToDo List', style: TextStyle(color: isToDo ? selectedColor: negativeColor, fontWeight: isToDo ? FontWeight.bold : FontWeight.normal),)),
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
                    child: Center(child: Text('Friends', style: TextStyle(color: !isToDo ? selectedColor: negativeColor, fontWeight: !isToDo ? FontWeight.bold : FontWeight.normal),)),
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
      )
    ;
  }

  Widget ToDoWidget() {

    String selectedPostID = user.lastPostID;
    return
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: FutureBuilder(
          future: PostServices().getPosts(user.userUID),
          builder: (context, AsyncSnapshot snap) {
            if(!snap.hasData) {
              return CircularProgressIndicator();
            }else{
              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemCount: snap.data.length,
                    itemBuilder: (context, index) {
                      PostModel post = snap.data[index] as PostModel;
                      getActList(post.postUID);
                      DenemeModel denemeModel = DenemeModel(userObj: user, activitiesList: actList, postObj: post);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            InkWell(
                              onTap : () {
                                if (selectedPostID == post.postUID) {
                                  selectedPostID = user.lastPostID;
                                }else {
                                  selectedPostID = post.postUID;
                                }
                                setState((){});
                                print(selectedPostID);
                                //TODO ikinci tap'ta postu kapat
                                //TODO aynı anda sadece bir tane post açık kalabilir
                                //TODO sayfaya ilk girişte mutlaka son post açık kalmalı
                              },
                              child:  Container(
                                decoration: BoxDecoration(
                                    color: negativeColor,
                                    borderRadius: BorderRadius.all(Radius.circular(25))
                                ),
                                width: MediaQuery.of(context).size.width*0.95,

                                /*TODO == yap   */
                                child: selectedPostID==post.postUID ?
                                OpenPost(denemeModel) : ClosedPost(post), //DenemeModel???
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
      )
    ;
  }

  Widget FriendWidget() {
    return
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: FutureBuilder(
          future: PostServices().getFriends(user.friends),
          builder: (context, AsyncSnapshot snap) {
            if(!snap.hasData) {
              return CircularProgressIndicator();
            }else{
              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ClampingScrollPhysics(),
                    itemCount: snap.data.length,
                    itemBuilder: (context, index) {
                      UserModel friend = snap.data[index] as UserModel;
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child : Container(
                          decoration: BoxDecoration(
                              color: negativeColor,
                              borderRadius: BorderRadius.all(Radius.circular(25))
                          ),
                          width: MediaQuery.of(context).size.width*0.95,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    //TODO eğer kendi sayfama yönlendirmeye çalışıyosam !isMyPage gibi olmalı
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfilePage(user: friend,)));
                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(friend.ppURL),
                                        radius: MediaQuery.of(context).size.width*0.05,
                                      ),
                                      SizedBox(
                                        width: 8, //TODO dynamiccc
                                      ),
                                      Column(
                                        children: [
                                          Container(width: MediaQuery.of(context).size.width*0.8,child: Text("${friend.name} ${friend.surname}")),
                                          Container(width: MediaQuery.of(context).size.width*0.8,child: Text("@${friend.username}"))
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),);
                    },

                  ),
                ],
              );
            }
          },
        ),
      )
    ;
  }

  Widget OpenPost(DenemeModel mod) {
    var postDate = mod.postObj.date.toDate();
    var mediaqueryHeight=MediaQuery.of(context).size.height*0.06;
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
                                      fit: BoxFit.cover,
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
                                      onPressed: () async {
                                        ///postun reactionlarına bak şu anki kullanıcıdan reaksiyon varsa
                                        ///aynısıysa geri al (reaksiyonu sil - database + postmodel)
                                        ///farklıysa eskisini güncelle.
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
                                            if(oldReactType==ReactionModel.angry)
                                              mod.postObj.angryCounter--;
                                            else if (oldReactType==ReactionModel.brokenHeart)
                                              mod.postObj.brokenHeartCounter--;
                                            else if(oldReactType == ReactionModel.joy)
                                              mod.postObj.joyCounter--;
                                            else if(oldReactType == ReactionModel.sob)
                                              mod.postObj.sobCounter--;
                                            reaction.type = ReactionModel.heart;
                                            mod.postObj.heartCounter++;
                                            await PostServices().updateReaction(reaction);
                                            await PostServices().updatePost(mod.postObj).then((value) {
                                              setState((){
                                              });
                                            });
                                          }

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
                                      onPressed: ()async{
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
                                      },
                                    ), Text("${mod.postObj.brokenHeartCounter}"),
                                  ],
                                ), Row(
                                  children: [
                                    IconButton(padding: EdgeInsets.zero,
                                      icon: Text("${Emojis.rollingOnTheFloorLaughing}",style: TextStyle(fontSize: 15),),
                                      onPressed: ()async{
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

                                      },
                                    ),  Text("${mod.postObj.joyCounter}"),
                                  ],
                                ),Row(
                                  children: [
                                    IconButton(padding: EdgeInsets.zero,
                                      icon: Text("${Emojis.sadButRelievedFace}",style: TextStyle(fontSize: 15),),
                                      onPressed: ()async{
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


                                      },
                                    ), Text("${mod.postObj.sobCounter}"),
                                  ],
                                ),Row(
                                  children: [
                                    IconButton(padding: EdgeInsets.zero,
                                      icon: Text("${Emojis.angryFace}",style: TextStyle(fontSize: 15),),
                                      onPressed: ()async{
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



  Widget ClosedPost(PostModel post) {
    var postDate = post.date.toDate();
    int day = postDate.day;
    var month = postDate.month;
    var year = postDate.year;
    List<UserModel> participants = [];


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.calendar_today, color: textColor, size: MediaQuery.of(context).size.width*0.1),
          Text("${formatter.format(day)}-${formatter.format(month)}-${year}",
            style: TextStyle(color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width*0.045,
            ), ),
          Text(participants.length.toString()),

          //TODO iki kişiden fazlasını artı olarak göster
        ],
      ),
    );
  }

  void scrollUp() {
    final double start = 0;
    controller.jumpTo(start);
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



