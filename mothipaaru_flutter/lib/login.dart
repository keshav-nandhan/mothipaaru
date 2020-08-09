import 'package:firebase_auth_ui/providers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'home.dart';
 
 class LoginPage extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return Container(
       height: MediaQuery.of(context).size.height,
       width: double.infinity,
       child: MyButton(),
     );
   }
 }

 class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('MyButton was tapped!');
      },
      child: FittedBox(
                  child: GestureDetector(
                    onTap: () {
              FirebaseAuthUi.instance().launchAuth([AuthProvider.google()])
              .then((firebaseUser){                
              Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return HomePage();                      
                })
                );
                    });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 25),
                      padding:
                          EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.blueAccent,
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Login with Google",
                            style: Theme.of(context).textTheme.button.copyWith(
                                  color: Colors.black,
                                ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
              ),
    );
  }
}

