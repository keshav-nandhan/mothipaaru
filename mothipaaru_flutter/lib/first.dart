import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mothipaaru_flutter/chat.dart';
import 'package:mothipaaru_flutter/home.dart';
import 'package:mothipaaru_flutter/login.dart';
import 'package:mothipaaru_flutter/notifications.dart';
import 'package:mothipaaru_flutter/profile.dart';
import 'package:mothipaaru_flutter/users.model.dart';

class FirstPage extends StatefulWidget {

final Users userLoggedIn;
final int tabIndex;
FirstPage({Key? key, required this.userLoggedIn,required this.tabIndex}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
   final _scaffoldKey = GlobalKey<ScaffoldState>();
int _selectedIndex =0;
   @override
   void initState() {
    super.initState();
    setState(() {
      _selectedIndex=widget.tabIndex;
    });
  }
   
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
          preferredSize: Size.fromHeight(35),
          child: AppBar(titleTextStyle:GoogleFonts.vollkorn(textStyle: TextStyle(color: Colors.white,fontSize: 26,fontWeight: FontWeight.bold)) , title:Text('Mothi Paaru'),
          backgroundColor: Colors.black,
           elevation: 5.0, 
           flexibleSpace: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [ Color.fromARGB(255, 15, 66, 61),
                      Color.fromARGB(255, 4, 60, 103),],begin:Alignment.bottomLeft,end:Alignment.topRight)),),
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
bottomNavigationBar: SizedBox(
  height: 64,
  child:   BottomNavigationBar(
  
      backgroundColor:  Color.fromARGB(255, 15, 33, 61),
  
      type: BottomNavigationBarType.fixed,
  
      iconSize: 24,
  
    showSelectedLabels: false,
  
    showUnselectedLabels: false,
  
    unselectedItemColor: Colors.white.withOpacity(.20),
  
    selectedFontSize: 14,
  
    unselectedFontSize: 12,
  
    selectedIconTheme: IconThemeData(color: Colors.amberAccent, size: 30),
  
    selectedItemColor: Color.fromARGB(255, 15, 33, 61),                      
  
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
  
    elevation: 0.5,
  
    ),
),
     );
  }
}