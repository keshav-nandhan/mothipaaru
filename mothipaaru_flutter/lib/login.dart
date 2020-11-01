
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
     return Container(
       height: MediaQuery.of(context).size.height,
       color: Colors.white,
       width: double.infinity,
       child: MyButton(),
     );
   }
 }

 class MyButton extends StatelessWidget {
   
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: FittedBox(
      child: OutlineButton(
      splashColor: Colors.white,
      onPressed: () async {
      UserCredential userCredential;
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =await googleUser.authentication;
        final GoogleAuthCredential googleAuthCredential =GoogleAuthProvider.credential(accessToken: googleAuth.accessToken,idToken: googleAuth.idToken,);
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }
      
      final Users currentuser= new Users(userCredential.user.displayName, userCredential.user.email, userCredential.user.photoURL, userCredential.user.uid);
              Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return HomePage(userLoggedIn:currentuser);                      
                }));
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
     ),
     ),
    );
  }
}

