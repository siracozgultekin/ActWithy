import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/pages/homePage.dart';
import 'package:actwithy/pages/profilePage.dart';
import 'package:actwithy/services/authService.dart';
import 'package:flutter/material.dart';



class DrawerPage extends StatefulWidget {
  UserModel userProf;
  DrawerPage({required this.userProf});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}


class _DrawerPageState extends State<DrawerPage> {

  var page = HomePage();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFF4C6170),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 170,
            color: Color(0xFF4C6170),
            child: Padding(
              padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(
                                    user: widget.userProf,
                                  )),

                          );
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: widget.userProf.ppURL == 'ppURL'
                              ? BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey
                          )
                              : BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(widget.userProf.ppURL),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 8),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Text(
                                      "${widget.userProf.name}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Text(
                                    "@${widget.userProf.username}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold

                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 2.0),
                                        child: Text(
                                          "${widget.userProf.friends.length}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Text(
                                        "Friends",
                                        style: TextStyle(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 2.0, left: 10),
                                        child: Text(
                                          "${widget.userProf.postCount}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Text(
                                        "Posts",
                                        style: TextStyle(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey[600],
            height: 0.05,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: [
                  ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ClampingScrollPhysics(),
                    children: <Widget>[
                      Container(height: 330,),
                      Divider(
                        color: Colors.grey,
                        height: 0.5,
                        thickness: 0.2,
                      ),
                      InkWell(
                        onTap: () async {
                          await AuthService().signOut(context);
                        },
                        child: ListTile(
                          title: Row(
                            children: [
                              Icon(Icons.logout),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Log Out',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listTile(Icon icon, String text, var page) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => page));
      },
      child: ListTile(
        leading: icon,
        title: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

