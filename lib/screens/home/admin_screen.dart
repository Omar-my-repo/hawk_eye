import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/controllers/map_drawer/map_cubit.dart';
import 'package:maps/controllers/map_drawer/map_states.dart';
import 'package:maps/shared_component/drawer_screens/drawer_admin.dart';
import 'package:maps/shared_component/drawer_screens/drawer_area_admin.dart';
import 'package:maps/shared_component/drawer_screens/drawer_superadmin.dart';
import 'package:workmanager/workmanager.dart';
import '../../backend_task.dart';
import 'internet_error.dart';

class AdminScreen extends StatefulWidget {
  AdminScreen({Key? key, required this.role}) : super(key: key);
  final String role;

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  var user = FirebaseAuth.instance.currentUser;

  void initMarker(specify, specifyId) async {
    final MarkerId markerId = MarkerId(specifyId);
    final Marker marker = Marker(
        markerId: markerId,
        position:
            LatLng(specify['location'].latitude, specify['location'].longitude),
        infoWindow: InfoWindow(
            title: specify['name'],
            snippet:
                //'${specify['date_time']} - ${specify['role'] == 'user' ? 'مندوب' : 'مشرف'}'));
                '${specify['date_time']} - ${specify['role'] == 'user' ? 'مندوب' : {
                    specify['role'] == 'admin'
                        ? 'مشرف'
                        : {
                            specify['role'] == 'area_admin'
                                ? 'مدير منطقة'
                                : 'مدير عام'
                          }
                  }}'));
    if (mounted) {
      setState(
        () {
          markers[markerId] = marker;
        },
      );
    }
  }

  getMarkDataForSuperAdmin() async {
    FirebaseFirestore.instance.collection('users').get().then(
      (myCollection) {
        if (myCollection.docs.isNotEmpty) {
          for (int i = 0; i < myCollection.docs.length; i++) {
            initMarker(myCollection.docs[i].data(), myCollection.docs[i].id);
          }
        }
      },
    );
  }

  getMarkDataForAreaAdmin() async {
    FirebaseFirestore.instance
        .collection('users')
        //.where('role', whereIn: ['user', 'admin'])
        .where('areaAdminID', isEqualTo: user!.uid) //include himself
        .get()
        .then(
      (myCollection) {
        if (myCollection.docs.isNotEmpty) {
          for (int i = 0; i < myCollection.docs.length; i++) {
            initMarker(myCollection.docs[i].data(), myCollection.docs[i].id);
          }
        }
      },
    );
  }

  getMarkDataForAdmins() async {
    FirebaseFirestore.instance
        .collection('users')
        //.where('role', isEqualTo: 'user')
        .where('supervisorID', isEqualTo: user!.uid) //include himself
        .get()
        .then(
      (myCollection) {
        if (myCollection.docs.isNotEmpty) {
          for (int i = 0; i < myCollection.docs.length; i++) {
            initMarker(myCollection.docs[i].data(), myCollection.docs[i].id);
          }
        }
      },
    );
  }

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  String _connectionStatus = 'Unknown';

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    Workmanager().initialize(
      callbackDispatcher,
      // The top level  function, aka callbackDispatcher

      // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
    );
    var user = FirebaseAuth.instance.currentUser;
    Workmanager().registerPeriodicTask(
      "1",
      "Update Location",
      inputData: <String, dynamic>{
        'userID': user!.uid,
      },
      frequency: Duration(minutes: 10),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'الموقـع',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: widget.role ==
              'super_admin' //or call checkRole() // or use switch case
          ? DrawerSuperAdmin(role: widget.role)
          : widget.role == 'area_admin'
              ? DrawerAreaAdmin(role: widget.role)
              : DrawerAdmin(role: widget.role),
      //drawer: widget.role=='super_admin'? DrawerSuperAdmin(role: widget.role,):DrawerAdmin(role: widget.role,),
      body: _connectionStatus != ConnectivityResult.none.toString()
          ? BlocProvider(
              create: (context) => MapCubit(),
              child: BlocConsumer<MapCubit, MapStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  var cubit = MapCubit.get(context);
                  cubit.updatePosition();
                  if (state is UpdatePositionState) {
                    if (widget.role == 'super_admin') {
                      getMarkDataForSuperAdmin();
                    } else if (widget.role == 'area_admin') {
                      getMarkDataForAreaAdmin();
                    } else {
                      getMarkDataForAdmins();
                    }

                    return Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: LatLng(30.049999, 31.1950001), zoom: 8),
                          mapType: MapType.normal,
                          // onMapCreated: (GoogleMapController controller) {
                          //   myController = controller;
                          // },
                          markers: Set<Marker>.of(markers.values),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'الرجاء الإنتظار حتي يتم التحميل...',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  }
                },
              ),
            )
          : InternetError(),
    );
  }

  Widget checkRole() {
    if (widget.role == 'super_admin') {
      return DrawerSuperAdmin(role: this.widget.role);
    } else if (widget.role == 'admin') {
      return DrawerAdmin(role: this.widget.role);
    } else {
      return DrawerAreaAdmin(role: this.widget.role);
    }
  }
}
