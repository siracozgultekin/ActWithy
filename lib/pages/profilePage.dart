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

      body: Column(

        children: [
          Container(
            child: Image.asset("assets/images/img.png",height: MediaQuery.of(context).size.height*0.21, width: MediaQuery.of(context).size.width,fit: BoxFit.fill,),
          ),
          CircleAvatar(
          ),
        ],
      ),

    );
  }
}


