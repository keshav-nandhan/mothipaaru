import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
   body:new Center (
     child: new Text("This is Notifications page"),
   ),
   );
  }
}