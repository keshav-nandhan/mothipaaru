import 'package:flutter/material.dart';
import 'package:mothipaaru_flutter/userDetails.model.dart';
import 'users.model.dart';

class Matchfinder extends StatefulWidget {
  
final Users currentUser;
final List<UserDetails> usersMatchData=[];
  Matchfinder({Key key, @required this.currentUser, List<UserDetails> usersMatchData}) : super(key: key);  
   
  @override
_MatchfinderState createState() => _MatchfinderState();
}

class _MatchfinderState extends State<Matchfinder> {
 
UserDetails matchUser;

// Declare this variable

@override
void initState() {
  super.initState();
  
}

  @override
Widget build(BuildContext context) {
 final List<UserDetails> listDataSource=widget.usersMatchData;
 print(listDataSource);
 return Scaffold(
  appBar: new AppBar(title: Text('Opponents'),),
  //child: new ListView.builder(itemBuilder:this.matchUser)
  body:databindUsers(context, listDataSource)
         //appBar: new AppBar(title:Text('Match')),
);
                         
}



Widget databindUsers (BuildContext context,List<UserDetails> matchedUsers) {
  return new ListView.builder(
    padding: EdgeInsets.all(10.0),
    itemCount:matchedUsers.length,
    itemBuilder: (context,index){
        return userRecordCard(matchedUsers[index]);
            });
        }                  
          ListView userRecordCard(UserDetails matchedUser) {
             return ListView(
              padding: const EdgeInsets.all(8.0),
              children: <Widget>[
              Container(
                height: 50,
                color: Colors.amber[600],
                child: Center(child:Text(matchUser.username.toString())),
              ),
              Container(
                height: 50,
                color: Colors.amber[500],
                child: Center(child: Text(matchUser.phonenumber.toString())),
              ),
              Container(
                height: 50,
                color: Colors.amber[100],
                child: Center(child: Text(matchUser.favouritesport.toString())),
              ),
            ],
            );
          }

}

  

