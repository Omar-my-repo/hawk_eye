import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps/screens/home/admin_screen.dart';
import 'package:maps/screens/home/user_screen.dart';

class MyDrawerHeader extends StatelessWidget {
  const MyDrawerHeader({Key? key, required this.role}) : super(key: key);
  final role;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .23,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => checkRole()));
        },
        child: DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Image.asset(
            'assets/images/drawer_header.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget checkRole() {
    if (this.role == 'super_admin' ||
        this.role == 'admin' ||
        this.role == 'area_admin') {
      return AdminScreen(role: this.role);
    } else {
      return UserScreen();
    }
  }
}
