import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mothipaaru_flutter/notification.model.dart';
import 'package:mothipaaru_flutter/result.dart';
import 'package:mothipaaru_flutter/users.model.dart';

import 'loading.dart';

//import 'loading.dart';

class ProfilePage extends StatefulWidget {
  final Users currentUser;
  const ProfilePage({Key? key,required this.currentUser}): super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<NotificationModel> matchesPlayed=[];
  var biotext;

  int following=0,followedby=0,totalmatches=0;

@override
  void initState(){
    super.initState();
    setState(() {
    FirebaseFirestore.instance.collection('Users').doc(widget.currentUser.uid).collection('FollowedBy').get().then((value) => {followedby=value.size});
    FirebaseFirestore.instance.collection('Users').doc(widget.currentUser.uid).collection('Following').get().then((value) => {following=value.size});
    FirebaseFirestore.instance.collection("register_team").doc(widget.currentUser.uid).snapshots().listen((data) {
    biotext=data.data()!["descyourself"];
    });
     
    FirebaseFirestore.instance.collection('register_match').where('matchrequestedby',isEqualTo: widget.currentUser.uid).where('confirmed',isEqualTo:true).snapshots().listen((data) {
      data.docs.forEach((element) {
        this.matchesPlayed.add(new NotificationModel(element["matchrequestedagainst"],element["matchrequestedby"],element["sport"],element["isMatchover"],element["finalwinner"]!,element["confirmed"],element["dateupdated"],element["matchrequestedbyUser"],element["matchrequestedagainstUser"],element["matchrequestedbyPhoto"], element["matchrequestedagainstPhoto"], element.id));
      });
     });
     FirebaseFirestore.instance.collection('register_match').where('matchrequestedagainst',isEqualTo: widget.currentUser.uid).where('confirmed',isEqualTo:true).snapshots().listen((data) {
      data.docs.forEach((element) {
        this.matchesPlayed.add(new NotificationModel(element["matchrequestedagainst"],element["matchrequestedby"],element["sport"],element["isMatchover"],element["finalwinner"]!,element["confirmed"],element["dateupdated"],element["matchrequestedbyUser"],element["matchrequestedagainstUser"],element["matchrequestedbyPhoto"], element["matchrequestedagainstPhoto"], element.id));
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
     body:
     FutureBuilder(
      future: futureloaderdelay(),//it will return the future type result
            builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.done) 
      {
      return SingleChildScrollView(
      scrollDirection:Axis.vertical,
       child: Column(children: [
           Container(
            height:100,
            width: _screen.width,
           padding: const EdgeInsets.all(10),
           color:  Color.fromARGB(255, 15, 66, 61),
           child: 
           Row(
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
                  height: 150, // 150,
                  width: 150, //150,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.yellowAccent,
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
        
     
       
         Column(
         children: [
        Container(height: 40,width: double.infinity,decoration: BoxDecoration(color:  Color.fromARGB(255, 15, 66, 61)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(widget.currentUser.displayName.toString(),style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color:Colors.white)),
              ]),
              ),
             Container(height: 25,width: double.infinity,decoration: BoxDecoration(color:  Color.fromARGB(255, 15, 66, 61)),
              child: Center(
                child: 
              Text("Matches Played",style:TextStyle(fontSize: 16,color:Colors.white))
              ),
              ),  
         Container(
         width:_screen.width,
         color: Colors.lightBlue[50],
        child: ListView.separated(
          shrinkWrap: true,
          addRepaintBoundaries: true,
           separatorBuilder: (BuildContext context, int index) => const Divider(),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          dragStartBehavior: DragStartBehavior.start,
          physics: NeverScrollableScrollPhysics(),
                       scrollDirection: Axis.vertical,
                       itemCount:matchesPlayed.length,
                       itemBuilder: (context,index){
                       return matchesTabBar(matches:matchesPlayed[index]);
                         }),
         ),
         
          ])
         
         ]
       ),
     );
              }
              else{
                return Loading();
              }
 
            }),
     
   
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

Widget matchesTabBar({required NotificationModel matches}){
  
  return Stack(
    children:[
      Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      color:Colors.lightBlue[50],
      child: Row(
        
        //padding:EdgeInsets.symmetric(horizontal: 5),
        children:[
      
        Container(
          height:85,width: MediaQuery.of(context).size.width-5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Card(color: 
              matches.isMatchover==true?matches.finalwinner==widget.currentUser.uid?Colors.green[300]:Colors.red[300]:Colors.amber[100],
              shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
              ),
              child:ListTile(
                title: Text(matches.matchrequestedagainstUser.toString()+" vs "+ matches.matchrequestedbyUser.toString(), style: TextStyle(color: Colors.black)),
                //subtitle:Text(matches.sport.toString(),style: TextStyle(color: Colors.white)) ,
                subtitle:  Row(
                        children: [
                          if(matches.sport.toString()=="Basketball")
  Icon(Icons.sports_basketball_sharp)
  else if(matches.sport.toString()=="Volleyball")
  Icon(Icons.sports_volleyball_sharp)
  else if(matches.sport.toString()=="Cricket")
  Icon(Icons.sports_cricket_sharp)
  else if(matches.sport.toString()=="Badminton")
  Icon(Icons.sports_tennis_sharp)
  else
  Icon(Icons.sports_soccer_sharp),
                        ]),
                leading: matches.isMatchover==false?IconButton(
                  icon:Icon(Icons.flaky_outlined),
                  onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return MatchResult(userLoggedIn:widget.currentUser,match:matches);                      
                    }));
                }):IconButton(
                  icon:Icon(Icons.check_circle_rounded),
                  onPressed: (){
                  
                }),
                contentPadding: EdgeInsets.all(2),
              ),),
             
              GestureDetector(
                child: Container(
                  color: Theme.of(context).primaryColor,
                  // width: _screenWidth / 3,
                  // height: widget.height,
                  child: Stack(
                    children: <Widget>[
                      Align(
                      ),
                      
                    ],
                  ),
                ),
                onTap: () {
                  }
              ),
            ],
          ),
        )],
      ),
    ),
  ]);
}

Widget bio(Users profileuser) {
  return Row(
    children:[
    Container(
      color: Color.fromARGB(255, 15, 66, 61),
      height: 40,
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
           profileuser.displayName.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: biotext),
              ],
            ),
          ),
          // Text(
          //   'gyakhoe.com',
          //   style: TextStyle(
          //     color: Colors.pinkAccent,
          //   ),
          // ),
        ],
      ),
    ),]
  );
}
  
}


