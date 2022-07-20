import 'package:actwithy/Models/UserModel.dart';
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

  @override
  Widget build(BuildContext context) {

    bool isMyPage = user.userUID==FirebaseAuth.instance.currentUser!.uid;


    return Scaffold(
      backgroundColor: Color(0xFFD6E6F1),
      appBar: AppBar(
        backgroundColor: Color(0xFF48B2FA),
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
          color: Colors.white,
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

      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.21+65,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                child: Image.asset("assets/images/img.png",height: MediaQuery.of(context).size.height*0.21, width: MediaQuery.of(context).size.width,fit: BoxFit.fill,),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*0.21-65,
              left: (MediaQuery.of(context).size.width-130)*0.5,
              child: CircleAvatar(
                backgroundImage: NetworkImage("https://w7.pngwing.com/pngs/78/788/png-transparent-computer-icons-avatar-business-computer-software-user-avatar-child-face-hand-thumbnail.png"),
                radius: 65,                              //TODO make it dynamic
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).size.height*0.21,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('${user.name}', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      Text('${user.surname}', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
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
                child: Text(isMyPage? "Edit Profile":buttonText,style: TextStyle(color: Color(0xFFFFFFFF)),),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF4C6170),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  minimumSize: Size(100, 30),
                ),
              ),
            )
          ],
        ),
      ),

    );
  }



}


