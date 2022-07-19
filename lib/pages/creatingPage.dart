import 'package:actwithy/Models/ActivityModel.dart';
import 'package:actwithy/Models/PostModel.dart';
import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/pages/searchDelegatePage.dart';
import 'package:actwithy/services/postServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreatingPage extends StatefulWidget {
  PostModel postModel;
  CreatingPage({required this.postModel});


  @override
  State<CreatingPage> createState() => _CreatingPageState();
}

class _CreatingPageState extends State<CreatingPage> {




  TextEditingController locationKey= TextEditingController();
  final searchController = TextEditingController();
  List<String> items=['Seçiniz...','İşe gidecek','Sinemaya gidecek','Ders çalışacak','Yemek yiyecek'];
  String? selectedItem ='Seçiniz...';
  List<String> searchT= [
    'apple',
    'banana',
    'pear',
    'watermelon',
    'strawberry'
  ];
  TimeOfDay time = TimeOfDay(hour: 12, minute: 30);
  String date = DateTime.now().toString().substring(0,10);
  List<String> matchQuery=[];
  @override
  Widget build(BuildContext context) {
    final hours= time.hour.toString().padLeft(2,'0');
    final minutes= time.minute.toString().padLeft(2,'0');
    String hoursANDminutes='$hours:$minutes';
    DateTime times = DateTime.parse('${date}T$hours:$minutes');
    Timestamp myTimeStamp = Timestamp.fromDate(times);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(centerTitle: true,
          backgroundColor: Color(0XFF48B2FA),
          title: Text(
            "New ToDo",
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text("Edit",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Divider(
                    thickness: 1,
                    color: Colors.black,
                    indent: MediaQuery.of(context).size.width*0.4,
                    endIndent: MediaQuery.of(context).size.width*0.4,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    height: MediaQuery.of(context).size.height*0.39,
                    decoration: BoxDecoration(
                        color: Color(0XFFD6E6F1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: 6,
                          itemBuilder: (context,index){
                            return  Column(
                              children: [
                                Container(
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
                                                  child: InkWell(
                                                    child: Icon(Icons.edit),
                                                    onTap: (){
                                                      EditingPopUp();
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
                                ),
                                Divider(),
                              ],
                            );}),
                    ),
                  ),
                ],),
              SizedBox(height: MediaQuery.of(context).size.height*0.035,),
              Column(
                children: [
                  Text("Create",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Divider(
                    thickness: 1,
                    color: Colors.black,
                    indent: MediaQuery.of(context).size.width*0.4,
                    endIndent: MediaQuery.of(context).size.width*0.4,
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    height: MediaQuery.of(context).size.height*0.3,
                    decoration: BoxDecoration(
                        color: Color(0XFFD6E6F1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child:Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        width: MediaQuery.of(context).size.width*0.25,
                                        child: Text("Activity Type:",style: TextStyle(fontWeight: FontWeight.bold),)),
                                    SizedBox(
                                        width: 200,
                                        child: Center(
                                          child: DropdownButton<String>(
                                            value: selectedItem,
                                            items: items.map((item) =>DropdownMenuItem(
                                                value: item,
                                                child: Text(item,style:TextStyle(fontSize:15 ),)))
                                                .toList(),
                                            onChanged: (item)=> setState(()=> selectedItem =item),
                                          ),
                                        )),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context).size.width*0.25,
                                          child: Text("Time:",style: TextStyle(fontWeight: FontWeight.bold),)),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${hours}:${minutes}',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            IconButton(
                                              onPressed: ()async{
                                                TimeOfDay? newTime= await showTimePicker(
                                                  context: context,
                                                  initialTime: time,
                                                );
                                                if(newTime==null){return;};
                                                setState(()=>time=newTime);
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
                                        width: MediaQuery.of(context).size.width*0.25,
                                        child: Text("Location:",style: TextStyle(fontWeight: FontWeight.bold),)),
                                    SizedBox(
                                      height: 20,width: 200,
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
                                      Text("Participants",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      IconButton(
                                          padding: EdgeInsets.only(left:8),
                                          constraints: BoxConstraints(),
                                          onPressed: (){
                                         showSearch(context: context, delegate: SearchPeoplePage());
                                      }, icon: Icon(Icons.person_add_alt_1_outlined)),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Colors.red,
                                  width: MediaQuery.of(context).size.width*0.7,
                                  constraints: BoxConstraints(
                                    minHeight: MediaQuery.of(context).size.height*0.1,
                                    maxHeight: MediaQuery.of(context).size.height*0.4,
                                  ),
                                  child: ListView.builder(
                                     itemCount: 3,
                                    //itemCount: ActivityModel().participants.length,
                                      itemBuilder: (context,index)=>Column(
                                        children: [
                                          Container(height: 30,width: 200,color: Colors.green,),
                                          Divider(height: 5,thickness: 2,),
                                        ],
                                      )),

                                ),

                                Container(// divider görevi gören widget.
                                  color: Colors.black,
                                  width: MediaQuery.of(context).size.width*0.7,
                                  height: 5,
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2,top:2,left:20,right: 20),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){},
                          child: Text("Clear",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),),
                        ),
                        InkWell(
                          onTap: ()async {
                            //ActivityModel activityObj= ActivityModel(activityType:selectedItem!, time:hoursANDminutes, location:locationKey.text,);
                            //TODO bir tane activity varsa önce post oluştur.
                          String ActId=  await PostServices().createActivity(selectedItem!, myTimeStamp,locationKey.text);

                          if(widget.postModel.postUID=="postUID"){
                            //TODO Databasede yeni post oluşturmamız gerekiyor.
                            widget.postModel =  await PostServices().createPost();
                          }

                          widget.postModel.activityUID.add(ActId);
                          await PostServices().updatePost(widget.postModel);
                          print("actvty:  ${widget.postModel.activityUID}");
                          },
                          child: Text("Submit",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green[600]),),
                        ),
                      ],
                    ),
                  ),
                ],),
            ],
          ),
        ),
      ),
    );
  }
  EditingPopUp(){
    return showDialog(context: context, builder: (context)=>AlertDialog(
      contentPadding: EdgeInsets.all(10),
      title: Text("Title"),
      content: Container(
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
                  // delete and edit icons
                ],
              ),
            ),
            Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(
                        width: MediaQuery.of(context).size.width*0.25,
                        child: Text("Hacettepe Teknokent",overflow: TextOverflow.ellipsis)),
                  ],
                ),
                Padding(
                  padding:  EdgeInsets.only(left:8.0,right: 8.0),
                  child: Row(
                    children: [
                      Container(
                        height: 20,width: 20,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0,right:3.0),
                        child: Container(
                          height: 20,width: 20,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,

                          ),
                        ),
                      ), Container(
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
      ),
      actions: [
        InkWell(
            onTap: (){Navigator.pop(context);},
            child: Text("Cancel")),
        InkWell(
            onTap: (){Navigator.pop(context);},
            child: Text("Save")),
      ],
    ));
  }
  Aramafonk(){
    String query=''; // queryi hallet...
    for(var fruit in searchT){
      if(fruit.toLowerCase().contains(searchController.text.toLowerCase())){
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context,index){
          var result= matchQuery[index];
          return ListTile(
            title: Text(result),
          );
        }
    );
  }

}


