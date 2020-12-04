import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mothipaaru_flutter/loading.dart';
import 'package:mothipaaru_flutter/notifications.dart';
import 'package:mothipaaru_flutter/userDetails.model.dart';
import 'users.model.dart';

class Matchfinder extends StatefulWidget {
  
final Users userLoggedIn;
final List<UserDetails> usersMatchData;
  Matchfinder({@required this.userLoggedIn,@required this.usersMatchData});  
   
  @override
_MatchfinderState createState() => _MatchfinderState();
}

class _MatchfinderState extends State<Matchfinder> {
 
UserDetails matchUser;
//static bool confirmmatch=false;
// Declare this variable

@override
void initState() {
  super.initState();
}

  @override
Widget build(BuildContext context) {

 return Scaffold(
  appBar: AppBar(title: Text('Opponents'),
  actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: () async{
              Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return NotificationsPage(currentUser:widget.userLoggedIn);                      
                }));
              },
              child:  Icon(Icons.notifications),
            ),
          ),
        ],
  ),
  //child: new ListView.builder(itemBuilder:this.matchUser)
  body: FutureBuilder(
      future: futureloaderdelay(),//it will return the future type result
            builder: (context, snapshot) {
              
              if(snapshot.connectionState == ConnectionState.done) {
                return  databindUsers(context,widget.usersMatchData);
              }
              return Loading(); //show loading
            }),
 
         //appBar: new AppBar(title:Text('Match')),
);
                         
}



Widget databindUsers (BuildContext context,List<UserDetails> matchedUsers) {
  return ListView.builder(
    padding: EdgeInsets.all(10.0),
    itemCount:matchedUsers.length,
    itemBuilder: (context,index){
        return _createListRow(matchedUsers[index],widget.userLoggedIn);
            });
        }                  



        _createListRow(UserDetails matchedUser,Users userLoggedIn) {
        return Card(
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //CircleAvatar(backgroundImage: AssetImage(matchedUser.imageurl.toString())),
               ListTile(
                  leading: CircleAvatar(radius: 30.0,backgroundImage:NetworkImage(matchedUser.imageurl.toString()),backgroundColor: Colors.transparent),
                  title: Text(matchedUser.username.toString()),
                  subtitle: Text(matchedUser.phonenumber.toString(),style: TextStyle(color: Colors.black.withOpacity(0.6)),),

                ),
              Center(child: Text(matchedUser.favouritesport.toString())),
              Icon(Icons.location_on, size: 14),Text(matchedUser.distancebtw.toString()),
              ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    //MaterialButton(onPressed: null)
                    ElevatedButton(
                      //textColor: const Color(0xFFB71C1C),
                      //focusColor:  const Color(0x006200EE),
                      onPressed: () async {
                  showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('Mothipaaru?'),
                        content: Text('Would you like to Challenge?'),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () => Navigator.of(context).pop('No'),
                              child: Text('Cancel')),
                          FlatButton(
                              onPressed: () => Navigator.of(context).pop('Yes'),
                              child: Text('Confirm'))
                        ],
                    )).then((value) =>
                  {
                  if(value.toString()=='Yes')
                  // Notification(this.matchrequestedagainst,this.matchrequestedby,this.sport,this.comments,this.confirmed,this.dateupdated);
                  FirebaseFirestore.instance.collection('register_match').add({
                  'matchrequestedby':userLoggedIn.uid,
                  'matchrequestedagainst':matchedUser.uid,
                  'sport':matchedUser.favouritesport,
                  'matchrequestedbyUser':userLoggedIn.displayName,
                  'matchrequestedagainstUser':matchedUser.username,
                  'matchrequestedbyPhoto':userLoggedIn.photoURL,
                  'matchrequestedagainstPhoto':matchedUser.imageurl,
                  'isMatchover':false,
                  'confirmed':false,
                  'dateupdated':DateTime.now().toString(),
                    }),

                   FirebaseFirestore.instance.collection('register_team').doc(userLoggedIn.uid.toString()).set({
                  'isUseravailable':false,
                    },SetOptions(mergeFields:['isUseravailable'] )), 

                    FirebaseFirestore.instance.collection('register_team').doc(matchedUser.uid.toString()).set({
                  'isUseravailable':false,
                     },SetOptions(mergeFields:['isUseravailable'] )), 
                  });
            },
            child: Text('Mothipaaru'),
          ),
                  ],
                ),
            ],
          ),
        );
      }

          ListView userRecordCard(UserDetails matchedUser) {
             return ListView(
               
              padding: const EdgeInsets.all(8.0),
              children:<Widget>[
              Container(
                height: 50,
                color: Colors.amber[600],
                child: Center(child:Text(matchedUser.username.toString())),
              ),
              Container(
                height: 50,
                color: Colors.amber[500],
                child: Center(child: Text(matchedUser.phonenumber.toString())),
              ),
              Container(
                height: 50,
                color: Colors.amber[100],
                child: Center(child: Text(matchedUser.favouritesport.toString())),
              ),
            ],
            );
          }

                 futureloaderdelay() {
            return Future.delayed(Duration(milliseconds: 3000),);
        }

}

  

