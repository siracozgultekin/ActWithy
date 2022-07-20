import 'package:actwithy/Models/UserModel.dart';
import 'package:actwithy/services/postServices.dart';
import 'package:flutter/material.dart';

class ParticipantSearchPage extends SearchDelegate {

  final String? hintText;
  final TextStyle? hintTextColor;
  ParticipantSearchPage({this.hintText,this.hintTextColor});
  List<String> searchTerms= [
    'apple',
    'banana',
    'pear',
    'watermelon',
    'strawberry'
  ];
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      hintColor: Colors.white.withOpacity(0.8),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0XFF48B2FA),
        elevation: 0,
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.2,
          ),
        ),
      ),
      scaffoldBackgroundColor: Color(0XFFD6E6F1),
    );}
  TextStyle? get  searchFieldStyle => hintTextColor;
  String? get searchFieldLabel => hintText;
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),);
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: PostServices().getFriendsProfiles(query.toLowerCase()),
      builder: (context, AsyncSnapshot snap) {
        if(!snap.hasData){
          print("HATA");
          return CircularProgressIndicator(color: Colors.red,);
        } else {
          return ListView.builder(
              itemCount: snap.data.length,
              itemBuilder: ((context, index) {
                var result = snap.data[index] as UserModel;
                return InkWell(
                  onTap: (){},
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.height * 0.05,
                          decoration: result.ppURL == 'ppURL'
                              ? BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey)
                              :BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  '${result.ppURL}'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(alignment: AlignmentDirectional.centerStart,
                            height: MediaQuery.of(context).size.height*0.075,
                            child: Text(result.name,style: TextStyle(fontSize: 17,color: Colors.black),)),
                      ),
                    ],
                  ),
                );
              }));
        }
      },

    );

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
          child: Text("Kişileri aramayı dene",textAlign:TextAlign.center ,style: TextStyle(fontSize: 17,color: Colors.grey),)),
    );
  }
}