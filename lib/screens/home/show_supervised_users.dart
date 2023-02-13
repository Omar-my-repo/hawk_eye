import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maps/shared_component/drawer_screens/drawer_superadmin.dart';

import 'internet_error.dart';

class ShowSupervisedUsers extends StatefulWidget {
  const ShowSupervisedUsers(
      {Key? key,
      required this.role,
      required this.adminID,
      required this.adminName})
      : super(key: key);
  final role;
  final adminID;
  final adminName;

  @override
  _ShowSupervisedUsersState createState() => _ShowSupervisedUsersState();
}

class _ShowSupervisedUsersState extends State<ShowSupervisedUsers> {
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
        title: Text('عرض المندوبين التابعين'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      drawer: DrawerSuperAdmin(role: this.widget.role),
      body: _connectionStatus != ConnectivityResult.none.toString()
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 22.0),
                        child: Text(this.widget.adminName,
                            style: TextStyle(
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.center),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .where('role', isEqualTo: 'user')
                        .where('supervisorID', isEqualTo: this.widget.adminID)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data!.docs;
                        if (data.length == 0) {
                          return Center(
                              child: Text(
                            'لا يوجد مندوبين تابعين له حاليا.',
                            style: TextStyle(fontSize: 24),
                          ));
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              if (data[index]['name'] ==
                                  this.widget.adminName) {
                                return Container();
                              } //why this check ?
                              return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 10),
                                      Text(
                                        data[index]['name'],
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.blue),
                                      ),
                                    ],
                                  ));
                            });
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            )
          : InternetError(),
    );
  }
}
