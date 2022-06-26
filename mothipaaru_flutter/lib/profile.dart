import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mothipaaru_flutter/notification.model.dart';
import 'package:mothipaaru_flutter/users.model.dart';

import 'loading.dart';

class ProfilePage extends StatefulWidget {
  final Users currentUser;
  const ProfilePage({Key? key,required this.currentUser}): super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<NotificationModel> matchesPlayed=[];
  int following=0,followedby=0,totalmatches=0;

@override
  void initState(){
    super.initState();
    setState(() {
    FirebaseFirestore.instance.collection('Users').doc(widget.currentUser.uid).collection('FollowedBy').get().then((value) => {followedby=value.size});
    FirebaseFirestore.instance.collection('Users').doc(widget.currentUser.uid).collection('Following').get().then((value) => {following=value.size});
     
    FirebaseFirestore.instance.collection('register_match').where('matchrequestedby',isEqualTo: widget.currentUser.uid).where('confirmed',isEqualTo:true).snapshots().listen((data) {
      data.docs.forEach((element) {
        this.matchesPlayed.add(new NotificationModel(element["matchrequestedagainst"],element["matchrequestedby"],element["sport"],element["isMatchover"],element["confirmed"],element["dateupdated"],element["matchrequestedbyUser"],element["matchrequestedagainstUser"],element["matchrequestedbyPhoto"], element["matchrequestedagainstPhoto"], element.id));
      });
     });
     FirebaseFirestore.instance.collection('register_match').where('matchrequestedagainst',isEqualTo: widget.currentUser.uid).where('confirmed',isEqualTo:true).snapshots().listen((data) {
      data.docs.forEach((element) {
        this.matchesPlayed.add(new NotificationModel(element["matchrequestedagainst"],element["matchrequestedby"],element["sport"],element["isMatchover"],element["confirmed"],element["dateupdated"],element["matchrequestedbyUser"],element["matchrequestedagainstUser"],element["matchrequestedbyPhoto"], element["matchrequestedagainstPhoto"], element.id));
      });
     });
    totalmatches=this.matchesPlayed.length; 
    });
    
    
  }

   @override
    void dispose() {
      super.dispose();
    }
           futureloaderdelay() {
            return Future.delayed(Duration(milliseconds: 1000));
        }
  @override
  Widget build(BuildContext context) {
   
   var _screen=MediaQuery.of(context).size;
   return Scaffold(
     body: FutureBuilder(
      future: futureloaderdelay(),//it will return the future type result
            builder: (context, snapshot) {   
                if(snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              }
              return
      Column(children: [
         Container(
         padding: const EdgeInsets.all(10),
         color:  Color.fromARGB(255, 15, 66, 61),
         height: 155,
         child: Row(
        children: <Widget>[
          Container(
            width: 100,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
         height: 100, //155,
         width: 100, //155,
         child: Center(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 100, // 150,
                width: 100, //150,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.red,
                      width: 3,
                    )),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 100 , //140,
                width: 100, //140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(this.widget.currentUser.photoURL.toString()),
                ),
              ),
            ),
          ],
        ),
         ),
       )
            ),
          ),
          Container(
            width: _screen.width - 100 - 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                statsBox(count: totalmatches.toString(), title: 'Matches'),
                statsBox(count: followedby.toString(), title: 'Followers'),
                statsBox(count: following.toString() , title: 'Following'),
              ],
            ),
          ),
        ],
         ),
         
       ),
       Container(
       width: _screen.width - 100 - 40,
       child: Text("Matches Played"),
       ),
       ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount:matchesPlayed.length,
                      itemBuilder: (context,index){
                      return matchesTabBar(height:25,matches:matchesPlayed[index]);
                        })
      
     
       ]);
            },
     ),
   );
  }
  

Widget statsBox({  required String count,  required String title,}) {
  return Container(
    height: 98,
    width: 80,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    ),
  );  
}

Widget matchesTabBar({required height,required NotificationModel matches}){
  return (Container(
      height: 110,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Card(color: matches.isMatchover==true?Colors.greenAccent:Colors.redAccent,
          shape:BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          child:ListTile(
            title: Text(matches.matchrequestedagainstUser.toString()+" vs "+ matches.matchrequestedbyUser.toString(), style: TextStyle(color: Colors.white),            ),
            subtitle:Text(matches.sport.toString()) ,
            leading: matches.isMatchover==false?ElevatedButton(
              onPressed: (){
              FirebaseFirestore.instance.collection('register_match').doc(matches.docid).set({'isMatchover':true});
            }, child: Text('Complete'),):Text("Completed", style: TextStyle(color: Colors.white)),
            contentPadding: EdgeInsets.all(2),
          ),),
          GestureDetector(
            child: Container(
              color: Theme.of(context).primaryColor,
              //width: _screenWidth / 3,
              //height: widget.height,
              child: Stack(
                children: <Widget>[
                  Align(
                  ),
                  // isTv
                  //     ? Align(
                  //         alignment: Alignment.bottomCenter,
                  //         child: Container(
                  //           height: 2,
                  //           color: Colors.white,
                  //         ),
                  //       )
                  //     : SizedBox(),
                ],
              ),
            ),
            onTap: () {
              }
          ),
          GestureDetector(
            child: Container(
              color: Theme.of(context).primaryColor,
              // width: _screenWidth / 3,
              // height: widget.height,
              child: Stack(
                children: <Widget>[
                  Align(
                  ),
                  // isTag
                  //     ? Align(
                  //         alignment: Alignment.bottomCenter,
                  //         child: Container(
                  //           height: 2,
                  //           color: Colors.white,
                  //         ),
                  //       )
                  //     : SizedBox(),
                ],
              ),
            ),
            onTap: () {
              }
          ),
        ],
      ),
    ));
}
  
}


