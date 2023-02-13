// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:maps/screens/home/user_screen.dart';
// import 'package:maps/shared_component/logo_background.dart';
//
// class ChooseMyAdmin extends StatefulWidget {
//   const ChooseMyAdmin({Key? key}) : super(key: key);
//
//   @override
//   _ChooseMyAdminState createState() => _ChooseMyAdminState();
// }
//
// int _value = 0;
//
// class _ChooseMyAdminState extends State<ChooseMyAdmin> {
//   var user = FirebaseAuth.instance.currentUser;
//
//   @override
//   Widget build(BuildContext context) {
//     var user = FirebaseAuth.instance.currentUser;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Container(
//             width: double.infinity,
//             child: Text(
//               ' أهلاً   ${user!.displayName}',
//               textDirection: TextDirection.rtl,
//               textAlign: TextAlign.center,
//             )),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('users')
//               .where('role', isEqualTo: 'admin')
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               var data = snapshot.data!.docs;
//               return Stack(
//                 children: [
//                   LogoBackground(),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const SizedBox(
//                         height: 40,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(right: 20),
//                         child: Text(
//                           'رجاءً قم بإختيار مديرك المباشر',
//                           style: TextStyle(
//                               fontSize: 24, fontWeight: FontWeight.bold),
//                           textDirection: TextDirection.rtl,
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                       drawAdmins(data),
//                     ],
//                   ),
//                   Positioned(
//                     bottom: 100,
//                     right: 25,
//                     child: Container(
//                       child: ElevatedButton(
//                         onPressed: () async {
//
//                           await FirebaseFirestore.instance
//                               .collection('users')
//                               .doc(user.uid)
//                               .set(
//                             {
//                               'uid': user.uid,
//                               'email': user.email,
//                               'name': user.displayName,
//                               'location': '',
//                               'role':'user',
//                               'supervisor': data[_value]['name'],
//                               'date_time':'',
//                             }).then(
//                                 (value) {
//                               Navigator.pushAndRemoveUntil(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => UserScreen(),
//                                   ),
//                                       (route) => false);
//                             },
//                           );
//                           // await FirebaseFirestore.instance
//                           //     .collection('users')
//                           //     .doc(user!.uid)
//                           //     .update(
//                           //   {
//                           //     'supervisor': data[_value]['name'],
//                           //     'role': 'user'
//                           //   },
//                           // ).then(
//                           //   (value) {
//                           //     Navigator.pushAndRemoveUntil(
//                           //         context,
//                           //         MaterialPageRoute(
//                           //           builder: (context) => UserScreen(),
//                           //         ),
//                           //         (route) => false);
//                           //   },
//                           // );
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text('التالي',
//                               style: TextStyle(
//                                   fontSize: 24, fontWeight: FontWeight.bold)),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               );
//             }
//             return Stack(
//               children: [
//                 LogoBackground(),
//                 Center(
//                   child: CircularProgressIndicator(),
//                 )
//               ],
//             );
//           }),
//     );
//   }
//
//   Widget drawAdmins(data) {
//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: data.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(
//             data[index]['name'],
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           leading: Radio(
//             value: index,
//             activeColor: Color(0xFF6200EE),
//             onChanged: (int? value) {
//               setState(() {
//                 _value = value!;
//               });
//             },
//             groupValue: _value,
//           ),
//         );
//       },
//     );
//   }
// }
