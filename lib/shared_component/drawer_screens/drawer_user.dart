import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps/screens/home/send_repots.dart';

import '../../screens/home/admins_contacts.dart';
import '../../screens/home/developers_contacts.dart';
import 'home_tab.dart';
import 'logout_tab.dart';
import 'my_drawer_header.dart';

//var collection = FirebaseFirestore.instance.collection('users');
//var user = FirebaseAuth.instance.currentUser;

class DrawerUser extends StatelessWidget {
  const DrawerUser({Key? key}) : super(key: key);

  //var active = collection.doc(user!.uid) .docs[user!.uid]['active'];
  //collection.doc(user!.uid)
  static const TextStyle drawerTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          MyDrawerHeader(role: 'user'),
          const SizedBox(height: 15),
          HomeTab(role: 'user'),
          ListTile(
            // show if only active
            leading: Icon(Icons.dashboard),
            title: const Text('إرسال تقرير', style: drawerTextStyle),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SendReports(role: 'user')),
                  (route) => false);
            },
          ),
          ListTile(
            leading: Icon(Icons.phone_callback_outlined),
            title: const Text('تــواصل', style: drawerTextStyle),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminContacts(role: 'user')),
                  (route) => false);
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: const Text('دعم فني', style: drawerTextStyle),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => DevelopersContacts(role: 'user')),
                  (route) => false);
            },
          ),
          const Divider(
            color: Colors.black45,
          ),
          LogoutTab(),
        ],
      ),
    );
  }
}
