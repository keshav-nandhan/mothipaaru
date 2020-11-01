import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
 decoration: InputDecoration(
     border: InputBorder.none,
     contentPadding: EdgeInsets.all(15.0),
     filled: true,
     fillColor: Colors.grey[150],
     labelText: 'Enter Your Name'
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
       
       matchedUsers=matchfinderfunc(_genderValue,_myActivity,widget.userLoggedIn,_currentPosition.toString(),mobileNumberController.text.toString());
       await _getCurrentLocation();
       if(matchedUsers.length>0)
       {
         Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return Matchfinder(currentUser:currentUser,usersMatchData:this.matchedUsers);                      
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
                       
        List<UserDetails> matchfinderfunc(String gender,String sport,Users userLoggedIn,String cityLocation,String mobilenumber) {
        List<UserDetails> listDataSource=<UserDetails>[];var opponentsfound;
           FirebaseFirestore.instance.collection('register_team').doc(userLoggedIn.uid.toString()).set({
                  'uid':userLoggedIn.uid,
                  'dateupdated':DateTime.now().toString(),
                  'gender':gender,
                  'phonenumber':mobilenumber,
                  'favouritesport':sport,
                  'citylocation':cityLocation,
                  'descground':'',
                  'imageurl':userLoggedIn.photoURL,
                  'mailaddress':userLoggedIn.email,
                  'username':userLoggedIn.displayName
                },SetOptions(merge: true));
              FirebaseFirestore.instance.collection("register_team").where('gender',isEqualTo: gender).where('favouritesport',isEqualTo: sport).snapshots()
               .listen((data) =>{
                data.docs.forEach((doc) =>{
                if(doc.data()['uid']!=userLoggedIn.uid)
                {
                  opponentsfound=new UserDetails(doc.data()['uid'], doc.data()['citylocation'], DateTime.now().toString(), null, doc.data()['favouritesport'], doc.data()['gender'], doc.data()['imageurl'], doc.data()['mailaddress'], doc.data()['phonenumber'], doc.data()['username']),
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
        
          ListView userRecordCard(UserDetails matchedUser) {
             return ListView(
              padding: const EdgeInsets.all(8.0),
              children: <Widget>[
              Container(
                height: 50,
                color: Colors.amber[600],
                child: Center(child:Text(matchUser.username.toString())),
              ),
              Container(
                height: 50,
                color: Colors.amber[500],
                child: Center(child: Text(matchUser.phonenumber.toString())),
              ),
              Container(
                height: 50,
                color: Colors.amber[100],
                child: Center(child: Text(matchUser.favouritesport.toString())),
              ),
            ],
            );
          }
Widget databindUsers (BuildContext context,List<UserDetails> matchedUsers) {
  return new ListView.builder(
    padding: EdgeInsets.all(10.0),
    itemCount:matchedUsers.length,
    itemBuilder: (context,index){
        return userRecordCard(matchedUsers[index]);
            });
        }                  
        

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

