import 'package:flutter/material.dart';
import 'package:maps/screens/home/admin_screen.dart';
import 'package:maps/screens/home/user_screen.dart';

//import '../../find_next_screen.dart';
//import 'drawer_user.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key, required this.role}) : super(key: key);
  final String role;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.location_on_outlined),
      title: const Text(
        'الرئيسية',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onTap: () async {
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => checkRole()));
      },
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
