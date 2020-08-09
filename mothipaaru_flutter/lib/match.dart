import 'package:flutter/material.dart';


class Matchfinder extends StatefulWidget {
  @override
  
  _MatchfinderState createState() => _MatchfinderState();
}


class _MatchfinderState extends State<Matchfinder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: new AppBar(title:Text('Match')),
   body:new Center (
     child: new Text("This is Search page"),
   ),
   );
  }
}