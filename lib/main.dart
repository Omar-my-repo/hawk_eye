import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maps/find_next_screen.dart';
//import 'package:maps/screens/auth/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Widget homeScreen = await getNextScreen();
  runApp(MyApp(homeScreen));
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Widget home;

  const MyApp(this.home) : super();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? Container(),
        );
      },
      home: this.home,
    );
  }
}
