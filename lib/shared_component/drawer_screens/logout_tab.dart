//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//import 'package:google_sign_in/google_sign_in.dart';
import 'package:maps/data/web_services/auth_services.dart';
import 'package:maps/screens/auth/login_screen.dart';
//import 'package:workmanager/workmanager.dart';

class LogoutTab extends StatelessWidget {
  LogoutTab({Key? key}) : super(key: key);
  final _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.power_settings_new, color: Colors.redAccent),
      title: const Text('تسجيل الخروج',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent)),
      onTap: () async {
        await _auth.logOut().then(
          (value) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
                (route) => false);
          },
        );
      },
    );
  }
}
