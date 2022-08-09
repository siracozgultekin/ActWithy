import 'package:actwithy/Models/PostModel.dart';
import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/pages/creatingPage.dart';
import 'package:actwithy/pages/editProfilePage.dart';
import 'package:actwithy/pages/homePage.dart';
import 'package:actwithy/pages/searchPage.dart';
import 'package:actwithy/services/postServices.dart';
import 'package:actwithy/services/searchService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;
  ProfilePage({required this.user});
  @override
  State<ProfilePage> createState() => _ProfilePageState(user);
}


class _ProfilePageState extends State<ProfilePage> {

  UserModel user;
  _ProfilePageState(this.user);

  bool isToDo = true;
  bool isMyFriend = false;
  String buttonText = "";
  final controller = ScrollController();

  bool additional = true;

  getIsMyFriend() async {
    bool result = await SearchService().isMyFriend(user.userUID);
    setState(() {
      isMyFriend = result;
      if (isMyFriend) {
        buttonText = "Remove Friend";
      }else buttonText = "Add Friend";
    });
  }

  initState()  {
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage()));
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
                Text('@${user.username}', style: TextStyle(fontSize: 15),),
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
        leadingWidth: MediaQuery.of(context).size.width * 0.4,
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
          isToDo ? ToDoWidget() : FriendWidget(),
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
              Image.network(user.backgroundURL, height: MediaQuery.of(context).size.height*0.21, width: MediaQuery.of(context).size.width,fit: BoxFit.fill,),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfilePage(userModel: user))).then((value) {setState((){});});
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditProfilePage(userModel: user,)));
                }else if (!isMyPage && isMyFriend) {
                  await SearchService().removeFriend(user.userUID);
                }else if (!isMyPage && !isMyFriend) {
                  await SearchService().addFriend(user.userUID);
                }

                setState((){
                  isMyFriend = !isMyFriend;
                });

                setState(() {
                  if(!isMyFriend) {
                    buttonText = "Add Friend";
                  }else if (isMyFriend){
                    buttonText = "Remove Friend";
                  }
                });
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
                    physics: ClampingScrollPhysics(),
                    itemCount: snap.data.length,
                    itemBuilder: (context, index) {
                      PostModel post = snap.data[index] as PostModel;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            InkWell(
                              onTap : (){
                                selectedPostID = post.postUID;
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
                                /*TODO == yap   */                        child: selectedPostID!=post.postUID ?
                              OpenPost(post) : ClosedPost(post),
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

  Widget OpenPost(PostModel post) {
    var postDate = post.date.toDate();
    var day = postDate.day;
    var month = postDate.month;
    var year = postDate.year;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.ppURL),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("@${user.username}",style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor
                                ),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("${user.name} ${user.surname}", style: TextStyle(
                                    color: textColor
                                ),),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Text("${formatter.format(day)}/${formatter.format(month)}/${year}",style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width*0.04,
                  ),),
                ],
              ),
              Column(
                //TODO get activities of the post
                children: [

                ],
              ),
            ],
          ),
        ),
      ],
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


}



