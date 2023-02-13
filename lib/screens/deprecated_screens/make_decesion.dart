// import 'package:flutter/material.dart';
// import 'package:maps/shared_component/logo_background.dart';
//
// import 'admin_navigator.dart';
// import 'choose_my_admin.dart';
//
// class MakeDecision extends StatelessWidget {
//   const MakeDecision({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           LogoBackground(),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                     onPressed: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context) => ChooseMyAdmin()));
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8),
//                           child: Text(
//                             'تسجيل الدخول كمندوب',
//                             style: TextStyle(
//                                 fontSize: 22, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ],
//                     )),
//                 const SizedBox(height: 50),
//                 ElevatedButton(
//                     onPressed: () async {
//                       Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context) => AdminNavigator()));
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'تسجيل الدخول كمسؤول',
//                             style: TextStyle(
//                                 fontSize: 22, fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(width: 25),
//                           Icon(Icons.lock),
//                         ],
//                       ),
//                     ))
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
