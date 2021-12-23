
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mothipaaru_flutter/users.model.dart';
import 'home.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;


 class LoginPage extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return InteractiveViewer(child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.redAccent, Colors.teal]),
        ),
       //child: MyButton(),
       child:ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(children: <Widget>[
                  VerticalText(),
                  TextLogin(),
                ]),
                MyButton(),
              ],
            ),
          ],
        ),
     ),
     );
   }
 }

 class MyButton extends StatelessWidget {
   
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
      padding: const EdgeInsets.only(top: 200, right: 50, left: 125),
      child: Container(
        alignment: Alignment.bottomRight,
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blue[300]!,
              blurRadius: 10.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                5.0, // horizontal, move right 10
                5.0, // vertical, move down 10
              ),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
      child:TextButton(
      // splashColor: Colors.white,
      
      onPressed: () async {
    
      UserCredential userCredential;
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        //final GoogleSignInAccount  googleUser=await GoogleSignIn().signIn();
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
                return HomePage(userLoggedIn:currentuser);                      
                }));
      },
       child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Sign-In with Google',
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.lightBlueAccent,
              ),
            ],
       ),
      // child: Padding(
      //   padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      //   child: Row(
      //     mainAxisSize: MainAxisSize.min,
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Padding(
      //         padding: const EdgeInsets.only(left: 10),
      //         child: Text(
      //           'Sign in with Google',
      //           style: TextStyle(
      //             fontSize: 20,
      //             color: Colors.grey,
      //           ),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
     ),
     ),
      ),
    );
  }
}

class VerticalText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 10),
      child: RotatedBox(
          quarterTurns: -1,
          child: Text(
            'Mothi Paaru',
            style: TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.w900,
            ),
          )),
    );
  }
}

class TextLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 10.0),
      child: Container(
        //color: Colors.green,
        height: 200,
        width: 200,
        child: Column(
          children: <Widget>[
            Container(
              height: 60,
            ),
            Center(
              child: Text(
                'SHOW WHO YOU ARE TO THIS WORLD!',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

