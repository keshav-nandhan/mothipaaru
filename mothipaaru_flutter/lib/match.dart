
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mothipaaru_flutter/loading.dart';
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
Animation? sizeAnimation;
static bool sortname=false;
static bool sortdistance=false;
static bool sortwins=false;
static bool sortlosses=false;
//static bool confirmmatch=false;
// Declare this variable

@override
void initState() {
  _animationController=AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this
  );
  super.initState();
}


  void dispose() {
    super.dispose();
    _animationController.dispose();
  }


  @override
Widget build(BuildContext context) {

 return Scaffold(
  appBar: AppBar(title: Text('Opponents Found'),backgroundColor: Color.fromARGB(255, 4, 60, 103),
  elevation: 0.5,
  ),
  //child: new ListView.builder(itemBuilder:this.matchUser)
  body: Container(
    child: StreamBuilder(
      
        //it will return the future type result
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.none) 
                  return  databindUsers(context,widget.usersMatchData!);
                if(snapshot.connectionState == ConnectionState.waiting||snapshot.connectionState ==ConnectionState.active||snapshot.connectionState ==ConnectionState.done)
                  {
                    return Loading();
                  }
                  return Loading();
              }),
  ),
 
);
                         
}



Widget databindUsers (BuildContext context,List<UserDetails> matchedUsers) {
  return Column(

    children: [

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton.icon(onPressed: ()=>setState(() {
            if(sortname)
            {
              matchedUsers.sort((a, b) => a.username!.compareTo(b.username!));
              sortname=false;
            }
              else
              {
            matchedUsers.sort((a, b) => b.username!.compareTo(a.username!));
            sortname=true;
              }
          }),
           icon: Icon(Icons.short_text_sharp), label: Text("Name")),
           TextButton.icon(onPressed: ()=>setState(() {
            if(sortdistance)
            {
              matchedUsers.sort((a, b) => a.distancebtw.compareTo(b.distancebtw));
              sortdistance=false;
            }
              else
              {
            matchedUsers.sort((a, b) => b.distancebtw.compareTo(a.distancebtw));
            sortdistance=true;
              }
          }),
          icon:Icon(Icons.short_text_sharp), label: Text("Distance")),
          TextButton.icon(onPressed: ()=>setState(() {
            if(sortwins)
            {
              matchedUsers.sort((a, b) => a.Wins.compareTo(b.Wins));
              sortwins=false;
            }
              else
              {
            matchedUsers.sort((a, b) => b.Wins.compareTo(a.Wins));
            sortwins=true;
              }
          }),
          icon:Icon(Icons.short_text_sharp), label: Text("Wins")),
          TextButton.icon(onPressed: ()=>setState(() {
            if(sortlosses)
            {
              matchedUsers.sort((a, b) => a.Losses.compareTo(b.Losses));
              sortlosses=false;
            }
              else
              {
            matchedUsers.sort((a, b) => b.Losses.compareTo(a.Losses));
            sortlosses=true;
              }
          }),
          icon:Icon(Icons.short_text_sharp), label: Text("Losses")),
        ],
      ),
      Expanded(
        //height: double.infinity,
        child: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount:matchedUsers.length,
          itemBuilder: (context,index){
              return _createListRow(matchedUsers[index],widget.userLoggedIn);
                  }),
      ),
    ],
  );
        }                  



_createListRow(UserDetails matchedUser,Users userLoggedIn) {
      
             _animationController =new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1300));

      // animation = Tween(begin: 0,end: 60).animate(_animationController)..addListener((){
      //   setState(() {
            

      //   });
      // });
      // sizeAnimation = Tween(begin: 0,end: 1).animate(CurvedAnimation(parent: _animationController,curve: Curves.fastOutSlowIn))..addListener((){
      // setState(() {

      //   });
      // });
    // _animationController.addListener(() {
    //   setState(() {
      
    // });
        return Stack(
          children: [
            Card(
              color: Colors.lightBlue[50],
              borderOnForeground:true,
              shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                        side: BorderSide(
                        color: Colors.white24,width: 1.0,
                        ),),
              child: 
              Column(
                children: [
                Padding(
                  padding: EdgeInsets.all(2),
                  child:SizedBox(
                  height: 550,
                  child: Container(
                    child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Center(child: Text(matchedUser.username.toString())),
                      Center(child: CircleAvatar(radius: 45.0,backgroundImage:NetworkImage(matchedUser.imageurl.toString()),backgroundColor: Colors.transparent),),

                      Row(
                        children: [
                          //Expanded(flex: 1,child: Text("About :"+matchedUser.descyourself.toString(),style: TextStyle(color: Colors.black.withOpacity(0.6)),),),
                          Expanded(flex: 1,child:Container(
child:Column(children:[Icon(Icons.location_on, size: 14),Text(matchedUser.distancebtw.toStringAsFixed(2).toString()+"km"),])
                          ),),
                          Expanded(flex: 1,child:Container(
child:Column(children:[Icon(Icons.people), Text(matchedUser.totalfollowers==0?"0":matchedUser.totalfollowers.toString())])
                          ),),
                          Expanded(flex: 1,child:Container(
child:Column(children:[
  if(matchedUser.favouritesport.toString()=="Basketball")
  Icon(Icons.sports_basketball_sharp)
  else if(matchedUser.favouritesport.toString()=="Volleyball")
  Icon(Icons.sports_volleyball_sharp)
  else if(matchedUser.favouritesport.toString()=="Cricket")
  Icon(Icons.sports_cricket_sharp)
  else if(matchedUser.favouritesport.toString()=="Badminton")
  Icon(Icons.sports_tennis_sharp)
  else
  Icon(Icons.sports_soccer_sharp)
  , Text(matchedUser.favouritesport.toString())]),
                          ),),
                          //Expanded(flex:1,child: Text(matchedUser.favouritesport.toString(),style: TextStyle(color: Colors.black.withOpacity(0.6)),),),
                        ],
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
child:Text("Wins : "+matchedUser.Wins.toString())),
Container(
child:Text("Losses : "+matchedUser.Losses.toString())),]
                      ),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _ratingBar(3,matchedUser.rating!.abs()),
                        ]),

                      Text("About :"+matchedUser.descyourself.toString(),style: TextStyle(color: Colors.black.withOpacity(0.6)),),
                      Text("Contact :" +matchedUser.phonenumber.toString()),
                      //CircleAvatar(backgroundImage: AssetImage(matchedUser.imageurl.toString())),
                      //  ListTile(
                      //     leading: Text("About :"+matchedUser.descyourself.toString(),style: TextStyle(color: Colors.black.withOpacity(0.6)),),
                      //     title: Text(matchedUser.username.toString()),
                      //     subtitle: Text("About :"+matchedUser.descyourself.toString(),style: TextStyle(color: Colors.black.withOpacity(0.6)),),  
                      //     trailing: Column(children:[Icon(Icons.people), Text(matchedUser.totalfollowers==0?"0":matchedUser.totalfollowers.toString())])
                      //   ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                         Flexible(
                          child: GestureDetector(
                          onTap: () async{
                            setState(() {
                      _animationController.forward();
                      if(!matchedUser.isfollowing){
                          FirebaseFirestore.instance.collection("Users").doc(matchedUser.uid).collection("FollowedBy").doc(widget.userLoggedIn.uid).set({});
                          FirebaseFirestore.instance.collection("Users").doc(widget.userLoggedIn.uid).collection("Following").doc(matchedUser.uid).set({});
                          matchedUser.isfollowing=true;
                        }
                        else{
                          FirebaseFirestore.instance.collection("Users").doc(matchedUser.uid).collection("FollowedBy").doc(widget.userLoggedIn.uid).delete();
                          FirebaseFirestore.instance.collection("Users").doc(widget.userLoggedIn.uid).collection("Following").doc(matchedUser.uid).delete();
                          matchedUser.isfollowing=false;
                          }        
                            });
                      
                          },
                          child: 
                          AnimatedContainer(
                        decoration: BoxDecoration(
                            color:  matchedUser.isfollowing?Colors.green[600]:Colors.lightBlue[300],
                            borderRadius: BorderRadius.circular(100.0),
                            boxShadow: [
                              BoxShadow(
                                color: matchedUser.isfollowing?Colors.green[600]!:Color.fromARGB(255, 0, 300, 0),
                                blurRadius: 181, // soften the shadow
                                spreadRadius: -15, //end the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  20.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ],
                        ),
                        padding: EdgeInsets.only(
                              left: 5.0,
                              right: 5.0,
                              top: 5.0,
                              bottom: 5.0),
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              (!matchedUser.isfollowing)
                                  ? AnimatedContainer(
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.easeInCirc,
                                    )
                                  : Container(),
                              // AnimatedSize(
                              //   duration: Duration(milliseconds: 400),
                              //   child: matchedUser.isfollowing ? SizedBox(width: 10.0) : Container(),
                              // ),
                              AnimatedSize(
                                duration: Duration(milliseconds: 200),
                                child: matchedUser.isfollowing ? Text("Following") : Text("Follow") ,
                              ),
                              AnimatedSize(
                                duration: Duration(milliseconds: 200),
                                child: matchedUser.isfollowing ? Icon(Icons.done) : Icon(Icons.add),
                              ),
                              // AnimatedSize(
                              //   alignment: Alignment.topLeft,
                              //   duration: Duration(milliseconds: 200),
                              //   child: matchedUser.isfollowing ? SizedBox(width: 10.0) : Container(),
                              // ),
                              // AnimatedSize(
                              //   vsync: this,
                              //   duration: Duration(milliseconds: 200),
                              //   child: sent ? Text("Following") : Container(),
                              // ),
                            ],
                        ))),
                         ),
                         
                      Expanded(child:Container()),
                      Expanded(
                          child: Container(
                                height: 55,
                                width: 85,
                                decoration: BoxDecoration(color:Colors.lightBlue[300],
                                boxShadow:[BoxShadow(color: Colors.lightBlue[100]!,offset: const Offset(4,4),  blurRadius: 15,spreadRadius: 1.0)],
                                borderRadius: BorderRadius.circular(25)),
                            child: GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.all(6),
                                child: Row(
                                  children: [
                                    Center(
                                      child: Text('Mothi Paaru',style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                    ),
                                                                           Icon(
                                                      Icons.flag_sharp,
                                                    )
                                  ],
                                  
                                ),
                              ),
                            onTap:() async {
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
                              'finalwinner':"",
                              'winnerby'+userLoggedIn.uid.toString():"",
                              'winnerby'+matchedUser.uid.toString():"",
                              'ratingby'+userLoggedIn.uid.toString():"",
                              'ratingby'+matchedUser.uid.toString():"",
                                                    }),
                            
                               FirebaseFirestore.instance.collection('register_team').doc(userLoggedIn.uid.toString()).set({
                              'isUseravailable':false,
                                                    },SetOptions(mergeFields:['isUseravailable'] )), 
                            
                                                    FirebaseFirestore.instance.collection('register_team').doc(matchedUser.uid.toString()).set({
                              'isUseravailable':false,
                                                     },SetOptions(mergeFields:['isUseravailable'] )), 
                              });
                                                },
                                              
                            ),
                          ),
                      ),
                    ],),
                    ],
                  ),
                ),
                  ),
                ),
              ],
            ),),
          ],
        );
      }

                 futureloaderdelay() {
                  
            return Future.delayed(Duration(milliseconds: 2000),);
        }
Widget _ratingBar(int mode,[double readonlyrating=0]) {
    switch (mode) {
        case 3:
        return RatingBar.builder(
          initialRating: readonlyrating,
          minRating: 1,
          ignoreGestures: true,
          tapOnlyMode: true,
          direction: Axis.horizontal,
          allowHalfRating: true,
          unratedColor: Colors.amber.withAlpha(50),
          itemCount: 5,
          itemSize: 40.0,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
          },
          updateOnDrag: true,
        );
      default:
        return Container();
    }
  }
}

  

