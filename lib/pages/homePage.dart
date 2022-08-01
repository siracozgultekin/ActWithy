import 'package:actwithy/Models/ActivityModel.dart';
import 'package:actwithy/Models/PostModel.dart';
import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/pages/creatingPage.dart';
import 'package:actwithy/pages/drawerPage.dart';
import 'package:actwithy/pages/searchPage.dart';
import 'package:actwithy/services/authService.dart';
import 'package:actwithy/services/postServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final controller = ScrollController();
  late UserModel user;
  bool isLoading = true;
  @override
  void initState() {
    getMe();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: isLoading
          ? CircularProgressIndicator(
        backgroundColor: Color(0xFF15202B),
      )
          : DrawerPage(
        userProf: user,
      ),
 appBar: AppBar(
   leading:  Builder(
     builder: (context) => InkWell(
       splashColor: Colors.transparent,
       highlightColor: Colors.transparent,
       borderRadius: BorderRadius.circular(15),
       onTap: () {
         Scaffold.of(context).openDrawer();
       },
       child: isLoading
           ? Container()
           : Padding(
         padding: const EdgeInsets.all(8.0),
         child: Container(
           height: 20,
           width: 20,
           decoration: user.ppURL == 'ppURL'
               ? BoxDecoration(
             shape: BoxShape.circle,
             color: Colors.grey,
           )
               : BoxDecoration(
               shape: BoxShape.circle,
               image: DecorationImage(
                 fit: BoxFit.fill,
                 image: NetworkImage(user.ppURL),
               )),
         ),
       ),
     ), /*MaterialButton(
              child: Image.asset('assets/images/pp.jpg'),
              onPressed: () {Scaffold.of(context).openDrawer();}
            ),*/
   ),
   centerTitle: true,
   title: Container(
     height: 60,width: 60,
     decoration: BoxDecoration(
       shape: BoxShape.circle,
       image: DecorationImage(image: AssetImage("assets/images/mavibg.png"),),
     ),
   ),

   actions: [
     Row(
       children: [
         IconButton(
             onPressed: () async {
                bool check = await PostServices().checkDailyPost();
                PostModel postModel;

                if (!check){

                      postModel = PostModel(postUID: "postUID", date: Timestamp.now(), activityUID: [], heartCounter: 0, brokenHeartCounter: 0, joyCounter: 0, sobCounter: 0, angryCounter: 0);
                }else{ //oluşturulmuş demek
                 postModel= await PostServices().getDailyPost();

                }

               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CreatingPage( postModel: postModel,)));

             },
             icon: Icon(Icons.warning)),
         Padding(
           padding: const EdgeInsets.only(right: 8.0),
           child: Text("3",style: TextStyle(fontSize: 20),),
         ),
       ],
     ),
   ],
 ),
    body:  FutureBuilder(
        future: PostServices().getFriendsPosts(),
        builder: (context, AsyncSnapshot snap) {
          if (!snap.hasData) {
            return CircularProgressIndicator();
          } else {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView.separated(
                  controller: controller,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey,
                    height: 0.25,
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: snap.data.length ,   //TODO snap.data.length,
                  itemBuilder: (context, index) {
                   DenemeModel postModelObj = snap.data[index] as DenemeModel;
                    return mainListTile(postModelObj);
                  }),
            );
          }
        }),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: MediaQuery.of(context).size.height * 0.075,
          indicatorColor: Colors.transparent,
          backgroundColor: Color(0xFF9AC6C5),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) {
            setState(() async{
              selectedIndex = value;
              if (selectedIndex == 0) {
                scrollUp();
              } else if (selectedIndex == 1) {
                showSearch(
                    context: context,
                    delegate: SearchPage(
                        hintText: "Search",
                        hintTextColor: TextStyle(color: Colors.white)));
              } else if (selectedIndex == 2) {
                bool check = await PostServices().checkDailyPost();
                PostModel postModel;

                if (!check){
                  postModel = PostModel(postUID: "postUID", date: Timestamp.now(), activityUID: [], heartCounter: 0, brokenHeartCounter: 0, joyCounter: 0, sobCounter: 0, angryCounter: 0);
                }else{ //oluşturulmuş demek
                  postModel= await PostServices().getDailyPost();

                }

                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CreatingPage(postModel: postModel)));
              } else if (selectedIndex == 3) {
<<<<<<< Updated upstream

              }else if (selectedIndex == 4) {

=======
              } else if (selectedIndex == 4) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfilePage(user: user)));
>>>>>>> Stashed changes
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

    );
  }
  void scrollUp() {
    final double start = 0;
    controller.jumpTo(start);
  }
  getMe() async {
    UserModel us = UserModel.fromSnapshot(await PostServices().getMyDoc());
    print("snapshotugeçti");
    setState(() {
      user = us;
      isLoading = false;
    });
  }
  Widget mainListTile(DenemeModel mod){
    return Container(height: 10,color: Colors.brown, child: Center(child: Text(mod.model!.username)),);
  }
}
