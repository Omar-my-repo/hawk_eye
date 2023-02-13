import 'package:flutter/material.dart';
import 'package:maps/screens/home/admins_contacts.dart';
import 'package:maps/screens/home/send_repots.dart';
import 'package:maps/screens/home/show_reports.dart';

import '../../screens/home/developers_contacts.dart';
import 'home_tab.dart';
import 'logout_tab.dart';
import 'my_drawer_header.dart';

class DrawerAdmin extends StatelessWidget {
  const DrawerAdmin({Key? key, required this.role}) : super(key: key);
  final String role;

  static const TextStyle drawerTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          MyDrawerHeader(
            role: this.role,
          ),
          const SizedBox(
            height: 15,
          ),
          HomeTab(role: this.role),
          //items shown if only active
          ListTile(
            leading: Icon(Icons.dashboard_outlined),
            title: const Text('عـرض الـتقـاريـر', style: drawerTextStyle),
            onTap: () {
              Navigator.pop(context);

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShowReports(role: this.role)),
                  (route) => false);
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: const Text('إرسال تقرير', style: drawerTextStyle),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SendReports(role: this.role)),
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
                      builder: (context) => AdminContacts(role: this.role)),
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
                      builder: (context) =>
                          DevelopersContacts(role: this.role)),
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
