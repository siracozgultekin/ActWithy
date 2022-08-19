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

import '../services/authService.dart';
import 'notificationPage.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;
  ProfilePage({required this.user});
  @override
  State<ProfilePage> createState() => _ProfilePageState(user);
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedIndex = 4;
  UserModel user;
  _ProfilePageState(this.user);

  bool isToDo = true;
  bool isMyFriend = false;
  bool pending = false;
  String buttonText = "";

  
  bool initial=true;

  

  bool isClicked=false;

  bool destinationClicked =false;
  

  final controller = ScrollController();


  late bool hidden;
  List<bool> boolList = [];

  String isRequest = "";

  late double containerHeight;


  getIsMyFriend() async {
    bool result = await SearchService().isMyFriend(user.userUID);

    String temp = await SearchService().isPending(user.userUID);
    containerHeight=MediaQuery.of(context).size.height*0.38;
    isRequest = await SearchService().controlFriendRequest(user.userUID);

    pending = !temp.isEmpty;

    //bool isPenging = await ;
    setState(() {
      isMyFriend = result;
      if(result){
        hidden=false;
      }
      if (isMyFriend) {
        buttonText = "Remove Friend";
        hidden=false;
      }
      else if (pending) {
        buttonText = "Pending";
        hidden = true;
      }
      else {
        buttonText = "Add Friend";
        hidden=true;
      }
    });
  }

  // getActList(String postId) async {
  //   List<ActivityModel> aa = await PostServices().getPostsActivities(postId);
  //   print(aa);
  //   actList.add(aa);
  // }



  @override
  initState() {


    //getActList(user.lastPostID);
    getIsMyFriend();
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //
    //   // if(scrollController.hasClients) {
    //   //       //containerHeight = MediaQuery.of(context).size.height*0.38-scrollController.offset;
    //   // }
    //
    // });

    scrollController.addListener(() {
      double off = scrollController.offset;
      initial=false;


        if(off>MediaQuery.of(context).size.height*0.38){
          setState((){ containerHeight=0;});
        }else{
          setState((){containerHeight =MediaQuery.of(context).size.height*0.38-off;});
        }



      //print("$off   +++ $containerHeight");
    });
/*
    scrollController.addListener(() {
      setState((){
        closeTopContainer = scrollController.offset > 13;
        if(scrollController.offset > 10 && scrollController.offset < 15) {
          denemeTopContainer = 1;
        } else if(scrollController.offset >= 15 && scrollController.offset < 25) {
          denemeTopContainer = 2;
        } else if(scrollController.offset >= 25) {
          denemeTopContainer = 3;
        } else {
          denemeTopContainer = 0;
        }
      });

});*/


  }

  int denemeTopContainer = 0;
  Color selectedColor = const Color(0xFF4C6170); //dark blue
  Color negativeColor = const Color(0xFFFFFFFF); //white
  Color bgColor = const Color(0xFFD6E6F1); //light blue
  Color appbarColor = const Color(0xFF48B2FA); //neon blue
  Color textColor = const Color(0xFF2D3A43);
  NumberFormat formatter = NumberFormat("00");

  ScrollController scrollController = ScrollController(initialScrollOffset: 0);
  bool closeTopContainer = false;

  @override
  Widget build(BuildContext context) {

    bool isMyPage = user.userUID == FirebaseAuth.instance.currentUser!.uid;

    if (isMyPage) {
      hidden = false;
    }

    if(isMyFriend) {
      hidden=false;
    }



    //https://www.youtube.com/watch?v=Cn6VCTaHB-k
    //https://api.flutter.dev/flutter/widgets/NestedScrollView-class.html
    //https://api.flutter.dev/flutter/widgets/CustomScrollView-class.html
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
          onDestinationSelected: destinationClicked? (value){}: (value) async {
            setState((){destinationClicked=true;});
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

            });

            switch(selectedIndex){
              case 0: Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePage()),
                      (route) => false);
              break;
              case 1: showSearch(
                  context: context,
                  delegate: SearchPage(
                      hintText: "Search",
                      hintTextColor: TextStyle(color: Colors.white)));
              break;
              case 2: Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => CreatingPage(postModel: postModel)));
              break;
              case 3: Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => NotificationPage()));
              break;
              case 4:
                //if(!isMyPage)
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfilePage(user: currentUser)));
                break;
            }

            setState((){destinationClicked=false;});
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
        title: !isMyPage
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        '@${user.username}',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ), //TODO align left
                      Text(
                        '${user.postCount} Posts',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ],
              )
            : Container(),
        leading: isMyPage
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '@${user.username}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${user.postCount} Posts',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              )
            : BackButton(
                color: negativeColor,
              ),
        leadingWidth: isMyPage
            ? MediaQuery.of(context).size.width * 0.5
            : MediaQuery.of(context).size.width * 0.2,
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings),
              iconSize: 35,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
            AnimatedContainer(

                duration: Duration(milliseconds: 1),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topCenter,
                height: initial?MediaQuery.of(context).size.height*0.38:containerHeight,
              // (scrollController.offset<=MediaQuery.of(context).size.height*0.38) ? MediaQuery.of(context).size.height*0.38-scrollController.offset : 0,
                //denemeTopContainer == 0 ?  MediaQuery.of(context).size.height*0.38 : denemeTopContainer == 1 ? MediaQuery.of(context).size.height*0.28 : denemeTopContainer == 2 ? MediaQuery.of(context).size.height*0.15 : 0,
                child: ProfileWidget(isMyPage)),
                
          (hidden?Divider(thickness: 2, color: textColor,):DividerWidget()),
          Expanded(child: isToDo ? (hidden ? hiddenWidget():ToDoWidget()) : (hidden ? hiddenWidget() : FriendWidget())),
          //hidden?Divider(thickness: 2, color: textColor,):DividerWidget(),
          //Expanded(child: isToDo ? (hidden ? hiddenWidget():ToDoWidget()) : (hidden ? hiddenWidget() : FriendWidget())),

        ],

      ),
    );
  }


  
  Widget hiddenWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.calendar_month_rounded),
        Text("You are not friends with ${user.username}.")
      ],
    );
  }

  //TODO bio karakter kısıtlaması getir

  Widget ProfileWidget(bool isMyPage) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height:
          MediaQuery.of(context).size.height * 0.38, //TODO boyutları kontrol et
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              child: Image.network(
                user.backgroundURL,
                height: MediaQuery.of(context).size.height * 0.21,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              //NetworkImage(user.backgroundURL); //height width
              //Image.asset("assets/images/img.png",height: MediaQuery.of(context).size.height*0.21, width: MediaQuery.of(context).size.width,fit: BoxFit.fill,),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.21 -
                MediaQuery.of(context).size.width * 0.158,
            left: (MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width * 0.316) *
                0.5,
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.ppURL), //TODO pp-bg hallet
              radius: MediaQuery.of(context).size.width *
                  0.158, //TODO make it dynamic
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.21,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                //TODO wrap with sized box
                children: [
                  Text(
                    '${user.name}',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.036,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                  Text(
                    '${user.surname}',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.036,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.21,
            right: 8.0,
            child: (isRequest!="")? Column(children: [
              ElevatedButton(
              onPressed: isClicked?(){}: () async {
                setState((){isClicked=true;});
                /// TODO arkadaşlık isteğini kabul et
                await SearchService().addFriend(user.userUID);
                UserModel me = UserModel.fromSnapshot(
                    await PostServices().getMyDoc());
                await PostServices()
                    .deleteFriendRequest(me, isRequest).then((value) {
                  setState((){isRequest="";
                  isMyFriend =true;
                  buttonText = "Remove Friend";
                  isClicked=false;});
                });
              },
              child: Text(
               "Accept",
                style: TextStyle(
                    color: negativeColor,
                    fontSize: MediaQuery.of(context).size.width * 0.028),
              ),
              style: ElevatedButton.styleFrom(
                primary: selectedColor,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                minimumSize: Size(100, 30),
              ),
            ),
              ElevatedButton(
              onPressed: isClicked?(){}: () async {
                setState((){isClicked=true;});
                /// TODO arkadaşlık isteğini reddet
                UserModel me = UserModel.fromSnapshot(
                    await PostServices().getMyDoc());
                await PostServices()
                    .deleteFriendRequest(me, isRequest).then((value) {
                  setState((){isRequest ="";
                  isClicked=true;});
                });
              },
              child: Text(
                "Reject",
                style: TextStyle(
                    color: selectedColor,
                    fontSize: MediaQuery.of(context).size.width * 0.028),
              ),
              style: ElevatedButton.styleFrom(
                primary: negativeColor,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                minimumSize: Size(100, 30),
              ),
            ),],):
            ElevatedButton(
              onPressed: isClicked?(){}: () async {
                if (isMyPage) {
                  print(1);
                  ///TODO editle profili
                  //UserModel userModel = UserModel.fromSnapshot(await FirebaseFirestore.instance.collection('users').doc(user.userUID).get()) as UserModel;
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditProfilePage(userModel: user))).then((value) {

                  });
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditProfilePage(userModel: user,)));
                } else if (!isMyFriend && pending) {
                  setState((){isClicked=true;});
                  print(2);

                  await SearchService().deleteRequest(user.userUID).then((value){
                    setState((){
                      hidden = true;
                      buttonText = "Add Friend";
                      pending = false;
                      isClicked =false;
                    });
                  });

                }
                else if (!isMyPage && isMyFriend) {
                  print(3);
                  setState((){isClicked=true;});
                  await SearchService()
                      .removeFriend(user.userUID)
                      .then((value) {
                    setState(() {
                      isMyFriend = !isMyFriend;
                      buttonText = "Add Friend";
                      pending = false; //gereksiz??
                      hidden = true;
                      isClicked = false;
                    });
                  });
                } else if (!isMyPage && !isMyFriend && !pending) {
                  print(4);
                  setState((){isClicked=true;});
                  await SearchService().sendRequest(user.userUID).then((value) {
                    setState(() {
                      buttonText = "Pending";
                      pending = true;
                      hidden = true;
                      isClicked = false;
                    });
                  });
                }
              },
              child: Text(
                isMyPage ? "Edit Profile" : buttonText,
                style: TextStyle(
                    color: negativeColor,
                    fontSize: MediaQuery.of(context).size.width * 0.028),
              ),
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
              top: MediaQuery.of(context).size.height * 0.23 +
                  MediaQuery.of(context).size.width * 0.158,
              left: 8.0,
              height: MediaQuery.of(context).size.height * 0.07,
              child: Text(
                user.bio,
                style: TextStyle(
                  color: textColor,
                ),
              )),
        ],
      ),
    );
  }

  Widget DividerWidget() {
    return SizedBox(
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
                  height: MediaQuery.of(context).size.height*0.05,
                  child: Center(
                      child: Text(
                    'ToDo List',
                    style: TextStyle(
                        color: isToDo ? selectedColor : negativeColor,
                        fontWeight:
                            isToDo ? FontWeight.bold : FontWeight.normal),
                  )),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: isToDo
                          ? BorderSide(width: 2.2, color: selectedColor)
                          : BorderSide(width: 1.5, color: negativeColor),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isToDo = false;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height*0.05,
                  child: Center(
                      child: Text(
                    'Friends',
                    style: TextStyle(
                        color: !isToDo ? selectedColor : negativeColor,
                        fontWeight:
                            !isToDo ? FontWeight.bold : FontWeight.normal),
                  )),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: !isToDo
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
    );
  }

  Widget ToDoWidget() {
    //String selectedPostID = user.lastPostID;
    return SingleChildScrollView(
      controller: scrollController,

      physics: ClampingScrollPhysics(),
      child: FutureBuilder(
        future: PostServices().getPosticipants(user.userUID),
        builder: (context, AsyncSnapshot snap) {
          if (!snap.hasData) {
            return CircularProgressIndicator();
          } else {
            return Column(
              children: [
                ListView.builder(

                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  itemCount: snap.data.length,
                  itemBuilder: (context, index) {
                    PosticipantModel posticipant = snap.data[index];
                    PostModel post = posticipant.post;
                    var partList = posticipant.participantList;
                    boolList.add(true);
                    //getActList(post.postUID);
                    //DenemeModel denemeModel = DenemeModel(userObj: user, activitiesList: actList[index], postObj: post);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: negativeColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              width: MediaQuery.of(context).size.width * 0.95,

                              /*TODO == yap   */
                              child: ExpansionTile(
                                //initiallyExpanded: post.postUID==user.lastPostID,
                                textColor: textColor,
                                title: boolList[index]
                                    ? ClosedPost(posticipant)
                                    : InfoWidget(post),
                                // leading: CircleAvatar(
                                //   backgroundImage: NetworkImage(user.ppURL),
                                //   radius: 20,
                                // ),
                                children: [
                                  SingleChildScrollView(
                                    physics: NeverScrollableScrollPhysics(),
                                    child: FutureBuilder(
                                      future: PostServices().getActPart(post),
                                      builder: (context, AsyncSnapshot snap) {
                                        if (!snap.hasData) {
                                          return CircularProgressIndicator();
                                        } else {
                                          return Column(
                                            children: [
                                              ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                physics: BouncingScrollPhysics(),
                                                itemCount: snap.data.length,
                                                itemBuilder: (context, index) {
                                                  PartivityModel partivity = snap.data[index];
                                                  ActivityModel activity = partivity.activity;
                                                  List<UserModel> participantList = partivity.participantList;
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0,
                                                            top: 8.0,
                                                            bottom: 8.0),
                                                    child: Center(
                                                        child: Column(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(activity
                                                                      .activityType),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(0.0),
                                                                        child: InkWell(
                                                                            child:
                                                                                Icon(Icons.watch_later_outlined)),
                                                                      ),
                                                                      Text(
                                                                          "${formatter.format(activity.time.toDate().hour)}:${formatter.format(activity.time.toDate().minute)}"),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Icon(Icons
                                                                        .location_on),
                                                                    Text(
                                                                        "${activity.location}"),
                                                                  ],
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    ParticipantPopUp(
                                                                        participantList);
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      if (activity
                                                                              .participants
                                                                              .length >=
                                                                          1)
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(left: 8.0),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                20,
                                                                            width:
                                                                                20,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.green,
                                                                              shape: BoxShape.circle,
                                                                              image: DecorationImage(
                                                                                fit: BoxFit.cover,
                                                                                image: NetworkImage(participantList[0].ppURL),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      if (activity
                                                                              .participants
                                                                              .length >=
                                                                          2)
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            left:
                                                                                4.0,
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Container(
                                                                                height: 20,
                                                                                width: 20,
                                                                                decoration: BoxDecoration(
                                                                                    color: Colors.green,
                                                                                    shape: BoxShape.circle,
                                                                                    image: DecorationImage(
                                                                                      fit: BoxFit.cover,
                                                                                      image: NetworkImage(participantList[1].ppURL),
                                                                                    )),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      if (activity
                                                                              .participants
                                                                              .length >
                                                                          2)
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(left: 8.0),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text("+${activity.participants.length - 2}"),
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
                                                                                    padding: const EdgeInsets.only(left: 2.0, right: 2),
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
                                                            Divider(
                                                              height: 3,
                                                              thickness: 1.50,
                                                            ),
                                                          ],
                                                        ),

                                                      ],
                                                    )),
                                                  );
                                                },
                                              ),
                                              Divider(
                                                height: 1,
                                                color: Colors.blue,
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets
                                                    .all(8.0),
                                                child: Container(
                                                  height: MediaQuery.of(
                                                      context)
                                                      .size
                                                      .height *
                                                      0.05,
                                                  width: MediaQuery.of(
                                                      context)
                                                      .size
                                                      .width *
                                                      0.9,
                                                  child:
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                    Axis.horizontal,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                              padding:
                                                              EdgeInsets.zero,
                                                              icon:
                                                              Text(
                                                                "${Emojis.redHeart}",
                                                                style:
                                                                TextStyle(fontSize: 15),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                ///postun reactionlarına bak şu anki kullanıcıdan reaksiyon varsa
                                                                ///aynısıysa geri al (reaksiyonu sil - database + postmodel)
                                                                ///farklıysa eskisini güncelle.
                                                                bool
                                                                check =
                                                                await PostServices().checkReaction(post);
                                                                if (!check) {
                                                                  ///reaksiyon yoksa yenisini oluştur.
                                                                  String
                                                                  reactionID =
                                                                  await PostServices().createReaction(user.userUID, post.postUID, ReactionModel.heart);
                                                                  post.reactionIDs.add(reactionID);
                                                                  post.heartCounter++;
                                                                  await PostServices().updatePost(post).then((value) {
                                                                    setState(() {});
                                                                  });
                                                                } else {
                                                                  /// reaksiyon var. reaksiyonu databaseden çek düzenle
                                                                  ReactionModel
                                                                  reaction =
                                                                  await PostServices().getReaction(post);
                                                                  if (reaction.type ==
                                                                      ReactionModel.heart) {
                                                                    /// aynısına tıklanmış her yerden
                                                                    /// (database + postun listesi + postun counterı)
                                                                    post.reactionIDs.remove(reaction.reactionUID);
                                                                    post.heartCounter--;
                                                                    await PostServices().deleteReaction(reaction.reactionUID);
                                                                    await PostServices().updatePost(post).then((value) {
                                                                      setState(() {});
                                                                    });
                                                                  } else {
                                                                    /// farklı reaksiyona tıklanmış güncelle
                                                                    String oldReactType = reaction.type;
                                                                    if (oldReactType == ReactionModel.angry)
                                                                      post.angryCounter--;
                                                                    else if (oldReactType == ReactionModel.brokenHeart)
                                                                      post.brokenHeartCounter--;
                                                                    else if (oldReactType == ReactionModel.joy)
                                                                      post.joyCounter--;
                                                                    else if (oldReactType == ReactionModel.sob)
                                                                      post.sobCounter--;
                                                                    reaction.type = ReactionModel.heart;
                                                                    post.heartCounter++;
                                                                    await PostServices().updateReaction(reaction);
                                                                    await PostServices().updatePost(post).then((value) {
                                                                      setState(() {});
                                                                    });
                                                                  }
                                                                }
                                                              },
                                                            ),
                                                            Text(
                                                                "${post.heartCounter}"),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                              padding:
                                                              EdgeInsets.zero,
                                                              icon:
                                                              Text(
                                                                "${Emojis.brokenHeart}",
                                                                style:
                                                                TextStyle(fontSize: 15),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                bool
                                                                check =
                                                                await PostServices().checkReaction(post);
                                                                if (!check) {
                                                                  ///reaksiyon yoksa yenisini oluştur.
                                                                  String
                                                                  reactionID =
                                                                  await PostServices().createReaction(user.userUID, post.postUID, ReactionModel.brokenHeart);
                                                                  post.reactionIDs.add(reactionID);
                                                                  post.brokenHeartCounter++;
                                                                  await PostServices().updatePost(post).then((value) {
                                                                    setState(() {});
                                                                  });
                                                                } else {
                                                                  ReactionModel
                                                                  reaction =
                                                                  await PostServices().getReaction(post);
                                                                  if (reaction.type ==
                                                                      ReactionModel.brokenHeart) {
                                                                    post.reactionIDs.remove(reaction.reactionUID);
                                                                    post.brokenHeartCounter--;
                                                                    await PostServices().deleteReaction(reaction.reactionUID);
                                                                    await PostServices().updatePost(post).then((value) {
                                                                      setState(() {});
                                                                    });
                                                                  } else {
                                                                    String oldReactType = reaction.type;
                                                                    if (oldReactType == ReactionModel.angry)
                                                                      post.angryCounter--;
                                                                    else if (oldReactType == ReactionModel.heart)
                                                                      post.heartCounter--;
                                                                    else if (oldReactType == ReactionModel.joy)
                                                                      post.joyCounter--;
                                                                    else if (oldReactType == ReactionModel.sob)
                                                                      post.sobCounter--;
                                                                    reaction.type = ReactionModel.brokenHeart;
                                                                    post.brokenHeartCounter++;
                                                                    await PostServices().updateReaction(reaction);
                                                                    await PostServices().updatePost(post).then((value) {
                                                                      setState(() {});
                                                                    });
                                                                  }
                                                                }
                                                              },
                                                            ),
                                                            Text(
                                                                "${post.brokenHeartCounter}"),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                              padding:
                                                              EdgeInsets.zero,
                                                              icon:
                                                              Text(
                                                                "${Emojis.rollingOnTheFloorLaughing}",
                                                                style:
                                                                TextStyle(fontSize: 15),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                bool
                                                                check =
                                                                await PostServices().checkReaction(post);
                                                                if (!check) {
                                                                  String
                                                                  reactionID =
                                                                  await PostServices().createReaction(user.userUID, post.postUID, ReactionModel.joy);
                                                                  post.reactionIDs.add(reactionID);
                                                                  post.joyCounter++;
                                                                  await PostServices().updatePost(post).then((value) {
                                                                    setState(() {});
                                                                  });
                                                                } else {
                                                                  ReactionModel
                                                                  reaction =
                                                                  await PostServices().getReaction(post);
                                                                  if (reaction.type ==
                                                                      ReactionModel.joy) {
                                                                    post.reactionIDs.remove(reaction.reactionUID);
                                                                    post.joyCounter--;
                                                                    await PostServices().deleteReaction(reaction.reactionUID);
                                                                    await PostServices().updatePost(post).then((value) {
                                                                      setState(() {});
                                                                    });
                                                                  } else {
                                                                    String oldReactType = reaction.type;
                                                                    if (oldReactType == ReactionModel.angry)
                                                                      post.angryCounter--;
                                                                    else if (oldReactType == ReactionModel.heart)
                                                                      post.heartCounter--;
                                                                    else if (oldReactType == ReactionModel.brokenHeart)
                                                                      post.brokenHeartCounter--;
                                                                    else if (oldReactType == ReactionModel.sob)
                                                                      post.sobCounter--;
                                                                    reaction.type = ReactionModel.joy;
                                                                    post.joyCounter++;
                                                                    await PostServices().updateReaction(reaction);
                                                                    await PostServices().updatePost(post).then((value) {
                                                                      setState(() {});
                                                                    });
                                                                  }
                                                                }
                                                              },
                                                            ),
                                                            Text(
                                                                "${post.joyCounter}"),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                              padding:
                                                              EdgeInsets.zero,
                                                              icon:
                                                              Text(
                                                                "${Emojis.sadButRelievedFace}",
                                                                style:
                                                                TextStyle(fontSize: 15),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                bool
                                                                check =
                                                                await PostServices().checkReaction(post);
                                                                if (!check) {
                                                                  String
                                                                  reactionID =
                                                                  await PostServices().createReaction(user.userUID, post.postUID, ReactionModel.sob);
                                                                  post.reactionIDs.add(reactionID);
                                                                  post.sobCounter++;
                                                                  await PostServices().updatePost(post).then((value) {
                                                                    setState(() {});
                                                                  });
                                                                } else {
                                                                  ReactionModel
                                                                  reaction =
                                                                  await PostServices().getReaction(post);
                                                                  if (reaction.type ==
                                                                      ReactionModel.sob) {
                                                                    post.reactionIDs.remove(reaction.reactionUID);
                                                                    post.sobCounter--;
                                                                    await PostServices().deleteReaction(reaction.reactionUID);
                                                                    await PostServices().updatePost(post).then((value) {
                                                                      setState(() {});
                                                                    });
                                                                  } else {
                                                                    String oldReactType = reaction.type;
                                                                    if (oldReactType == ReactionModel.angry)
                                                                      post.angryCounter--;
                                                                    else if (oldReactType == ReactionModel.heart)
                                                                      post.heartCounter--;
                                                                    else if (oldReactType == ReactionModel.brokenHeart)
                                                                      post.brokenHeartCounter--;
                                                                    else if (oldReactType == ReactionModel.joy)
                                                                      post.joyCounter--;
                                                                    reaction.type = ReactionModel.sob;
                                                                    post.sobCounter++;
                                                                    await PostServices().updateReaction(reaction);
                                                                    await PostServices().updatePost(post).then((value) {
                                                                      setState(() {});
                                                                    });
                                                                  }
                                                                }
                                                              },
                                                            ),
                                                            Text(
                                                                "${post.sobCounter}"),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                              padding:
                                                              EdgeInsets.zero,
                                                              icon:
                                                              Text(
                                                                "${Emojis.angryFace}",
                                                                style:
                                                                TextStyle(fontSize: 15),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                bool
                                                                check =
                                                                await PostServices().checkReaction(post);
                                                                if (!check) {
                                                                  String
                                                                  reactionID =
                                                                  await PostServices().createReaction(user.userUID, post.postUID, ReactionModel.angry);
                                                                  post.reactionIDs.add(reactionID);
                                                                  post.angryCounter++;
                                                                  await PostServices().updatePost(post).then((value) {
                                                                    setState(() {});
                                                                  });
                                                                } else {
                                                                  ReactionModel
                                                                  reaction =
                                                                  await PostServices().getReaction(post);
                                                                  if (reaction.type ==
                                                                      ReactionModel.angry) {
                                                                    post.reactionIDs.remove(reaction.reactionUID);
                                                                    post.angryCounter--;
                                                                    await PostServices().deleteReaction(reaction.reactionUID);
                                                                    await PostServices().updatePost(post).then((value) {
                                                                      setState(() {});
                                                                    });
                                                                  } else {
                                                                    String oldReactType = reaction.type;
                                                                    if (oldReactType == ReactionModel.sob)
                                                                      post.sobCounter--;
                                                                    else if (oldReactType == ReactionModel.heart)
                                                                      post.heartCounter--;
                                                                    else if (oldReactType == ReactionModel.brokenHeart)
                                                                      post.brokenHeartCounter--;
                                                                    else if (oldReactType == ReactionModel.joy)
                                                                      post.joyCounter--;
                                                                    reaction.type = ReactionModel.angry;
                                                                    post.angryCounter++;
                                                                    await PostServices().updateReaction(reaction);
                                                                    await PostServices().updatePost(post).then((value) {
                                                                      setState(() {});
                                                                    });
                                                                  }
                                                                }
                                                              },
                                                            ),
                                                            Text(
                                                                "${post.angryCounter}"),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                  )
                                ],
                                onExpansionChanged: (state) => setState(() {
                                  boolList[index] = !state;
                                }),
                              )
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
    );
  }

  Widget InfoWidget(post){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.calendar_month_outlined, size: 30, color: textColor,),
              Text("${formatter.format(post.date.toDate().day)}/${formatter.format(post.date.toDate().month)}/${post.date.toDate().year}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: textColor),),
            ],
          ),
          Divider(thickness: 2,color: textColor,)
        ],
      ),
    );
  }

  Widget FriendWidget() {
    return SingleChildScrollView(
      controller: scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      child: FutureBuilder(
        future: PostServices().getFriends(user.friends),
        builder: (context, AsyncSnapshot snap) {
          if (!snap.hasData) {
            return CircularProgressIndicator();
          } else {
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
                      child: Container(
                        decoration: BoxDecoration(
                            color: negativeColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  //TODO eğer kendi sayfama yönlendirmeye çalışıyosam !isMyPage gibi olmalı
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ProfilePage(
                                            user: friend,
                                          )));
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(friend.ppURL),
                                      radius:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                    ),
                                    SizedBox(
                                      width: 8, //TODO dynamiccc
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Text(
                                                "${friend.name} ${friend.surname}")),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Text("@${friend.username}"))
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
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget OpenPost(DenemeModel mod) {
    var mediaqueryHeight = MediaQuery.of(context).size.height * 0.06;
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
            child: Container(
              height: mod.activitiesList.length <= 2
                  ? MediaQuery.of(context).size.height * 0.33
                  : MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                  child: Column(
                children: [
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
                                    future: PostServices().getParticipants(
                                        mod.activitiesList[index]),
                                    builder: (context, AsyncSnapshot snap) {
                                      if (!snap.hasData) {
                                        return CircularProgressIndicator();
                                      } else {
                                        ActivityModel activity =
                                            mod.activitiesList[index];
                                        List<UserModel> participantList =
                                            snap.data;
                                        return Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(activity.activityType),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(0.0),
                                                        child: InkWell(
                                                            child: Icon(Icons
                                                                .watch_later_outlined)),
                                                      ),
                                                      Text(
                                                          "${formatter.format(activity.time.toDate().hour)}:${formatter.format(mod.activitiesList[index].time.toDate().minute)}"),
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
                                                    ParticipantPopUp(
                                                        participantList);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      if (activity.participants
                                                              .length >=
                                                          1)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0),
                                                          child: Container(
                                                            height: 20,
                                                            width: 20,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.green,
                                                              shape: BoxShape
                                                                  .circle,
                                                              image:
                                                                  DecorationImage(
                                                                image: NetworkImage(
                                                                    participantList[
                                                                            0]
                                                                        .ppURL),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      if (activity.participants
                                                              .length >=
                                                          2)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 4.0,
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                height: 20,
                                                                width: 20,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Colors
                                                                            .green,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              NetworkImage(participantList[1].ppURL),
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
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "+${activity.participants.length - 2}"),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    height: 5,
                                                                    width: 5,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .black,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            2.0,
                                                                        right:
                                                                            2),
                                                                    child:
                                                                        Container(
                                                                      height: 5,
                                                                      width: 5,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .black,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: 5,
                                                                    width: 5,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .black,
                                                                      shape: BoxShape
                                                                          .circle,
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
                                            Divider(
                                              height: 3,
                                              thickness: 1.50,
                                            ),
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
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Text(
                                    "${Emojis.redHeart}",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  onPressed: () async {
                                    ///postun reactionlarına bak şu anki kullanıcıdan reaksiyon varsa
                                    ///aynısıysa geri al (reaksiyonu sil - database + postmodel)
                                    ///farklıysa eskisini güncelle.
                                    bool check = await PostServices()
                                        .checkReaction(mod.postObj);
                                    if (!check) {
                                      ///reaksiyon yoksa yenisini oluştur.
                                      String reactionID = await PostServices()
                                          .createReaction(
                                              mod.userObj.userUID,
                                              mod.postObj.postUID,
                                              ReactionModel.heart);
                                      mod.postObj.reactionIDs.add(reactionID);
                                      mod.postObj.heartCounter++;
                                      await PostServices()
                                          .updatePost(mod.postObj)
                                          .then((value) {
                                        setState(() {});
                                      });
                                    } else {
                                      /// reaksiyon var. reaksiyonu databaseden çek düzenle
                                      ReactionModel reaction =
                                          await PostServices()
                                              .getReaction(mod.postObj);
                                      if (reaction.type ==
                                          ReactionModel.heart) {
                                        /// aynısına tıklanmış her yerden
                                        /// (database + postun listesi + postun counterı)
                                        mod.postObj.reactionIDs
                                            .remove(reaction.reactionUID);
                                        mod.postObj.heartCounter--;
                                        await PostServices().deleteReaction(
                                            reaction.reactionUID);
                                        await PostServices()
                                            .updatePost(mod.postObj)
                                            .then((value) {
                                          setState(() {});
                                        });
                                      } else {
                                        /// farklı reaksiyona tıklanmış güncelle
                                        String oldReactType = reaction.type;
                                        if (oldReactType == ReactionModel.angry)
                                          mod.postObj.angryCounter--;
                                        else if (oldReactType ==
                                            ReactionModel.brokenHeart)
                                          mod.postObj.brokenHeartCounter--;
                                        else if (oldReactType ==
                                            ReactionModel.joy)
                                          mod.postObj.joyCounter--;
                                        else if (oldReactType ==
                                            ReactionModel.sob)
                                          mod.postObj.sobCounter--;
                                        reaction.type = ReactionModel.heart;
                                        mod.postObj.heartCounter++;
                                        await PostServices()
                                            .updateReaction(reaction);
                                        await PostServices()
                                            .updatePost(mod.postObj)
                                            .then((value) {
                                          setState(() {});
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
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Text(
                                    "${Emojis.brokenHeart}",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  onPressed: () async {
                                    bool check = await PostServices()
                                        .checkReaction(mod.postObj);
                                    if (!check) {
                                      ///reaksiyon yoksa yenisini oluştur.
                                      String reactionID = await PostServices()
                                          .createReaction(
                                              mod.userObj.userUID,
                                              mod.postObj.postUID,
                                              ReactionModel.brokenHeart);
                                      mod.postObj.reactionIDs.add(reactionID);
                                      mod.postObj.brokenHeartCounter++;
                                      await PostServices()
                                          .updatePost(mod.postObj)
                                          .then((value) {
                                        setState(() {});
                                      });
                                    } else {
                                      ReactionModel reaction =
                                          await PostServices()
                                              .getReaction(mod.postObj);
                                      if (reaction.type ==
                                          ReactionModel.brokenHeart) {
                                        mod.postObj.reactionIDs
                                            .remove(reaction.reactionUID);
                                        mod.postObj.brokenHeartCounter--;
                                        await PostServices().deleteReaction(
                                            reaction.reactionUID);
                                        await PostServices()
                                            .updatePost(mod.postObj)
                                            .then((value) {
                                          setState(() {});
                                        });
                                      } else {
                                        String oldReactType = reaction.type;
                                        if (oldReactType == ReactionModel.angry)
                                          mod.postObj.angryCounter--;
                                        else if (oldReactType ==
                                            ReactionModel.heart)
                                          mod.postObj.heartCounter--;
                                        else if (oldReactType ==
                                            ReactionModel.joy)
                                          mod.postObj.joyCounter--;
                                        else if (oldReactType ==
                                            ReactionModel.sob)
                                          mod.postObj.sobCounter--;
                                        reaction.type =
                                            ReactionModel.brokenHeart;
                                        mod.postObj.brokenHeartCounter++;
                                        await PostServices()
                                            .updateReaction(reaction);
                                        await PostServices()
                                            .updatePost(mod.postObj)
                                            .then((value) {
                                          setState(() {});
                                        });
                                      }
                                    }
                                  },
                                ),
                                Text("${mod.postObj.brokenHeartCounter}"),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Text(
                                    "${Emojis.rollingOnTheFloorLaughing}",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  onPressed: () async {
                                    bool check = await PostServices()
                                        .checkReaction(mod.postObj);
                                    if (!check) {
                                      String reactionID = await PostServices()
                                          .createReaction(
                                              mod.userObj.userUID,
                                              mod.postObj.postUID,
                                              ReactionModel.joy);
                                      mod.postObj.reactionIDs.add(reactionID);
                                      mod.postObj.joyCounter++;
                                      await PostServices()
                                          .updatePost(mod.postObj)
                                          .then((value) {
                                        setState(() {});
                                      });
                                    } else {
                                      ReactionModel reaction =
                                          await PostServices()
                                              .getReaction(mod.postObj);
                                      if (reaction.type == ReactionModel.joy) {
                                        mod.postObj.reactionIDs
                                            .remove(reaction.reactionUID);
                                        mod.postObj.joyCounter--;
                                        await PostServices().deleteReaction(
                                            reaction.reactionUID);
                                        await PostServices()
                                            .updatePost(mod.postObj)
                                            .then((value) {
                                          setState(() {});
                                        });
                                      } else {
                                        String oldReactType = reaction.type;
                                        if (oldReactType == ReactionModel.angry)
                                          mod.postObj.angryCounter--;
                                        else if (oldReactType ==
                                            ReactionModel.heart)
                                          mod.postObj.heartCounter--;
                                        else if (oldReactType ==
                                            ReactionModel.brokenHeart)
                                          mod.postObj.brokenHeartCounter--;
                                        else if (oldReactType ==
                                            ReactionModel.sob)
                                          mod.postObj.sobCounter--;
                                        reaction.type = ReactionModel.joy;
                                        mod.postObj.joyCounter++;
                                        await PostServices()
                                            .updateReaction(reaction);
                                        await PostServices()
                                            .updatePost(mod.postObj)
                                            .then((value) {
                                          setState(() {});
                                        });
                                      }
                                    }
                                  },
                                ),
                                Text("${mod.postObj.joyCounter}"),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Text(
                                    "${Emojis.sadButRelievedFace}",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  onPressed: () async {
                                    bool check = await PostServices()
                                        .checkReaction(mod.postObj);
                                    if (!check) {
                                      String reactionID = await PostServices()
                                          .createReaction(
                                              mod.userObj.userUID,
                                              mod.postObj.postUID,
                                              ReactionModel.sob);
                                      mod.postObj.reactionIDs.add(reactionID);
                                      mod.postObj.sobCounter++;
                                      await PostServices()
                                          .updatePost(mod.postObj)
                                          .then((value) {
                                        setState(() {});
                                      });
                                    } else {
                                      ReactionModel reaction =
                                          await PostServices()
                                              .getReaction(mod.postObj);
                                      if (reaction.type == ReactionModel.sob) {
                                        mod.postObj.reactionIDs
                                            .remove(reaction.reactionUID);
                                        mod.postObj.sobCounter--;
                                        await PostServices().deleteReaction(
                                            reaction.reactionUID);
                                        await PostServices()
                                            .updatePost(mod.postObj)
                                            .then((value) {
                                          setState(() {});
                                        });
                                      } else {
                                        String oldReactType = reaction.type;
                                        if (oldReactType == ReactionModel.angry)
                                          mod.postObj.angryCounter--;
                                        else if (oldReactType ==
                                            ReactionModel.heart)
                                          mod.postObj.heartCounter--;
                                        else if (oldReactType ==
                                            ReactionModel.brokenHeart)
                                          mod.postObj.brokenHeartCounter--;
                                        else if (oldReactType ==
                                            ReactionModel.joy)
                                          mod.postObj.joyCounter--;
                                        reaction.type = ReactionModel.sob;
                                        mod.postObj.sobCounter++;
                                        await PostServices()
                                            .updateReaction(reaction);
                                        await PostServices()
                                            .updatePost(mod.postObj)
                                            .then((value) {
                                          setState(() {});
                                        });
                                      }
                                    }
                                  },
                                ),
                                Text("${mod.postObj.sobCounter}"),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Text(
                                    "${Emojis.angryFace}",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  onPressed: () async {
                                    bool check = await PostServices()
                                        .checkReaction(mod.postObj);
                                    if (!check) {
                                      String reactionID = await PostServices()
                                          .createReaction(
                                              mod.userObj.userUID,
                                              mod.postObj.postUID,
                                              ReactionModel.angry);
                                      mod.postObj.reactionIDs.add(reactionID);
                                      mod.postObj.angryCounter++;
                                      await PostServices()
                                          .updatePost(mod.postObj)
                                          .then((value) {
                                        setState(() {});
                                      });
                                    } else {
                                      ReactionModel reaction =
                                          await PostServices()
                                              .getReaction(mod.postObj);
                                      if (reaction.type ==
                                          ReactionModel.angry) {
                                        mod.postObj.reactionIDs
                                            .remove(reaction.reactionUID);
                                        mod.postObj.angryCounter--;
                                        await PostServices().deleteReaction(
                                            reaction.reactionUID);
                                        await PostServices()
                                            .updatePost(mod.postObj)
                                            .then((value) {
                                          setState(() {});
                                        });
                                      } else {
                                        String oldReactType = reaction.type;
                                        if (oldReactType == ReactionModel.sob)
                                          mod.postObj.sobCounter--;
                                        else if (oldReactType ==
                                            ReactionModel.heart)
                                          mod.postObj.heartCounter--;
                                        else if (oldReactType ==
                                            ReactionModel.brokenHeart)
                                          mod.postObj.brokenHeartCounter--;
                                        else if (oldReactType ==
                                            ReactionModel.joy)
                                          mod.postObj.joyCounter--;
                                        reaction.type = ReactionModel.angry;
                                        mod.postObj.angryCounter++;
                                        await PostServices()
                                            .updateReaction(reaction);
                                        await PostServices()
                                            .updatePost(mod.postObj)
                                            .then((value) {
                                          setState(() {});
                                        });
                                      }
                                    }
                                  },
                                ),
                                Text("${mod.postObj.angryCounter}"),
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

  Widget ClosedPost(PosticipantModel posticipant) {
    PostModel post = posticipant.post;
    List<UserModel> participants = posticipant.participantList;
    var postDate = post.date.toDate();
    int day = postDate.day;
    var month = postDate.month;
    var year = postDate.year;


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.calendar_today,
            color: textColor, size: MediaQuery.of(context).size.width * 0.08),
        Text(
          "${formatter.format(day)}/${formatter.format(month)}/${year}",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.045,
          ),
        ),
        InkWell(
          onTap: () {
            ParticipantPopUp(
                participants);
          },
          child: Row(
            children: [
              if (participants
                  .length >=
                  1)
                Padding(
                  padding:
                  const EdgeInsets
                      .only(
                      left: 8.0),
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration:
                    BoxDecoration(
                      color:
                      Colors.green,
                      shape: BoxShape
                          .circle,
                      image:
                      DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            participants[
                            0]
                                .ppURL),
                      ),
                    ),
                  ),
                ),
              if (participants
                  .length >=
                  2)
                Padding(
                  padding:
                  const EdgeInsets
                      .only(
                    left: 4.0,
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration:
                        BoxDecoration(
                            color: Colors
                                .green,
                            shape: BoxShape
                                .circle,
                            image:
                            DecorationImage(
                              fit: BoxFit.cover,
                              image:
                              NetworkImage(
                                  participants[1].ppURL),
                            )),
                      ),
                    ],
                  ),
                ),
              if (participants
                  .length >
                  2)
                Padding(
                  padding:
                  const EdgeInsets
                      .only(
                      left: 8.0),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                          "+${participants.length - 2}"),
                      Row(
                        children: [
                          Container(
                            height: 5,
                            width: 5,
                            decoration:
                            BoxDecoration(
                              color: Colors
                                  .black,
                              shape: BoxShape
                                  .circle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets
                                .only(
                                left:
                                2.0,
                                right:
                                2),
                            child:
                            Container(
                              height: 5,
                              width: 5,
                              decoration:
                              BoxDecoration(
                                color: Colors
                                    .black,
                                shape: BoxShape
                                    .circle,
                              ),
                            ),
                          ),
                          Container(
                            height: 5,
                            width: 5,
                            decoration:
                            BoxDecoration(
                              color: Colors
                                  .black,
                              shape: BoxShape
                                  .circle,
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
    );
  }

  void scrollUp() {
    final double start = 0;
    controller.jumpTo(start);
  }
  Future<void> func()async{
  setState(() {

  });
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
                        separatorBuilder: (context, index) => Divider(
                          thickness: 10,
                        ),
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
                                            fit: BoxFit.cover,
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
