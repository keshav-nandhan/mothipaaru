import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mothipaaru_flutter/chatscreen.dart';
import 'package:mothipaaru_flutter/loading.dart';
import 'package:mothipaaru_flutter/users.model.dart';
import 'package:mothipaaru_flutter/message.model.dart';

class Chatwindow extends StatefulWidget {

final Users currentUser;
Chatwindow({Key key,@required this.currentUser}): super(key: key);

  @override
  _ChatwindowState createState() => _ChatwindowState();
}

class _ChatwindowState extends State<Chatwindow> {
List<ChatRoomModel> chatrooms=[];
List<ChatUsers> chatwithPeople=[];

@override
void initState(){
  super.initState();
  List<ChatUsers> guystochat=[];
  FirebaseFirestore.instance.collection("chatroom").get().then((data) => {
        data.docs.forEach((doc) =>{
          if(doc.id.contains(widget.currentUser.uid))
          {
            if(doc.data()["usercontact1"]==widget.currentUser.uid)
            {
              FirebaseFirestore.instance.collection("Users").doc(doc.data()['usercontact2']).get().then((element) {
                ChatUsers people=new ChatUsers(element.data()["displayName"],element.data()["email"],element.data()["photoURL"], element.data()["uid"],doc.id);
                guystochat.add(people);
                }),
            } 
            else if(doc.data()["usercontact2"]==widget.currentUser.uid)
            {  
              FirebaseFirestore.instance.collection("Users").doc(doc.data()['usercontact1']).get().then((element) {
                ChatUsers people=new ChatUsers(element.data()["displayName"],element.data()["email"],element.data()["photoURL"], element.data()["uid"],doc.id);
                guystochat.add(people);
                }),
            }
          }
        }),
        
  }).then((value) => {
setState(() {
        this.chatwithPeople=guystochat;
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
      appBar: AppBar(title: Text('Messages'),),
      //body:databindUsers(context,widget.currentUser,this.chatwithPeople)
      body: FutureBuilder(
      future: futureloaderdelay(),//it will return the future type result
            builder: (context, snapshot) {
              
              if(snapshot.connectionState == ConnectionState.done) {
                return databindUsers(context,widget.currentUser,this.chatwithPeople);
              }
              return Loading(); //show loading
            }),
            );
            }
        
          Widget databindUsers (BuildContext context,Users currentUser,List<ChatUsers> chatrooms) {
          return new ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount:chatrooms.length,
            itemBuilder: (context,index){
            return _chatroomListRow(chatrooms[index]);
                    });
                }
        
        
                 _chatroomListRow(ChatUsers matchreq) {
                return Card(
                  elevation: 3,
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //CircleAvatar(backgroundImage: AssetImage(matchedUser.imageurl.toString())),
                       
                       ListTile(
                        //  leading: CircleAvatar(
                        //    radius: 25.0,
                        //    backgroundImage:NetworkImage(matchreq.matchrequestedbyPhoto.toString()),
                        //    backgroundColor: Colors.transparent),
        
                          leading: CircleAvatar(radius: 30.0,backgroundImage:NetworkImage(matchreq.photoURL.toString()),backgroundColor: Colors.transparent),
                          contentPadding: EdgeInsets.all(5.0),
                          subtitle: Text(matchreq.displayName.toString()),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ChatScreenPage(chatroomID:matchreq.chatRoomID.toString(),currentUser:widget.currentUser,secondUser:matchreq.displayName);                      
                        }));
                          },
        
                        ),
                    
                    ],
                  ),
                );
              }
      
        futureloaderdelay() {
            return Future.delayed(Duration(milliseconds: 2000),);
        }
}