import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,elevation: 0,),
      body: Column(
        children: [
          Text("Hello There!",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Color(0xFF4C6170)),),
          Container(
            height: MediaQuery.of(context).size.height*0.5,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/welcome2.png",
                  ),
                )),
          ),
          Text("Welcome to ActWithy",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Color(0xFF4C6170)),),
          ElevatedButton(
            onPressed: (){},
            child: Text("Login",style: TextStyle(color: Color(0xFF4C6170)),),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF9AC6C5),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              minimumSize: Size(200,35),

            ),),
          ElevatedButton(
              onPressed: (){},
              child: Text("Sign Up",style: TextStyle(color: Color(0xFF9AC6C5)),),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF4C6170),
              shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
    ),
    minimumSize: Size(200,35),

    ),),
        ],
      ),
    );
  }
}
