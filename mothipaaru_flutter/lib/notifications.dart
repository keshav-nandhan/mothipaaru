import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mothipaaru_flutter/chat.dart';
import 'package:mothipaaru_flutter/loading.dart';
import 'package:mothipaaru_flutter/notification.model.dart';
import 'package:mothipaaru_flutter/users.model.dart';

class NotificationsPage extends StatefulWidget {
  
final Users currentUser;
  NotificationsPage({Key key,@required this.currentUser}): super(key: key);
   
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}


class _NotificationsPageState extends State<NotificationsPage> {

List<NotificationModel> notificationitems=[];
  @override
void initState() {
   super.initState();
  var notify;List<NotificationModel> matchesrequested=[];
  FirebaseFirestore.instance.collection("register_match").get().then((data) {
        data.docs.forEach((doc) =>{
          notify=new NotificationModel(doc.data()['matchrequestedagainst'],doc.data()['matchrequestedby'],doc.data()['sport'],doc.data()['isMatchover'],doc.data()['confirmed'],doc.data()['dateupdated'],doc.data()['matchrequestedbyUser'],doc.data()['matchrequestedagainstUser'],doc.data()['matchrequestedbyPhoto'],doc.data()['matchrequestedagainstPhoto'],doc.id),
          matchesrequested.add(notify),
        });
          
   }).then((value) => {
          setState((){
                 this.notificationitems=matchesrequested;
                  })
   });
}

  @override
  void dispose() {
    super.dispose();
  }


 
  @override
  Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(title: Text('Notifications'),
   actions: <Widget>[
     FlatButton(  
              onPressed: () async{
              Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return Chatwindow(currentUser:widget.currentUser);                      
                }));
              },
              child:  Icon(Icons.messenger),
            ),],
   ),
    body: FutureBuilder(
      future: futureloaderdelay(),//it will return the future type result
            builder: (context, snapshot) {
              
              if(snapshot.connectionState == ConnectionState.done) {
                return databindUsers(context,widget.currentUser,this.notificationitems);
              }
              return Loading(); //show loading
            })
   //body:this.notificationitems.length>0?databindUsers(context,widget.currentUser,this.notificationitems):Text("No Notifications Pending")
   );
  }

  Widget databindUsers (BuildContext context,Users currentUser,List<NotificationModel> matchnotification) {
    if(this.notificationitems.length>0){
  return new ListView.builder(
    padding: EdgeInsets.all(10.0),  
    itemCount:matchnotification.length,
    itemBuilder: (context,index){
        return _createListRow(matchnotification[index]);
            });
    }
    else{
      return Text("No Pending Notifications");
    }
        }

      _createListRow(NotificationModel matchreq) {
        if((matchreq.matchrequestedagainst==widget.currentUser.uid)&&(!matchreq.confirmed)&&(!matchreq.isMatchover))
        {
        return Card(
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //CircleAvatar(backgroundImage: AssetImage(matchedUser.imageurl.toString())),
               
               ListTile(
                 leading: CircleAvatar(
                   radius: 25.0,
                   backgroundImage:NetworkImage(matchreq.matchrequestedbyPhoto.toString()),
                   backgroundColor: Colors.transparent),
                  //leading: CircleAvatar(radius: 30.0,backgroundImage:NetworkImage(matchedUser.imageurl.toString()),backgroundColor: Colors.transparent),
                  contentPadding: EdgeInsets.all(5.0),
                  subtitle: Text(matchreq.matchrequestedbyUser.toString()+ " has Challenged a " + matchreq.sport.toString() + " match" ,style: TextStyle(color: Colors.black.withOpacity(0.6)),),

                ),
            
              ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    //MaterialButton(onPressed: null)
                    ElevatedButton(
                      //textColor: const Color(0xFFB71C1C),
                      //focusColor:  const Color(0x006200EE),
                      onPressed: () async {
                        bool insert=true;
                        dynamic docid=matchreq.matchrequestedby+matchreq.matchrequestedagainst;
                  FirebaseFirestore.instance.collection("register_match").doc(matchreq.docid).set({
                    'confirmed':true,
                    'dateupdated':DateTime.now().toString()
                  },SetOptions(merge: true));
                      FirebaseFirestore.instance.collection("chatroom").get().then((data) => {
                     data.docs.forEach((doc) =>{
                       if(doc.id.contains(matchreq.matchrequestedagainst)&&doc.id.contains(matchreq.matchrequestedby))
                       {
                          insert=false
                       }
                     })
                    
                  }).then((value) => 
                          {
                            if(insert)
                            {
                              FirebaseFirestore.instance.collection("chatroom").doc(docid).set({
                                                      'usercontact1':matchreq.matchrequestedagainst,
                                                      'usercontact2':matchreq.matchrequestedby,
                                                        },SetOptions(merge: true)).then((value) => {
                                                          Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return Chatwindow(currentUser:widget.currentUser);                      
                                          })) 
                                                        })
                                                    }
                            });
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
               else if((matchreq.matchrequestedby==widget.currentUser.uid)&&(!matchreq.confirmed)&&(!matchreq.isMatchover)){
                 return ListTile(
                 leading: CircleAvatar(
                   radius: 25.0,
                   backgroundImage:NetworkImage(matchreq.matchrequestedagainstPhoto.toString()),
                   backgroundColor: Colors.transparent),

                  //leading: CircleAvatar(radius: 30.0,backgroundImage:NetworkImage(matchedUser.imageurl.toString()),backgroundColor: Colors.transparent),
                  contentPadding: EdgeInsets.all(5.0),
                  subtitle: Text("You have Challenged "+matchreq.matchrequestedagainstUser.toString()+ " a "+matchreq.sport+" match" ,style: TextStyle(color: Colors.black.withOpacity(0.6)),)
                );
               }
      }
      
      futureloaderdelay() {
            return Future.delayed(Duration(milliseconds: 2000),);
        }
                  

}