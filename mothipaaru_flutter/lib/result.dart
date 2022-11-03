import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mothipaaru_flutter/first.dart';
import 'package:mothipaaru_flutter/notification.model.dart';
import 'package:mothipaaru_flutter/users.model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'loading.dart';

class MatchResult extends StatefulWidget {
  final Users userLoggedIn;
  final NotificationModel match;
  const MatchResult({Key? key,required this.userLoggedIn,required this.match}) : super(key: key);

  @override
  State<MatchResult> createState() => _MatchResultState();
}

class _MatchResultState extends State<MatchResult> {
    final _formKey = GlobalKey<FormState>();
  
  List<Users> me=[]; 
  
  List<Users> opponent=[];
  String winnerbyopponent="",winnerbyme="";
  double ratingbyopponent=0,ratingbyme=0;
  var dropdownitems=[{"uid":"0","value":"Select"}];
  var opponentuid="";
  
  get  toController => null;
  
  get fromController => null;
   
late final _ratingController;
  late double _rating;
double _initialRating = 2.0;
  double _userRating = 3.0;
  bool _isRTLMode = false;
  bool _isVertical = false;
  int _ratingBarMode = 1;

  @override
  
  void initState(){
  super.initState();
  
   _ratingController = TextEditingController(text: '3.0');
    _rating = _initialRating;
  if(widget.userLoggedIn.uid==widget.match.matchrequestedby){
    opponentuid=widget.match.matchrequestedagainst.toString();
   }
   else{
opponentuid=widget.match.matchrequestedby.toString();
   }


  //  ApiDoc obj=new ApiDoc();
  //  me.add(obj.getUser(widget.userLoggedIn.uid));
    FirebaseFirestore.instance.collection("Users").snapshots().listen((event) {
      event.docs.forEach((element) {
        if(element.data()["uid"]==widget.userLoggedIn.uid){
          me.add(new Users(element.data()["displayName"],element.data()["email"],element.data()["photoURL"], element.data()["uid"]));
        }
        if(element.data()["uid"]==opponentuid){
           opponent.add(new Users(element.data()["displayName"],element.data()["email"],element.data()["photoURL"], element.data()["uid"]));
        }
      });
       setState(() {
        
          FirebaseFirestore.instance.collection("register_match").doc(widget.match.docid).snapshots().listen((event) {
                    winnerbyme=event.data()!["winnerby"+ widget.userLoggedIn.uid];
                    ratingbyme=event.data()!["ratingby"+ widget.userLoggedIn.uid];
                    ratingbyme.isNaN?_rating=_initialRating:_rating=ratingbyme;
                    });
          FirebaseFirestore.instance.collection("register_match").doc(widget.match.docid).snapshots().listen((event) {
                    winnerbyopponent=event.data()!["winnerby"+ opponentuid];
                    ratingbyopponent=event.data()!["ratingby"+ opponentuid];
                    });

          dropdownitems.add({"uid":me[0].uid,"value":me[0].displayName=="null"?"1st user":me[0].displayName.toString()});
          dropdownitems.add({"uid":opponent[0].uid,"value":opponent[0].displayName=="null"?"1st user":opponent[0].displayName.toString()});
         });
    }).onDone(() => {
      
    });
     
    print(dropdownitems);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
      ),
      body: 
       FutureBuilder(
      future: futureloaderdelay(),//it will return the future type result
            builder: (context, snapshot) {
               if(snapshot.connectionState == ConnectionState.waiting) {
                           return Loading();} //show loading
                            else{
   return Container(
          child: Row(
            children: [
            Form(
               key: _formKey,
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
           Padding(
                padding:EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Winner by Me"),
                  Flexible(
              
              child: DropdownButton(
                 hint: Text("Winner by me"),
                value: winnerbyme==""?dropdownitems[0]["uid"]:winnerbyme,
              items: dropdownitems.map((item){
                return DropdownMenuItem(value:item["uid"].toString(),child: Text(item["value"].toString()));
              }).toList(),
              onChanged: (String? value) => {
                setState(() => {
                  //winnerbyme=value.toString(),
                  winnerbyme==""?winnerbyme=value.toString():winnerbyme=value.toString(),
                
                },)
              },
              ),
                  )
                ]
              ),
            ),
              Padding(
                padding:EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Winner by Opponent"),
                  Flexible(
              
              child: DropdownButton(
                disabledHint: Text("Disabled"),
                 hint: Text("Winner by Opponent"),
                value: winnerbyopponent==""?dropdownitems[0]["uid"]:winnerbyopponent,
              items: dropdownitems.map((item){
                return DropdownMenuItem(value:item["uid"].toString(),child: Text(item["value"].toString()));
              }).toList(),
              onChanged: null,
              ),
                  )
                ]
              ),
            ),
            Padding(
                padding:EdgeInsets.all(5),child: 
           
           Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[ Text("Rating"),_ratingBar(1)
              ]),),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {

                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState!.validate()) {
                      
                      if(winnerbyme!=""){
                        FirebaseFirestore.instance.collection("register_match").doc(widget.match.docid).update({"winnerby"+widget.userLoggedIn.uid.toString():winnerbyme,"ratingby"+widget.userLoggedIn.uid.toString():_rating});
                      }
                      if(winnerbyme==winnerbyopponent && winnerbyme!="" && winnerbyopponent!="")
                      {
                        FirebaseFirestore.instance.collection("register_match").doc(widget.match.docid).update({
                          "finalwinner": winnerbyme.toString(),
                          "isMatchover":true,
                          "dateupdated":DateTime.now().toString()
                      });
                      
                     
                      FirebaseFirestore.instance.collection("register_match").doc(widget.match.docid).snapshots().listen((event)=>{
                          FirebaseFirestore.instance.collection("Users").doc(widget.match.matchrequestedby).collection("rating").doc(widget.match.matchrequestedby).set({
                          "matches": FieldValue.increment(1),
                          "rating": FieldValue.increment(event.data()!["ratingby"+widget.match.matchrequestedagainst.toString()]),
                        },SetOptions(merge: true)),
                        FirebaseFirestore.instance.collection("Users").doc(widget.match.matchrequestedagainst).collection("rating").doc(widget.match.matchrequestedagainst).set({
                          "matches": FieldValue.increment(1),
                          "rating": FieldValue.increment(event.data()!["ratingby"+widget.match.matchrequestedby.toString()]),
                        },SetOptions(merge: true))
                      });
                      
                      
                      if(winnerbyme==opponentuid){
                      FirebaseFirestore.instance.collection("Users").doc(widget.userLoggedIn.uid).collection("WinsLosses").doc(widget.userLoggedIn.uid).set({
                          "Losses": FieldValue.increment(1),
                      },SetOptions(merge: true));
                      FirebaseFirestore.instance.collection("Users").doc(winnerbyme).collection("WinsLosses").doc(winnerbyme).set({
                          "Wins": FieldValue.increment(1),
                      },SetOptions(merge: true)); 
                      }
                      else{
                        FirebaseFirestore.instance.collection("Users").doc(opponentuid).collection("WinsLosses").doc(opponentuid).set({
                          "Losses": FieldValue.increment(1),
                      },SetOptions(merge: true));
                      FirebaseFirestore.instance.collection("Users").doc(widget.userLoggedIn.uid).collection("WinsLosses").doc(widget.userLoggedIn.uid).set({
                          "Wins": FieldValue.increment(1),
                      },SetOptions(merge: true)); 
                      }
                      }
                      else{
                        if(winnerbyopponent!="")
                        EasyLoading.showToast('There is a mismatch in claimed winners, Our team will verify and get back to you',toastPosition: EasyLoadingToastPosition.center,duration:Duration(milliseconds: 3000));
                        
                      }

                      // If the form is valid, display a Snackbar.
                      Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return FirstPage(userLoggedIn:widget.userLoggedIn,tabIndex: 3,);                      
                        }));
                              // Scaffold.of(context)
                      //     .showSnackBar(SnackBar(content: Text('You fly from '+fromController.text+' to '+toController.text)));
                    }
                  },
                  child: Text('Complete the Match'),
                ),
           
              ],
             
            ),],
      ),),
       ) ],),
    );
  }}));
  }
Widget _ratingBar(int mode,[double readonlyrating=0]) {
    switch (mode) {
      case 1:
        return RatingBar.builder(
          initialRating: _rating,
          minRating: 1,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          allowHalfRating: true,
          unratedColor: Colors.amber.withAlpha(50),
          itemCount: 5,
          itemSize: 40.0,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
          updateOnDrag: true,
        );
      case 2:
        return RatingBar.builder(
          initialRating: _initialRating,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                );
              case 1:
                return Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.redAccent,
                );
              case 2:
                return Icon(
                  Icons.sentiment_neutral,
                  color: Colors.amber,
                );
              case 3:
                return Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.lightGreen,
                );
              case 4:
                return Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.green,
                );
              default:
                return Container();
            }
          },
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
          updateOnDrag: true,
        );
      default:
        return Container();
    }
  }

   futureloaderdelay() {
            return Future.delayed(Duration(milliseconds: 1000),);
        }

}

