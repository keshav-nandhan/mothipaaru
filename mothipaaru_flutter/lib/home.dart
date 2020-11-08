import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mothipaaru_flutter/login.dart';
import 'package:mothipaaru_flutter/match.dart';
import 'package:mothipaaru_flutter/users.model.dart';
// import 'chat.dart';
// import 'match.dart';
// import 'notifications.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mothipaaru_flutter/userDetails.model.dart';
import 'users.model.dart';


class HomePage extends StatefulWidget {

final Users userLoggedIn;
HomePage({Key key, @required this.userLoggedIn}) : super(key: key);


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin<HomePage>{
PageController pageController;
Position _currentPosition;
UserDetails matchUser;
final _formKey = GlobalKey<FormState>();

// Declare this variable
int selectedRadio;
String _myActivity="";
String _genderValue="";
TextEditingController mobileNumberController = TextEditingController();
TextEditingController commentsController = TextEditingController();
bool searchusers=true;

List<UserDetails> matchedUsers;

@override
void initState() {
  super.initState();
  selectedRadio = 0;
}
 
 setSelectedRadioTile(String val) {
    setState(() {
      _genderValue = val;
    });
  }
 
 
// Changes the selected value on 'onChanged' click on each radio button
setSelectedRadio(int val) {
  setState(() {
    selectedRadio = val;
  });
}


  final _scaffoldKey = GlobalKey<ScaffoldState>();
  //   @override
  // void dispose() {
  //   pageController.dispose();
  //   super.dispose();
  // }

  //   @override
  // void initState() {
  //   pageController = PageController(); //can change initital page
  //   super.initState();
  // }

// onPageChanged(int pageIndex) {
//     setState(() {
//       this._currentIndex = pageIndex;
//     });
//   }

  @override
  Widget build(BuildContext context) {
  
  final Users currentUser=widget.userLoggedIn;
  //  final List<Widget> views=[
  //    Matchfinder(userLoggedIn: currentUser),
  //    Notifications(),
  //    Chatwindow()
  //  ];
  
     return Scaffold(
       appBar: AppBar(
         title:Text('Mothi Paaru'),
         centerTitle: true,
         elevation: 4.0, 
         actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: () async{
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
                //GoogleSignInAuthentication googleAuth =
                Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return LoginPage();                      
                }));
              },
              child:  Icon(Icons.login_outlined),
            ),
          ),
        ],
       ),
      key: _scaffoldKey,

      body:Form(
key: _formKey,
child:Column(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment:CrossAxisAlignment.center,
  children: <Widget>[
 // Add TextFormFields and RaisedButton here.
 TextFormField(

 controller: mobileNumberController,
 decoration: InputDecoration(
 border: InputBorder.none,
 contentPadding: EdgeInsets.all(15.0),
 filled: true,
 fillColor: Colors.grey[150],
 labelText: 'Enter Mobile Number'
     
    ),
   // The validator receives the text that the user has entered.
   validator: (value) {
     if (value.isEmpty) {
 return 'Please enter valid number';
     }
     return null;
   },
 ), 
 
TextFormField(
  controller: commentsController,
 decoration: InputDecoration(
     border: InputBorder.none,
     contentPadding: EdgeInsets.all(15.0),
     filled: true,
     fillColor: Colors.grey[150],
     labelText: 'Enter Comments like desc ground/yourself'
   ),
   // The validator receives the text that the user has entered.
   validator: (value) {
     if (value.isEmpty) {
 return 'Please enter valid Name';
     }
     return null;
   },
 ),
 SizedBox(
    child:Column(
      children: [
   RadioListTile(
    value: "Male",
    groupValue: _genderValue,
    title: Text("Male"),
    onChanged: (val) {
 print("Radio Tile pressed $val");
 setSelectedRadioTile(val);
    },
    activeColor: Colors.orange,
    selected: true,
  ),
 
  RadioListTile(
    value: "Female",
    groupValue: _genderValue,
    title: Text("Female"),
    onChanged: (val) {
 print("Radio Tile pressed $val");
 setSelectedRadioTile(val);
    },
    activeColor: Colors.orange,
    selected: false,
  ),],)
 ),
  DropDownFormField(
     filled: true,
     errorText: "Please Select Atleast one sport",
     required: true,
     titleText: 'Favourite Sport',
     hintText: 'Please choose one',
     value: _myActivity,
     onSaved: (value) {
       setState(() {
         _myActivity = value;
       });
     },
     onChanged: (value) {
       setState(() {
         _myActivity = value;
       });
     },
     dataSource: [
       {
         "display": "Football",
         "value": "Football",
       },
       {
         "display": "Basketball",
         "value": "Basketball",
       },
       {
         "display": "Cricket",
         "value": "Cricket",
       },
       {
         "display": "Voleyball",
         "value": "Voleyball",
       },
       {
         "display": "Badminton",
         "value": "Badminton",
       },
     ],
     textField: 'display',
     valueField: 'value',
   ),
   
 RaisedButton(
   onPressed: ()async {
   
     // Validate returns true if the form is valid, otherwise false.
     if (_formKey.currentState.validate()) {
       await _getCurrentLocation();
       matchedUsers=await matchfinderfunc(_genderValue,_myActivity,widget.userLoggedIn,_currentPosition.toString(),mobileNumberController.text.toString(),commentsController.text.toString());
       await _getCurrentLocation();
       if(matchedUsers.length>0)
       {
         Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return Matchfinder(userLoggedIn:currentUser,usersMatchData:matchedUsers);                      
                })
                );
       }
      }
    },
       child: Text('Search'),
  ),
]),
     

),
);  
  }        
      // PageView(
      //   children: views,
      //   controller: pageController,
      //   onPageChanged: onPageChanged,
      //   physics: NeverScrollableScrollPhysics()
      // ),
      
      // //body:views[_currentIndex],
      // bottomNavigationBar: CupertinoTabBar(
      //   activeColor: Theme.of(context).accentColor,
      //   currentIndex: _currentIndex,
      //   onTap: (int index) {
      // pageController.animateToPage(index,duration: Duration(milliseconds: 400),curve: Curves.easeInOut);    
      //   },
      //   items: allDestinations.map((Modules destination) {
      //     return BottomNavigationBarItem(
      //       icon: Icon(destination.icon),
      //       backgroundColor: destination.color,
      //       label: destination.title
      //     );
      //   }).toList(),
      // ),
          _getCurrentLocation() async {
            
            
            final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
            GeolocationStatus locationpermissionstatus=await geolocator.checkGeolocationPermissionStatus();
            bool locationenabled=await geolocator.isLocationServiceEnabled();
            if((locationpermissionstatus==GeolocationStatus.granted)&& locationenabled){
            await geolocator
                .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
                .then((Position position) {
              setState(() {
                _currentPosition = position;
              });
              //_getAddressFromLatLng();
            }).catchError((e) {
              print(e);
            });
          }
          else{
            
          }
        }
                       
        Future<List<UserDetails>> matchfinderfunc(String gender,String sport,Users userLoggedIn,String cityLocation,String mobilenumber,String desccomments) async {
        List<UserDetails> listDataSource=<UserDetails>[];var opponentsfound;var nearbyplayer;
           FirebaseFirestore.instance.collection('register_team').doc(userLoggedIn.uid.toString()).set({
                  'uid':userLoggedIn.uid,
                  'dateupdated':DateTime.now().toString(),
                  'gender':gender,
                  'phonenumber':mobilenumber,
                  'favouritesport':sport,
                  'citylocation':cityLocation,
                  'descground':desccomments,
                  'imageurl':userLoggedIn.photoURL,
                  'mailaddress':userLoggedIn.email,
                  'username':userLoggedIn.displayName,
                  'isUseravailable':true
                },SetOptions(merge: true));
              FirebaseFirestore.instance.collection("register_team").where('gender',isEqualTo: gender).where('favouritesport',isEqualTo: sport).snapshots()
               .listen((data) =>{
                data.docs.forEach((doc) =>{
                if(doc.data()['uid']!=userLoggedIn.uid)
                {
                    nearbyplayer =distancebetweenplayers(doc.data()['citylocation'].toString(),cityLocation),
                    opponentsfound=new UserDetails(doc.data()['uid'], doc.data()['citylocation'], DateTime.now().toString(), doc.data()['descground'], doc.data()['favouritesport'], doc.data()['gender'], doc.data()['imageurl'], doc.data()['mailaddress'], doc.data()['phonenumber'], doc.data()['username'],nearbyplayer,doc.data()['isUseravailable']),
                    
                    listDataSource.add(opponentsfound),
                }
                
                })
              });
                //var list=  Firestore.instance.collection("register_team").where('gender',isEqualTo: gender).where('favouritesport',isEqualTo: sport).snapshots().toList();
            return listDataSource;
              }
                          
                              //  Future<bool> backtoLogin() async{
                              //       return Future.value(true);// return true if the route to be popped
                              // }
                  
              distancebetweenplayers(String opponentlocation, String usercityLocation){
              //Lat: 37.4219983, Long: -122.084
              //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
              //Future<double> result=geolocator.distanceBetween(double.parse(opponentlocation.split(',')[0].split(':')[1].trim()),double.parse(opponentlocation.split(',')[1].split(':')[1].trim()),double.parse(usercityLocation.split(',')[1].split(':')[1].trim()),double.parse(usercityLocation.split(',')[1].split(':')[1].trim()));
              dynamic result=calculateDistance(double.parse(opponentlocation.split(',')[0].split(':')[1].trim()),double.parse(opponentlocation.split(',')[1].split(':')[1].trim()),double.parse(usercityLocation.split(',')[1].split(':')[1].trim()),double.parse(usercityLocation.split(',')[1].split(':')[1].trim()))/1000;
              result=result.toStringAsFixed(2).toString()+"km";
              return result;
              }
              
              double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
                var p = 0.017453292519943295; var c = cos; var a = 0.5 - c((lat2 - lat1) * p)/2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p))/2; return 12742 * asin(sqrt(a)); 
                }




// class Modules {
//   const Modules(this.title, this.icon, this.color);
//   final String title;
//   final IconData icon;
//   final MaterialColor color;
// }

// const List<Modules> allDestinations = <Modules>[
//   Modules('Match', Icons.search, Colors.teal),
//   Modules('Notification', Icons.notifications, Colors.cyan),
//   Modules('Chat', Icons.chat, Colors.orange),
// ];


// class Matchfinder extends StatefulWidget {
  
// final Users userLoggedIn;
//   Matchfinder({Key key, @required this.userLoggedIn}) : super(key: key);  
   
//   @override
// _MatchfinderState createState() => _MatchfinderState();
// }

}