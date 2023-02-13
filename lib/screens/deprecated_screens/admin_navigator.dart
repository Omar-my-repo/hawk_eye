// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:maps/screens/home/admin_screen.dart';
// import 'package:maps/shared_component/logo_background.dart';
//
// class AdminNavigator extends StatefulWidget {
//   const AdminNavigator({Key? key}) : super(key: key);
//
//   @override
//   _AdminNavigatorState createState() => _AdminNavigatorState();
// }
//
// TextEditingController _controller = TextEditingController();
//
// class _AdminNavigatorState extends State<AdminNavigator> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     var user = FirebaseAuth.instance.currentUser;
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           LogoBackground(),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   'قم بتأكيد الرقم السري الخاص بالمسؤولين',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(
//                   height: 35,
//                 ),
//                 TextField(
//                   obscureText: true,
//                   controller: _controller,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 20),
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   )),
//                 ),
//                 const SizedBox(
//                   height: 35,
//                 ),
//                 ElevatedButton(
//                     onPressed: () async {
//                       if (_controller.text == 'alibaba') {
//                         await FirebaseFirestore.instance
//                                 .collection('users')
//                                 .doc(user!.uid)
//                                 .set(
//                               {
//                                 'uid': user.uid,
//                                 'email': user.email,
//                                 'name': user.displayName,
//                                 'location': '',
//                                 'role':'admin',
//                                 'date_time':'',
//                               },
//                             ).then(
//                               (value) {
//                             Navigator.pushAndRemoveUntil(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => AdminScreen(),
//                                 ),
//                                     (route) => false);
//                           },
//                         );
//
//                         // await FirebaseFirestore.instance
//                         //     .collection('users')
//                         //     .doc(user!.uid)
//                         //     .update(
//                         //   {'role': 'admin'},
//                         // ).then(
//                         //   (value) {
//                         //     Navigator.pushAndRemoveUntil(
//                         //         context,
//                         //         MaterialPageRoute(
//                         //           builder: (context) => AdminScreen(),
//                         //         ),
//                         //         (route) => false);
//                         //   },
//                         // );
//                       }
//                     },
//                     child: Text(
//                       'التالي',
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ))
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
