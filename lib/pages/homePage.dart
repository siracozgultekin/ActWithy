import 'package:actwithy/pages/creatingPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
 appBar: AppBar(
   actions: [
     IconButton(
         onPressed: (){
           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CreatingPage()));

         },
         icon: Icon(Icons.add)),
   ],
 ),
    );
  }
}
