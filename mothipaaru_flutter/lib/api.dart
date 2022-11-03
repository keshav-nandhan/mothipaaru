import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mothipaaru_flutter/notification.model.dart';
import 'package:mothipaaru_flutter/users.model.dart';

class ApiDoc{
Users userdata=[] as Users;
Users getUser(String uid){
  FirebaseFirestore.instance.collection("Users").doc(uid).snapshots().listen((item) { 
   userdata=new Users(item.data()!["displayName"],item.data()!["email"],item.data()!["photoURL"],item.data()!["uid"]);
  });
  
  return userdata;
}

NotificationModel getMatch(String docid){ 
  late NotificationModel matchdata;
  FirebaseFirestore.instance.collection("register_match").doc(docid).snapshots().listen((item) { 
    matchdata=new NotificationModel(item.data()!["matchrequestedagainst"],item.data()!["matchrequestedby"],item.data()!["sport"],item.data()!["isMatchover"],
    item.data()!["finalwinner"]!,
    item.data()!["confirmed"],item.data()!["dateupdated"],item.data()!["matchrequestedbyUser"],item.data()!["matchrequestedagainstUser"],item.data()!["matchrequestedbyPhoto"],
    item.data()!["matchrequestedagainstPhoto"],item.data()!["docid"]);
  });
  return matchdata;
}
}