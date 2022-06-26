
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mothipaaru_flutter/first.dart';
import 'package:mothipaaru_flutter/users.model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

 class LoginPage extends StatefulWidget {
  LoginPage({
    Key? key,
    required this.title,
    required this.analytics,
    required this.observer,
  }) : super(key: key);


   final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

   @override
  _LoginPageState createState() => _LoginPageState();
 }

 class _LoginPageState extends State<LoginPage> {

  void setMessage(String message) {
    setState(() {
    });
  }

   @override

   Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body:
     Container(
        child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 60),
          child: const Text(
            "MothiPaaru",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 15),
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green[200]!.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xff1bccba),
                      Color(0xff22e2ab),
                    ],
                  ),
                ),
                child: GestureDetector(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_outlined),
                    color: Colors.white,
                    iconSize: 32,
                     onPressed: () async {
    try {
      
      UserCredential userCredential;
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser= await GoogleSignIn().signIn();
  
        final GoogleSignInAuthentication googleAuth =await googleUser!.authentication;
        
        
        final GoogleAuthCredential googleAuthCredential =GoogleAuthProvider.credential(accessToken: googleAuth.accessToken,idToken: googleAuth.idToken) as GoogleAuthCredential;
        userCredential = await _auth.signInWithCredential(googleAuthCredential);


        //final obj = await GoogleSignIn().authenticatedClient();
        // final GoogleSignInAuthentication googleAuth =await googleUser.authentication;
        
        // final GoogleAuthCredential googleAuthCredential =GoogleAuthProvider.credential(accessToken: googleAuth.accessToken,idToken: googleAuth.idToken,);
        //userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }
      
      final Users currentuser= new Users(userCredential.user!.displayName, userCredential.user!.email, userCredential.user!.photoURL, userCredential.user!.uid);
         FirebaseFirestore.instance.collection("Users").doc(currentuser.uid).set({
                    'displayName':currentuser.displayName, 'email':currentuser.email,'photoURL':currentuser.photoURL,'uid':currentuser.uid
                  },SetOptions(merge:true));
              Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return FirstPage(userLoggedIn:currentuser);                      
                }));

} on FirebaseAuthException catch (e) {
  FirebaseCrashlytics.instance.log(e.message.toString());
    }
    
      },
                  ),
                ),
              ),
            ],
            
          ),
        ),
        
        Row(
      mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sign In With Google")
          ],
        )
      ],
    ),
      ),
     
     );
   }
 }


// class VerticalText extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 60, left: 10),
//       child: RotatedBox(
//           quarterTurns: -3,
//           child: Text(
//             'PISTHA',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 38,
//               fontWeight: FontWeight.w900,
//             ),
//           )),
//     );
//   }
// }

// class TextLogin extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 30.0, left: 10.0),
//       child: Container(
//         //color: Colors.green,
//         height: 200,
//         width: 200,
//         child: Column(
//           children: <Widget>[
//             Container(
//               height: 60,
//             ),
//             Center(
//               child: Text(
//                 'SHOW WHO YOU ARE TO THIS WORLD!',
//                 style: TextStyle(
//                   fontSize: 24,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

