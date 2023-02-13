import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/controllers/map_drawer/map_cubit.dart';
import 'package:maps/controllers/map_drawer/map_states.dart';
import 'package:maps/shared_component/drawer_screens/drawer_user.dart';

//import 'package:maps/shared_component/shared.dart';
import 'package:workmanager/workmanager.dart';

import '../../backend_task.dart';
import 'internet_error.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  // static const TextStyle drawerTextStyle =
  //     TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  Set<Marker> getMarker(lat, long) {
    return <Marker>[
      Marker(
        markerId: MarkerId('user'),
        position: LatLng(lat, long),
        // infoWindow: InfoWindow(title: data['name'], snippet: data['email']),
      )
    ].toSet();
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

  @override
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
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  @override
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
      drawer: DrawerUser(),
      body: _connectionStatus != ConnectivityResult.none.toString()
          ? BlocProvider(
              create: (BuildContext context) => MapCubit(),
              child: BlocConsumer<MapCubit, MapStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  var cubit = MapCubit.get(context);

                  cubit.updatePosition();
                  if (state is UpdatePositionState) {
                    return GoogleMap(
                      markers: getMarker(cubit.newPosition!.latitude,
                          cubit.newPosition!.longitude),
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,

                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          cubit.newPosition!.latitude,
                          cubit.newPosition!.longitude,
                        ),
                        zoom: 15,
                      ),
                      // onMapCreated: (GoogleMapController controller) {
                      //   _controller.complete(controller);
                      // },
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
}
