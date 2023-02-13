// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:maps/data/web_services/auth_services.dart';
// import 'package:maps/data/web_services/lat_lon_services.dart';
// import 'package:maps/screens/auth/login_screen.dart';
// import 'package:maps/shared_component/shared.dart';
//
//
//
// Position? position;
//
// final LatLongServices _latLongServices = LatLongServices();
//
// bool isDataUpdated = false;
//
// _updatePosition() async {
//   position = await Geolocator.getCurrentPosition();
//   try {
//     await _latLongServices.updateUserGeoPoint(
//       position!.latitude,
//       position!.longitude,
//     );
//     isDataUpdated = true;
//   } catch (e) {
//     isDataUpdated = false;
//     print('===========location didn\'t updated to firestore===========');
//   }
// }
//
//
//
//
//
// class UsersScreen extends StatefulWidget {
//   const UsersScreen({Key? key}) : super(key: key);
//
//   @override
//   _UsersScreenState createState() => _UsersScreenState();
// }
//
// class _UsersScreenState extends State<UsersScreen> {
//   final AuthServices _auth = AuthServices();
//   var user = FirebaseAuth.instance.currentUser;
//   Completer<GoogleMapController> _controller = Completer();
//
//   _checkPermission() async {
//
//
//     var isServiceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!isServiceEnabled) {
//       showToast(errorMessage: 'Please Open your Location Service First,(GPS) ');
//     } else {
//       var permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         showToast(
//           errorMessage:
//               'to run the app you must allow the location permission ',
//         );
//         permission = await Geolocator.requestPermission();
//       }else{
//         print(11);
//       }
//     }
//   }
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     _checkPermission();
//     _updatePosition();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(user!.uid)
//             .snapshots(),
//         builder:
//             (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//                 child: Text(
//                     "Something went wrong, please check internet connection",
//                     style: TextStyle(fontSize: 18)));
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: Text("Loading"));
//           }
//
//           Map<String, dynamic> data =
//               snapshot.data!.data() as Map<String, dynamic>;
//
//           moveCamera(position!.latitude, position!.longitude);
//           // moveCamera(data['location'].latitude, data['location'].longitude);
//
//           return Stack(
//             children: [
//               GoogleMap(
//                 markers: getMarker(data),
//                 mapType: MapType.normal,
//                 myLocationEnabled: true,
//                 myLocationButtonEnabled: true,
//
//                 initialCameraPosition: CameraPosition(
//                   target: LatLng(position!.latitude, position!.longitude),
//                   zoom: 14,
//                 ),
//                 onMapCreated: (GoogleMapController controller) {
//                   _controller.complete(controller);
//                 },
//               ),
//               Positioned(
//                 bottom: 20,
//
//                 child: Row(
//                   children: [
//                     Container(
//                       height: 50,
//                       margin: EdgeInsets.only(left: 30),
//                       child: ElevatedButton(
//                         child: Text('log out'.toUpperCase(),style: TextStyle(fontSize: 20),),
//                         onPressed: (){},
//                         onLongPress: () async {
//                           try {
//                             await _auth.signOut();
//                             Navigator.of(context).pushReplacement(
//                               MaterialPageRoute(
//                                 builder: (context) => LoginScreen(),
//                               ),
//                             );
//                           } catch (e) {
//                             print(e.toString());
//                           }
//                         },
//                       ),
//                     ),
//                       Spacer(),
//                     FloatingActionButton(
//                       onPressed: () {
//
//                         // moveCamera(
//                         //     data['location'].latitude, data['location'].longitude);
//                       },
//                     ),
//
//                   ],
//                 ),
//               )
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Set<Marker> getMarker(data) {
//     print(9);
//
//     return <Marker>[
//       Marker(
//         markerId: MarkerId(data['uid']),
//         position: LatLng(data['location'].latitude, data['location'].longitude),
//         infoWindow: InfoWindow(title: data['name'], snippet: data['email']),
//       )
//     ].toSet();
//   }
//
//   Future<void> moveCamera(lat, long) async {
//     print(10);
//
//     final GoogleMapController controller = await _controller.future;
//     controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
//       target: LatLng(lat, long),
//       zoom: 17,
//     )));
//   }
// }
//
//
