import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mothipaaru_flutter/chat.dart';
import 'package:mothipaaru_flutter/home.dart';
import 'package:mothipaaru_flutter/login.dart';
import 'package:mothipaaru_flutter/notifications.dart';
import 'package:mothipaaru_flutter/profile.dart';
import 'package:mothipaaru_flutter/users.model.dart';

class FirstPage extends StatefulWidget {

final Users userLoggedIn;
FirstPage({Key? key, required this.userLoggedIn}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
   final _scaffoldKey = GlobalKey<ScaffoldState>();
   int _selectedIndex = 0;
    @override
  void dispose() {
    super.dispose();
  }
    void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
}
  final String title="HomePage";
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
static List<Widget> _pages=[];
  @override
  Widget build(BuildContext context) {
  _pages = <Widget>[
  HomePage(userLoggedIn: widget.userLoggedIn),
  Chatwindow(currentUser:widget.userLoggedIn), 
  NotificationsPage(currentUser: widget.userLoggedIn),
  ProfilePage(currentUser:widget.userLoggedIn),];
     return Scaffold(
          appBar:PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(title:Text('Mothi Paaru',style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
          backgroundColor: Colors.black,
           elevation: 10.0, 
           flexibleSpace: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [ Color.fromARGB(255, 15, 66, 61),
                      Color.fromARGB(255, 9, 24, 127),],begin:Alignment.bottomLeft,end:Alignment.topRight)),),
           actions: <Widget>[
               IconButton(
                 icon: Icon(Icons.logout),
                onPressed: () async{
                  await GoogleSignIn().signOut();
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return LoginPage(title:title,analytics: analytics,observer: observer,);                      
                  }));
                },
              ),
          
          ],
          ),
               ),
        
      key: _scaffoldKey,
      body: Container(child: _pages.elementAt(_selectedIndex),),
bottomNavigationBar: BottomNavigationBar(
    backgroundColor:  Color.fromARGB(255, 15, 66, 61),
    type: BottomNavigationBarType.fixed,
    iconSize: 30,
  showSelectedLabels: false,
  showUnselectedLabels: false,
  selectedIconTheme: IconThemeData(color: Colors.amberAccent, size: 40),
  selectedItemColor: Color.fromARGB(255, 15, 66, 61),                      
  selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.chat),
        label: 'Chats',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.notifications_active_rounded),
        label: 'Alert',
      ),
       BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
     currentIndex: _selectedIndex, //New
  onTap: _onItemTapped, 
  elevation: 0,
  ),
     );
  }
}