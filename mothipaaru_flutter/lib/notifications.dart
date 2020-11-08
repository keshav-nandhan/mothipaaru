import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mothipaaru_flutter/notification.model.dart';
import 'package:mothipaaru_flutter/userDetails.model.dart';
import 'package:mothipaaru_flutter/users.model.dart';

class NotificationsPage extends StatefulWidget {
  
  final Users currentUser;
final List<UserDetails> opponentsList;
  NotificationsPage({Key key,@required this.currentUser,@required this.opponentsList}): super(key: key);
   
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}


class _NotificationsPageState extends State<NotificationsPage> {

final List<NotificationModel> matchesrequested=[];
final notificationsforuser=[];
  @override
void initState() {
  var notify;
  super.initState();
FirebaseFirestore.instance.collection("register_match").where('matchrequestedagainst',isEqualTo: widget.currentUser.uid.toString()).snapshots()
               .listen((data) =>{
                data.docs.forEach((doc) =>{
                  if(!doc.data()['isMatchover']&&!doc.data()['confirmed'])
                  {
                    notify=new NotificationModel(doc.data()['matchrequestedagainst'],doc.data()['matchrequestedby'],doc.data()['sport'],doc.data()['isMatchover'],doc.data()['confirmed'],doc.data()['dateupdated']),
                    matchesrequested.add(notify),
                  }
                })
               });

}


  @override
  Widget build(BuildContext context) {
     return Scaffold(
   appBar: AppBar(title: Text('Notifications'),),
   body:databindUsers(context,widget.currentUser)
   );
  }

  Widget databindUsers (BuildContext context,Users currentUser) {
  return ListView.builder(
    padding: EdgeInsets.all(10.0),
    itemCount:matchesrequested.length,
    itemBuilder: (context,index){
        return _createListRow(matchesrequested[index]);
            });
        }

      _createListRow(NotificationModel matchreq) {
        return Card(
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //CircleAvatar(backgroundImage: AssetImage(matchedUser.imageurl.toString())),
               ListTile(
                  //leading: CircleAvatar(radius: 30.0,backgroundImage:NetworkImage(matchedUser.imageurl.toString()),backgroundColor: Colors.transparent),
                  title: Text(matchreq.matchrequestedby.toString()),
                  subtitle: Text("User has Challenged a " + matchreq.sport.toString() + "match" ,style: TextStyle(color: Colors.black.withOpacity(0.6)),),

                ),
            
            
              ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    //MaterialButton(onPressed: null)
                    ElevatedButton(
                      //textColor: const Color(0xFFB71C1C),
                      //focusColor:  const Color(0x006200EE),
                      onPressed: () async {
                  
            },
            child: Text('Yes'),
          ),
            ElevatedButton(
                      //textColor: const Color(0xFFB71C1C),
                      //focusColor:  const Color(0x006200EE),
                      onPressed: () async {
                  
            },
            child: Text('No'),
          ),
                  ],
                ),
            ],
          ),
        );
      }

                  

}