// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class AdminSet extends StatefulWidget {
//   const AdminSet({Key? key}) : super(key: key);
//
//   @override
//   _AdminSetState createState() => _AdminSetState();
// }
//
// class _AdminSetState extends State<AdminSet> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Report Screen')),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('users').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           List<String> Ids=[];
//           if (snapshot.hasData) {
//             for(var doc in snapshot.data!.docs){
//                 Ids.add(doc.id);
//             }
//             print('===========******************==============');
//             print(Ids[0]);
//             return StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(Ids[0])
//                     .collection('report')
//                     .snapshots(),
//                 builder: (context, snap) {
//                   if(snap.hasData){
//                     return ListView.builder(
//                         itemCount: snapshot.data!.docs.length,
//                         itemBuilder: (context, ind) {
//                          print(snap.data!.docs.length);
//
//                           return ListTile(
//                             //snap.data!.docs[0]['body']
//                             title: Text('age'),
//                             subtitle: Text('pls'),
//                           );
//                         });
//                   }
//                   return Center(child: CircularProgressIndicator());
//
//                 });
//           }
//           return CircularProgressIndicator();
//         },
//       ),
//     );
//   }
// }
