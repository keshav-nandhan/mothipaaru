import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'chat.dart';
import 'match.dart';
import 'notifications.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin<HomePage>{
   int _currentIndex = 0;

   final List<Widget> views=[
     Matchfinder(),
     Notifications(),
     Chatwindow()
   ];
   
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body:views[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: allDestinations.map((Modules destination) {
          return BottomNavigationBarItem(
            icon: Icon(destination.icon),
            backgroundColor: destination.color,
            title: Text(destination.title)
          );
        }).toList(),
      ),
    );
  }
}

class Modules {
  const Modules(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}

const List<Modules> allDestinations = <Modules>[
  Modules('Match', Icons.search, Colors.teal),
  Modules('Notification', Icons.notifications, Colors.cyan),
  Modules('Chat', Icons.chat, Colors.orange),
];

final List<Widget> views =[];

class DestinationView extends StatefulWidget {
  const DestinationView({ Key key, this.destination }) : super(key: key);

  final Modules destination;

  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  TextEditingController _textController;
  String error;

LocationData _locationData;
Future<bool> _serviceEnabled = Location().serviceEnabled();
Future<LocationData> _locationdata= Location().getLocation();
Future<PermissionStatus> _permissionGranted=Location().hasPermission();


  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: 'sample text: ${widget.destination.title}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.destination.title} Text'),
        backgroundColor: widget.destination.color,
      ),
      backgroundColor: widget.destination.color[100],
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: TextField(controller: _textController),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}