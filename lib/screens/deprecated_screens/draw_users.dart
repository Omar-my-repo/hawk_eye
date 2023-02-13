// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:maps/controllers/manage_supervisors/supervisors_cubit.dart';
//
// class DrawUsers extends StatefulWidget {
//   DrawUsers({Key? key, required this.data}) : super(key: key);
//   final data;
//
//   @override
//   _DrawUsersState createState() => _DrawUsersState();
// }
//
// class _DrawUsersState extends State<DrawUsers> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: BlocProvider.of<SupervisorsCubit>(context),
//       child: Expanded(
//         child: Container(
//           color: Colors.grey[200],
//           child: ListView.builder(
//             shrinkWrap: true,
//             physics: const ClampingScrollPhysics(),
//             itemCount: widget.data.length,
//             itemBuilder: (context, index) {
//               var cubit = SupervisorsCubit.get(context);
//               //لو الرول ادمن
//               // if (widget.data[index]['role'] == 'admin') {
//               //   cubit.addToSelectedList(
//               //       widget.data[index]['uid'].toString().trim());
//               //   // selectedUids
//               //   //     .add(data[i]['uid'].toString().trim());
//               // } else {
//               //   cubit.addToUnSelectedList(
//               //       widget.data[index]['uid'].toString().trim());
//               //
//               //   // unSelectedUids
//               //   //     .add(data[i]['uid'].toString().trim());
//               // }
//
//               print('**************************');
//               print(cubit.selectedUids);
//               print('----------------------------------------');
//               print(cubit.unSelectedUids);
//               return CheckboxListTile(
//                   title: Text(
//                     widget.data[index]['name'],
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//
//                   // adding trim is important cause some timed data saved in a list with white space000
//                   value: cubit.unSelectedUids
//                       .contains(widget.data[index]['uid'].toString().trim()),
//                   // value: selectedUids
//                   //     .contains(data[index]['uid'].toString().trim()),
//                   controlAffinity: ListTileControlAffinity.leading,
//                   onChanged: (value) {
//                     if (cubit.selectedUids.contains(
//                         widget.data[index]['uid'].toString().trim())) {
//                       cubit.selectedUids.remove(widget.data[index]['uid']
//                           .toString()
//                           .trim()); // unselect
//
//                       cubit.unSelectedUids.add(
//                           widget.data[index]['uid'].toString().trim()); //add
//
//                     } else {
//                       cubit.selectedUids.add(widget.data[index]['uid']
//                           .toString()
//                           .trim()); // select
//
//                       cubit.unSelectedUids
//                           .remove(widget.data[index]['uid'].toString().trim());
//                     }
//                     setState(() {
//
//                     });
//                     print('==========================>');
//                     print(cubit.selectedUids);
//                     print(cubit.unSelectedUids);
//                   });
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
