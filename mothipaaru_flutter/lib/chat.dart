import 'package:flutter/material.dart';

class Chatwindow extends StatefulWidget {
  @override
  _ChatwindowState createState() => _ChatwindowState();
}

class _ChatwindowState extends State<Chatwindow> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
   body:new Center (
     child: new Text("This is Chat page"),
   ),
   );
  }
}