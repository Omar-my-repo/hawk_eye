// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:maps/controllers/manage_supervisors/supervisors_cubit.dart';
// import 'package:maps/controllers/manage_supervisors/supervisors_states.dart';
// import 'package:maps/shared_component/drawer_screens/drawer_superadmin.dart';
// import 'package:maps/shared_component/shared.dart';
//
// import '../home/draw_users.dart';
//
// class ManageSupervisors extends StatefulWidget {
//   const ManageSupervisors({Key? key, required this.role}) : super(key: key);
//   final String role;
//
//   @override
//   _ManageSupervisorsState createState() => _ManageSupervisorsState();
// }
//
// class _ManageSupervisorsState extends State<ManageSupervisors> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           'إختيار المـشرفين',
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//       ),
//       drawer: DrawerSuperAdmin(role: widget.role),
//       body: BlocProvider(
//         create: (context) => SupervisorsCubit(),
//         child: BlocConsumer<SupervisorsCubit, SupervisorsStates>(
//           listener: (context, state) {},
//           builder: (context, state) {
//             var cubit = SupervisorsCubit.get(context);
//
//             return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 child: Stack(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         const Text(
//                           ' قم بإختيار المشرفين الجدد. ',
//                           style: TextStyle(
//                               fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(
//                           height: 10
//                         ),
//                         StreamBuilder<QuerySnapshot>(
//                           stream: FirebaseFirestore.instance
//                               .collection('users')
//                               .where('role', isNotEqualTo: 'super_admin')
//                               .snapshots(),
//                           builder: (context, snapshot) {
//                             if (snapshot.hasData) {
//                               var data = snapshot.data!.docs;
//                               for (int index = 0;
//                                   index < data.length;
//                                   index++) {
//                                 if (data[index]['role'] == 'admin') {
//                                   //   لو مش منضاف قبل كدا ضيفه
//                                   if (!cubit.selectedUids.contains(
//                                       data[index]['uid'].toString().trim())) {
//                                     cubit.addToSelectedList(
//                                         data[index]['uid'].toString().trim());
//                                   }
//                                 } else {
//                                   if (!cubit.unSelectedUids.contains(
//                                       data[index]['uid'].toString().trim())) {
//                                     cubit.addToUnSelectedList(
//                                         data[index]['uid'].toString().trim());
//                                   }
//                                 }
//                               }
//
//                               print('**************************');
//                               print(cubit.selectedUids);
//                               print('----------------------------------------');
//                               print(cubit.unSelectedUids);
//
//                               if (data.length != 0) {
//                                 return Expanded(
//                                   child: Container(
//                                     color: Colors.grey[200],
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       physics: const ClampingScrollPhysics(),
//                                       itemCount: data.length,
//                                       itemBuilder: (context, index) {
//                                         var cubit =
//                                             SupervisorsCubit.get(context);
//                                         //لو الرول ادمن
//                                         // if (widget.data[index]['role'] == 'admin') {
//                                         //   cubit.addToSelectedList(
//                                         //       widget.data[index]['uid'].toString().trim());
//                                         //   // selectedUids
//                                         //   //     .add(data[i]['uid'].toString().trim());
//                                         // } else {
//                                         //   cubit.addToUnSelectedList(
//                                         //       widget.data[index]['uid'].toString().trim());
//                                         //
//                                         //   // unSelectedUids
//                                         //   //     .add(data[i]['uid'].toString().trim());
//                                         // }
//
//                                         // print('**************************');
//                                         // print(cubit.selectedUids);
//                                         // print('----------------------------------------');
//                                         // print(cubit.unSelectedUids);
//                                         return CheckboxListTile(
//                                             title: Text(
//                                               data[index]['name'],
//                                               style: TextStyle(
//                                                   fontSize: 18,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//
//                                             // adding trim is important cause some timed data saved in a list with white space000
//                                             value: cubit.selectedUids.contains(
//                                                 data[index]['uid']
//                                                     .toString()
//                                                     .trim()),
//                                             // value: selectedUids
//                                             //     .contains(data[index]['uid'].toString().trim()),
//                                             controlAffinity:
//                                                 ListTileControlAffinity.leading,
//                                             onChanged: (value) {
//                                               if (cubit.selectedUids.contains(
//                                                   data[index]['uid']
//                                                       .toString()
//                                                       .trim())) {
//
//                                                 cubit.makeItUnselected(
//                                                     data[index]['uid']
//                                                         .toString()
//                                                         .trim());
//                                                 print('11111111111111111111');
//
//                                                 // cubit.addToUnSelectedList(
//                                                 //     data[index]['uid']
//                                                 //         .toString()
//                                                 //         .trim());
//                                                 // cubit.removeFromSelectedList(
//                                                 //     data[index]['uid']
//                                                 //         .toString()
//                                                 //         .trim());
//
//                                                 // cubit.selectedUids.remove(data[index]['uid']
//                                                 //     .toString()
//                                                 //     .trim()); // unselect
//
//                                                 // cubit.unSelectedUids.add(
//                                                 //     data[index]['uid'].toString().trim()); //add
//
//                                                 // if(!cubit.unSelectedUids.contains(
//                                                 //     data[index]['uid'].toString().trim())){
//                                                 //   cubit.unSelectedUids.add(
//                                                 //       data[index]['uid'].toString().trim());
//                                                 // }
//
//                                               } else {
//                                                 // cubit.removeFromUnSelectedList(
//                                                 //     data[index]['uid']
//                                                 //         .toString()
//                                                 //         .trim());
//                                                 //
//                                                 // cubit.addToSelectedList(
//                                                 //     data[index]['uid']
//                                                 //         .toString()
//                                                 //         .trim());
//                                                 cubit.makeItSelected(data[index]
//                                                         ['uid']
//                                                     .toString()
//                                                     .trim());
//                                                 print('2222222222222222222222');
//
//                                                 // cubit.selectedUids.add(data[index]['uid']
//                                                 //     .toString()
//                                                 //     .trim()); // select
//                                                 //
//                                                 // cubit.unSelectedUids
//                                                 //     .remove(data[index]['uid'].toString().trim());
//                                               }
//                                               // setState(() {});
//                                               print(
//                                                   '==========================>');
//                                               print(cubit.selectedUids);
//                                               print(cubit.unSelectedUids);
//                                             });
//                                       },
//                                     ),
//                                   ),
//                                 );
//                               }
//                               return Expanded(
//                                 child: Container(
//                                   color: Colors.grey[200],
//                                   child: Center(
//                                     child: const Text(
//                                       'لا يوجد مستخدمين بعد ',
//                                       style: TextStyle(
//                                           fontSize: 24,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black45),
//                                     ),
//                                   ),
//                                 ),
//                               );
//
//                               // return drawUsers(data);
//                             }
//                             return Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                     Positioned(
//                       left: 0,
//                       bottom: 20,
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           try {
//                             if (cubit.selectedUids.isNotEmpty) {
//                               for (int i = 0;
//                                   i < cubit.selectedUids.length;
//                                   i++) {
//                                 await FirebaseFirestore.instance
//                                     .collection('users')
//                                     .doc(cubit.selectedUids[i])
//                                     .update({
//                                   'role': 'admin',
//                                   'supervisorID': cubit.selectedUids[i],
//                                 });
//                               }
//                               showToast(errorMessage: 'تمت العملية بنجاح');
//                             } else {
//                               showToast(
//                                   errorMessage:
//                                       'يجب إختيار احد المناديب أولاً');
//                             }
//                             // setState(() {
//                             //   selectedUids = [];
//                             //   unSelectedUids=[];
//                             // });
//                           } catch (e) {
//                             showToast(
//                                 errorMessage:
//                                     'حدث خطأ اثناء الإضافة، حاول مرة اخري');
//                           }
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(6.0),
//                           child: Text(
//                             'حفظ',
//                             style: TextStyle(
//                                 fontSize: 26, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ));
//           },
//         ),
//       ),
//     );
//   }
//
// // Widget drawUsers(data,) {
// //   if (data.length != 0) {
// //     return DrawUsers(data: data,);
// //   }
// //   return Expanded(
// //     child: Container(
// //       color: Colors.grey[200],
// //       child: Center(
// //         child: const Text(
// //           'لا يوجد مستخدمين بعد ',
// //           style: TextStyle(
// //               fontSize: 24,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.black45),
// //         ),
// //       ),
// //     ),
// //   );
// // }
//
// // Widget drawUsers(data) {
// //   if (data.length != 0) {
// //     return Expanded(
// //       child: Container(
// //         color: Colors.grey[200],
// //         child: ListView.builder(
// //           shrinkWrap: true,
// //           physics: const ClampingScrollPhysics(),
// //           itemCount: data.length,
// //           itemBuilder: (context, index) {
// //             return CheckboxListTile(
// //                 title: Text(
// //                   data[index]['name'],
// //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                 ),
// //
// //                 // adding trim is important cause some timed data saved in a list with white space000
// //                 value: selectedUids.contains(data[index]['uid'].toString().trim()),
// //                 // value: selectedUids
// //                 //     .contains(data[index]['uid'].toString().trim()),
// //                 controlAffinity: ListTileControlAffinity.leading,
// //                 onChanged: (value) {
// //                   if (selectedUids.contains(data[index]['uid'].toString().trim())) {
// //                     selectedUids.remove(
// //                         data[index]['uid'].toString().trim()); // unselect
// //                   } else {
// //                     selectedUids
// //                         .add(data[index]['uid'].toString().trim()); // select
// //                   }
// //                   print('==========================>');
// //                   print(selectedUids);
// //                   setState(() {});
// //                 });
// //           },
// //         ),
// //       ),
// //     );
// //   }
// //   return Expanded(
// //     child: Container(
// //       color: Colors.grey[200],
// //       child: Center(
// //         child: const Text(
// //           'لا يوجد مناديب جدد ',
// //           style: TextStyle(
// //               fontSize: 24,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.black45),
// //         ),
// //       ),
// //     ),
// //   );
// // }
//
// }
