import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

//import 'package:maps/screens/auth/login_screen.dart';
import 'package:maps/screens/auth/register_screen.dart';

//import 'package:maps/screens/deprecated_screens/make_decesion.dart';
import 'package:maps/screens/home/admin_screen.dart';
import 'package:maps/screens/home/user_screen.dart';
import 'package:maps/screens/onboarding/on_boarding_screen.dart';

Future<Widget> getNextScreen() async {
  Widget nextScreen = UserScreen();

  var user = FirebaseAuth.instance.currentUser;
  //if user is not active, do not get in
  if (user != null) {
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (snap.exists) {
      if (snap['role'] == 'admin') {
        nextScreen = AdminScreen(role: 'admin');
      } else if (snap['role'] == 'super_admin') {
        nextScreen = AdminScreen(role: 'super_admin');
      } else if (snap['role'] == 'area_admin') {
        nextScreen = AdminScreen(role: 'area_admin');
      }
    } else {
      nextScreen = RegisterScreen(); //OnBoardingScreen
    }
  } else {
    nextScreen = OnBoardingScreen(); //OnBoardingScreen LoginScreen
  }
  return nextScreen;
}
