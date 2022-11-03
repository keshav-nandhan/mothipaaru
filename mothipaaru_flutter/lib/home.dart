import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mothipaaru_flutter/match.dart';
import 'package:mothipaaru_flutter/users.model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mothipaaru_flutter/userDetails.model.dart';
class HomePage extends StatefulWidget {

final Users userLoggedIn;
HomePage({Key? key, required this.userLoggedIn}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin<HomePage>{
  final String title="HomePage";
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  
Position? _currentPosition;
LocationPermission?  grantpermission;
UserDetails? matchUser;
final _formKey = GlobalKey<FormState>();
InterstitialAd? _interstitialad;
int adloadattempt=0;
// Declare this variable
int? selectedRadio;
String? _myActivity="",categoryval="";
String? _genderValue="Male";
TextEditingController mobileNumberController = TextEditingController();
TextEditingController commentsController = TextEditingController();
bool searchusers=true;

List<UserDetails> matchedUsers=[];

List<String> submenuitems=<String>[];
      final category=[
          {"key":"Indoor","items":[{
          "Carrom",
          "Chess",
          "Snooker",
          "Cards",
          }]},
          {"key":"Outdoor","items":[{  "Football",
          "Basketball",
          "Cricket",
          "Volleyball",
          "Badminton"
          }]},
          {"key":"ESports","items":[{"BGMI",
          "Ludo",
          "Apex Legends",
          "COD",}]}
     ];
     
     final List<String> OutdoorItems=<String>[
          "Football",
          "Basketball",
          "Cricket",
          "Volleyball",
          "Badminton"
     ];


     final List<String> indoorItems=<String>[
          "Carrom",
          "Chess",
          "Snooker",
          "Cards",
     ];
     
     final List<String> eSportsItems=<String>[
          "BGMI",
          "Ludo",
          "Apex Legends",
          "COD",
     ];


void showInterstitialad(){
  if(_interstitialad!=null){
    _interstitialad?.fullScreenContentCallback=FullScreenContentCallback(
      onAdDismissedFullScreenContent:(InterstitialAd ad)=>{ad.dispose(),initad()},
      onAdFailedToShowFullScreenContent: (InterstitialAd ad,AdError error) => {ad.dispose(),initad()},
    );
  }
  _interstitialad?.show();
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
void initState() {
  super.initState();
  selectedRadio = 0;
  getFormData();
  initad();
}

getFormData(){
  setState(() {
    FirebaseFirestore.instance.collection("register_team").doc(widget.userLoggedIn.uid).snapshots().listen((event) {
      if(event.exists){
        mobileNumberController.text=event.data()!['phonenumber'];
        commentsController.text=event.data()!['descyourself'];
        _genderValue=event.data()!['gender'];
        _myActivity=event.data()!['favouritesport'];
      }
    });
  });
}
void dispose() {
super.dispose();
  _interstitialad?.dispose();
  }

 setSelectedRadioTile(String? val) {
    setState(() {
      _genderValue = val;
    });
  }


 
 final _scaffoldKey = GlobalKey<ScaffoldState>();
    @override

  @override
  Widget build(BuildContext context) {
  
  final Users currentUser=widget.userLoggedIn;

     return WillPopScope(
       onWillPop: _willConfirmExit,
       
        child:
        Scaffold(
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
 contentPadding: EdgeInsets.all(10.0),
 filled: true,
 fillColor: Colors.black12,
 labelText: 'Enter Mobile Number',
    ),
   // The validator receives the text that the user has entered.
   validator: (value) {
     if (value!.isEmpty) {
     return 'Please enter valid Number';
     }
   
     return null;
   },
 ), 
 
TextFormField(
  controller: commentsController,
 decoration: InputDecoration(
     border: InputBorder.none,
     contentPadding: EdgeInsets.all(10.0),
     filled: true,
     fillColor: Colors.black12,
     labelText: 'About yourself'
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
    toggleable: true,
    value: "Male",
    groupValue: _genderValue,
    title: Text("Male"),
    onChanged: (dynamic val) {
 setSelectedRadioTile(val);
    },
    activeColor: Colors.black,
    selected: true,
  ),
 
  RadioListTile(
    toggleable: true,
    value: "Female",
    groupValue: _genderValue,
    title: Text("Female"),
    onChanged: (dynamic val) {
 setSelectedRadioTile(val);
    },
    activeColor: Colors.black,
    selected: false,
  ),],)
 ),
//  DropdownButton(
//     value : category.isNotEmpty? categoryval : "", 
//     icon: const Icon(Icons.keyboard_arrow_down),      
//     items:category.map((item) {
//                 return DropdownMenuItem(
//                   value: item.values,
//                   child: Text(item.values.first.toString()),
//                 );
//               }).toList(),
//               onChanged: (value) => {},
//    ),
  DropdownButton(
    value : _myActivity!.isNotEmpty? _myActivity : OutdoorItems[0], 
    icon: const Icon(Icons.keyboard_arrow_down),      
    items:OutdoorItems.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
               onChanged: (String? newValue) { 
                setState(() {
                  _myActivity = newValue;
                });
              },
   ),
   
 ElevatedButton(
   onPressed: () async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (serviceEnabled) {
     grantpermission = await Geolocator.checkPermission();
     //grantpermission=await Permission.locationWhenInUse.isGranted;
     // Validate returns true if the form is valid, otherwise false.
     if (grantpermission == LocationPermission.denied) {
       grantpermission = await Geolocator.requestPermission();
     }
     else{
    if (_formKey.currentState!.validate()) {

    var following=   FirebaseFirestore.instance.collection("Users").doc(widget.userLoggedIn.uid).collection("Following").snapshots();
    await _getCurrentLocation();
    matchedUsers=matchfinderfunc(_genderValue,_myActivity,widget.userLoggedIn,_currentPosition.toString(),mobileNumberController.text.toString(),commentsController.text.toString());

       Future.delayed(Duration(milliseconds: 500)).then((value) => {
       
       matchedUsers=setfollowersandrating(matchedUsers,following),

       if(matchedUsers.length>0)
       {
        showInterstitialad(),
         Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return Matchfinder(userLoggedIn:currentUser,usersMatchData:matchedUsers);                      
                })
                )
       }
       else{
         if((_currentPosition.toString()=="")||(_currentPosition.toString()=="null"))
         {
        
         }
         else{
          showAlertDialog(context)
         }
       }

       });

      }
  }
     }
     else{
 showLocationDialog(context);
     }
   
    },
       child: Text('Search'),
       style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 15, 66, 61),
       ),
  ),
 
]),
),
 
]
),

),
 
),
     
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
                  'descyourself':desccomments,
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
                    opponentsfound=new UserDetails(doc['uid'], doc['citylocation'], DateTime.now().toString(), doc['descyourself'], doc['favouritesport'], doc['gender'], doc['imageurl'], doc['mailaddress'], doc['phonenumber'], doc['username'],nearbyplayer,doc['isUseravailable'],0,false,0,0,0),
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
              //return result.toStringAsFixed(2).toString()+" km";
              return result;
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

  setfollowersandrating(List<UserDetails> matchedUsers, Stream<QuerySnapshot<Map<String, dynamic>>> following) {
    for(int i=0;i<matchedUsers.length;i++){
      FirebaseFirestore.instance.collection("Users").doc(matchedUsers[i].uid).collection("FollowedBy").snapshots().listen((value) =>{ 
     matchedUsers[i].totalfollowers= value.docs.length,
    FirebaseFirestore.instance.collection("Users").doc(matchedUsers[i].uid).collection("rating").doc(matchedUsers[i].uid).snapshots().listen((value) =>{ 
     if(value.exists){
        matchedUsers[i].rating= value.data()!['rating']/value.data()!['matches']
     }
     else{
      matchedUsers[i].rating= 0
     }
     }),
     FirebaseFirestore.instance.collection("Users").doc(matchedUsers[i].uid).collection("WinsLosses").doc(matchedUsers[i].uid).snapshots().listen((value) =>{ 
     if(value.exists){
        matchedUsers[i].Wins= value.data()!['Wins'],
        matchedUsers[i].Losses= value.data()!['Losses'],
     }
     else{
      matchedUsers[i].Wins= 0,
      matchedUsers[i].Losses= 0
     }
     })
     

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
  
   


}