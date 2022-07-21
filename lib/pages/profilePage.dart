import 'package:actwithy/Models/PostModel.dart';
import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/services/postServices.dart';
import 'package:actwithy/services/searchService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {

    bool isMyPage = user.userUID==FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: bgColor,
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
        leading: isMyPage ?Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('@${user.username}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            Text('${user.postCount} Posts', style: TextStyle(fontSize: 15),),
          ],
        ): BackButton(
          color: negativeColor,
        ),
        leadingWidth: MediaQuery.of(context).size.width * 0.2,
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
              child: Column(
                children: [
                  Text('${user.name}', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold, color: textColor),),
                  Text('${user.surname}', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold, color: textColor),),
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
              child: Text(isMyPage? "Edit Profile":buttonText,style: TextStyle(color: negativeColor),),
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
    return

      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: FutureBuilder(
            future: PostServices().getMyPosts(),
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
                        return Column(
                          children: [
                            Container(
                              height: 65,
                              width: 200,
                              color: Colors.white38,
                              child: Text(post.postUID),
                            )
                          ],
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
                      return Column(
                        children: [
                          Container(
                            height: 65,
                            width: 200,
                            color: Colors.white38,
                            child: Text(friend.userUID),
                          )
                        ],
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


}


