import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mothipaaru_flutter/loading.dart';
import 'package:mothipaaru_flutter/notifications.dart';
import 'package:mothipaaru_flutter/userDetails.model.dart';
import 'users.model.dart';

class Matchfinder extends StatefulWidget {
  
final Users userLoggedIn;
final List<UserDetails>? usersMatchData;
  Matchfinder({required this.userLoggedIn,required this.usersMatchData});  
   
  @override
_MatchfinderState createState() => _MatchfinderState();
}

class _MatchfinderState extends State<Matchfinder> with TickerProviderStateMixin{

UserDetails? matchUser;
late AnimationController _animationController;
Animation? animation;

  double _containerPaddingLeft = 20.0;
  Animation? sizeAnimation;
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
            child: TextButton(
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
                return  databindUsers(context,widget.usersMatchData!);
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
      
      var followers;
     // FirebaseFirestore.instance.collection("Users").doc(matchedUser.uid).collection("FollowedBy").doc().get().then((value) =>followers=value.["id"]);
             _animationController =new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1300));

      animation = Tween(begin: 0,end: 60).animate(_animationController)..addListener((){
        setState(() {
            

        });
      });
      sizeAnimation = Tween(begin: 0,end: 1).animate(CurvedAnimation(parent: _animationController,curve: Curves.fastOutSlowIn))..addListener((){
      setState(() {

        });
      });
    // _animationController.addListener(() {
    //   setState(() {
      
    // });
        return Container(
          height: 325,
          child:Card(
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(6),
          child: Container(
            child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //CircleAvatar(backgroundImage: AssetImage(matchedUser.imageurl.toString())),
               ListTile(
                  leading: CircleAvatar(radius: 30.0,backgroundImage:NetworkImage(matchedUser.imageurl.toString()),backgroundColor: Colors.transparent),
                  title: Text(matchedUser.username.toString()),
                  subtitle: Text("About :"+matchedUser.descground.toString(),style: TextStyle(color: Colors.black.withOpacity(0.6)),),  
                  //trailing: Column(children:[Icon(Icons.people), Text(matchedUser.followers==0?"0":matchedUser.followers.toString())])
                ),
              Padding(padding:EdgeInsets.all(2.0), child: Text("Contact :" +matchedUser.phonenumber.toString()),),
              Center(child: Text(matchedUser.favouritesport.toString())),
              Icon(Icons.location_on, size: 14),Text(matchedUser.distancebtw.toString()),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Align(
                   alignment: Alignment.bottomLeft,
                  child: GestureDetector(
                  onTap: () {
              _animationController.forward();
              if(!matchedUser.isFollowing){
                if(followers==null){
                  FirebaseFirestore.instance.collection("Users").doc(matchedUser.uid).collection("FollowedBy").doc(widget.userLoggedIn.uid).set({});
                  FirebaseFirestore.instance.collection("Users").doc(widget.userLoggedIn.uid).collection("Following").doc(matchedUser.uid).set({});
                }
                else{
                  if(followers.toString().contains(widget.userLoggedIn.uid.toString()))
                  {

                  }
                  else{
                    FirebaseFirestore.instance.collection("register_team").doc(matchedUser.uid).set({
                    'followers':followers.toString()+","+widget.userLoggedIn.uid,
                  },SetOptions(merge: true));
                  }
                }

              }
                
                  },
                  child: AnimatedContainer(
                decoration: BoxDecoration(
                    color:  matchedUser.isFollowing?Colors.green[600]:Colors.blueAccent,
                    borderRadius: BorderRadius.circular(100.0),
                    boxShadow: [
                      BoxShadow(
                        color: matchedUser.isFollowing?Colors.green[600]!:Colors.blueAccent,
                        blurRadius: 21, // soften the shadow
                        spreadRadius: -15, //end the shadow
                        offset: Offset(
                          0.0, // Move to right 10  horizontally
                          20.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                ),
                padding: EdgeInsets.only(
                      left: _containerPaddingLeft,
                      right: 20.0,
                      top: 10.0,
                      bottom: 10.0),
                duration: Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      (!matchedUser.isFollowing)
                          ? AnimatedContainer(
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInCirc,
                            )
                          : Container(),
                      AnimatedSize(
                        duration: Duration(milliseconds: 600),
                        child: matchedUser.isFollowing ? SizedBox(width: 10.0) : Container(),
                      ),
                      AnimatedSize(
                        duration: Duration(milliseconds: 200),
                        child: matchedUser.isFollowing ? Text("Following") : Text("Follow") ,
                      ),
                      AnimatedSize(
                        duration: Duration(milliseconds: 200),
                        child: matchedUser.isFollowing ? Icon(Icons.done) : Icon(Icons.add),
                      ),
                      AnimatedSize(
                        alignment: Alignment.topLeft,
                        duration: Duration(milliseconds: 600),
                        child: matchedUser.isFollowing ? SizedBox(width: 10.0) : Container(),
                      ),
                      // AnimatedSize(
                      //   vsync: this,
                      //   duration: Duration(milliseconds: 200),
                      //   child: sent ? Text("Following") : Container(),
                      // ),
                    ],
                ))),
                 ),
                 
              //MaterialButton(onPressed: null)
              Align(
                alignment: Alignment.bottomRight,
                                    child: ElevatedButton(
                  //textColor: const Color(0xFFB71C1C),
                  //focusColor:  const Color(0x006200EE),
                  onPressed: () async {
                  showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Mothipaaru?'),
                    content: Text('Would you like to Challenge?'),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => Navigator.of(context).pop('No'),
                          child: Text('Cancel')),
                      TextButton(
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
            child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                'Mothi Paaru',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(
                Icons.view_week,
                color: Colors.lightBlueAccent,
              ),
            ],
       ),
          ),
              ),
                  ],),
            ],
          ),
        ),
          ),
        );
      }

                 futureloaderdelay() {
            return Future.delayed(Duration(milliseconds: 3000),);
        }

}

  



class CreateListRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
