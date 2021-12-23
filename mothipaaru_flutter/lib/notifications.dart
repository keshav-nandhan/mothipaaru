import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mothipaaru_flutter/chat.dart';
import 'package:mothipaaru_flutter/loading.dart';
import 'package:mothipaaru_flutter/notification.model.dart';
import 'package:mothipaaru_flutter/users.model.dart';

class NotificationsPage extends StatefulWidget {
  
final Users currentUser;
  NotificationsPage({Key? key,required this.currentUser}): super(key: key);
   
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}


class _NotificationsPageState extends State<NotificationsPage> {

List<NotificationModel> notificationitems=[];
late ScrollController listscrollcontroller;
  @override
void initState() {
  listscrollcontroller = ScrollController();
 listscrollcontroller.addListener(_scrollListener);
   super.initState();
  var notify;List<NotificationModel> matchesrequested=[];
  FirebaseFirestore.instance.collection("register_match").where('matchrequestedagainst',isEqualTo: widget.currentUser.uid).snapshots().listen((data) {
        data.docs.forEach((doc) =>{
          notify=new NotificationModel(doc.data()['matchrequestedagainst'],doc.data()['matchrequestedby'],doc.data()['sport'],doc.data()['isMatchover'],doc.data()['confirmed'],doc.data()['dateupdated'],doc.data()['matchrequestedbyUser'],doc.data()['matchrequestedagainstUser'],doc.data()['matchrequestedbyPhoto'],doc.data()['matchrequestedagainstPhoto'],doc.id),
          matchesrequested.add(notify),
        });
   });
   FirebaseFirestore.instance.collection("register_match").where('matchrequestedby',isEqualTo: widget.currentUser.uid).snapshots().listen((data) {
        data.docs.forEach((doc) =>{
          notify=new NotificationModel(doc.data()['matchrequestedagainst'],doc.data()['matchrequestedby'],doc.data()['sport'],doc.data()['isMatchover'],doc.data()['confirmed'],doc.data()['dateupdated'],doc.data()['matchrequestedbyUser'],doc.data()['matchrequestedagainstUser'],doc.data()['matchrequestedbyPhoto'],doc.data()['matchrequestedagainstPhoto'],doc.id),
          matchesrequested.add(notify),
        });
   });
          setState((){
                 this.notificationitems=matchesrequested;
                  });
}

  @override
  void dispose() {
    super.dispose();
  }

_scrollListener() {
  if (listscrollcontroller.offset >= listscrollcontroller.position.maxScrollExtent &&
     !listscrollcontroller.position.outOfRange) {
   setState(() {//you can do anything here
   });
 }
 if (listscrollcontroller.offset <= listscrollcontroller.position.minScrollExtent &&
    !listscrollcontroller.position.outOfRange) {
   setState(() {//you can do anything here
    });
  }
}
 
  @override
  Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(title: Text('Notifications'),
   actions: <Widget>[
     TextButton(  
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
                return new ListView(
                  children: databindUsers(context,widget.currentUser,this.notificationitems),
                  scrollDirection: Axis.vertical,
                );
                 //Column(children:databindUsers(context,widget.currentUser,this.notificationitems));
              }
              return Loading(); //show loading
            })
   //body:this.notificationitems.length>0?databindUsers(context,widget.currentUser,this.notificationitems):Text("No Notifications Pending")
   );
  }

  List <Widget> databindUsers (BuildContext context,Users currentUser,List<NotificationModel> matchnotification) {
    List <Widget> notice=[];
    if(matchnotification.length>0){
      for(var i=0;i<matchnotification.length;i++){
        notice.add( _createListRow(matchnotification[i]));
      // return new Column(children:<Widget>[
      //   Padding(child: _createListRow(matchnotification[i]),
      //   padding: EdgeInsets.all(5.0),
      //)
        
      //]);
      }
    }
    else notice.add(Text("No New  Notifications Pending"));
    return notice;
    }
      
  // return new ListView.builder(
  //   padding: EdgeInsets.all(4.0),  
  //   controller: listscrollcontroller,
  //   itemCount:matchnotification,
  //   itemBuilder: (context,index){
      
      // children:[new Expanded(child:SizedBox(child: new ListView.builder(
          // if(_createListRow(matchnotification[index])==[])
          // {
          //  return new Text("No Pending Notifications");
          // }
          // else{
          //   return new Column(children: _createListRow(matchnotification[index]));
          // }
          
      
    //}
  //    {
  //   return new Row(children: strings.map((item) => new Text(item)).toList());
  // }
        //return _createListRow(matchnotification[index]);
  
    
     Widget _createListRow(NotificationModel matchreq) {
        if(matchreq.matchrequestedagainst==widget.currentUser.uid){
          if(!matchreq.confirmed!){
          return new Padding(
            padding: EdgeInsets.all(4.0),
            child:Card(
          elevation: 2,
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //CircleAvatar(backgroundImage: AssetImage(matchedUser.imageurl.toString())),
               
               ListTile(
                 leading: CircleAvatar(
                   radius: 25.0,
                   backgroundImage:NetworkImage(matchreq.matchrequestedbyPhoto.toString()),
                   backgroundColor: Colors.transparent),
                   contentPadding: EdgeInsets.all(4.0),
                   title:  Container(child:Text(matchreq.matchrequestedbyUser.toString()+ " has Challenged a " + matchreq.sport.toString() + " match" ,style: TextStyle(color: Colors.black.withOpacity(0.6)),)),
                  //leading: CircleAvatar(radius: 30.0,backgroundImage:NetworkImage(matchedUser.imageurl.toString()),backgroundColor: Colors.transparent),
                  subtitle: Container(child:Text(DateFormat.yMMMd().format(DateTime.parse(matchreq.dateupdated!)))),
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
                        dynamic docid=matchreq.matchrequestedby!+matchreq.matchrequestedagainst!;
                  FirebaseFirestore.instance.collection("register_match").doc(matchreq.docid).set({
                    'confirmed':true,
                    'dateupdated':DateTime.now().toString()
                  },SetOptions(merge: true)).then((value) => {
                    //this.notificationitems.forEach((element) {
                    
                      setState(() {
                                        
                    })
                  });
                    //this.notificationitems=this.notificationitems;
                    
                  
                      FirebaseFirestore.instance.collection("chatroom").get().then((data) => {
                     data.docs.forEach((doc) =>{
                       if(doc.id.contains(matchreq.matchrequestedagainst!)&&doc.id.contains(matchreq.matchrequestedby!))
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
                            else{
                                                           Navigator.pushReplacement(context, MaterialPageRoute(
                                        builder: (context) {
                                          return NotificationsPage(currentUser:widget.currentUser);                      
                                          })) 
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
        ),
          );
          }
          else{
              return new Card( 
                elevation: 2,
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.all(5.0),
                child:Padding(
                padding: EdgeInsets.all(4.0),
                child:ListTile(
                 leading: CircleAvatar(
                   radius: 25.0,
                   backgroundImage:NetworkImage(matchreq.matchrequestedbyPhoto.toString()),
                   backgroundColor: Colors.transparent),

                  //leading: CircleAvatar(radius: 30.0,backgroundImage:NetworkImage(matchedUser.imageurl.toString()),backgroundColor: Colors.transparent),
                  contentPadding: EdgeInsets.all(5.0),
                  title: Container(child:Text("You have Accepted a "+matchreq.sport!+" match with "+matchreq.matchrequestedbyUser.toString()+ ". Now you can chat with "+matchreq.matchrequestedbyUser!,style: TextStyle(color: Colors.black.withOpacity(0.6)),)),
                  subtitle: Container(child:Text(DateFormat.yMMMd().format(DateTime.parse(matchreq.dateupdated!)))),
               ),
              )
              );
          }
        }
        else if(matchreq.matchrequestedby==widget.currentUser.uid){
          if(!matchreq.confirmed!){
      return new Card( 
                elevation: 2,
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.all(5.0),
                child:Padding(
                padding: EdgeInsets.all(4.0),
                child:ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundImage:NetworkImage(matchreq.matchrequestedagainstPhoto.toString()),
            backgroundColor: Colors.transparent),

          //leading: CircleAvatar(radius: 30.0,backgroundImage:NetworkImage(matchedUser.imageurl.toString()),backgroundColor: Colors.transparent),
          contentPadding: EdgeInsets.all(5.0),
          subtitle: Text("You have Challenged "+matchreq.matchrequestedagainstUser.toString()+ " a "+matchreq.sport!+" match" ,style: TextStyle(color: Colors.black.withOpacity(0.6)),)
        ),
      ),
      );
          }
          else
          {
         return new Card( 
                elevation: 2,
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.all(5.0),
                child:Padding(
                padding: EdgeInsets.all(4.0),
                child:ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundImage:NetworkImage(matchreq.matchrequestedagainstPhoto.toString()),
            backgroundColor: Colors.transparent),

          //leading: CircleAvatar(radius: 30.0,backgroundImage:NetworkImage(matchedUser.imageurl.toString()),backgroundColor: Colors.transparent),
          contentPadding: EdgeInsets.all(5.0),
          subtitle: Text(matchreq.matchrequestedagainstUser.toString()+ " has Accepted your "+matchreq.sport!+" match Challenge. Now you can chat with "+matchreq.matchrequestedagainstUser!,style: TextStyle(color: Colors.black.withOpacity(0.6)),)
        ),
         ),
         );  
          }
        }
        else{
         return new Card( 
                elevation: 2,
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.all(5.0),
                child:Padding(
                padding: EdgeInsets.all(4.0),
                child:ListTile(
          //leading: CircleAvatar(radius: 30.0,backgroundImage:NetworkImage(matchedUser.imageurl.toString()),backgroundColor: Colors.transparent),
          contentPadding: EdgeInsets.all(5.0),
          subtitle: Text("No New Pending Notifications" ,style: TextStyle(color: Colors.black.withOpacity(0.6)),)
        ),
      ),
         );

        }
               
      }
      
      futureloaderdelay() {
            return Future.delayed(Duration(milliseconds: 2000),);
        }
                  

}