
import 'package:flutter/material.dart';

class CreatingPage extends StatefulWidget {
  const CreatingPage({Key? key}) : super(key: key);

  @override
  State<CreatingPage> createState() => _CreatingPageState();
}

class _CreatingPageState extends State<CreatingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
        backgroundColor: Color(0XFF48B2FA),
        title: Text("New ToDo",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),
      ),
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                 width: MediaQuery.of(context).size.width*0.9,
                  height: MediaQuery.of(context).size.height*0.4,
                decoration: BoxDecoration(
                    color: Color(0XFFD6E6F1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: 6,
                          itemBuilder: (context,index){
                            return  Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("İşe gidiyor"),
                                            Row(children: [Container(
                                              padding:  EdgeInsets.all(0.0),
                                              child: InkWell(child: Icon(Icons.watch_later_outlined)),),
                                              Text("09.30"),],)
                                          ],
                                        ),
                                      ), // activity and clock
                                      Row(
                                        children: [
                                          Container(
                                            padding:  EdgeInsets.only(left: 10),
                                            child: InkWell(child: Icon(Icons.close)),),
                                          Container(
                                            padding:  EdgeInsets.all(0.0),
                                            child: InkWell(child: Icon(Icons.edit)),),
                                        ],
                                      ), // delete and edit icons
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.location_on),
                                        Text("Hacettepe Teknokent"),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:8.0,right: 8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 20,width: 20,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,

                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("+2 kişi"),
                                        Row(
                                          children: [
                                            Container(
                                              height: 5,width: 5,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                shape: BoxShape.circle,
                                              ),
                                            ),Padding(
                                              padding: const EdgeInsets.only(left: 2.0,right: 2),
                                              child: Container(

                                                height: 5,width: 5,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),Container(
                                              height: 5,width: 5,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );})
                      // bunu return döndür.
                    ],
                  ),
                ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
