import 'package:actwithy/Models/ActivityModel.dart';
import 'package:actwithy/Models/PostModel.dart';
import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/pages/editParticipantSearchPage.dart';
import 'package:actwithy/pages/participantSearchPage.dart';
import 'package:actwithy/pages/profilePage.dart';
import 'package:actwithy/services/postServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreatingPage extends StatefulWidget {
  PostModel postModel;
  CreatingPage({required this.postModel});
  static List<UserModel> participants = [];
  @override
  State<CreatingPage> createState() => _CreatingPageState();
}

class _CreatingPageState extends State<CreatingPage> {
  final controller = ScrollController();
  TextEditingController locationKey = TextEditingController();
  TextEditingController activityKey = TextEditingController();
  final searchController = TextEditingController();
  List<String> items = [
    'Seçiniz...',
    'gidecek',
    'yapacak',
    'çalışacak',
    'yiyecek','içecek','izleyecek','buluşacak','ağlayacak','girecek','uyuyacak','oynayacak'
  ];
  String? selectedItem = 'Seçiniz...';

  TimeOfDay time = TimeOfDay(hour: 12, minute: 30);
  String date = DateTime.now().toString().substring(0, 10);
  List<String> matchQuery = [];
  @override
  int newLength = 0, length = 0;

  List<ActivityModel> activities = [];

  initState() {
    length = widget.postModel.activityUID.length;
    CreatingPage.participants = CreatingPage.participants;
    super.initState();
  }

  Widget build(BuildContext context) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    String hoursANDminutes = '$hours:$minutes';
    DateTime times = DateTime.parse('${date}T$hours:$minutes');
    Timestamp myTimeStamp = Timestamp.fromDate(times);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Color(0XFF48B2FA),
          title: Text(
            "New ToDo",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                children: [
                  Text(
                    "Create",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    thickness: 0.8,
                    color: Colors.black,
                    indent: MediaQuery.of(context).size.width * 0.4,
                    endIndent: MediaQuery.of(context).size.width * 0.4,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: BoxDecoration(
                        color: Color(0XFFD6E6F1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        child: Text(
                                          "Activity Type:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: SizedBox(
                                          height: 20,
                                          width: MediaQuery.of(context).size.width *
                                              0.27,
                                          child: TextFormField(
                                            controller: activityKey,
                                          )),
                                    ),
                                    SizedBox(
                                        width: MediaQuery.of(context).size.width *
                                            0.3,
                                        child: Center(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: selectedItem,
                                            items: items
                                                .map((item) => DropdownMenuItem(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                     /* style: TextStyle(
                                                          fontSize: 15),*/
                                                    )))
                                                .toList(),
                                            onChanged: (item) => setState(
                                                () => selectedItem = item),
                                          ),
                                        )),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: Text(
                                            "Time:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${hours}:${minutes}',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                TimeOfDay? newTime =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime: time,
                                                );
                                                if (newTime == null) {
                                                  return;
                                                }
                                                ;
                                                setState(() => time = newTime);
                                              },
                                              icon: Icon(Icons.expand_more),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: Text(
                                          "Location:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    SizedBox(
                                        height: 20,
                                        width: 200,
                                        child: TextFormField(
                                          controller: locationKey,
                                        )),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Participants",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.only(left: 8),
                                          constraints: BoxConstraints(),
                                          onPressed: () {
                                            showSearch(
                                                    context: context,
                                                    delegate:
                                                        ParticipantSearchPage())
                                                .then((value) {
                                              setState(() {});
                                            });
                                            //setState((){CreatingPage.participants = CreatingPage.participants;});
                                          },
                                          icon: Icon(
                                              Icons.person_add_alt_1_outlined)),
                                    ],
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  constraints: BoxConstraints(
                                    minHeight:
                                        MediaQuery.of(context).size.height *
                                            0.1,
                                    // maxHeight:
                                    //     MediaQuery.of(context).size.height *
                                    //         0.4,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color(0XFFD6E6F1),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            CreatingPage.participants.length,
                                        //itemCount: ActivityModel().participants.length,
                                        itemBuilder: (context, index) => Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          15, 10, 15, 0),
                                                  child: InkWell(
                                                    onTap: (){
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(user: CreatingPage
                                                          .participants[
                                                      index])));
                                                    },
                                                    child: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.07,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: Colors.white),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.05,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.05,
                                                              decoration: CreatingPage
                                                                          .participants[
                                                                              index]
                                                                          .ppURL ==
                                                                      'ppURL'
                                                                  ? BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                          .grey)
                                                                  : BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      image:
                                                                          DecorationImage(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        image: NetworkImage(
                                                                            '${CreatingPage.participants[index].ppURL}'),
                                                                      ),
                                                                    ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                    alignment:
                                                                        AlignmentDirectional
                                                                            .centerStart,
                                                                    child: Text(
                                                                      CreatingPage
                                                                          .participants[
                                                                              index]
                                                                          .name,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          color: Colors
                                                                              .black),
                                                                    )),
                                                                Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8.0),
                                                                    child:
                                                                        InkWell(
                                                                      onTap: () {
                                                                        ParticipantSearchPage
                                                                            .participants
                                                                            .remove(CreatingPage
                                                                                .participants[index]
                                                                                .userUID);
                                                                        setState(
                                                                            () {
                                                                          CreatingPage
                                                                              .participants
                                                                              .removeAt(index);
                                                                        });
                                                                      },
                                                                      child: Text(
                                                                        "Remove",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .red,
                                                                            fontWeight:
                                                                                FontWeight.w700),
                                                                      ),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 2, top: 2, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedItem = 'Seçiniz...';
                              locationKey.text = "";
                              time = TimeOfDay(hour: 12, minute: 30);
                              CreatingPage.participants = [];
                              ParticipantSearchPage.participants = [];
                            });
                          },
                          child: Text(
                            "Clear",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 20),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            //ActivityModel activityObj= ActivityModel(activityType:selectedItem!, time:hoursANDminutes, location:locationKey.text,);
                            //TODO bir tane activity varsa önce post oluştur.
                            String ActId = await PostServices().createActivity(
                                activityKey.text + ' ' +selectedItem!,
                                myTimeStamp,
                                locationKey.text,
                                ParticipantSearchPage().getParticipants());
                            //print("participantss ${ParticipantSearchPage.participants}");

                            if (widget.postModel.postUID == "postUID") {
                              //TODO Databasede yeni post oluşturmamız gerekiyor.
                              widget.postModel =
                                  await PostServices().createPost();
                            }

                            widget.postModel.activityUID.add(ActId);
                            await PostServices().updatePost(widget.postModel);
                            print("activity: ${widget.postModel.activityUID}");
                            setState(() {
                              length = newLength;
                              CreatingPage.participants = [];
                              selectedItem = 'Seçiniz...';
                              locationKey.text = "";
                              time = TimeOfDay(hour: 12, minute: 30);
                              activityKey.text = '';
                            });
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[600]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.035,
            ),
            Column(
              children: [
                Text(
                  "Edit",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.black,
                  indent: MediaQuery.of(context).size.width * 0.4,
                  endIndent: MediaQuery.of(context).size.width * 0.4,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.33,
                  decoration: BoxDecoration(
                      color: Color(0XFFD6E6F1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: FutureBuilder(
                      future: PostServices()
                          .getDailyActivities(), //Last post of current user
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
                              itemCount: snap.data.length,
                              itemBuilder: (context, index) {
                                newLength = snap.data.length;
                                //PostModel myLastpostObj = snap.data as PostModel;
                                //print("KONTROL EDİLEN YER: ${myLastpostObj.activityUID}");
                                List<ActivityModel> activityList = [];
                                for (var activity in snap.data) {
                                  //List<ActivityModel> activityL = uid;
                                  activityList.add(activity);
                                }

                                return ListViewTile(activityList[index]);
                              },
                            ),
                          );
                        }
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ParticipantPopUp(List<UserModel> participantList) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.only(left: 10, right: 10),
              title: Center(
                  child: Text(
                "Participants",
                style: TextStyle(fontSize: 25, color: Color(0xFF2D3A43)),
              )),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.7,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
                        itemCount: participantList.length,
                        itemBuilder: (context, index) {
                          UserModel user = participantList[index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage(
                                              user: user,
                                            )));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0XFFD6E6F1),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(user.ppURL),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 5, 0),
                                                child: Text(
                                                  user.username,
                                                  style: TextStyle(
                                                      color: Color(0xFF2D3A43),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 5, 0),
                                                child: Text(
                                                  "${user.name} ${user.surname}",
                                                  style: TextStyle(
                                                      color: Color(0xFF4C6170),
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Ok",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF2D3A43),
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ],
            ));
  }

  Widget ListViewTile(ActivityModel activityObj) {
    return FutureBuilder(
        future: PostServices()
            .getParticipants(activityObj), //Last post of current user
        builder: (context, AsyncSnapshot snap) {
          if (!snap.hasData) {
            return CircularProgressIndicator();
          } else {
            List<UserModel> participantList = snap.data;
            print("participant sayısı: ${activityObj.participants.length}");
            return Column(
              children: [
                Container(
                  //height: MediaQuery.of(context).size.height*0.13,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${activityObj.activityType}"),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(0.0),
                                        child: InkWell(
                                            child: Icon(
                                                Icons.watch_later_outlined)),
                                      ),
                                      Text(
                                          "${activityObj.time.toDate().hour}:${activityObj.time.toDate().minute}"),
                                    ],
                                  )
                                ],
                              ),
                            ), // activity and clock
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: InkWell(
                                      onTap: () async{
                                        widget.postModel.activityUID.remove(activityObj.activityUID);
                                        await PostServices().updatePost(widget.postModel).then((value) {
                                          setState(() {});
                                        });
                                      }, child: Icon(Icons.close)),
                                ),
                                Container(
                                  padding: EdgeInsets.all(0.0),
                                  child: InkWell(
                                    child: Icon(Icons.edit),
                                    onTap: () async {
                                      EditingPopUp(activityObj).then((value) {
                                        setState(() {});
                                      });
                                      participantList = await PostServices()
                                          .getParticipants(activityObj);
                                      setState(() {});
                                    },
                                  ),
                                ),
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
                              Text("${activityObj.location}"),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              ParticipantPopUp(participantList);
                            },
                            child: Row(
                              children: [
                                if (activityObj.participants.length >= 1)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              participantList[0].ppURL),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (activityObj.participants.length >= 2)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 4.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    participantList[1].ppURL),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (activityObj.participants.length > 2)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "+${activityObj.participants.length - 2}"),
                                        Row(
                                          children: [
                                            Container(
                                              height: 5,
                                              width: 5,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0, right: 2),
                                              child: Container(
                                                height: 5,
                                                width: 5,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 5,
                                              width: 5,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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
                Divider(),
              ],
            );
          }
        });
  }

  EditingPopUp(ActivityModel activityModel) async {
    DateTime activityTime = activityModel.time.toDate();
    TimeOfDay time =
        TimeOfDay(hour: activityTime.hour, minute: activityTime.minute);

    var hours = time.hour.toString().padLeft(2, '0');
    var minutes = time.minute.toString().padLeft(2, '0');
    
    List<String> allActivity = activityModel.activityType.split(' ');
    String writedActivity = '';
    String? selectedItem = allActivity[allActivity.length-1];
    for (int i=0;i<allActivity.length-1;i++){
      writedActivity+=allActivity[i];
    }
    print(writedActivity);

    TextEditingController locationKey =
        TextEditingController(text: activityModel.location);

    
    TextEditingController activityKey =
    TextEditingController(text: writedActivity);

    List<UserModel> activityParticipants =
        await PostServices().getParticipants(activityModel);

    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  contentPadding: EdgeInsets.all(10),
                  title: Text(
                    "Edit Activity",
                    style: TextStyle(fontSize: 25, color: Color(0xFF2D3A43)),
                  ),
                  content: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                        color: Color(0XFFD6E6F1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.17,
                                        child: Text(
                                          "Activity Type:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    SizedBox(
                                        height: 20,
                                        width: MediaQuery.of(context).size.width *
                                            0.27,
                                        child: TextFormField(
                                          controller: activityKey,
                                        )),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.22,
                                        child: Center(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: selectedItem,
                                            items: items
                                                .map((item) => DropdownMenuItem(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    )))
                                                .toList(),
                                            onChanged: (item) {
                                              setState(
                                                  () => selectedItem = item);
                                            },
                                          ),
                                        )),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: Text(
                                            "Time:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${hours}:${minutes}',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                TimeOfDay? newTime =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime: time,
                                                );
                                                if (newTime == null) {
                                                  return;
                                                }
                                                setState(() {
                                                  time = newTime;
                                                  hours = time.hour
                                                      .toString()
                                                      .padLeft(2, '0');
                                                  minutes = time.minute
                                                      .toString()
                                                      .padLeft(2, '0');
                                                });
                                              },
                                              icon: Icon(Icons.expand_more),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: Text(
                                          "Location:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    SizedBox(
                                        height: 20,
                                        width: 150,
                                        child: TextFormField(
                                          controller: locationKey,
                                          //initialValue: activityModel.location,
                                        )),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Participants",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.only(left: 8),
                                          constraints: BoxConstraints(),
                                          onPressed: () {
                                            EditParticipantSearchPage
                                                editSearch =
                                                EditParticipantSearchPage(
                                                    participantsObj:
                                                        activityParticipants,
                                                    participantsString:
                                                        activityModel
                                                            .participants);
                                            showSearch(
                                                    context: context,
                                                    delegate: editSearch)
                                                .then((value) {
                                              setState(() {});
                                            });

                                            activityModel.participants =
                                                editSearch
                                                    .getParticipantsString();
                                            setState(() {
                                              activityParticipants = editSearch
                                                  .getParticipantsObj();
                                            });
                                            print(
                                                "editlenen participantlar: ${activityModel.participants}");
                                          },
                                          icon: Icon(
                                              Icons.person_add_alt_1_outlined)),
                                    ],
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  constraints: BoxConstraints(
                                    minHeight:
                                        MediaQuery.of(context).size.height *
                                            0.1,
                                    // maxHeight:
                                    // MediaQuery.of(context).size.height *
                                    //     0.4,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color(0XFFD6E6F1),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: activityParticipants.length,
                                        itemBuilder: (context, index) => Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 10, 0, 0),
                                                  child: InkWell(
                                                    onTap: (){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage(user:activityParticipants[
                                                      index],)));
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.07,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: Colors.white),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.05,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.05,
                                                              decoration: activityParticipants[
                                                                              index]
                                                                          .ppURL ==
                                                                      'ppURL'
                                                                  ? BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                          .grey)
                                                                  : BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      image:
                                                                          DecorationImage(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        image: NetworkImage(
                                                                            activityParticipants[index]
                                                                                .ppURL),
                                                                      ),
                                                                    ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                    alignment:
                                                                        AlignmentDirectional
                                                                            .centerStart,
                                                                    child: Text(
                                                                      activityParticipants[
                                                                              index]
                                                                          .name,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          color: Colors
                                                                              .black),
                                                                    )),
                                                                Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8.0),
                                                                    child:
                                                                        InkWell(
                                                                      onTap: () {
                                                                        activityModel
                                                                            .participants
                                                                            .removeAt(
                                                                                index);
                                                                        setState(
                                                                            () {
                                                                          activityParticipants
                                                                              .removeAt(index);
                                                                        });
                                                                        print(
                                                                            " kalan participantlar ${activityModel.participants} ve ${activityParticipants}");
                                                                      },
                                                                      child: Text(
                                                                        "Remove",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .red,
                                                                            fontWeight:
                                                                                FontWeight.w700),
                                                                      ),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel ",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.w700),
                        )),
                    InkWell(
                        onTap: () async {
                          hours = time.hour.toString().padLeft(2, '0');
                          minutes = time.minute.toString().padLeft(2, '0');
                          DateTime times =
                              DateTime.parse('${date}T$hours:$minutes');
                          Timestamp myTimeStamp = Timestamp.fromDate(times);
                          print(
                              "modelin kalan participantları: ${activityModel.participants}");
                          activityModel.activityType = activityKey.text +' '+ selectedItem!;
                          activityModel.location = locationKey.text;
                          activityModel.time = myTimeStamp;
                          await PostServices().updateActivity(activityModel).then((value) {
                            Navigator.pop(context);
                          });

                        },
                        child: Text(
                          " Save",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.green,
                              fontWeight: FontWeight.w700),
                        )),
                  ],
                );
              },
            ));
  }
}
