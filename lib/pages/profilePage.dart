import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  //final String uid;
  //ProfilePage({required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState(/*uid*/);
}

class _ProfilePageState extends State<ProfilePage> {
  //String uid;
  //_ProfilePageState(this.uid);

  bool isToDo = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD6E6F1),
      appBar: AppBar(
        backgroundColor: Color(0xFF48B2FA),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.checklist_rtl_outlined)
          ],
        ),
        automaticallyImplyLeading: false,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('@bedirbebedir', style: TextStyle(fontSize: 15),),
            Text('57 Lists', style: TextStyle(fontSize: 15),),
          ],
        ),
        leadingWidth: MediaQuery.of(context).size.width * 0.4,
        actions: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
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
                      Text('@bedirbebedir', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      Text('57 Lists', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*0.21,
              right: 8.0,
              child: ElevatedButton(
                onPressed: (){
                },
                child: Text("Edit Profile",style: TextStyle(color: Color(0xFFFFFFFF)),),
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


