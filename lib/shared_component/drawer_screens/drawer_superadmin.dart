import 'package:flutter/material.dart';
import 'package:maps/screens/home/delete_users.dart';
import 'package:maps/screens/home/manage_area_admins.dart';
import 'package:maps/screens/home/manage_area_supervisors.dart';
import 'package:maps/screens/home/manage_delegates.dart';
import 'package:maps/screens/home/manage_super.dart';
import 'package:maps/screens/home/show_reports.dart';

//import '../../find_next_screen.dart';
import '../../screens/home/admins_contacts.dart';
import '../../screens/home/developers_contacts.dart';
import 'home_tab.dart';
import 'logout_tab.dart';
import 'my_drawer_header.dart';

class DrawerSuperAdmin extends StatelessWidget {
  const DrawerSuperAdmin({Key? key, required this.role}) : super(key: key);
  final String role;

  static const TextStyle drawerTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          MyDrawerHeader(role: this.role),
          const SizedBox(
            height: 15,
          ),
          HomeTab(
            role: this.role,
          ),
          ListTile(
            //enabled: false,
            leading: Icon(Icons.house_outlined),
            title: const Text(
              'إختيار مديري المناطق',
              style: drawerTextStyle,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => ManageAreaAdmins(role: this.role)),
                  (route) => false);
            },
          ),
          ListTile(
            //enabled: false,
            leading: Icon(Icons.people),
            title: const Text(
              'إختيار مشرفي المناطق',
              style: drawerTextStyle,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) =>
                          ManageAreaSupervisors(role: this.role)),
                  (route) => false);
            },
          ),
          ListTile(
            //enabled: false,
            leading: Icon(Icons.add_box_outlined),
            title: const Text(
              'إختيار المـشرفين',
              style: drawerTextStyle,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => ManageSuper(role: this.role)),
                  (route) => false);
            },
          ),
          ListTile(
            leading: Icon(Icons.apps),
            title: const Text('إختيار المندوبين ', style: drawerTextStyle),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => ManageDelegates(role: this.role)),
                  (route) => false);
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard_outlined),
            title: const Text('عـرض الـتقـاريـر', style: drawerTextStyle),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShowReports(
                            role: this.role,
                          )),
                  (route) => false);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_outline_rounded),
            title: const Text('حـذف موظفيين', style: drawerTextStyle),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeleteUsers(
                            role: this.role,
                          )),
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
                      builder: (context) => DevelopersContacts(
                            role: this.role,
                          )),
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
