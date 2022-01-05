
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mothipaaru_flutter/chat.dart';
import 'package:mothipaaru_flutter/login.dart';
import 'package:mothipaaru_flutter/match.dart';
import 'package:mothipaaru_flutter/notifications.dart';
import 'package:mothipaaru_flutter/users.model.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'match.dart';
// import 'notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mothipaaru_flutter/userDetails.model.dart';
import 'users.model.dart';

class HomePage extends StatefulWidget {

final Users userLoggedIn;
HomePage({Key? key, required this.userLoggedIn}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin<HomePage>{
  
late PageController pageController;
Position? _currentPosition;
late bool grantpermission;
UserDetails? matchUser;
final _formKey = GlobalKey<FormState>();

// Declare this variable
int? selectedRadio;
String? _myActivity="";
String? _genderValue="";
TextEditingController mobileNumberController = TextEditingController();
TextEditingController commentsController = TextEditingController();
bool searchusers=true;

List<UserDetails> matchedUsers=[];

  var dropdownkey;



@override
void initState() {
  super.initState();
  selectedRadio = 0;
}
 
 setSelectedRadioTile(String? val) {
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
    @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }


  

  @override
  Widget build(BuildContext context) {
  
  final Users currentUser=widget.userLoggedIn;

     final List<String> items=<String>[
          "Football",
          "Basketball",
          "Cricket",
          "Voleyball",
          "Badminton"
     ];
     return WillPopScope(
       onWillPop: _willConfirmExit,
       
        child:Scaffold(appBar:AppBar(title:Text('Mothi Paaru'),
         elevation: 15.0, 
         actions: <Widget>[
             IconButton(
               icon: Icon(Icons.logout),
              onPressed: () async{
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return LoginPage();                      
                }));
              },
            ),
        ],
       ),
      key: _scaffoldKey,

body:Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.transparent, Colors.black12]),
        ),
    child:Column(
    children:[
    Form(
    key: _formKey,
    child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:CrossAxisAlignment.center,
        
        children: <Widget>[
          
 // Add TextFormFields and RaisedButton here.
 TextFormField(
  keyboardType: TextInputType.number,
  inputFormatters:  <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
 controller: mobileNumberController,
 decoration: InputDecoration(
 border: InputBorder.none,
 contentPadding: EdgeInsets.all(15.0),
 filled: true,
 fillColor: Colors.black12,
 labelText: 'Enter Mobile Number',
    ),
   // The validator receives the text that the user has entered.
   validator: (value) {
     if (value!.isEmpty) {
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
     fillColor: Colors.black12,
     labelText: 'Enter Comments like desc ground/yourself'
   ),
   // The validator receives the text that the user has entered.
   validator: (value) {
     if (value!.isEmpty) {
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
    onChanged: (dynamic val) {
 setSelectedRadioTile(val);
    },
    activeColor: Colors.brown,
    selected: true,
  ),
 
  RadioListTile(
    value: "Female",
    groupValue: _genderValue,
    title: Text("Female"),
    onChanged: (dynamic val) {
 setSelectedRadioTile(val);
    },
    activeColor: Colors.brown,
    selected: false,
  ),],)
 ),
  DropdownButton(
    value : _myActivity!.isNotEmpty? _myActivity : items[0], 
    icon: const Icon(Icons.keyboard_arrow_down),      
    items:items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
               onChanged: (String? newValue) { 
                setState(() {
                  _myActivity = newValue!;
                });
              },
   ),
   
 ElevatedButton(
   onPressed: () async {
     grantpermission=await Permission.locationWhenInUse.isGranted;
   
     // Validate returns true if the form is valid, otherwise false.
    if (_formKey.currentState!.validate()) {

    var following=   FirebaseFirestore.instance.collection("Users").doc(widget.userLoggedIn.uid).collection("Following").snapshots();
    await _getCurrentLocation();
    matchedUsers=matchfinderfunc(_genderValue,_myActivity,widget.userLoggedIn,_currentPosition.toString(),mobileNumberController.text.toString(),commentsController.text.toString());

       Future.delayed(Duration(milliseconds: 4000)).then((value) => {
       matchedUsers=setfollowers(matchedUsers,following),
       if(matchedUsers.length>0)
       {
         Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return Matchfinder(userLoggedIn:currentUser,usersMatchData:matchedUsers);                      
                })
                )
       }
       else{
         if((_currentPosition.toString()=="")||(_currentPosition.toString()=="null"))
         {
           if(!grantpermission)
           {
           Permission.locationWhenInUse.request(),
           }
           else{
         
           showLocationDialog(context)
           }

         }
         else{
          showAlertDialog(context)
         }
       }

       });

      }
    },
       child: Text('Search'),
  ),
 
]),
),
Flexible(
  child:Row(
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,

    children: [
      Align(
 alignment: Alignment.bottomLeft,
 child:FloatingActionButton(
    mini: true,
    heroTag:"notifybtn",
  backgroundColor: Colors.transparent,
  foregroundColor: Colors.black,
  onPressed: () {
    Navigator.push(context, MaterialPageRoute(
         builder: (context) {
           return NotificationsPage(currentUser:widget.userLoggedIn);                      
           }));
    // Respond to button press
  },
  child: Icon(Icons.notifications_active_sharp),
),

),
Align(
      alignment: Alignment.bottomRight,
     child:FloatingActionButton(
       heroTag: "chatbtn",
        mini: true,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(
             builder: (context) {
               return Chatwindow(currentUser:widget.userLoggedIn);                      
               }));
      },
      child: Icon(Icons.messenger_outline_rounded),
    ),
 
)
    ],
    ),
  
),

    


  
]
),

),
)
     
     );
  }        
              _getCurrentLocation() async {
          
            //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
            //GeolocationStatus locationpermissionstatus=await geolocator.checkGeolocationPermissionStatus();
            bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
            if (!serviceEnabled) {
    
              return Future.error('Location services are disabled.');
            }


            LocationPermission locationenabled=await Geolocator.requestPermission();
            if(serviceEnabled && (locationenabled==LocationPermission.whileInUse || locationenabled==LocationPermission.always)){
            await Geolocator
                .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
                .then((Position position) {
              setState(() {
                _currentPosition = position;
              });
              //return position;
              //_getAddressFromLatLng();
            }).catchError((e) {
              print(e);
            });
          }
          
        }
                       
        List<UserDetails> matchfinderfunc(String? gender,String? sport,Users userLoggedIn,String cityLocation,String mobilenumber,String desccomments) {
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
                if(doc['uid']!=userLoggedIn.uid)
                {
                    nearbyplayer =distancebetweenplayers(doc['citylocation'].toString(),cityLocation),
                    opponentsfound=new UserDetails(doc['uid'], doc['citylocation'], DateTime.now().toString(), doc['descground'], doc['favouritesport'], doc['gender'], doc['imageurl'], doc['mailaddress'], doc['phonenumber'], doc['username'],nearbyplayer,doc['isUseravailable'],0,false),
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
                
              double result=Geolocator.distanceBetween(double.parse(opponentlocation.split(',')[0].split(':')[1].trim()),double.parse(opponentlocation.split(',')[1].split(':')[1].trim()),double.parse(usercityLocation.split(',')[0].split(':')[1].trim()),double.parse(usercityLocation.split(',')[1].split(':')[1].trim()));
              //Lat: 37.4219983, Long: -122.084
              result=result/1000;
              //double result=calculateDistance(double.parse(opponentlocation.split(',')[0].split(':')[1].trim()),double.parse(opponentlocation.split(',')[1].split(':')[1].trim()),double.parse(usercityLocation.split(',')[0].split(':')[1].trim()),double.parse(usercityLocation.split(',')[1].split(':')[1].trim()));
              return result.toStringAsFixed(2).toString()+" km";
              }
              
  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(  
    child: Text("OK"),  
    onPressed: () {  
      Navigator.of(context).pop();  
    },  
  );  
  
  // Create AlertDialog  
  AlertDialog alert = AlertDialog(  
    title: Text("Sorry"),  
    content: Text("No Opponents Match Found"),
    actions: [  
      okButton,  
    ]
    
  );  
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
  }

showLocationDialog(BuildContext context) {
    Widget okButton = TextButton(  
    child: Text("OK"),  
    onPressed: () {  
      Navigator.of(context).pop();  
    },  
  );  
  
  // Create AlertDialog  
  AlertDialog alert = AlertDialog(  
    title: Text("Location Settings"),  
    content: Text("Please enable location and try again"),
    actions: [  
      okButton,  
    ]
    
  );  
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
  }
Future<bool> _willConfirmExit() async {
    showDialog(
                  context: context,
                  builder: (context) => WillPopScope(
                    onWillPop: () async => false,
                    child: AlertDialog(
                        title: Text('Confirm?'),
                        content: Text('Are you sure you want to Exit?'),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () => Navigator.of(context).pop('No'),
                              child: Text('No')),
                          TextButton(
                              onPressed: () =>SystemNavigator.pop(),
                              child: Text('Yes'))
                        ],
                    ),
                  ),
    );

    return Future.value(false);
            // return true if the route to be popped
}

  setfollowers(List<UserDetails> matchedUsers, Stream<QuerySnapshot<Map<String, dynamic>>> following) {



    for(int i=0;i<matchedUsers.length;i++){

      FirebaseFirestore.instance.collection("Users").doc(matchedUsers[i].uid).collection("FollowedBy").snapshots().listen((value) =>{ 
     matchedUsers[i].totalfollowers= value.docs.length
     });

      following.listen((event) =>{
  for (var item in event.docs) {
    if(matchedUsers[i].uid==item.id)
    {
      matchedUsers[i].isfollowing=true
    }
  }
});
    }
    return matchedUsers;
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