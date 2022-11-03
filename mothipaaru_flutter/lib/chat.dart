import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mothipaaru_flutter/chatscreen.dart';
import 'package:mothipaaru_flutter/loading.dart';
import 'package:mothipaaru_flutter/users.model.dart';
import 'package:mothipaaru_flutter/message.model.dart';

class Chatwindow extends StatefulWidget {

final Users currentUser;
Chatwindow({Key? key,required this.currentUser}): super(key: key);

  @override
  _ChatwindowState createState() => _ChatwindowState();
}

class _ChatwindowState extends State<Chatwindow> {
List<ChatRoomModel> chatrooms=[];
List<ChatUsers> chatwithPeople=[];
InterstitialAd? _interstitialad;
  static const kDefaultPadding=4.0;
int adloadattempt=0;
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
                ChatUsers people=new ChatUsers(element.data()?["displayName"],element.data()?["email"],element.data()?["photoURL"], element.data()?["uid"],doc.id);
                guystochat.add(people);
                }),
            } 
            else if(doc.data()["usercontact2"]==widget.currentUser.uid)
            {  
              FirebaseFirestore.instance.collection("Users").doc(doc.data()['usercontact1']).get().then((element) {
                ChatUsers people=new ChatUsers(element.data()!["displayName"],element.data()!["email"],element.data()!["photoURL"], element.data()!["uid"],doc.id);
                guystochat.add(people);
                }),
            }
          }
        }),
        
  }).then((value) => {
setState(() {
        this.chatwithPeople=guystochat;
        initad();
        })

  });
  
  }

  void showInterstitialad(){
  if(_interstitialad!=null){
    _interstitialad?.fullScreenContentCallback=FullScreenContentCallback(
      onAdDismissedFullScreenContent:(InterstitialAd ad)=>{ad.dispose(),initad()},
      onAdFailedToShowFullScreenContent: (InterstitialAd ad,AdError error) => {ad.dispose(),initad()},
    );
  }
  _interstitialad?.show();
}
  
   @override
    void dispose() {
      super.dispose();
          _interstitialad?.dispose();
    }
  
  void initad(){
  InterstitialAd.load(adUnitId: "ca-app-pub-7392433179328561/4059352630", request: AdRequest(), adLoadCallback: InterstitialAdLoadCallback(
   onAdLoaded: (InterstitialAd ad) {
     _interstitialad=ad;
     adloadattempt=0;
   },
   onAdFailedToLoad: (LoadAdError error)=>{print(error),adloadattempt+=1,_interstitialad=null,if(adloadattempt<3)initad()}));
}

      @override
      Widget build(BuildContext context) {
      return Scaffold(
      // appBar: AppBar(title: Text('Chats'),
      // actions: [IconButton(icon: Icon(Icons.search), onPressed: (){})]),
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
                  color: Colors.lightBlue[50],
                  elevation: 3,
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding,vertical:kDefaultPadding*0.75),
                        child: ListTile(
                        //  leading: CircleAvatar(
                        //    radius: 25.0,
                        //    backgroundImage:NetworkImage(matchreq.matchrequestedbyPhoto.toString()),
                        //    backgroundColor: Colors.transparent),
        
                          leading: CircleAvatar(radius: 30.0,backgroundImage:NetworkImage(matchreq.photoURL.toString()),backgroundColor: Colors.transparent),
                          contentPadding: EdgeInsets.all(5.0),
                          subtitle: Text(matchreq.displayName.toString()),
                          onTap: (){
                            showInterstitialad();
                            Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ChatScreenPage(chatroomID:matchreq.chatRoomID.toString(),currentUser:widget.currentUser,secondUser:matchreq.displayName);                      
                        }));
                          },
        
                        ),)
                      //CircleAvatar(backgroundImage: AssetImage(matchedUser.imageurl.toString())),
                       
                       
                    
                    ],
                  ),
                );
              }
      
        futureloaderdelay() {
            return Future.delayed(Duration(milliseconds: 1000),);
        }
}