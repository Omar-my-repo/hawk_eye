import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps/shared_component/drawer_screens/drawer_area_admin.dart';
import 'package:maps/shared_component/drawer_screens/drawer_user.dart';
import 'package:maps/shared_component/logo_background.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../find_next_screen.dart';
import '../../shared_component/drawer_screens/drawer_admin.dart';
import '../../shared_component/drawer_screens/drawer_superadmin.dart';

class DevelopersContacts extends StatelessWidget {
  const DevelopersContacts({Key? key, required this.role}) : super(key: key);
  final String role;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Widget nextScreen = await getNextScreen();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => nextScreen));
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'المطوريين',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        drawer: checkRole(this.role),
        body: Stack(
          children: [
            LogoBackground(),
            Column(
              children: [
                const SizedBox(height: 20),
                drawADeveloper(
                  name: 'حــسن جـمال أحمد',
                  email: 'Hassan93work@gmail.com',
                  phone: '01287848630',
                ),
                // const SizedBox(height: ),
                drawADeveloper(
                  name: 'عمـر مـحـمد علي',
                  email: 'OmarMail4contact@gmail.com',
                  phone: '01126075300',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget checkRole(String role) {
    if (role == 'super_admin') {
      return DrawerSuperAdmin(role: this.role);
    } else if (role == 'area_admin') {
      return DrawerAreaAdmin(role: this.role);
    } else if (role == 'admin') {
      return DrawerAdmin(role: this.role);
    } else {
      return DrawerUser();
    }
  }

  Widget drawADeveloper(
      {required String name, required String email, required String phone}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Colors.black45,
            width: .5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.person),
                  const SizedBox(width: 15),
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  launch("mailto:$email?subject=العنوان&body=أضف%رسالتك");
                },
                child: Row(
                  children: [
                    Icon(Icons.email),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        email,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  launch("tel:$phone");
                },
                child: Row(
                  children: [
                    Icon(Icons.phone),
                    const SizedBox(width: 15),
                    Text(
                      '$phone  20+',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
